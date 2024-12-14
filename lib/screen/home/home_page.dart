import 'package:ecommerce/screen/home/widgets/categoreis.dart';
import 'package:ecommerce/screen/home/widgets/categories_section.dart';
import 'package:ecommerce/screen/home/widgets/hero_section.dart';
import 'package:ecommerce/screen/home/widgets/hero_section_slider.dart';
import 'package:ecommerce/screen/home/widgets/products_list.dart';
import 'package:ecommerce/screen/home/widgets/seacrh_field.dart';
import 'package:ecommerce/screen/home/widgets/section_header.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = 'All'; // Track the selected category

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: Text(
          //     'Categories',
          //     style: Theme.of(context).textTheme.headlineSmall,
          //   ),
          // ),
          SearchField(),
          CategoryPage(
              // onCategorySelected: (category) {
              //   setState(() {
              //     selectedCategory = category; // Update the selected category
              //   });
              // },
              ),
          // HeroSection(),
          // HeroSectionSlider(),
          // CategoriesSection(),
          // Add the header with a "See More" button
          ProductHeader(
            title: 'Trending Products',
            onSeeMorePressed: () {
              // Navigate to show all products when "See More" is clicked
              print('See More clicked!');
              // Navigate to a new page to show all products or load more data
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductList(
                    limit: 3,
                  ),
                ),
              );
            },
          ),
          ProductList(
            limit: 2,
          ),
          ProductHeader(
            title: 'Popular Categories',
            onSeeMorePressed: () {
              // Navigate to show all products when "See More" is clicked
              print('See More clicked!');
              // Navigate to a new page to show all products or load more data
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductList(
                    limit: 3,
                  ),
                ),
              );
            },
          ),
          const ProductList(
            limit: 3,
          ),

          ProductHeader(
            title: 'Fashion Categories',
            onSeeMorePressed: () {
              // Navigate to show all products when "See More" is clicked
              print('See More clicked!');
              // Navigate to a new page to show all products or load more data
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductList(
                    limit: 3,
                  ),
                ),
              );
            },
          ),
          const ProductList(
            limit: 3,
          ),

          ProductHeader(
            title: 'Men Categories',
            onSeeMorePressed: () {
              // Navigate to show all products when "See More" is clicked
              print('See More clicked!');
              // Navigate to a new page to show all products or load more data
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductList(
                    limit: 3,
                  ),
                ),
              );
            },
          ),
          const ProductList(
            limit: 3,
          ),
        ],
      ),
    );
  }
}
