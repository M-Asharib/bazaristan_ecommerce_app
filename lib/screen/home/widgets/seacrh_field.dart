import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // For navigation

class SearchField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        onSubmitted: (query) {
          // Navigate to the search results page with the query
          GoRouter.of(context).go('/search?query=$query');
        },
        decoration: InputDecoration(
          hintText: 'Search products...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: EdgeInsets.symmetric(
              vertical: 4, horizontal: 16), // Reduced padding for smaller height
        ),
      ),
    );
  }
}
