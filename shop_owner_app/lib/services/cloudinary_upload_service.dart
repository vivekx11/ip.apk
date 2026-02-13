import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'dart:convert';

class CloudinaryUploadService {
  static final CloudinaryUploadService _instance = CloudinaryUploadService._internal();
  factory CloudinaryUploadService() => _instance;
  CloudinaryUploadService._internal();

  final ImagePicker _picker = ImagePicker();
  
  // Production backend URL
  static const String API_BASE_URL = 'https://instantpick-backend.onrender.com/api';
  
  // Use ImageKit upload endpoint
  static const String UPLOAD_ENDPOINT = '$API_BASE_URL/upload/product';

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

  /// Upload product with image to backend
  Future<Map<String, dynamic>> uploadProduct({
    required XFile imageFile,
    required String name,
    required String description,
    required double price,
    required String shopId,
    required String shopName,
    String? category,
    int? stock,
    String? unit,
    Function(double)? onProgress,
  }) async {
    try {
      // Validate file exists
      final file = File(imageFile.path);
      if (!await file.exists()) {
        throw Exception('Selected image file not found.');
      }

      // Check file size (max 10MB)
      final fileSize = await file.length();
      if (fileSize > 10 * 1024 * 1024) {
        throw Exception('Image file too large. Please select an image smaller than 10MB.');
      }

      print('📤 Uploading product to: $UPLOAD_ENDPOINT');

      // Create multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(UPLOAD_ENDPOINT),
      );

      // Add image file
      var multipartFile = await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        contentType: MediaType('image', path.extension(imageFile.path).replaceAll('.', '')),
      );
      request.files.add(multipartFile);

      // Add product data
      request.fields['name'] = name;
      request.fields['description'] = description;
      request.fields['price'] = price.toString();
      request.fields['shopId'] = shopId;
      request.fields['shopName'] = shopName;
      
      if (category != null) request.fields['category'] = category;
      if (stock != null) request.fields['stock'] = stock.toString();
      if (unit != null) request.fields['unit'] = unit;

      // Send request with timeout
      var streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Upload timeout. Server is taking too long to respond.');
        },
      );
      
      // Get response
      var response = await http.Response.fromStream(streamedResponse);
      
      print('📊 Response status: ${response.statusCode}');
      print('📊 Response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = json.decode(response.body);
        
        if (responseData['success'] == true) {
          print('✅ Product uploaded successfully');
          return responseData;
        } else {
          throw Exception(responseData['message'] ?? 'Upload failed');
        }
      } else if (response.statusCode == 404) {
        throw Exception('Upload endpoint not found. Please check backend URL.');
      } else if (response.statusCode >= 500) {
        throw Exception('Server error. Please try again later.');
      } else {
        try {
          final errorData = json.decode(response.body);
          throw Exception(errorData['message'] ?? 'Upload failed with status ${response.statusCode}');
        } catch (e) {
          throw Exception('Upload failed: ${response.body}');
        }
      }

    } catch (e) {
      print('❌ Error uploading product: $e');
      print('❌ Error type: ${e.runtimeType}');
      rethrow;
    }
  }

  /// Upload additional images to existing product
  Future<Map<String, dynamic>> uploadAdditionalImages({
    required String productId,
    required List<XFile> imageFiles,
    Function(int, double)? onProgress,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$API_BASE_URL/upload/product/$productId/images'),
      );

      // Add all image files
      for (var imageFile in imageFiles) {
        var multipartFile = await http.MultipartFile.fromPath(
          'images',
          imageFile.path,
          contentType: MediaType('image', path.extension(imageFile.path).replaceAll('.', '')),
        );
        request.files.add(multipartFile);
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData;
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to upload images');
      }

    } catch (e) {
      print('❌ Error uploading additional images: $e');
      rethrow;
    }
  }

  /// Delete image from backend
  Future<bool> deleteImage(String imageUrl) async {
    try {
      final response = await http.delete(
        Uri.parse('$API_BASE_URL/upload/image'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'imageUrl': imageUrl}),
      );

      if (response.statusCode == 200) {
        print('✅ Image deleted successfully');
        return true;
      } else {
        print('❌ Failed to delete image');
        return false;
      }
    } catch (e) {
      print('❌ Error deleting image: $e');
      return false;
    }
  }
}
