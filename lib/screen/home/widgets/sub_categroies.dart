import 'package:ecommerce/screen/home/categories_products.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shimmer/shimmer.dart'; // Import shimmer package

class SubCategoriesPage extends StatelessWidget {
  final String categoryId;

  SubCategoriesPage({required this.categoryId});

  // Fetch sub-categories for the selected category
  Stream<List<Map<String, String>>> fetchSubCategories() {
    return FirebaseFirestore.instance
        .collection('category')
        .doc(categoryId)
        .collection('sub_categories')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          "id": doc.id,
          "name": (doc['name'] ?? '').toString(),
        };
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sub-categories')),
      body: StreamBuilder<List<Map<String, String>>>(
        stream: fetchSubCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of items per row
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3.5, // Adjust aspect ratio as needed
              ),
              itemCount: 6, // Simulate 6 shimmer placeholders
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final subCategories = snapshot.data ?? [];

          if (subCategories.isEmpty) {
            return Center(child: Text("No sub-categories available"));
          }

          return GridView.builder(
            padding: EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of items per row
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 3.5, // Adjust aspect ratio as needed
            ),
            itemCount: subCategories.length,
            itemBuilder: (context, index) {
              var subCategory = subCategories[index];
              return GestureDetector(
                onTap: () {
                  // Handle sub-category tap
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryDetailPage(
                        categoryId: categoryId, // Passing categoryId
                        subCategoryId:
                            subCategory["id"]!, // Passing sub-category ID
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green, // Background color
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                  child: Center(
                    child: Text(
                      subCategory["name"]!,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
