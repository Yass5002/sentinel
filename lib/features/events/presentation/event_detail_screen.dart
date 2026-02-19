import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentinel/core/theme/app_theme.dart';
import 'package:sentinel/features/events/domain/event_model.dart';
import 'package:sentinel/features/events/presentation/event_detail_provider.dart';
import 'package:intl/intl.dart';

class EventDetailScreen extends ConsumerWidget {
  final String eventId;

  const EventDetailScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(eventDetailProvider(eventId));

    return Scaffold(
      backgroundColor: Colors.black,
      body: eventAsync.when(
        data: (event) => _buildContent(context, event),
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryColor),
        ),
        error: (err, stack) => _buildErrorState(context, err),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: AppTheme.errorColor, size: 64),
          const SizedBox(height: 16),
          const Text(
            'EVENT NOT FOUND',
            style: TextStyle(
              color: AppTheme.errorColor,
              fontFamily: 'Courier',
              fontWeight: FontWeight.bold,
              fontSize: 24,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: const TextStyle(color: Colors.white54),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('BACK', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, Event event) {
    return Column(
      children: [
        // 1. Top Bar: Event Name + Back
        SafeArea(
          bottom: false,
          child: Container(
            width: double.infinity,
            color: Colors.black,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    event.name.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),

        // 2. Scrollable Body
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildStatusHeader(event),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Message Block
                      if (event.message?.isNotEmpty == true) ...[
                        _buildSectionTitle('MESSAGE'),
                        const SizedBox(height: 4),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          color: AppTheme.darkSurface,
                          child: Text(
                            event.message!,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                              height: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Recipients
                      _buildSectionTitle('RECIPIENTS'),
                      const SizedBox(height: 4),
                      SizedBox(
                        height: 90,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: event.contacts.isEmpty
                              ? 1
                              : event.contacts.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            if (event.contacts.isEmpty) {
                              return _buildContactCard(
                                name: 'NO RECIPIENTS',
                                email: '',
                                status: 'NONE',
                                statusColor: Colors.grey,
                              );
                            }
                            final contact = event.contacts[index];
                            final displayName = contact.name?.isNotEmpty == true
                                ? contact.name!
                                : (contact.email.isNotEmpty
                                      ? contact.email.split('@')[0]
                                      : 'Unknown');

                            String statusText = 'PENDING';
                            Color statusColor = Colors.grey;

                            if (event.fired) {
                              statusText = 'SENT';
                              statusColor = AppTheme.errorColor;
                            } else if (event.checkedIn) {
                              statusText = 'SAFE';
                              statusColor = Colors.green;
                            } else if (event.terminated) {
                              statusText = 'CANCELLED';
                              statusColor = Colors.grey;
                            }

                            return _buildContactCard(
                              name: displayName.toUpperCase(),
                              email: contact.email,
                              status: statusText,
                              statusColor: statusColor,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Attachments
                      if (event.attachments.isNotEmpty) ...[
                        _buildSectionTitle('ATTACHMENTS'),
                        const SizedBox(height: 4),
                        ...event.attachments.map(
                          (file) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              color: AppTheme.darkSurface,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.insert_drive_file,
                                    color: AppTheme.primaryColor,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      file.filename,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontFamily: 'Courier',
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    _formatBytes(file.fileSize),
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 12,
                                      fontFamily: 'Courier',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],

                      // Metadata footer
                      const SizedBox(height: 24),
                      Center(
                        child: Text(
                          'CREATED ${DateFormat('MMM d, yyyy · HH:mm').format(event.createdAt).toUpperCase()}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontFamily: 'Courier',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusHeader(Event event) {
    Color bgColor;
    String text;

    if (event.checkedIn) {
      bgColor = const Color(0xFF1B5E20); // Dark Green
      text = 'CHECKED IN';
    } else if (event.fired) {
      bgColor = const Color(0xFFB71C1C); // Deep Red
      text = 'ALERTS SENT';
    } else if (event.terminated) {
      bgColor = AppTheme.darkSurface;
      text = 'CANCELLED';
    } else {
      bgColor = AppTheme.primaryColor;
      text = 'ACTIVE';
    }

    final date = event.updatedAt;
    final dateStr = DateFormat(
      'MMM d, yyyy · HH:mm',
    ).format(date).toUpperCase();

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenHeight = MediaQuery.of(context).size.height;
        return Container(
          width: double.infinity,
          height: screenHeight * 0.25,
          color: bgColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3.0,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                dateStr,
                style: const TextStyle(
                  color: Colors.white70,
                  fontFamily: 'Courier',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white.withOpacity(0.5),
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required String name,
    required String email,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(12),
      color: AppTheme.darkSurface, // #1E1E1E
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            email,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 10,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(color: statusColor, width: 1),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
