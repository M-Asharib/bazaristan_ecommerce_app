import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CategoryDetailPage extends StatelessWidget {
  final String category;

  CategoryDetailPage({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category: $category'),
        actions: [
          // Add a TextButton or IconButton to navigate back
          TextButton(
            onPressed: () {
              // Go directly to /home
              GoRouter.of(context).go('/home');
            },
            child: Text(
              'Back',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    
      body: Center(
        child: Text(
          'Showing products for "$category"',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
