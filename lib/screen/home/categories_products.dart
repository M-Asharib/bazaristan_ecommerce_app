import 'dart:convert'; // For base64Decode
import 'dart:typed_data'; // For Uint8List

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ecommerce/screen/admin/categries/detail.dart';
import 'package:ecommerce/screen/home/widgets/product_card.dart';
import 'package:ecommerce/screen/home/widgets/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // For navigation

class CategoryDetailPage extends StatelessWidget {
  final String categoryId;
  final String subCategoryId;

  CategoryDetailPage(
      {Key? key, required this.categoryId, required this.subCategoryId})
      : super(key: key);

  // Fetch category details by categoryId
  Future<Map<String, String>> fetchCategoryAndSubCategoryNames() async {
    try {
      // Fetch category name
      final categoryDoc = await FirebaseFirestore.instance
          .collection('category')
          .doc(categoryId)
          .get();

      if (categoryDoc.exists) {
        // Fetch sub-category name by ID
        final subCategoryDoc = await FirebaseFirestore.instance
            .collection('category')
            .doc(categoryId)
            .collection('sub_categories')
            .doc(subCategoryId)
            .get();

        if (subCategoryDoc.exists) {
          return {
            'categoryName': categoryDoc['name'] ?? 'Unknown Category',
            'subCategoryName': subCategoryDoc['name'] ?? 'Unknown Sub-category',
          };
        } else {
          return {
            'categoryName': categoryDoc['name'] ?? 'Unknown Category',
            'subCategoryName': 'Sub-category Not Found',
          };
        }
      } else {
        return {
          'categoryName': 'Category Not Found',
          'subCategoryName': 'Sub-category Not Found',
        };
      }
    } catch (e) {
      print('Error fetching category and sub-category names: $e');
      return {
        'categoryName': 'Error fetching category name',
        'subCategoryName': 'Error fetching sub-category name',
      };
    }
  }

  // Fetch products from Firestore filtered by categoryId
  Stream<List<Map<String, dynamic>>> fetchProductsByCategory() {
    return FirebaseFirestore.instance
        .collection('products')
        .where('sub_category', isEqualTo: subCategoryId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'name': doc['name'] ?? '',
          'price': doc['price'] ?? 0,
          // 'images1': doc['images1'] ?? [],
          'images1': doc['images1'] != null && doc['images1'] is List
              ? List<String>.from(doc['images1'])
              : [],
        };
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Map<String, String>>(
          future: fetchCategoryAndSubCategoryNames(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading...');
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.hasData) {
              final categoryName =
                  snapshot.data?['categoryName'] ?? 'Unknown Category';
              final subCategoryName =
                  snapshot.data?['subCategoryName'] ?? 'Unknown Sub-category';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$categoryName : $subCategoryName'),
                ],
              );
            }

            return Text('No data available');
          },
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Use Navigator.pop() to go back
          },
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: fetchProductsByCategory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final products = snapshot.data ?? [];

          if (products.isEmpty) {
            return Center(
                child: Text("No products available in this category"));
          }

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  2, // Two items per row, you can adjust this as needed
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            padding: EdgeInsets.all(10),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final images = product['images1'];

              // Handle base64 decoding for images:
              List<Uint8List> imageBytesList = [];

              if (images is List) {
                for (var image in images) {
                  if (image is String && image.isNotEmpty) {
                    try {
                      imageBytesList.add(base64Decode(image));
                    } catch (e) {
                      print('Error decoding base64 image: $e');
                    }
                  }
                }
              } else if (images is String && images.isNotEmpty) {
                try {
                  imageBytesList.add(base64Decode(images));
                } catch (e) {
                  print('Error decoding base64 image: $e');
                }
              }

              return GestureDetector(
                onTap: () {
                  // Handle navigation on card tap
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailPage(
                        productId: product['id'],
                      ),
                    ),
                  );
                },
                child: ProductCard(
                  imageUrl: images.first,
                  // imageUrl: imageBytesList.isNotEmpty
                  //     ? 'data:image/png;base64,${base64Encode(imageBytesList[0])}'
                  //     : '', // Convert base64 to URL format if images are found
                  price: product['price'].toString(),
                  onAddToCart: () {
                    print("Add to Cart clicked for ${product['name']}");
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
