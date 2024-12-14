import 'dart:convert'; // Import this for base64Decode
import 'dart:typed_data'; // Import this for Uint8List

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/screen/admin/categries/detail.dart';
import 'package:flutter/material.dart';

class ProductList extends StatelessWidget {
  // Fetch products list from Firestore
  Future<List<Map<String, dynamic>>> fetchProducts() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('products').get();

      return querySnapshot.docs.map((doc) {
        var productData = doc.data();
        return {
          'id': doc.id,
          'name': productData['name'] ?? '',
          'price': productData['price']?.toString() ?? '0.00',
          'images1':
              productData['images1'] != null && productData['images1'] is List
                  ? List<String>.from(productData['images1'])
                  : [], // Ensure images1 is a list of strings
        };
      }).toList();
    } catch (e) {
      throw Exception("Failed to load products: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 1200
        ? 6
        : screenWidth > 800
            ? 4
            : screenWidth > 600
                ? 3
                : 3;

    final childAspectRatio = screenWidth > 600 ? 0.7 : 0.7;

    // Set responsive font sizes
    double headingFontSize = screenWidth > 800 ? 18.0 : 10.0;
    double priceFontSize = screenWidth > 800 ? 16.0 : 8.0;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var products = snapshot.data!;
            return GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: childAspectRatio,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                final thumbnails = product['images1'];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailPage(product: product),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: AspectRatio(
                            aspectRatio: 1, // Ensures the image is square
                            child: thumbnails.isNotEmpty
                                ? Image.memory(
                                    base64Decode(thumbnails.first),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey,
                                        child: Center(
                                          child: Icon(
                                            Icons.broken_image,
                                            size: 48,
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    color: Colors.grey,
                                    child: Center(
                                      child: Icon(
                                        Icons.broken_image,
                                        size: 48,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            product['name']!,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontSize: headingFontSize,
                                ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'Rs. ${product['price']}',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: Colors.blue,
                                  fontSize: priceFontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No products found.'));
          }
        },
      ),
    );
  }
}
