import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sentinel/core/theme/app_theme.dart';
import 'package:sentinel/core/theme/font_utils.dart';
import 'package:sentinel/core/theme/text_style_helper.dart';
import 'package:sentinel/core/time/time_sync_provider.dart';
import 'package:sentinel/core/storage/preferences_service.dart';
import 'package:sentinel/core/widgets/custom_error_widget.dart';
import 'package:sentinel/features/events/presentation/active_event_provider.dart';
import 'package:sentinel/features/events/presentation/event_providers.dart';
import 'package:sentinel/l10n/app_localizations.dart';
import 'package:sentinel/core/services/location_tracking_provider.dart';

enum _LocationBannerState { none, backgroundLimited, denied, disabledByUser }

class ActiveEventScreen extends ConsumerStatefulWidget {
  final String eventId;

  const ActiveEventScreen({super.key, required this.eventId});

  @override
  ConsumerState<ActiveEventScreen> createState() => _ActiveEventScreenState();
}

class _ActiveEventScreenState extends ConsumerState<ActiveEventScreen> {
  Timer? _timer;
  Duration _remaining = Duration.zero;
  _LocationBannerState _locationBanner = _LocationBannerState.none;
  bool _isExpired = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _checkLocationStatus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final l10n = AppLocalizations.of(context)!;
      ref
          .read(locationTrackingManagerProvider)
          .syncTrackingState(
            notifTitle: l10n.notifTrackingTitle,
            notifBody: l10n.notifTrackingBody,
            notifDesc: l10n.notifTrackingDesc,
          );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  void _updateTime() {
    final state = ref.read(activeEventProvider(widget.eventId));
    final event = state.event.valueOrNull;

    if (event != null) {
      final now = ref.read(timeSyncProvider.notifier).now;
      final remaining = event.expiresAt.difference(now);

      if (mounted) {
        if (remaining.isNegative && !_isExpired) {
          // Transition to expired
          setState(() {
            _remaining = Duration.zero;
            _isExpired = true;
          });
          _handleExpiration();
        } else if (!remaining.isNegative) {
          setState(() {
            _remaining = remaining;
            _isExpired = false;
          });
        }
      }
    }
  }

  Future<void> _handleExpiration() async {
    // 1. Invalidate Home List so it upgrades to "Fired" or "History"
    ref.invalidate(eventListProvider);

    // 2. Immediately transition to read-only detail view
    if (mounted) {
      context.replace('/history/${widget.eventId}');
    }
  }

  String _formatDuration(Duration d) {
    if (d.inHours >= 24) {
      final days = d.inDays;
      final hours = d.inHours % 24;
      final minutes = d.inMinutes % 60;
      final seconds = d.inSeconds % 60;
      return '$days${AppLocalizations.of(context)!.days} ${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      final hours = d.inHours;
      final minutes = d.inMinutes % 60;
      final seconds = d.inSeconds % 60;
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  Color _getTimerColor() {
    if (_isExpired) return AppTheme.errorColor;
    if (_remaining.inMinutes < 5) {
      return AppTheme.errorColor; // Pulsing Red logic could be animation
    }
    if (_remaining.inHours < 1) return AppTheme.primaryColor;
    return Colors.white;
  }

  Future<void> _handleCheckIn() async {
    final success = await ref
        .read(activeEventProvider(widget.eventId).notifier)
        .checkIn();

    if (success && mounted) {
      ref.invalidate(eventListProvider); // Refresh home list
      final l10n = AppLocalizations.of(context)!;
      ref
          .read(locationTrackingManagerProvider)
          .syncTrackingState(
            notifTitle: l10n.notifTrackingTitle,
            notifBody: l10n.notifTrackingBody,
            notifDesc: l10n.notifTrackingDesc,
          );
      context.go(
        '/',
      ); // Navigate to Home (clears stack effectively if using GoRouter correctly)
    }
  }

  Future<void> _handleCancel() async {
    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkSurface,
        title: Text(
          AppLocalizations.of(context)!.cancelEventTitle.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          AppLocalizations.of(context)!.cancelEventBody,
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              AppLocalizations.of(context)!.keepButton,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              AppLocalizations.of(context)!.cancelEvent,
              style: const TextStyle(
                color: AppTheme.errorColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await ref
          .read(activeEventProvider(widget.eventId).notifier)
          .cancelEvent();

      if (success && mounted) {
        ref.invalidate(eventListProvider);
        final l10n = AppLocalizations.of(context)!;
        ref
            .read(locationTrackingManagerProvider)
            .syncTrackingState(
              notifTitle: l10n.notifTrackingTitle,
              notifBody: l10n.notifTrackingBody,
              notifDesc: l10n.notifTrackingDesc,
            );
        context.go('/');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(activeEventProvider(widget.eventId));

    // Redirect to readonly detail page if it expires in the background while we are here
    ref.listen(activeEventProvider(widget.eventId), (prev, next) {
      final ev = next.event.valueOrNull;
      if (ev != null && ev.fired) {
        if (mounted &&
            GoRouterState.of(context).matchedLocation.contains('/event/')) {
          context.replace('/history/${widget.eventId}');
        }
      }
    });

    // Initial time update on first build with data
    if (state.event.hasValue && _remaining == Duration.zero && !_isExpired) {
      Future.microtask(() => _updateTime());
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: state.event.when(
        data: (event) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Hero Timer (Top Section)
              Expanded(
                flex: 4,
                child: Center(
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      event.fired
                          ? AppLocalizations.of(context)!.alertsSent
                          : (event.terminated
                                ? AppLocalizations.of(context)!.cancelled
                                : (_isExpired
                                      ? AppLocalizations.of(context)!.alertsSent
                                      : _formatDuration(_remaining))),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: FontUtils.getCourierFont(
                          context,
                        ), // Monospace with fallback
                        fontSize: (event.fired || _isExpired)
                            ? 40
                            : 56, // Adjust for longer text
                        fontWeight: FontWeight.w900, // ExtraBold
                        color: (event.fired || _isExpired)
                            ? AppTheme.errorColor
                            : (event.terminated ? Colors.grey : _getTimerColor()),
                        letterSpacing: TextStyleHelper.getLetterSpacing(context, 4.0),
                      ),
                    ),
                  ),
                ),
              ),

              // 2. Targeted Contacts Section
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
                child: Text(
                  AppLocalizations.of(context)!.recipients,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: TextStyleHelper.getLetterSpacing(context, 1.5),
                  ),
                ),
              ),

              SizedBox(
                height: 70, // Fixed height for contacts row
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: event.contacts.isEmpty ? 1 : event.contacts.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    if (event.contacts.isEmpty) {
                      return _buildContactCard(
                        name: AppLocalizations.of(context)!.noContacts,
                        status: AppLocalizations.of(context)!.none,
                        statusColor: Colors.grey,
                      );
                    }
                    final contact = event.contacts[index];
                    // Use name if available, otherwise fallback to email or 'Unknown'
                    final displayName = contact.name?.isNotEmpty == true
                        ? contact.name!
                        : (contact.email.isNotEmpty
                              ? contact.email.split('@')[0]
                              : AppLocalizations.of(context)!.unknown);

                    return _buildContactCard(
                      name: displayName.toUpperCase(),
                      status: event.terminated
                          ? AppLocalizations.of(context)!.cancelled
                          : (_isExpired
                                ? AppLocalizations.of(context)!.alertsSent
                                : AppLocalizations.of(context)!.pending),
                      statusColor: event.terminated
                          ? Colors.grey
                          : (_isExpired
                                ? AppTheme.errorColor
                                : Colors.greenAccent),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // 3. Briefing Block (Consolidated Details)
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
                child: Text(
                  AppLocalizations.of(context)!.details,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: TextStyleHelper.getLetterSpacing(context, 1.5),
                  ),
                ),
              ),

              // Location status banner
              if (_locationBanner != _LocationBannerState.none)
                _buildLocationBanner(),

              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                color: AppTheme.darkSurface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.message?.isNotEmpty == true
                          ? event.message!
                          : AppLocalizations.of(context)!.noMessage,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(
                          Icons.attach_file,
                          color: AppTheme.primaryColor,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(
                            context,
                          )!.filesCount(event.attachments.length),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Icon(
                          Icons.location_on,
                          color: _locationBanner == _LocationBannerState.none
                              ? Colors.greenAccent
                              : Colors.grey,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _locationBanner == _LocationBannerState.none
                              ? AppLocalizations.of(context)!.tracking
                              : (_locationBanner == _LocationBannerState.denied
                                    ? AppLocalizations.of(context)!.locationOff
                                    : AppLocalizations.of(
                                        context,
                                      )!.locationLimited),
                          style: TextStyle(
                            color: _locationBanner == _LocationBannerState.none
                                ? Colors.white70
                                : Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Spacer to push actions to bottom if screen is tall
              const Spacer(),

              // 4. Actions (Bottom)
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Cancel Button
                    if (!event.terminated &&
                        !_isExpired &&
                        !state.isCheckingIn &&
                        !state.isCancelling)
                      TextButton(
                        onPressed: _handleCancel,
                        child: Text(
                          AppLocalizations.of(context)!.cancelEvent,
                          style: TextStyle(
                            color: Colors.white54,
                            letterSpacing: TextStyleHelper.getLetterSpacing(context, 1.5),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    const SizedBox(height: 16),

                    // I AM SAFE Button
                    SizedBox(
                      width: double.infinity,
                      height: 80, // Massive
                      child: ElevatedButton(
                        onPressed:
                            event.terminated ||
                                _isExpired ||
                                state.isCheckingIn ||
                                state.isCancelling
                            ? (event.terminated || _isExpired
                                  ? () => context.go('/')
                                  : null)
                            : _handleCheckIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: (event.terminated || _isExpired)
                              ? Colors.white24
                              : AppTheme.primaryColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ), // Sharp
                        ),
                        child: state.isCheckingIn
                            ? const CircularProgressIndicator(
                                color: Colors.black,
                              )
                            : Text(
                                event.terminated || _isExpired
                                    ? AppLocalizations.of(context)!.returnToHome
                                    : AppLocalizations.of(context)!.iAmSafe,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color:
                                      Colors.black, // High contrast on Orange
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: TextStyleHelper.getLetterSpacing(context, 1.5),
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).padding.bottom),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryColor),
        ),
        error: (err, stack) => CustomErrorWidget(
          message: AppLocalizations.of(context)!.failedToLoadEventDetails,
          onRetry: () => ref.invalidate(activeEventProvider),
        ),
      ),
    );
  }

  Future<void> _checkLocationStatus() async {
    // Check user preference first
    final prefs = ref.read(preferencesServiceProvider);
    if (!prefs.locationTrackingEnabled) {
      if (mounted) {
        setState(() => _locationBanner = _LocationBannerState.disabledByUser);
      }
      return;
    }

    final fineStatus = await Permission.locationWhenInUse.status;
    if (!fineStatus.isGranted) {
      if (mounted) {
        setState(() => _locationBanner = _LocationBannerState.denied);
      }
      return;
    }

    final bgStatus = await Permission.locationAlways.status;
    if (!bgStatus.isGranted) {
      if (mounted) {
        setState(
          () => _locationBanner = _LocationBannerState.backgroundLimited,
        );
      }
      return;
    }

    if (mounted) {
      setState(() => _locationBanner = _LocationBannerState.none);
    }
  }

  Widget _buildLocationBanner() {
    String text;
    String? actionText;
    VoidCallback? onAction;

    switch (_locationBanner) {
      case _LocationBannerState.disabledByUser:
        text = AppLocalizations.of(context)!.locationTrackingOffBanner;
        actionText = null;
        onAction = null;
      case _LocationBannerState.denied:
        text = AppLocalizations.of(context)!.locationDeniedBanner;
        actionText = null;
        onAction = null;
      case _LocationBannerState.backgroundLimited:
        text = AppLocalizations.of(context)!.locationLimitedBanner;
        actionText = AppLocalizations.of(context)!.openSettings;
        onAction = () => openAppSettings();
      case _LocationBannerState.none:
        return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
      padding: const EdgeInsets.all(12),
      color: AppTheme.darkSurface,
      child: Row(
        children: [
          const Icon(Icons.location_off, color: Colors.grey, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 13,
              ),
            ),
          ),
          if (actionText != null && onAction != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: Text(
                actionText,
                style: const TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required String name,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      width: 200, // Fixed width for consistency
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppTheme.darkSurface, // #1E1E1E
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            status,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: TextStyleHelper.getLetterSpacing(context, 1.0),
            ),
          ),
        ],
      ),
    );
  }
}
