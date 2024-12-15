import 'package:ecommerce/screen/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shimmer/shimmer.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce/screen/home/widgets/sub_categroies.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  // Stream to fetch categories from Firestore
  Stream<List<Map<String, String>>> fetchCategories() {
    return FirebaseFirestore.instance.collection('category').snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          return {
            "id": doc.id,
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
            return _buildShimmerLoading();
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final categories = snapshot.data ?? [];

          // Add the "All" category at the beginning of the list
          categories.insert(0, {
            "id": "all",
            "name": "All",
          });

          if (categories.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize
                    .min, // Make the column take the smallest space needed
                children: [
                  Icon(
                    Icons
                        .warning, // You can change this icon to whatever fits your needs
                    color: Colors.green, // Set the color to match your theme
                    size: 50, // Icon size
                  ),
                  SizedBox(
                      height:
                          10), // Add some spacing between the icon and the text
                  Text(
                    "No categories available",
                    style: TextStyle(
                      fontSize: 18, // Set font size for the text
                      color: Colors.black, // Text color
                    ),
                  ),
                ],
              ),
            );
          }

          return Row(
            children: categories.map((category) {
              bool isAllCategory = category["id"] == "all";
              return Padding(
                padding: const EdgeInsets.only(right: 5.0, bottom: 5.0),
                child: ChoiceChip(
                  label: Text(category["name"]!,
                      style: TextStyle(
                        fontSize: 12,
                      )),
                  selected: false, // No selection state
                  onSelected: (_) {
                    if (category["id"] == "all") {
                      // Navigate to Home page when "All" is selected
                      GoRouter.of(context).go('/home');
                    } else {
                      // Navigate to SubCategoriesPage for other categories
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SubCategoriesPage(categoryId: category["id"]!),
                        ),
                      );
                    }
                  },
                  selectedColor: isAllCategory
                      ? Colors.green
                      : Colors.green, // Green background for All category
                  backgroundColor:
                      isAllCategory ? Colors.green : Colors.grey[200],
                  labelStyle: TextStyle(
                    color: isAllCategory
                        ? Colors.white
                        : Colors.black, // White text for "All"
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Row(
        children: List.generate(
          5,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Container(
              width: 80,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
