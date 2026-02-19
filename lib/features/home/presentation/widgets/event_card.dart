import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentinel/core/theme/app_theme.dart';
import 'package:sentinel/core/time/time_sync_provider.dart';
import 'package:sentinel/features/events/domain/event_model.dart';
import 'package:timeago/timeago.dart' as timeago;

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
    if (widget.event.checkedIn) return Colors.green.withOpacity(0.6);
    if (widget.event.fired) return Colors.red.withOpacity(0.6);
    // Terminated / Canceled / Expired defaults
    if (widget.event.terminated) return Colors.grey.withOpacity(0.4);

    // Default fallback for "Alert Sent" (expired locally but not fired yet)
    return Colors.red.withOpacity(0.6);
  }

  @override
  Widget build(BuildContext context) {
    // Sharp corners, Dark Grey background
    return Container(
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
                                : Colors.white.withOpacity(
                                    0.3,
                                  ), // Much dimmer for inactive
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Timer or Status
                        if (_isActive)
                          Text(
                            _formatDuration(_remaining),
                            style: TextStyle(
                              fontFamily: 'Courier', // Monospace
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: _remaining.inMinutes < 10
                                  ? Colors.red
                                  : Colors.white,
                              letterSpacing: 2.0,
                            ),
                          )
                        else
                          Text(
                            widget.event.checkedIn
                                ? 'CHECKED IN'
                                : (widget.event.fired
                                      ? 'ALERT SENT'
                                      : (widget.event.terminated
                                            ? 'CANCELED'
                                            : 'ALERT SENT')),
                            style: TextStyle(
                              color: _getStatusColor(),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),

                        const SizedBox(height: 8),
                        // Metadata
                        Text(
                          'Created ${timeago.format(widget.event.createdAt)}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.3),
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
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Icon(
                        Icons
                            .arrow_forward_ios_sharp, // Use sharp arrow if available or standard
                        size: 16,
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
