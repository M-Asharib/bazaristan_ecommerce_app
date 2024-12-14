import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoriesScreen extends StatelessWidget {
  // Create a new Category
  Future<void> addCategory(String categoryName) async {
    CollectionReference categories =
        FirebaseFirestore.instance.collection('category');
    await categories.add({
      'name': categoryName,
    });
  }

  // Read Categories
  Stream<QuerySnapshot> getCategories() {
    return FirebaseFirestore.instance.collection('category').snapshots();
  }

  // Update Category
  Future<void> updateCategory(String categoryId, String newCategoryName) async {
    await FirebaseFirestore.instance
        .collection('category')
        .doc(categoryId)
        .update({'name': newCategoryName});
  }

  // Delete Category
  Future<void> deleteCategory(String categoryId) async {
    await FirebaseFirestore.instance
        .collection('category')
        .doc(categoryId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Categories')),
      body: StreamBuilder<QuerySnapshot>(
        stream: getCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No Categories Found'));
          }

          var categories = snapshot.data!.docs;
          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              var category = categories[index];
              return ListTile(
                title: Text(category['name']),
                onTap: () {
                  // Navigate to Sub-categories screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SubCategoriesScreen(categoryId: category.id),
                    ),
                  );
                },
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    deleteCategory(category.id);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show dialog to add a new category
          showDialog(
            context: context,
            builder: (context) {
              String categoryName = '';
              return AlertDialog(
                title: Text('Add Category'),
                content: TextField(
                  onChanged: (value) {
                    categoryName = value;
                  },
                  decoration: InputDecoration(hintText: 'Category Name'),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      if (categoryName.isNotEmpty) {
                        addCategory(categoryName);
                      }
                      Navigator.pop(context);
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class SubCategoriesScreen extends StatelessWidget {
  final String categoryId;

  SubCategoriesScreen({required this.categoryId});

  // Create a new Sub-category
  Future<void> addSubCategory(String subCategoryName) async {
    CollectionReference subCategories = FirebaseFirestore.instance
        .collection('category')
        .doc(categoryId)
        .collection('sub_categories');
    await subCategories.add({
      'name': subCategoryName,
    });
  }

  // Read Sub-categories
  Stream<QuerySnapshot> getSubCategories() {
    return FirebaseFirestore.instance
        .collection('category')
        .doc(categoryId)
        .collection('sub_categories')
        .snapshots();
  }

  // Update Sub-category
  Future<void> updateSubCategory(
      String subCategoryId, String newSubCategoryName) async {
    await FirebaseFirestore.instance
        .collection('category')
        .doc(categoryId)
        .collection('sub_categories')
        .doc(subCategoryId)
        .update({'name': newSubCategoryName});
  }

  // Delete Sub-category
  Future<void> deleteSubCategory(String subCategoryId) async {
    await FirebaseFirestore.instance
        .collection('category')
        .doc(categoryId)
        .collection('sub_categories')
        .doc(subCategoryId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sub-categories')),
      body: StreamBuilder<QuerySnapshot>(
        stream: getSubCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No Sub-categories Found'));
          }

          var subCategories = snapshot.data!.docs;
          return ListView.builder(
            itemCount: subCategories.length,
            itemBuilder: (context, index) {
              var subCategory = subCategories[index];
              return ListTile(
                title: Text(subCategory['name']),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    deleteSubCategory(subCategory.id);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show dialog to add a new sub-category
          showDialog(
            context: context,
            builder: (context) {
              String subCategoryName = '';
              return AlertDialog(
                title: Text('Add Sub-category'),
                content: TextField(
                  onChanged: (value) {
                    subCategoryName = value;
                  },
                  decoration: InputDecoration(hintText: 'Sub-category Name'),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      if (subCategoryName.isNotEmpty) {
                        addSubCategory(subCategoryName);
                      }
                      Navigator.pop(context);
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
