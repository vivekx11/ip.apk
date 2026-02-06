import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'network_service.dart';

class PhotoUploadService {
  static final PhotoUploadService _instance = PhotoUploadService._internal();
  factory PhotoUploadService() => _instance;
  PhotoUploadService._internal();

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  final NetworkService _networkService = NetworkService();

  /// Pick image from gallery
  Future<XFile?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      return image;
    } catch (e) {
      print('Error picking image from gallery: $e');
      return null;
    }
  }

  /// Pick image from camera
  Future<XFile?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      return image;
    } catch (e) {
      print('Error picking image from camera: $e');
      return null;
    }
  }

  /// Upload image to Firebase Storage
  Future<String?> uploadProductImage({
    required XFile imageFile,
    required String shopName,
    required String productName,
    Function(double)? onProgress,
  }) async {
    // Check internet connection first
    if (!await _networkService.hasInternetConnection()) {
      throw Exception('No internet connection. Please check your network and try again.');
    }

    try {
      // Validate file exists and is readable
      final file = File(imageFile.path);
      if (!await file.exists()) {
        throw Exception('Selected image file not found.');
      }

      // Check file size (max 5MB)
      final fileSize = await file.length();
      if (fileSize > 5 * 1024 * 1024) {
        throw Exception('Image file too large. Please select an image smaller than 5MB.');
      }

      // Create unique filename
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.basename(imageFile.path)}';
      final String filePath = 'products/$shopName/$productName/$fileName';

      // Create reference
      final Reference ref = _storage.ref().child(filePath);

      // Upload file with metadata
      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {
          'uploadedBy': shopName,
          'productName': productName,
          'uploadTime': DateTime.now().toIso8601String(),
        },
      );

      final UploadTask uploadTask = ref.putFile(file, metadata);

      // Listen to upload progress
      if (onProgress != null) {
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          final double progress = snapshot.bytesTransferred / snapshot.totalBytes;
          onProgress(progress);
        });
      }

      // Wait for upload to complete with timeout
      final TaskSnapshot snapshot = await uploadTask.timeout(
        const Duration(minutes: 5),
        onTimeout: () {
          uploadTask.cancel();
          throw Exception('Upload timeout. Please check your internet connection and try again.');
        },
      );
      
      // Get download URL
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      
      print('✅ Image uploaded successfully: $downloadUrl');
      return downloadUrl;
      
    } catch (e) {
      print('❌ Error uploading image: $e');
      return null;
    }
  }

  /// Upload multiple images
  Future<List<String>> uploadMultipleProductImages({
    required List<XFile> imageFiles,
    required String shopName,
    required String productName,
    Function(int, double)? onProgress,
  }) async {
    List<String> downloadUrls = [];
    
    for (int i = 0; i < imageFiles.length; i++) {
      final String? url = await uploadProductImage(
        imageFile: imageFiles[i],
        shopName: shopName,
        productName: productName,
        onProgress: (progress) {
          if (onProgress != null) {
            onProgress(i, progress);
          }
        },
      );
      
      if (url != null) {
        downloadUrls.add(url);
      }
    }
    
    return downloadUrls;
  }

  /// Delete image from Firebase Storage
  Future<bool> deleteProductImage(String imageUrl) async {
    try {
      final Reference ref = _storage.refFromURL(imageUrl);
      await ref.delete();
      print('✅ Image deleted successfully');
      return true;
    } catch (e) {
      print('❌ Error deleting image: $e');
      return false;
    }
  }

  /// Show image picker options dialog
  Future<XFile?> showImagePickerOptions() async {
    // This would typically show a dialog, but for simplicity, we'll just pick from gallery
    return await pickImageFromGallery();
  }
}