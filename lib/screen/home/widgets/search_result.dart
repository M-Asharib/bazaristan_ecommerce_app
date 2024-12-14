import 'dart:convert'; // For base64 decoding
import 'dart:typed_data'; // For Uint8List

import 'package:ecommerce/screen/home/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firestore queries
import 'package:go_router/go_router.dart';

class SearchResultsPage extends StatelessWidget {
  final String query;

  SearchResultsPage({Key? key, required this.query}) : super(key: key);

  // Fetch products filtered by the search query
  Stream<List<Map<String, dynamic>>> fetchSearchResults() {
    print("Search query: $query");
    return FirebaseFirestore.instance
        .collection('products')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name',
            isLessThanOrEqualTo:
                query + '\uf8ff') // To filter the results based on query
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'name': doc['name'] ?? '',
          'price': doc['price'] ?? 0,
          'images1': doc['images1'] ?? [], // Default to an empty list if null
        };
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results for "$query"'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).go('/home');
          },
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: fetchSearchResults(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final products = snapshot.data ?? [];

          if (products.isEmpty) {
            return Center(child: Text("No products found for '$query'"));
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              // Determine the number of columns based on screen width
              int crossAxisCount = 2;
              if (constraints.maxWidth > 600) {
                crossAxisCount = 6; // For larger screens, use 3 columns
              } else if (constraints.maxWidth > 900) {
                crossAxisCount = 4; // For extra large screens, use 4 columns
              }

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount, // Set columns dynamically
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.7, // Adjust to change the card size
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  final images = product['images1'];

                  // Base64 encode the first image (if available)
                  String? base64Image;
                  if (images.isNotEmpty) {
                    base64Image =
                        images[0]; // Assuming the first image is base64 encoded
                  }

                  return ProductCard(
                    imageUrl: base64Image != null
                        ? 'data:image/png;base64,$base64Image'
                        : '', // Base64 decoded image
                    price: product['price'].toString(),
                    onAddToCart: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('${product['name']} added to cart!')),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
