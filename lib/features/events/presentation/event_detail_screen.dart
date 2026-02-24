import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentinel/core/theme/app_theme.dart';
import 'package:sentinel/core/theme/text_style_helper.dart';
import 'package:sentinel/features/events/domain/event_model.dart';
import 'package:sentinel/features/events/presentation/event_providers.dart';
import 'package:sentinel/features/events/presentation/event_detail_provider.dart';
import 'package:sentinel/core/widgets/custom_error_widget.dart';
import 'package:intl/intl.dart' hide TextDirection;

import 'package:open_file/open_file.dart';
import 'package:sentinel/features/files/data/file_repository.dart';
import 'package:sentinel/features/files/domain/file_model.dart';
import 'package:sentinel/core/theme/font_utils.dart';
import 'package:sentinel/l10n/app_localizations.dart';

class EventDetailScreen extends ConsumerStatefulWidget {
  final String eventId;

  const EventDetailScreen({super.key, required this.eventId});

  @override
  ConsumerState<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends ConsumerState<EventDetailScreen> {
  String? _downloadingFileId;
  double _downloadProgress = 0.0;
  String? _downloadError;

  Future<void> _downloadAndOpenFile(FileModel file) async {
    if (_downloadingFileId != null) return;
    setState(() {
      _downloadingFileId = file.id;
      _downloadProgress = 0.0;
      _downloadError = null;
    });

    try {
      final repository = ref.read(fileRepositoryProvider);
      final downloadedFile = await repository.downloadFile(
        file.id,
        file.filename,
        onProgress: (received, total) {
          if (total != -1 && mounted) {
            setState(() {
              _downloadProgress = received / total;
            });
          }
        },
      );

      final result = await OpenFile.open(
        downloadedFile.path,
      ); // OpenFile will safely handle IO permissions
      if (result.type != ResultType.done && mounted) {
        setState(() {
          _downloadError = AppLocalizations.of(
            context,
          )!.failedToOpenFile(result.message);
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _downloadError = AppLocalizations.of(context)!.failedToDownloadFile;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _downloadingFileId = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventAsync = ref.watch(eventDetailProvider(widget.eventId));

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
    return CustomErrorWidget(
      message: error.toString(),
      onRetry: () => ref.invalidate(eventDetailProvider(widget.eventId)),
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
            padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(
                        Directionality.of(context) == TextDirection.rtl
                            ? Icons.arrow_forward_sharp
                            : Icons.arrow_back_sharp,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        event.name.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: TextStyleHelper.getLetterSpacing(context, 1.2),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (event.terminated || event.checkedIn || event.fired)
                      Consumer(
                        builder: (context, ref, child) {
                          return IconButton(
                            icon: const Icon(
                              Icons.delete_sharp,
                              color: Colors.white54,
                            ),
                            onPressed: () async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: AppTheme.darkSurface,
                                  title: Text(
                                    AppLocalizations.of(context)!.deleteEvent,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  content: Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.deleteEventHistoryConfirm,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: Text(
                                        AppLocalizations.of(context)!.cancel,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: Text(
                                        AppLocalizations.of(context)!.delete,
                                        style: const TextStyle(
                                          color: AppTheme.errorColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );

                              if (confirmed != true) return;

                              try {
                                await ref
                                    .read(eventListProvider.notifier)
                                    .deleteHistory(event.id);
                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                }
                              } catch (e) {
                                // Silent fail natively per spec requirements for inline errors
                                // Ideally we show state, but simple pop and refresh fails silently
                                // if offline, matching offline spec.
                              }
                            },
                          );
                        },
                      ),
                  ],
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
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 24, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Message Block
                      if (event.message?.isNotEmpty == true) ...[
                        _buildSectionTitle(
                          AppLocalizations.of(context)!.messageTitle,
                        ),
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
                      _buildSectionTitle(
                        AppLocalizations.of(context)!.recipients,
                      ),
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
                                name: AppLocalizations.of(
                                  context,
                                )!.noRecipients,
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

                            String statusText = AppLocalizations.of(
                              context,
                            )!.pending;
                            Color statusColor = Colors.grey;

                            if (event.fired) {
                              statusText = AppLocalizations.of(
                                context,
                              )!.alertsSent;
                              statusColor = AppTheme.errorColor;
                            } else if (event.checkedIn) {
                              statusText = AppLocalizations.of(context)!.safe;
                              statusColor = Colors.green;
                            } else if (event.terminated) {
                              statusText = AppLocalizations.of(
                                context,
                              )!.cancelled;
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
                        _buildSectionTitle(
                          AppLocalizations.of(context)!.attachments,
                        ),
                        if (_downloadError != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              _downloadError!,
                              style: const TextStyle(
                                color: AppTheme.errorColor,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        const SizedBox(height: 4),
                        ...event.attachments.map(
                          (file) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: InkWell(
                              onTap: () => _downloadAndOpenFile(file),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                color: AppTheme.darkSurface,
                                child: Row(
                                  children: [
                                    if (_downloadingFileId == file.id)
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          value: _downloadProgress > 0
                                              ? _downloadProgress
                                              : null,
                                          strokeWidth: 2,
                                          color: AppTheme.primaryColor,
                                        ),
                                      )
                                    else
                                      const Icon(
                                        Icons.insert_drive_file,
                                        color: AppTheme.primaryColor,
                                        size: 20,
                                      ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        file.filename,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontFamily: FontUtils.getCourierFont(
                                            context,
                                          ),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      _formatBytes(file.fileSize),
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.5,
                                        ),
                                        fontSize: 12,
                                        fontFamily: FontUtils.getCourierFont(
                                          context,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Icon(
                                      Icons.download_sharp,
                                      color: Colors.white.withValues(
                                        alpha: 0.5,
                                      ),
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],

                      // Metadata footer
                      const SizedBox(height: 24),
                      Center(
                        child: Text(
                          '${AppLocalizations.of(context)!.created} ${DateFormat('MMM d, yyyy · HH:mm').format(event.createdAt).toUpperCase()}',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontFamily: FontUtils.getCourierFont(context),
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            letterSpacing: TextStyleHelper.getLetterSpacing(context, 1.0),
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
      text = AppLocalizations.of(context)!.safe.toUpperCase();
    } else if (event.fired) {
      bgColor = const Color(0xFFB71C1C); // Deep Red
      text = AppLocalizations.of(context)!.alertsSent;
    } else if (event.terminated) {
      bgColor = AppTheme.darkSurface;
      text = AppLocalizations.of(context)!.cancelled;
    } else {
      bgColor = AppTheme.primaryColor;
      text = AppLocalizations.of(context)!.active;
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
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  letterSpacing: TextStyleHelper.getLetterSpacing(context, 3.0),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                dateStr,
                style: TextStyle(
                  color: Colors.white70,
                  fontFamily: FontUtils.getCourierFont(context),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: TextStyleHelper.getLetterSpacing(context, 1.0),
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
          color: Colors.white.withValues(alpha: 0.5),
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: TextStyleHelper.getLetterSpacing(context, 1.5),
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
              color: Colors.white.withValues(alpha: 0.5),
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
