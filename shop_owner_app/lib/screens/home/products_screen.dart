import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/shop_provider.dart';
import '../../providers/product_provider.dart';
import '../../services/shop_sync_service.dart';
import '../products/add_product_screen.dart';
import '../products/product_details_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _sortBy = 'name'; // name, price, stock
  
  @override
  void initState() {
    super.initState();
    _loadProducts();
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    try {
      final shopProvider = Provider.of<ShopProvider>(context, listen: false);
      
      String? shopId = shopProvider.shopId;
      
      if (shopId == null || shopId.isEmpty) {
        final shopSyncService = ShopSyncService();
        await shopSyncService.loadSavedBackendShopId();
        shopId = shopSyncService.backendShopId;
      }
      
      if (shopId != null && shopId.isNotEmpty && mounted) {
        await Provider.of<ProductProvider>(context, listen: false).loadShopProducts(shopId);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading products: $e')),
        );
      }
    }
  }
  
  List<Map<String, dynamic>> _getFilteredAndSortedProducts(List<Map<String, dynamic>> products) {
    // Filter by search query
    var filtered = products.where((product) {
      final name = (product['name'] ?? '').toString().toLowerCase();
      final description = (product['description'] ?? '').toString().toLowerCase();
      final category = (product['category'] ?? '').toString().toLowerCase();
      final query = _searchQuery.toLowerCase();
      
      return name.contains(query) || description.contains(query) || category.contains(query);
    }).toList();
    
    // Filter by category
    if (_selectedCategory != 'All') {
      filtered = filtered.where((product) {
        final category = (product['category'] ?? 'General').toString();
        return category == _selectedCategory;
      }).toList();
    }
    
    // Sort products
    filtered.sort((a, b) {
      switch (_sortBy) {
        case 'name':
          return (a['name'] ?? '').toString().compareTo((b['name'] ?? '').toString());
        case 'price':
          return (a['price'] ?? 0).compareTo(b['price'] ?? 0);
        case 'stock':
          return (b['stock'] ?? 0).compareTo(a['stock'] ?? 0);
        default:
          return 0;
      }
    });
    
    return filtered;
  }
  
  List<String> _getCategories(List<Map<String, dynamic>> products) {
    final categories = products
        .map((p) => (p['category'] ?? 'General').toString())
        .toSet()
        .toList();
    categories.sort();
    return categories;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        backgroundColor: AppTheme.primaryIndigo,
        foregroundColor: AppTheme.white,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) {
              setState(() {
                _sortBy = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'name', child: Text('Sort by Name')),
              const PopupMenuItem(value: 'price', child: Text('Sort by Price')),
              const PopupMenuItem(value: 'stock', child: Text('Sort by Stock')),
            ],
          ),
        ],
      ),
      body: Consumer2<ShopProvider, ProductProvider>(
        builder: (context, shopProvider, productProvider, child) {
          if (productProvider.isLoading) {
            return const Center(child: CircularProgressIndicator(color: AppTheme.primaryIndigo));
          }

          final allProducts = productProvider.products;
          final products = _getFilteredAndSortedProducts(allProducts);
          final categories = _getCategories(allProducts);

          if (allProducts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.inventory_outlined,
                    size: 80,
                    color: AppTheme.lightIndigo,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No products yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppTheme.darkGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Add your first product to get started',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddProductScreen(),
                        ),
                      ).then((_) => _loadProducts());
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Product'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryIndigo,
                      foregroundColor: AppTheme.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Search Bar
              Container(
                color: AppTheme.white,
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: const Icon(Icons.search, color: AppTheme.blueGrey),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: AppTheme.blueGrey),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: AppTheme.lightGrey,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              
              // Category Filters
              if (categories.isNotEmpty)
                Container(
                  color: AppTheme.white,
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildCategoryChip('All'),
                      ...categories.map((category) => _buildCategoryChip(category)),
                    ],
                  ),
                ),
              
              // Products Count
              Container(
                color: AppTheme.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${products.length} ${products.length == 1 ? 'Product' : 'Products'}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.blueGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Sort: ${_sortBy == 'name' ? 'Name' : _sortBy == 'price' ? 'Price' : 'Stock'}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.blueGrey,
                      ),
                    ),
                  ],
                ),
              ),
              
              const Divider(height: 1),
              
              // Products Grid
              Expanded(
                child: products.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.search_off,
                              size: 64,
                              color: AppTheme.lightIndigo,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No products found',
                              style: TextStyle(
                                fontSize: 18,
                                color: AppTheme.darkGrey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _searchQuery.isNotEmpty
                                  ? 'Try a different search term'
                                  : 'No products in this category',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppTheme.blueGrey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadProducts,
                        color: AppTheme.primaryIndigo,
                        child: GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return _buildProductCard(product);
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddProductScreen(),
            ),
          ).then((_) => _loadProducts());
        },
        backgroundColor: AppTheme.primaryIndigo,
        child: const Icon(Icons.add, color: AppTheme.white),
      ),
    );
  }
  
  Widget _buildCategoryChip(String category) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(category),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = category;
          });
        },
        backgroundColor: AppTheme.lightGrey,
        selectedColor: AppTheme.primaryIndigo.withValues(alpha: 0.2),
        labelStyle: TextStyle(
          color: isSelected ? AppTheme.primaryIndigo : AppTheme.darkGrey,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
        checkmarkColor: AppTheme.primaryIndigo,
      ),
    );
  }
  
  Widget _buildProductCard(Map<String, dynamic> product) {
    final imageUrls = product['imageUrls'];
    final hasImage = imageUrls != null && imageUrls is List && imageUrls.isNotEmpty;
    final stock = product['stock'] ?? 0;
    final isAvailable = product['isAvailable'] ?? false;
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailsScreen(product: product),
            ),
          ).then((_) => _loadProducts());
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image with badges
            Stack(
              children: [
                Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.lightGrey,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: hasImage
                      ? ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: Image.network(
                            imageUrls[0],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.shopping_bag,
                                size: 40,
                                color: AppTheme.primaryIndigo,
                              );
                            },
                          ),
                        )
                      : const Icon(
                          Icons.shopping_bag,
                          size: 40,
                          color: AppTheme.primaryIndigo,
                        ),
                ),
                
                // Availability Badge
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isAvailable 
                          ? AppTheme.successGreen 
                          : AppTheme.errorRed,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isAvailable ? 'Available' : 'Unavailable',
                      style: const TextStyle(
                        color: AppTheme.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                
                // Stock Badge
                if (stock <= 5)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: stock == 0 
                            ? AppTheme.errorRed 
                            : AppTheme.warningOrange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        stock == 0 ? 'Out of Stock' : 'Low Stock',
                        style: const TextStyle(
                          color: AppTheme.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            
            // Product Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Text(
                      product['name'] ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkGrey,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Category
                    Text(
                      product['category'] ?? 'General',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.blueGrey,
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // Price and Stock
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₹${(product['price'] ?? 0).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryIndigo,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.lightGrey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Stock: $stock',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.darkGrey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
