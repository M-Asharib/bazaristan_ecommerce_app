import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class ProductDetailPage extends StatefulWidget {
  final String productId;

  const ProductDetailPage({Key? key, required this.productId})
      : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  Map<String, dynamic>? product;
  bool isLoading = true;
  bool isAddedToCart = false;
  int quantity = 1;
  int selectedImageIndex = 0;

  Future<void> fetchProductDetails() async {
    try {
      final productDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productId)
          .get();

      if (productDoc.exists) {
        setState(() {
          product = productDoc.data();
          isLoading = false;
        });

        isAddedToCart = await _checkIfAddedToCart();
      } else {
        throw Exception("Product not found");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load product details: $e')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<bool> _checkIfAddedToCart() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? cartItems = prefs.getStringList('cartItems') ?? [];
    return cartItems.contains(widget.productId);
  }

  Future<void> _addToCart() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please log in to add items to the cart.')),
        );
        return;
      }

      final cartRef = FirebaseFirestore.instance
          .collection('cart')
          .doc(user.uid)
          .collection('products');

      final existingProduct = await cartRef.doc(widget.productId).get();
      if (existingProduct.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product is already in the cart.')),
        );
        return;
      }

      await cartRef.doc(widget.productId).set({
        'name': product!['name'],
        'price': product!['price'],
        'quantity': quantity,
        'image': product!['images1']?.first,
      });

      setState(() {
        isAddedToCart = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${product!['name']} added to cart!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add to cart: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text("Product Details")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Product Details")),
        body: Center(child: Text("Product not found")),
      );
    }

    final images = product!['images1'] as List<dynamic>? ?? [];

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.favorite_border),
              onPressed: () {
                // Add your favorite logic here
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ProductInfoSection(
                product: product!,
                selectedImageIndex: selectedImageIndex,
                images: images,
                onImageTap: (index) {
                  setState(() {
                    selectedImageIndex = index;
                  });
                },
              ),
              TabBar(
                tabs: [
                  Tab(text: 'Description'),
                  Tab(text: 'Reviews'),
                  Tab(text: 'Offers'),
                  Tab(text: 'Policy'),
                ],
                labelColor: Colors.green,
                unselectedLabelColor: Colors.black,
                labelStyle:
                    TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                indicatorColor: Colors.green,
              ),
              Expanded(
                flex: 3,
                child: TabBarView(
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(product!['description'] ??
                          'No description available.'),
                    ),
                    Center(child: Text("Reviews")),
                    Center(child: Text("Offers")),
                    Center(child: Text("Policy")),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Quantity control with - and + buttons
            Container(
              // padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Minus button
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Minus button
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (quantity > 1) {
                                quantity--;
                              }
                            });
                          },
                          child: Container(
                            height: 20,
                            width: 20,
                            alignment: Alignment.center,
                            child: Icon(Icons.remove, color: Colors.white),
                          ),
                        ),
                        SizedBox(
                            width: 10), // Space between buttons and quantity
                        // Quantity display
                        Container(
                          height: 30,
                          width: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$quantity',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                            width:
                                10), // Space between quantity and plus button
                        // Plus button
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              quantity++;
                            });
                          },
                          child: Container(
                            height: 20,
                            width: 20,
                            alignment: Alignment.center,
                            child: Icon(Icons.add, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
                height: 10), // Space between controls and "Add to Cart" button

            // Add to cart button
            ElevatedButton.icon(
              onPressed: _addToCart,
              icon: Icon(Icons.shopping_cart, color: Colors.white, size: 24),
              label: Text(
                'Add to Cart',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18, // Increased font size
                  color: Colors.white, // Set text color to white
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Set background color to green
                minimumSize: Size(180, 40), // Increased button size
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded corners
                ),
                elevation: 5, // Add slight elevation for depth
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}

class ProductInfoSection extends StatelessWidget {
  final Map<String, dynamic> product;
  final int selectedImageIndex;
  final List<dynamic> images;
  final ValueChanged<int> onImageTap;

  const ProductInfoSection({
    Key? key,
    required this.product,
    required this.selectedImageIndex,
    required this.images,
    required this.onImageTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (images.isNotEmpty)
            Column(
              children: [
                SizedBox(
                  height: 200,
                  child: PageView.builder(
                    controller: PageController(initialPage: selectedImageIndex),
                    onPageChanged: (index) {
                      onImageTap(index);
                    },
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.memory(
                          base64Decode(images[index]),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(images.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        onImageTap(index);
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: selectedImageIndex == index
                              ? Colors.green
                              : Colors.grey,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    product['name'] ?? 'No name available',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  'Rs. ${product['price']}',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
