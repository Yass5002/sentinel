import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentinel/core/theme/app_theme.dart';
import 'package:sentinel/core/theme/text_style_helper.dart';
import 'package:sentinel/core/time/time_sync_provider.dart';
import 'package:sentinel/features/events/presentation/event_providers.dart';
import 'package:sentinel/features/events/domain/event_model.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:sentinel/core/theme/font_utils.dart';
import 'package:sentinel/core/util/localization_helper.dart';
import 'package:sentinel/l10n/app_localizations.dart';

class EventCard extends ConsumerStatefulWidget {
  final Event event;
  final VoidCallback onTap;

  const EventCard({super.key, required this.event, required this.onTap});

  @override
  ConsumerState<EventCard> createState() => _EventCardState();
}

class _EventCardState extends ConsumerState<EventCard> {
  late Timer _timer;
  Duration _remaining = Duration.zero;
  bool _isActive = false;

  @override
  void initState() {
    super.initState();
    _updateStatus();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateStatus());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateStatus() {
    // Use the synchronized time from the provider
    final now = ref.read(timeSyncProvider.notifier).now;

    final isActive =
        !widget.event.terminated &&
        !widget.event.checkedIn &&
        !widget.event.fired &&
        widget.event.expiresAt.isAfter(now);

    if (mounted) {
      setState(() {
        _isActive = isActive;
        if (isActive) {
          _remaining = widget.event.expiresAt.difference(now);
        } else {
          _remaining = Duration.zero;
        }
      });
    }
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(d.inHours);
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  Color _getStatusColor() {
    if (_isActive) {
      if (_remaining.inMinutes < 30) return Colors.red;
      return AppTheme.primaryColor;
    }

    // Muted colors for inactive state
    if (widget.event.checkedIn) return Colors.green.withValues(alpha: 0.6);
    if (widget.event.fired) return Colors.red.withValues(alpha: 0.6);
    // Terminated / Canceled / Expired defaults
    if (widget.event.terminated) return Colors.grey.withValues(alpha: 0.4);

    // Default fallback for "Alert Sent" (expired locally but not fired yet)
    return Colors.red.withValues(alpha: 0.6);
  }

  @override
  Widget build(BuildContext context) {
    // Sharp corners, Dark Grey background
    Widget card = Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        // Muted background for inactive events (almost black), distinct from active (dark grey)
        color: _isActive ? AppTheme.darkSurface : const Color(0xFF141414),
        child: InkWell(
          onTap: widget.onTap,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left Accent Strip
                Container(width: 4, color: _getStatusColor()),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          widget.event.name.toUpperCase(),
                          style: TextStyle(
                            color: _isActive
                                ? Colors.white
                                : Colors.white.withValues(
                                    alpha: 0.3,
                                  ), // Much dimmer for inactive
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: TextStyleHelper.getLetterSpacing(context, 1.0),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Timer or Status
                        if (_isActive)
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Text(
                              _formatDuration(_remaining),
                              style: TextStyle(
                                fontFamily: FontUtils.getCourierFont(context),
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: _remaining.inMinutes < 10
                                    ? Colors.red
                                    : Colors.white,
                                letterSpacing: TextStyleHelper.getLetterSpacing(context, 2.0),
                              ),
                            ),
                          )
                        else
                          Text(
                            widget.event.checkedIn
                                ? AppLocalizations.of(context)!.checkedIn
                                : (widget.event.fired
                                      ? AppLocalizations.of(context)!.alertsSent
                                      : (widget.event.terminated
                                            ? AppLocalizations.of(
                                                context,
                                              )!.cancelled
                                            : AppLocalizations.of(
                                                context,
                                              )!.alertsSent)),
                            style: TextStyle(
                              color: _getStatusColor(),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),

                        const SizedBox(height: 8),
                        // Metadata
                        Text(
                          '${AppLocalizations.of(context)!.created} ${timeago.format(widget.event.createdAt, locale: Localizations.localeOf(context).languageCode)}',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.3),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Right Arrow (Optional, very subtle)
                if (_isActive)
                  Center(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(end: 16.0),
                      child: L10nHelper.flippedIcon(
                        context,
                        Icons.arrow_forward_ios_sharp,
                        size: 16,
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );

    if (_isActive) return card;

    return Dismissible(
      key: Key(widget.event.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        color: AppTheme.errorColor,
        alignment: AlignmentDirectional.centerEnd,
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: const Icon(Icons.delete_sharp, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppTheme.darkSurface,
            title: Text(
              AppLocalizations.of(context)!.deleteEvent,
              style: const TextStyle(color: Colors.white),
            ),
            content: Text(
              AppLocalizations.of(context)!.deleteEventHistoryConfirm,
              style: const TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  AppLocalizations.of(context)!.cancel,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  AppLocalizations.of(context)!.delete,
                  style: const TextStyle(color: AppTheme.errorColor),
                ),
              ),
            ],
          ),
        );

        if (confirmed != true) return false;

        try {
          await ref
              .read(eventListProvider.notifier)
              .deleteHistory(widget.event.id);
          return true;
        } catch (e) {
          return false; // Slides back if it fails
        }
      },
      child: card,
    );
  }
}
