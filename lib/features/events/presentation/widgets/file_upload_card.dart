import 'package:flutter/material.dart';
import 'package:sentinel/core/theme/app_theme.dart';
import 'package:sentinel/features/files/domain/file_model.dart';

class FileUploadCard extends StatelessWidget {
  final FileModel file;
  final VoidCallback onDelete;

  const FileUploadCard({super.key, required this.file, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      color: AppTheme.darkSurface,
      height: 48,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            color: Colors.white.withOpacity(0.05),
            child: const Icon(
              Icons.insert_drive_file_sharp,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              file.filename,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_sharp, color: Colors.white),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}

class FileUploadProgressCard extends StatelessWidget {
  final String filename;

  const FileUploadProgressCard({super.key, required this.filename});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      color: AppTheme.darkSurface,
      height: 48,
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                color: Colors.white.withOpacity(0.05),
                child: const SizedBox(
                  width: 24,
                  height: 24,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  filename,
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(height: 2, color: AppTheme.primaryColor),
          ),
        ],
      ),
    );
  }
}
