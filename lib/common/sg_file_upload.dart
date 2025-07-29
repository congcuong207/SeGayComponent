import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'sg_colors.dart';
import 'sg_text.dart';

class SGFileUpload extends StatefulWidget {
  final Function(List<SGUploadedFile>) onFilesSelected;
  final List<String>? allowedExtensions;
  final int? maxFileSize; // in bytes
  final int? maxFiles;
  final String? title;
  final String? subtitle;
  final bool multiple;

  const SGFileUpload({
    Key? key,
    required this.onFilesSelected,
    this.allowedExtensions,
    this.maxFileSize,
    this.maxFiles,
    this.title,
    this.subtitle,
    this.multiple = true,
  }) : super(key: key);

  @override
  State<SGFileUpload> createState() => _SGFileUploadState();
}

class _SGFileUploadState extends State<SGFileUpload> {
  bool _isDragOver = false;
  List<SGUploadedFile> _uploadedFiles = [];

  @override
  void initState() {
    super.initState();
    _setupDragAndDrop();
  }

  void _setupDragAndDrop() {
    // Add drag and drop event listeners to the document
    html.document.addEventListener('dragover', (event) {
      event.preventDefault();
    });

    html.document.addEventListener('dragenter', (event) {
      event.preventDefault();
      setState(() {
        _isDragOver = true;
      });
    });

    html.document.addEventListener('dragleave', (event) {
      event.preventDefault();
      setState(() {
        _isDragOver = false;
      });
    });

    html.document.addEventListener('drop', (event) {
      event.preventDefault();
      setState(() {
        _isDragOver = false;
      });
      final dragEvent = event as dynamic;
      final files = dragEvent.dataTransfer?.files;
      if (files != null) {
        _handleFiles(files);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: _isDragOver ? SGAppColors.primary600 : SGAppColors.neutral300,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
        color: _isDragOver ? SGAppColors.primary600.withOpacity(0.1) : Colors.white,
      ),
      child: GestureDetector(
        onTap: _showFilePicker,
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(
                Icons.cloud_upload_outlined,
                size: 48,
                color: _isDragOver ? SGAppColors.primary600 : SGAppColors.neutral500,
              ),
              const SizedBox(height: 16),
              SGText(
                text: widget.title ?? 'Upload Files',
                size: 18,
                fontWeight: FontWeight.w600,
                color: _isDragOver ? SGAppColors.primary600 : SGAppColors.neutral700,
              ),
              const SizedBox(height: 8),
              SGText(
                text: widget.subtitle ?? 
                      'Click to select files or drag and drop files here',
                size: 14,
                color: SGAppColors.neutral600,
                textAlign: TextAlign.center,
              ),
              if (widget.allowedExtensions != null) ...[
                const SizedBox(height: 8),
                SGText(
                  text: 'Allowed formats: ${widget.allowedExtensions!.join(', ')}',
                  size: 12,
                  color: SGAppColors.neutral500,
                ),
              ],
              if (widget.maxFileSize != null) ...[
                const SizedBox(height: 4),
                SGText(
                  text: 'Max file size: ${_formatFileSize(widget.maxFileSize!)}',
                  size: 12,
                  color: SGAppColors.neutral500,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showFilePicker() {
    final input = html.FileUploadInputElement()
      ..accept = widget.allowedExtensions?.join(',') ?? '*'
      ..multiple = widget.multiple;

    input.click();

    input.onChange.listen((event) {
      final files = input.files;
      if (files != null) {
        _handleFiles(files);
      }
    });
  }

  void _handleFiles(dynamic files) {
    final List<SGUploadedFile> newFiles = [];
    
    for (int i = 0; i < files.length; i++) {
      final file = files[i];
      
      // Check file extension
      if (widget.allowedExtensions != null) {
        final extension = file.name.split('.').last.toLowerCase();
        if (!widget.allowedExtensions!.contains(extension)) {
          _showError('File type not allowed: ${file.name}');
          continue;
        }
      }

      // Check file size
      if (widget.maxFileSize != null && file.size > widget.maxFileSize!) {
        _showError('File too large: ${file.name}');
        continue;
      }

      // Check max files
      if (widget.maxFiles != null && _uploadedFiles.length >= widget.maxFiles!) {
        _showError('Maximum number of files reached');
        continue;
      }

      final uploadedFile = SGUploadedFile(
        name: file.name,
        size: file.size,
        type: file.type,
        file: file,
      );

      newFiles.add(uploadedFile);
    }

    setState(() {
      _uploadedFiles.addAll(newFiles);
    });

    widget.onFilesSelected(_uploadedFiles);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}

class SGUploadedFile {
  final String name;
  final int size;
  final String type;
  final html.File file;

  SGUploadedFile({
    required this.name,
    required this.size,
    required this.type,
    required this.file,
  });

  String get formattedSize {
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    if (size < 1024 * 1024 * 1024) return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(size / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  Future<Uint8List> get bytes async {
    final reader = html.FileReader();
    reader.readAsArrayBuffer(file);
    await reader.onLoad.first;
    return reader.result as Uint8List;
  }
}

class SGFileUploadList extends StatelessWidget {
  final List<SGUploadedFile> files;
  final Function(SGUploadedFile) onRemove;

  const SGFileUploadList({
    Key? key,
    required this.files,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (files.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SGText(
          text: 'Uploaded Files (${files.length})',
          size: 16,
          fontWeight: FontWeight.w600,
          color: SGAppColors.neutral700,
        ),
        const SizedBox(height: 12),
        ...files.map((file) => _buildFileItem(file)),
      ],
    );
  }

  Widget _buildFileItem(SGUploadedFile file) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: SGAppColors.neutral300),
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Icon(
            _getFileIcon(file.type),
            color: SGAppColors.neutral600,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SGText(
                  text: file.name,
                  size: 14,
                  fontWeight: FontWeight.w500,
                  color: SGAppColors.neutral700,
                ),
                SGText(
                  text: file.formattedSize,
                  size: 12,
                  color: SGAppColors.neutral500,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => onRemove(file),
            icon: const Icon(Icons.close, size: 18),
            color: SGAppColors.neutral500,
          ),
        ],
      ),
    );
  }

  IconData _getFileIcon(String type) {
    if (type.startsWith('image/')) return Icons.image;
    if (type.startsWith('video/')) return Icons.video_file;
    if (type.startsWith('audio/')) return Icons.audio_file;
    if (type.contains('pdf')) return Icons.picture_as_pdf;
    if (type.contains('word') || type.contains('document')) return Icons.description;
    if (type.contains('excel') || type.contains('spreadsheet')) return Icons.table_chart;
    if (type.contains('powerpoint') || type.contains('presentation')) return Icons.slideshow;
    return Icons.insert_drive_file;
  }
} 