import 'package:ecommerce/screen/home/categories_products.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart'; // Import go_router

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
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final subCategories = snapshot.data ?? [];

          if (subCategories.isEmpty) {
            return Center(child: Text("No sub-categories available"));
          }

          return ListView.builder(
            itemCount: subCategories.length,
            itemBuilder: (context, index) {
              var subCategory = subCategories[index];
              return ListTile(
                title: Text(subCategory["name"]!),
                onTap: () {
                  // Handle sub-category tap using MaterialPageRoute
                Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => CategoryDetailPage(
      categoryId: categoryId, // Passing categoryId
      subCategoryId: subCategory["id"]!, // Passing sub-category ID
    ),
  ),
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
