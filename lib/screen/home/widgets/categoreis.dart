import 'package:ecommerce/screen/home/widgets/sub_categroies.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  String selectedCategoryId = "all"; // Default selected category is "All"

  // Stream to fetch categories from Firestore
  Stream<List<Map<String, String>>> fetchCategories() {
    return FirebaseFirestore.instance.collection('category').snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          // Convert each field to String explicitly
          return {
            "id": doc.id, // Get the document ID for navigation
            "name": (doc['name'] ?? '').toString(),
          };
        }).toList();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: StreamBuilder<List<Map<String, String>>>(
        stream: fetchCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final categories = snapshot.data ?? [];

          // Add the "All" category at the beginning of the list
          categories.insert(0, {
            "id": "all", // You can use any ID to identify "All"
            "name": "All",
          });

          if (categories.isEmpty) {
            return Center(child: Text("No categories available"));
          }

          return Row(
            children: categories.map((category) {
              bool isSelected = selectedCategoryId == category["id"];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: MouseRegion(
                  onEnter: (_) {
                    // Update the hover color on enter
                    setState(() {
                      if (selectedCategoryId != category["id"]) {
                        selectedCategoryId = category["id"]!;
                      }
                    });
                  },
                  onExit: (_) {
                    // Revert back when the mouse leaves
                    setState(() {
                      if (selectedCategoryId != "all") {
                        selectedCategoryId =
                            "all"; // Default to "All" when hovered out
                      }
                    });
                  },
                  child: ChoiceChip(
                    label: Text(category["name"]!,
                        style: TextStyle(
                          fontSize: 12, // Smaller font size
                        )),
                    selected: isSelected,
                    onSelected: (isSelected) {
                      setState(() {
                        selectedCategoryId = category["id"]!;
                      });

                      // Navigate to the SubCategoriesPage with category ID
                      // GoRouter.of(context).go('/category/${category["id"]}');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SubCategoriesPage(categoryId: category["id"]!),
                        ),
                      );
                    },
                    selectedColor: Colors.green,
                    backgroundColor: Colors.grey[200],
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(50), // Rounded corners
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12, // Smaller horizontal padding
                      vertical: 6, // Smaller vertical padding
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
