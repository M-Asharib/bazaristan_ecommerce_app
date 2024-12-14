import 'dart:convert';

import 'package:ecommerce/screen/home/payment.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:typed_data';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/services.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Variable to hold cart data from Firestore
  List<Map<String, dynamic>> cartItems = [];
  final currency = "PKR";
  final List<String> pakistanCities = [
    'Karachi',
    'Lahore',
    'Islamabad',
    'Rawalpindi',
    'Peshawar',
    'Quetta',
    'Faisalabad',
    'Multan',
    'Sialkot',
    'Gujranwala',
    'Murree',
    'Bahawalpur',
    'Sukkur',
    'Hyderabad',
    'Gawadar',
    'Mardan',
    'Sargodha',
    'Mingora',
    'Chiniot',
    'Turbat',
    'Dera Ghazi Khan',
    'Kasur',
    'Dera Ismail Khan',
    'Swat',
    'Abbottabad',
    'Jhelum',
    'Khairpur',
    'Faisalabad',
    'Larkana',
    'Chitral',
    'Bhakkar',
    'Bannu',
    'Kotli',
    'Mirpur Khas',
    'Attock',
    'Jhang',
    'Okara',
    'Bhimber',
    'Jamnagar',
    'Shikarpur',
    'Muzaffargarh',
    'Sheikhupura',
    'Gojra',
    'Badin',
    'Pishin',
    'Lodhran',
    'Mandi Bahauddin',
    'Wazirabad',
    'Hassan Abdal',
    'Narowal',
    'Khushab',
    'Gujrat',
    'Pakpattan',
    'Haripur',
    'Kotli',
    'Chakwal',
    'Hafizabad',
    'Jhelum',
    'Rohri',
    'Mianwali',
    'Mansehra',
    'Mirpur',
    'Sahiwal',
    'Khairpur',
    'Chiniot',
    'Sargodha',
    'Toba Tek Singh',
    'Pishin',
    'Ziarat',
    'Bhalwal',
    'Hasilpur',
    'Jalalpur',
    'Malkwal',
    'Jampur',
    'Matli',
    'Sui',
    'Hingorja',
    'Zafarwal',
    'Chiniot',
    'Bannu',
    'Chak Jhumra',
    'Fateh Jang',
    'Vihari',
    'Khanewal',
    'Dera Ismail Khan',
    'Saddar',
    'Abbottabad',
    'Buner',
    'Khushab',
    'Pindi Gheb',
    'Ghotki',
    'Sialkot',
    'Mithi',
    'Jamshoro',
    'Rajanpur',
    'Thatta',
    'Muzaffarabad',
    'Nowshera',
    'Panjgur',
    'Barkhan',
    'Rajanpur',
    'Layyah',
    'Chaman',
    'Umarkot',
    'Sadiqabad',
    'Kohat',
    'Sargodha',
    'Shahdadpur',
    'Matiari',
    'Karachi',
    'Islamabad',
    'Lahore',
    // Add more cities as needed
  ];

  final List<String> pakistanProvinces = [
    'Punjab',
    'Sindh',
    'Khyber Pakhtunkhwa (KP)',
    'Balochistan',
    'Islamabad Capital Territory',
    'Azad Jammu & Kashmir (AJK)',
    'Gilgit-Baltistan',
  ];

  final List<String> pakistanProvinces1 = [
    'Punjab',
    'Sindh',
    'Khyber Pakhtunkhwa',
    'Balochistan',
    'Islamabad Capital Territory',
    'Azad Kashmir',
    'Gilgit-Baltistan'
  ];

  final Map<String, List<String>> provinceCities1 = {
    'Punjab': ['Lahore', 'Multan', 'Faisalabad', 'Rawalpindi'],
    'Sindh': ['Karachi', 'Hyderabad', 'Sukkur', 'Larkana'],
    'Khyber Pakhtunkhwa': ['Peshawar', 'Abbottabad', 'Swat'],
    'Balochistan': ['Quetta', 'Gwadar', 'Turbat'],
    'Islamabad Capital Territory': ['Islamabad'],
    'Azad Kashmir': ['Muzaffarabad', 'Mirpur', 'Rawalakot'],
    'Gilgit-Baltistan': ['Gilgit', 'Skardu', 'Hunza'],
  };

  // final List<String> pakistanCities1 = []; // Dynamic based on province

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  // Fetch cart items from Firestore
  Future<void> fetchCartItems() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("No user is logged in.");
      return;
    }

    try {
      // Fetch cart items for the current user
      final cartRef = FirebaseFirestore.instance
          .collection('cart')
          .doc(user.uid)
          .collection('products');

      final snapshot = await cartRef.get();

      print("Cart snapshot: ${snapshot.docs.length} items found.");

      // Parse the cart data
      setState(() {
        cartItems = snapshot.docs.map((doc) {
          final price = doc['price'];

          // Ensure price is converted to a double
          double parsedPrice = price is String
              ? double.tryParse(price) ?? 0.0
              : price.toDouble();

          // Get image byte data
          Uint8List? imageBytes;
          if (doc['image'] != null) {
            imageBytes = doc['image'] is String
                ? base64Decode(doc['image']) // If the image is base64 encoded
                : doc['image']; // If image is stored as byte data
          }

          return {
            'id': doc.id,
            'name': doc['name'],
            'price': parsedPrice,
            'quantity': doc['quantity'],
            'image': imageBytes, // Store the byte data for the image
            'isSelected': true, // Add isSelected to track the checkbox state
          };
        }).toList();
      });
    } catch (e) {
      // Handle any errors while fetching data
      print('Failed to load cart items: $e');
    }
  }

  // Update item quantity in Firestore
  Future<void> updateItemQuantity(String itemId, int quantity) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("No user is logged in.");
      return;
    }

    try {
      final cartRef = FirebaseFirestore.instance
          .collection('cart')
          .doc(user.uid)
          .collection('products');

      await cartRef.doc(itemId).update({'quantity': quantity});

      // Update the local cartItems list
      setState(() {
        final index = cartItems.indexWhere((item) => item['id'] == itemId);
        if (index != -1) {
          cartItems[index]['quantity'] = quantity;
        }
      });

      print("Quantity updated successfully.");
    } catch (e) {
      print("Failed to update quantity: $e");
    }
  }

  // Delete an item from the cart
  Future<void> deleteItem(String itemId) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("No user is logged in.");
      return;
    }

    try {
      final cartRef = FirebaseFirestore.instance
          .collection('cart')
          .doc(user.uid)
          .collection('products');

      await cartRef.doc(itemId).delete();

      // Remove the item from the local list as well
      setState(() {
        cartItems.removeWhere((item) => item['id'] == itemId);
      });

      print("Item deleted successfully.");
    } catch (e) {
      print("Failed to delete item: $e");
    }
  }

  // Toggle the checkbox for selecting cart items
  void toggleItemSelection(String itemId) {
    setState(() {
      final index = cartItems.indexWhere((item) => item['id'] == itemId);
      if (index != -1) {
        cartItems[index]['isSelected'] = !cartItems[index]['isSelected'];
      }
    });
  }

  void showCheckoutBottomSheet() {
    // Filter selected items for checkout
    final selectedItems =
        cartItems.where((item) => item['isSelected']).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Ensures the bottom sheet is scrollable
      builder: (context) {
        // Define controllers for the shipping details form
        final phoneController = TextEditingController();
        final addressController = TextEditingController();
        final streetController = TextEditingController();
        final cityController = TextEditingController();
        final provinceController = TextEditingController();
        final countryController = TextEditingController(text: 'Pakistan');

        // Calculate the total price of selected items
        double totalPrice = selectedItems.fold(
            0, (sum, item) => sum + (item['price'] * item['quantity']));

        return ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false, // Removes default back button
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Checkout',
                    style: TextStyle(fontSize: 20, color: Colors.green),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context); // Close the bottom sheet
                    },
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                // Validate inputs
                if (phoneController.text.isEmpty ||
                    addressController.text.isEmpty ||
                    cityController.text.isEmpty ||
                    countryController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please fill all required fields.")),
                  );
                  return;
                }

                // Navigate to the payment page with shipping details
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentPage(
                      shippingDetails: {
                        'phone': phoneController.text,
                        'address': addressController.text,
                        'street': streetController.text,
                        'city': cityController.text,
                        'country': countryController.text,
                      },
                    ),
                  ),
                );
              },
              label: Row(
                children: [
                  Text(
                    '\ ${currency} ${totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Green color for the price text
                    ),
                  ),
                  SizedBox(
                      width:
                          8), // Add some spacing between the price and the text
                  Text(
                    'Proceed to Payment',
                    style: TextStyle(
                        color: Colors.white), // Green color for the text
                  ),
                ],
              ),
              icon: Icon(
                Icons.payment,
                color: Colors.white, // Green color for the icon
              ),
              backgroundColor: Colors.green, // White background for the button
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0), // Uniform horizontal padding
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min, // Fit the content to screen
                  children: [
                    SizedBox(height: 16),

                    // Shipping details form
                    TextField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 16, horizontal: 12), // Align content
                      ),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter
                            .digitsOnly, // Allow digits only
                        LengthLimitingTextInputFormatter(
                            10), // Limit to 10 digits after +92
                        PhoneInputFormatter(), // Custom formatter for validation
                      ],
                    ),

                    SizedBox(height: 16),
                    TextField(
                      controller: addressController,
                      decoration: InputDecoration(
                        labelText: 'Delivery Address',
                        prefixIcon: Icon(Icons.location_on),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 16, horizontal: 12), // Align content
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: streetController,
                      decoration: InputDecoration(
                        labelText: 'Street Address (Optional)',
                        prefixIcon: Icon(Icons.streetview),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 16, horizontal: 12), // Align content
                      ),
                      keyboardType: TextInputType.text,
                    ),

                    SizedBox(height: 16),
                    TextField(
                      controller: countryController,
                      enabled: false, // Disable editing
                      decoration: InputDecoration(
                        labelText: 'Pakistan',
                        prefixIcon: Icon(Icons.flag),
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownSearch<String>(
                            items: pakistanProvinces1,
                            selectedItem: provinceController.text.isEmpty
                                ? null
                                : provinceController.text,
                            onChanged: (String? newValue) {
                              setState(() {
                                provinceController.text = newValue ?? '';
                                // Update city dropdown based on selected province
                                final cities = provinceCities1[newValue] ?? [];
                                cityController.text =
                                    cities.isNotEmpty ? cities.first : '';
                                pakistanCities.clear();
                                pakistanCities.addAll(cities);
                              });
                            },
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                labelText: 'Province',
                                prefixIcon: Icon(Icons.location_city),
                                filled: true,
                                fillColor: Colors.grey[200],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            popupProps: PopupProps.menu(showSearchBox: true),
                            dropdownBuilder: (context, selectedItem) {
                              return Text(selectedItem ?? 'Province');
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: DropdownSearch<String>(
                            items: pakistanCities, // List of cities in Pakistan
                            selectedItem: cityController.text.isEmpty
                                ? null
                                : cityController
                                    .text, // Selected city based on controller
                            onChanged: (String? newValue) {
                              setState(() {
                                cityController.text =
                                    newValue ?? ''; // Update the selected city
                              });
                            },
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                labelText: 'City', // Label for the dropdown
                                prefixIcon: Icon(
                                    Icons.location_city), // Icon for the city
                                filled: true,
                                fillColor: Colors.grey[200], // Background color
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Border radius
                                  borderSide: BorderSide.none, // No border side
                                ),
                              ),
                            ),
                            popupProps: PopupProps.menu(
                              showSearchBox:
                                  true, // Enable search box in the dropdown
                            ),
                            dropdownBuilder: (context, selectedItem) {
                              return Text(selectedItem ??
                                  'City'); // Display selected city or default label
                            },
                          ),
                        ),
                      ],
                    ),

                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: DropdownSearch<String>(
                    //         items:
                    //             pakistanProvinces, // List of cities in Pakistan
                    //         selectedItem: provinceController.text.isEmpty
                    //             ? null
                    //             : provinceController
                    //                 .text, // Selected city based on controller
                    //         onChanged: (String? newValue) {
                    //           setState(() {
                    //             provinceController.text =
                    //                 newValue ?? ''; // Update the selected city
                    //           });
                    //         },
                    //         dropdownDecoratorProps: DropDownDecoratorProps(
                    //           dropdownSearchDecoration: InputDecoration(
                    //             labelText: 'Province', // Label for the dropdown
                    //             prefixIcon: Icon(
                    //                 Icons.location_city), // Icon for the city
                    //             filled: true,
                    //             fillColor: Colors.grey[200], // Background color
                    //             border: OutlineInputBorder(
                    //               borderRadius: BorderRadius.circular(
                    //                   10.0), // Border radius
                    //               borderSide: BorderSide.none, // No border side
                    //             ),
                    //           ),
                    //         ),
                    //         popupProps: PopupProps.menu(
                    //           showSearchBox:
                    //               true, // Enable search box in the dropdown
                    //         ),
                    //         dropdownBuilder: (context, selectedItem) {
                    //           return Text(selectedItem ??
                    //               'Province'); // Display selected city or default label
                    //         },
                    //       ),
                    //     ),
                    //     SizedBox(width: 16),
                    //     Expanded(
                    //       child: DropdownSearch<String>(
                    //         items: pakistanCities, // List of cities in Pakistan
                    //         selectedItem: cityController.text.isEmpty
                    //             ? null
                    //             : cityController
                    //                 .text, // Selected city based on controller
                    //         onChanged: (String? newValue) {
                    //           setState(() {
                    //             cityController.text =
                    //                 newValue ?? ''; // Update the selected city
                    //           });
                    //         },
                    //         dropdownDecoratorProps: DropDownDecoratorProps(
                    //           dropdownSearchDecoration: InputDecoration(
                    //             labelText: 'City', // Label for the dropdown
                    //             prefixIcon: Icon(
                    //                 Icons.location_city), // Icon for the city
                    //             filled: true,
                    //             fillColor: Colors.grey[200], // Background color
                    //             border: OutlineInputBorder(
                    //               borderRadius: BorderRadius.circular(
                    //                   10.0), // Border radius
                    //               borderSide: BorderSide.none, // No border side
                    //             ),
                    //           ),
                    //         ),
                    //         popupProps: PopupProps.menu(
                    //           showSearchBox:
                    //               true, // Enable search box in the dropdown
                    //         ),
                    //         dropdownBuilder: (context, selectedItem) {
                    //           return Text(selectedItem ??
                    //               'City'); // Display selected city or default label
                    //         },
                    //       ),
                    //     ),
                    //   ],
                    // ),

                    Divider(),

                    // List of selected cart items
                    ListView.builder(
                      shrinkWrap: true, // Fit content to avoid overflow
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: selectedItems.length,
                      itemBuilder: (context, index) {
                        final item = selectedItems[index];
                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 0), // Align with text fields
                          leading: item['image'] != null
                              ? Image.memory(
                                  item['image'],
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                )
                              : Icon(Icons.computer, size: 40),
                          title: Text(
                            item['name'],
                            style: TextStyle(
                                fontSize: 16), // Match TextField font size
                          ),
                          subtitle: Text(
                            'Qty: ${item['quantity']}',
                            style: TextStyle(fontSize: 14),
                          ),
                          trailing: Text(
                            '\ ${currency} ${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 16), // Match alignment
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the total price
    double totalPrice = cartItems.fold(
        0, (sum, item) => sum + (item['price'] * item['quantity']));

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          // Display cart items
          Expanded(
            child: cartItems.isEmpty
                ? Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: cartItems.length,
                            itemBuilder: (context, index) {
                              final item = cartItems[index];

                              return ListTile(
                                leading: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Checkbox(
                                      value: item['isSelected'],
                                      onChanged: (bool? newValue) =>
                                          toggleItemSelection(item['id']),
                                      activeColor: Colors.green,
                                    ),
                                    item['image'] != null
                                        ? Image.memory(
                                            item['image'],
                                            width: 30.0,
                                            height: 30.0,
                                            fit: BoxFit.cover,
                                          )
                                        : Icon(Icons.computer, size: 30.0),
                                  ],
                                ),
                                title: Text(item['name']),
                                subtitle:
                                    Text('\ ${currency} ${item['price']}'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove),
                                      onPressed: () {
                                        final quantity = item['quantity'] > 1
                                            ? item['quantity'] - 1
                                            : 1;
                                        updateItemQuantity(
                                            item['id'], quantity);
                                      },
                                    ),
                                    Text(item['quantity'].toString()),
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () => updateItemQuantity(
                                          item['id'], item['quantity'] + 1),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () => deleteItem(item['id']),
                                    ),
                                  ],
                                ),
                                onTap: () => toggleItemSelection(item['id']),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          // Total price and checkout button

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align text to the left
                  children: [
                    Text(
                      'Total:',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 1), // Add some spacing between the lines
                    Text(
                      '${currency} ${totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14, // Slightly larger font size for the price
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: cartItems.any((item) => item['isSelected'])
                      ? showCheckoutBottomSheet // Show checkout if any item is selected
                      : null,
                  child: Text(
                    'Proceed to Checkout',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Only allow numbers and restrict to proper format
    final text = newValue.text;
    if (text.length > 0 && text[0] != '3') {
      return oldValue; // Prevent any number that doesn't start with '3'
    }
    return newValue;
  }
}
