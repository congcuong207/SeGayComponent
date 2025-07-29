import 'package:flutter/material.dart';
import 'common/sg_file_upload.dart';
import 'common/sg_colors.dart';
import 'common/sg_text.dart';

class FileUploadExample extends StatefulWidget {
  const FileUploadExample({Key? key}) : super(key: key);

  @override
  State<FileUploadExample> createState() => _FileUploadExampleState();
}

class _FileUploadExampleState extends State<FileUploadExample> {
  List<SGUploadedFile> _uploadedFiles = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SGText(
          text: 'File Upload Example',
          size: 20,
          fontWeight: FontWeight.w600,
        ),
        backgroundColor: SGAppColors.primary600,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SGText(
              text: 'Upload Files',
              size: 24,
              fontWeight: FontWeight.bold,
              color: SGAppColors.neutral900,
            ),
            const SizedBox(height: 8),
            const SGText(
              text: 'Select files from your computer or drag and drop them here',
              size: 16,
              color: SGAppColors.neutral600,
            ),
            const SizedBox(height: 24),
            
            // Basic upload
            const SGText(
              text: 'Basic Upload',
              size: 18,
              fontWeight: FontWeight.w600,
              color: SGAppColors.neutral800,
            ),
            const SizedBox(height: 12),
            SGFileUpload(
              onFilesSelected: (files) {
                setState(() {
                  _uploadedFiles = files;
                });
              },
            ),
            const SizedBox(height: 32),
            
            // Upload with restrictions
            const SGText(
              text: 'Upload with Restrictions',
              size: 18,
              fontWeight: FontWeight.w600,
              color: SGAppColors.neutral800,
            ),
            const SizedBox(height: 12),
            SGFileUpload(
              onFilesSelected: (files) {
                setState(() {
                  _uploadedFiles = files;
                });
              },
              allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
              maxFileSize: 5 * 1024 * 1024, // 5MB
              maxFiles: 3,
              title: 'Upload Documents',
              subtitle: 'Only images, PDFs and Word documents up to 5MB',
            ),
            const SizedBox(height: 32),
            
            // File list
            if (_uploadedFiles.isNotEmpty) ...[
              SGFileUploadList(
                files: _uploadedFiles,
                onRemove: (file) {
                  setState(() {
                    _uploadedFiles.remove(file);
                  });
                },
              ),
              const SizedBox(height: 24),
              
              // Upload button
              ElevatedButton(
                onPressed: _uploadFiles,
                style: ElevatedButton.styleFrom(
                  backgroundColor: SGAppColors.primary600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const SGText(
                  text: 'Upload Files',
                  size: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _uploadFiles() {
    // Here you would implement the actual file upload logic
    // For example, using Dio to upload to your server
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: SGText(
          text: 'Uploading ${_uploadedFiles.length} files...',
          size: 16,
          color: Colors.white,
        ),
        backgroundColor: SGAppColors.primary600,
      ),
    );
    
    // Example of how to access file data
    for (final file in _uploadedFiles) {
      print('File: ${file.name}, Size: ${file.formattedSize}, Type: ${file.type}');
      // file.bytes.then((bytes) {
      //   // Upload bytes to server
      // });
    }
  }
} 