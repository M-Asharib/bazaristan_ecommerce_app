import 'dart:convert';
import 'dart:typed_data';

import 'package:ecommerce/screen/home/categories_products.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({Key? key}) : super(key: key);

  // Fetch categories from Firestore
  Stream<List<Map<String, String>>> fetchCategories() {
    return FirebaseFirestore.instance.collection('categories').snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          // Convert each field to String explicitly
          return {
            "id": (doc.id), // Get the document ID for navigation
            "image": (doc['image'] ?? '').toString(),
            "name": (doc['title'] ?? '').toString(),
          };
        }).toList();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Check if the screen is wide (for tablets/desktops)
          bool isLargeScreen =
              constraints.maxWidth > 600; // You can adjust this breakpoint

          // Set height for categories
          double heightFactor =
              isLargeScreen ? 0.15 : 0.25; // Less height on large screens

          // Set radius and font size based on screen size
          double radiusFactor = isLargeScreen ? 0.03 : 0.08;
          double fontSizeFactor = isLargeScreen ? 0.01 : 0.03;

          return StreamBuilder<List<Map<String, String>>>(
            stream: fetchCategories(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Error: ${snapshot.error}",
                    style: TextStyle(color: Colors.red),
                  ),
                );
              }

              final categoriesData = snapshot.data ?? [];

              if (categoriesData.isEmpty) {
                return Center(
                  child: Text(
                    "No categories available",
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return Column(
                children: [
                  // More Button
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        // Functionality for more categories
                      },
                      child: Text(
                        "More",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Categories Section with ListView
                  SizedBox(
                    height: constraints.maxWidth *
                        heightFactor, // Responsive height for the categories
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categoriesData.length,
                      itemBuilder: (context, index) {
                        final category = categoriesData[index];
                        final imageBytes = category["image"]!.isNotEmpty
                            ? base64Decode(category["image"]!)
                            : null;

                        return GestureDetector(
                          onTap: () {
                            // Print the category ID to the console
                            print("Category ID: ${category['id']}");
                            // GoRouter.of(context)
                            //     .go('/product/${category["id"]}');
                            GoRouter.of(context)
                                .go('/category/${category["id"]}');

                            // Navigate to the CategoryDetailPage with category ID
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => CategoryDetailPage(
                            //       categoryId:
                            //           category["id"]!, // Pass category ID
                            //     ),
                            //   ),
                            // );
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              children: [
                                // Display image using Image.memory
                                CircleAvatar(
                                  radius: constraints.maxWidth *
                                      radiusFactor, // Responsive size
                                  backgroundColor: Colors.grey.shade200,
                                  child: imageBytes != null
                                      ? ClipOval(
                                          child: Image.memory(
                                            imageBytes,
                                            fit: BoxFit.cover,
                                            width: constraints.maxWidth *
                                                radiusFactor *
                                                2,
                                            height: constraints.maxWidth *
                                                radiusFactor *
                                                2,
                                          ),
                                        )
                                      : Icon(
                                          Icons.image_not_supported,
                                          size: constraints.maxWidth *
                                              radiusFactor,
                                          color: Colors.grey,
                                        ),
                                ),
                                const SizedBox(height: 8),
                                // Category name
                                Text(
                                  category["name"]!,
                                  style: TextStyle(
                                    fontSize: constraints.maxWidth *
                                        fontSizeFactor, // Responsive text size
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
