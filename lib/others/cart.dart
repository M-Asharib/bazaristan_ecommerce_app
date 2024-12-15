
// class CartScreen extends StatelessWidget {
//   final String currency = 'USD'; // Replace with your preferred currency symbol.

//   // Function to fetch cart items with associated product data
//   Stream<List<Map<String, dynamic>>> fetchCartItemsWithProducts() async* {
//     final userId = FirebaseAuth.instance.currentUser?.uid;

//     final cartSnapshotStream = FirebaseFirestore.instance
//         .collection('carts')
//         .where('userId', isEqualTo: userId)
//         .snapshots();

//     await for (var cartSnapshot in cartSnapshotStream) {
//       if (cartSnapshot.docs.isEmpty) {
//         yield [];
//         continue;
//       }

//       List<Map<String, dynamic>> cartItemsWithProductData = [];

//       for (var cartDoc in cartSnapshot.docs) {
//         final cartData = cartDoc.data();

//         final productDoc = await FirebaseFirestore.instance
//             .collection('products')
//             .doc(cartData['productId'])
//             .get();

//         if (productDoc.exists) {
//           final productData = productDoc.data();
//           cartItemsWithProductData.add({
//             'cartId': cartDoc.id,
//             ...cartData,
//             'product': productData,
//           });
//         }
//       }

//       yield cartItemsWithProductData;
//     }
//   }

//   // Function to increment quantity
//   void incrementQuantity(String cartId, int currentQuantity) {
//     FirebaseFirestore.instance
//         .collection('carts')
//         .doc(cartId)
//         .update({'quantity': currentQuantity + 1});
//   }

//   // Function to decrement quantity
//   void decrementQuantity(String cartId, int currentQuantity) {
//     if (currentQuantity > 1) {
//       FirebaseFirestore.instance
//           .collection('carts')
//           .doc(cartId)
//           .update({'quantity': currentQuantity - 1});
//     }
//   }

//   // Function to delete a cart item
//   void deleteCartItem(String cartId) {
//     FirebaseFirestore.instance.collection('carts').doc(cartId).delete();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: StreamBuilder<List<Map<String, dynamic>>>(
//         stream: fetchCartItemsWithProducts(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return _buildShimmerLoading(); // Replace with shimmer loading widget
//           }

//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('Your cart is empty.'));
//           }

//           final cartItems = snapshot.data!;

//           return ListView.builder(
//             itemCount: cartItems.length,
//             itemBuilder: (context, index) {
//               final cartItem = cartItems[index];
//               final productData = cartItem['product'];

//               // Handle image decoding
//               Widget productImage;
//               if (productData['images1'] != null) {
//                 if (productData['images1'] is List &&
//                     productData['images1'].isNotEmpty) {
//                   final base64String = productData['images1'][0];
//                   productImage = Image.memory(
//                     base64Decode(base64String),
//                     width: 30.0,
//                     height: 30.0,
//                     fit: BoxFit.cover,
//                   );
//                 } else if (productData['images1'] is String) {
//                   final base64String = productData['images1'];
//                   productImage = Image.memory(
//                     base64Decode(base64String),
//                     width: 30.0,
//                     height: 30.0,
//                     fit: BoxFit.cover,
//                   );
//                 } else {
//                   productImage = Icon(Icons.computer, size: 30.0);
//                 }
//               } else {
//                 productImage = Icon(Icons.computer, size: 30.0);
//               }

//               return ListTile(
//                 leading: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Checkbox(
//                       value: cartItem['isSelected'] ?? true,
//                       onChanged: (bool? newValue) {
//                         FirebaseFirestore.instance
//                             .collection('carts')
//                             .doc(cartItem['cartId'])
//                             .update({'isSelected': newValue});
//                       },
//                       activeColor: Colors.green,
//                     ),
//                     productImage,
//                   ],
//                 ),
//                 title: Text(productData['name'] ?? 'Unknown'),
//                 subtitle: Text(
//                     '${currency} ${productData['price']?.toStringAsFixed(2) ?? '0.00'}'),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.remove),
//                       onPressed: () {
//                         decrementQuantity(
//                             cartItem['cartId'], cartItem['quantity']);
//                       },
//                     ),
//                     Text(cartItem['quantity'].toString()),
//                     IconButton(
//                       icon: Icon(Icons.add),
//                       onPressed: () {
//                         incrementQuantity(
//                             cartItem['cartId'], cartItem['quantity']);
//                       },
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.delete),
//                       onPressed: () {
//                         deleteCartItem(cartItem['cartId']);
//                       },
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }



//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('carts')
//                   .where('userId',
//                       isEqualTo: FirebaseAuth.instance.currentUser?.uid)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return _buildShimmerLoading(); // Shimmer effect for loading state
//                 }

//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return Center(child: Text('Your cart is empty.'));
//                 }

//                 final cartItems = snapshot.data!.docs;

//                 return Padding(
//                   padding: const EdgeInsets.all(0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         child: ListView.builder(
//                           itemCount: cartItems.length,
//                           itemBuilder: (context, index) {
//                             final cartItem = cartItems[index];
//                             final cartData =
//                                 cartItem.data() as Map<String, dynamic>;

//                             return FutureBuilder<DocumentSnapshot>(
//                               future: FirebaseFirestore.instance
//                                   .collection('products')
//                                   .doc(cartData['productId'])
//                                   .get(),
//                               builder: (context, productSnapshot) {
//                                 if (productSnapshot.connectionState ==
//                                     ConnectionState.waiting) {
//                                   return _buildShimmerLoading(); // Shimmer effect for product loading
//                                 }

//                                 if (!productSnapshot.hasData ||
//                                     !productSnapshot.data!.exists) {
//                                   return ListTile(
//                                     title: Text('Product details not found'),
//                                   );
//                                 }

//                                 final productData = productSnapshot.data!.data()
//                                     as Map<String, dynamic>;

//                                 // Handle the 'images1' field assuming it's base64-encoded
//                                 Widget productImage;
//                                 if (productData['images1'] != null) {
//                                   if (productData['images1'] is List &&
//                                       productData['images1'].isNotEmpty) {
//                                     String base64String =
//                                         productData['images1'][0];
//                                     productImage = Image.memory(
//                                       base64Decode(base64String),
//                                       width: 30.0,
//                                       height: 30.0,
//                                       fit: BoxFit.cover,
//                                     );
//                                   } else if (productData['images1'] is String) {
//                                     String base64String =
//                                         productData['images1'];
//                                     productImage = Image.memory(
//                                       base64Decode(base64String),
//                                       width: 30.0,
//                                       height: 30.0,
//                                       fit: BoxFit.cover,
//                                     );
//                                   } else {
//                                     productImage =
//                                         Icon(Icons.computer, size: 30.0);
//                                   }
//                                 } else {
//                                   productImage =
//                                       Icon(Icons.computer, size: 30.0);
//                                 }

//                                 return ListTile(
//                                   leading: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Checkbox(
//                                         value: cartData['isSelected'] ?? true,
//                                         onChanged: (bool? newValue) {
//                                           FirebaseFirestore.instance
//                                               .collection('carts')
//                                               .doc(cartItem.id)
//                                               .update({'isSelected': newValue});
//                                         },
//                                         activeColor: Colors.green,
//                                       ),
//                                       productImage,
//                                     ],
//                                   ),
//                                   title: Text(productData['name'] ?? 'Unknown'),
//                                   subtitle: Text(
//                                       '${currency} ${productData['price'] ?? '0.00'}'),
//                                   trailing: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       IconButton(
//                                         icon: Icon(Icons.remove),
//                                         onPressed: () {
//                                           final quantity =
//                                               cartData['quantity'] > 1
//                                                   ? cartData['quantity'] - 1
//                                                   : 1;
//                                           FirebaseFirestore.instance
//                                               .collection('carts')
//                                               .doc(cartItem.id)
//                                               .update({'quantity': quantity});
//                                         },
//                                       ),
//                                       Text(cartData['quantity'].toString()),
//                                       IconButton(
//                                         icon: Icon(Icons.add),
//                                         onPressed: () {
//                                           FirebaseFirestore.instance
//                                               .collection('carts')
//                                               .doc(cartItem.id)
//                                               .update({
//                                             'quantity': cartData['quantity'] + 1
//                                           });
//                                         },
//                                       ),
//                                       IconButton(
//                                         icon: Icon(Icons.delete),
//                                         onPressed: () {
//                                           FirebaseFirestore.instance
//                                               .collection('carts')
//                                               .doc(cartItem.id)
//                                               .delete();
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               },
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
