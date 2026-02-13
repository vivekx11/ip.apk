import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../services/cloudinary_upload_service.dart';

/// Example screen showing how to upload a product with image
class UploadProductExample extends StatefulWidget {
  final String shopId;
  final String shopName;

  const UploadProductExample({
    Key? key,
    required this.shopId,
    required this.shopName,
  }) : super(key: key);

  @override
  State<UploadProductExample> createState() => _UploadProductExampleState();
}

class _UploadProductExampleState extends State<UploadProductExample> {
  final _formKey = GlobalKey<FormState>();
  final _uploadService = CloudinaryUploadService();
  
  // Form controllers
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  
  XFile? _selectedImage;
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  String _selectedCategory = 'General';
  String _selectedUnit = 'piece';

  final List<String> _categories = [
    'General',
    'Food & Beverages',
    'Electronics',
    'Clothing',
    'Home & Garden',
    'Sports',
    'Books',
    'Toys',
    'Health & Beauty',
    'Other'
  ];

  final List<String> _units = ['piece', 'kg', 'gram', 'liter', 'ml', 'dozen', 'pack'];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final image = await _uploadService.pickImageFromGallery();
                if (image != null) {
                  setState(() => _selectedImage = image);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () async {
                Navigator.pop(context);
                final image = await _uploadService.pickImageFromCamera();
                if (image != null) {
                  setState(() => _selectedImage = image);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadProduct() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    try {
      final result = await _uploadService.uploadProduct(
        imageFile: _selectedImage!,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.parse(_priceController.text),
        shopId: widget.shopId,
        shopName: widget.shopName,
        category: _selectedCategory,
        stock: int.tryParse(_stockController.text) ?? 0,
        unit: _selectedUnit,
        onProgress: (progress) {
          setState(() => _uploadProgress = progress);
        },
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Product uploaded successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Clear form
        _nameController.clear();
        _descriptionController.clear();
        _priceController.clear();
        _stockController.clear();
        setState(() {
          _selectedImage = null;
          _selectedCategory = 'General';
          _selectedUnit = 'piece';
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Product'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Image picker
            GestureDetector(
              onTap: _isUploading ? null : _pickImage,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[400]!),
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(_selectedImage!.path),
                          fit: BoxFit.cover,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate, size: 64, color: Colors.grey[600]),
                          const SizedBox(height: 8),
                          Text('Tap to select image', style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 24),

            // Product name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Product Name *',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter product name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description *',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Price
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Price *',
                border: OutlineInputBorder(),
                prefixText: '\$ ',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter price';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter valid price';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Category
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (value) {
                if (value != null) setState(() => _selectedCategory = value);
              },
            ),
            const SizedBox(height: 16),

            // Stock and Unit
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _stockController,
                    decoration: const InputDecoration(
                      labelText: 'Stock',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<String>(
                    value: _selectedUnit,
                    decoration: const InputDecoration(
                      labelText: 'Unit',
                      border: OutlineInputBorder(),
                    ),
                    items: _units.map((unit) {
                      return DropdownMenuItem(value: unit, child: Text(unit));
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) setState(() => _selectedUnit = value);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Upload progress
            if (_isUploading) ...[
              LinearProgressIndicator(value: _uploadProgress),
              const SizedBox(height: 8),
              Text(
                'Uploading... ${(_uploadProgress * 100).toStringAsFixed(0)}%',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
            ],

            // Upload button
            ElevatedButton(
              onPressed: _isUploading ? null : _uploadProduct,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isUploading
                  ? const CircularProgressIndicator()
                  : const Text('Upload Product', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
