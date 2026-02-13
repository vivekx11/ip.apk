// Photo upload service - DEPRECATED
// This file is kept for backward compatibility but is no longer used.
// All functionality has been migrated to CloudinaryUploadService.

import 'package:image_picker/image_picker.dart';

class PhotoUploadService {
  static final PhotoUploadService _instance = PhotoUploadService._internal();
  factory PhotoUploadService() => _instance;
  PhotoUploadService._internal();

  final ImagePicker _picker = ImagePicker();

  // This service is deprecated
  // Use CloudinaryUploadService instead for all image upload operations
  
  Future<XFile?> pickImageFromGallery() async {
    return await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 80,
    );
  }

  Future<XFile?> pickImageFromCamera() async {
    return await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 80,
    );
  }
  
  // Stub method for compatibility
  Future<List<String>> uploadMultipleProductImages({
    required List<XFile> imageFiles,
    required String shopName,
    required String productName,
    Function(int, double)? onProgress,
  }) async {
    // This method is deprecated
    // Use CloudinaryUploadService.uploadProduct instead
    return [];
  }
}
