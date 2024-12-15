import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PaymentPage extends StatefulWidget {
  final Map<String, String> shippingDetails;

  PaymentPage({required this.shippingDetails});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _paymentFormKey = GlobalKey<FormState>();

  // Fields to store payment details
  String cardNumber = '';
  String expiryDate = '';
  String cvv = '';
  String selectedPaymentMethod = 'cashOnDelivery'; // Default method

  @override
  Widget build(BuildContext context) {
    final shippingDetails = widget.shippingDetails;

    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      appBar: AppBar(
        title: Text(
          'Payment',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        backgroundColor: Colors.green, // Set AppBar background color to green
        iconTheme: IconThemeData(
          color: Colors.white, // Set icon color to white
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (selectedPaymentMethod == 'cashOnDelivery' ||
              (_paymentFormKey.currentState?.validate() ?? false)) {
            // Process the payment
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Processing payment...')),
            );

            // Show the dialog box with the thank you message
            showDialog(
              context: context,
              barrierDismissible:
                  false, // Prevent dismissal by tapping outside the dialog
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor:
                      Colors.white, // White background for the dialog
                  title: Center(
                    child: Text(
                      'Thank you for shopping!',
                      style: TextStyle(
                        color: Colors.green, // Green color for the title text
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize
                        .min, // Make the column take the smallest space needed
                    children: [
                      Icon(
                        Icons
                            .check_circle_outline, // A check mark icon for confirmation
                        color: Colors.green,
                        size: 50,
                      ),
                      SizedBox(height: 10), // Add space between icon and text
                      Text(
                        'Your order has been successfully placed.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color:
                              Colors.black, // Black color for the message text
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the dialog
                        GoRouter.of(context).go(
                            '/home'); // Navigate to home after closing the dialog
                      },
                      child: Text(
                        'Close',
                        style: TextStyle(
                          color:
                              Colors.green, // Green color for the button text
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );

            // After 5 seconds, automatically close the dialog and navigate to home
            Future.delayed(Duration(seconds: 5), () {
              Navigator.pop(context); // Close the dialog after 5 seconds
              GoRouter.of(context).go('/home'); // Navigate to the home page
            });
          }
        },
        label: Text(
          selectedPaymentMethod == 'cashOnDelivery'
              ? 'Place Order (Cash on Delivery)'
              : 'Pay Now',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green, // Set background color to green
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _paymentFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Shipping Details Section in Table format
                Text(
                  'Shipping Details',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Table(
                  border: TableBorder.all(
                      color: Color(0xFFE9E7E7)), // Add border to the table
                  columnWidths: {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(2),
                  },
                  children: [
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(
                              8.0), // Add padding inside the cell
                          child: Text('Phone:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(
                              8.0), // Add padding inside the cell
                          child: Text(shippingDetails['phone'] ?? ''),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(
                              8.0), // Add padding inside the cell
                          child: Text('Address:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(
                              8.0), // Add padding inside the cell
                          child: Text(shippingDetails['address'] ?? ''),
                        ),
                      ],
                    ),
                    if (shippingDetails['street']?.isNotEmpty ?? false)
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(
                                8.0), // Add padding inside the cell
                            child: Text('Street:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(
                                8.0), // Add padding inside the cell
                            child: Text(shippingDetails['street'] ?? ''),
                          ),
                        ],
                      ),
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(
                              8.0), // Add padding inside the cell
                          child: Text('City:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(
                              8.0), // Add padding inside the cell
                          child: Text(shippingDetails['city'] ?? ''),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(
                              8.0), // Add padding inside the cell
                          child: Text('Country:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(
                              8.0), // Add padding inside the cell
                          child: Text(shippingDetails['country'] ?? ''),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(
                              8.0), // Add padding inside the cell
                          child: Text('Province:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(
                              8.0), // Add padding inside the cell
                          child: Text(shippingDetails['province'] ?? ''),
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(height: 30),

                // Payment Details Section
                Text(
                  'Enter Payment Details',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),

                // Payment Method Radio Buttons with Green Color
                Row(
                  children: [
                    Radio<String>(
                      value: 'cashOnDelivery',
                      groupValue: selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          selectedPaymentMethod = value!;
                        });
                      },
                      activeColor:
                          Colors.green, // Set radio button color to green
                    ),
                    Text('Cash on Delivery'),
                    SizedBox(width: 20),
                    Radio<String>(
                      value: 'onlinePayment',
                      groupValue: selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          selectedPaymentMethod = value!;
                        });
                      },
                      activeColor:
                          Colors.green, // Set radio button color to green
                    ),
                    Text('Online Payment'),
                  ],
                ),
                SizedBox(height: 20),

                // Conditionally show fields based on payment method
                if (selectedPaymentMethod == 'onlinePayment') ...[
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Card Number',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => cardNumber = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter card number';
                      }
                      if (value.length < 16) {
                        return 'Card number must be 16 digits';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Expiry Date (MM/YY)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.datetime,
                    onChanged: (value) => expiryDate = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter expiry date';
                      }
                      if (!RegExp(r'(0[1-9]|1[0-2])\/?([0-9]{2})$')
                          .hasMatch(value)) {
                        return 'Enter a valid expiry date';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'CVV',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => cvv = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter CVV';
                      }
                      if (value.length != 3) {
                        return 'CVV must be 3 digits';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                ],

                // Proceed Button with Green Background and White Text
                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor:
                //         Colors.green, // Set background color to green
                //   ),
                //   onPressed: () {
                //     if (selectedPaymentMethod == 'cashOnDelivery' ||
                //         (_paymentFormKey.currentState?.validate() ?? false)) {
                //       // Process the payment
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         SnackBar(content: Text('Processing payment...')),
                //       );
                //       // Simulate payment success and navigate back
                //       Navigator.pop(context);
                //     }
                //   },
                //   child: Text(
                //     selectedPaymentMethod == 'cashOnDelivery'
                //         ? 'Place Order (Cash on Delivery)'
                //         : 'Pay Now',
                //     style: TextStyle(color: Colors.white),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
