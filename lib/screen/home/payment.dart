import 'package:flutter/material.dart';

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
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _paymentFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Shipping Details Section
                Text(
                  'Shipping Details',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text('Phone: ${shippingDetails['phone']}'),
                Text('Address: ${shippingDetails['address']}'),
                if (shippingDetails['street']?.isNotEmpty ?? false)
                  Text('Street: ${shippingDetails['street']}'),
                Text('City: ${shippingDetails['city']}'),
                Text('Country: ${shippingDetails['country']}'),
                Divider(height: 30),

                // Payment Details Section
                Text(
                  'Enter Payment Details',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),

                // Payment Method Radio Buttons
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

                // Proceed Button
                ElevatedButton(
                  onPressed: () {
                    if (selectedPaymentMethod == 'cashOnDelivery' ||
                        (_paymentFormKey.currentState?.validate() ?? false)) {
                      // Process the payment
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Processing payment...')),
                      );
                      // Simulate payment success and navigate back
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    selectedPaymentMethod == 'cashOnDelivery'
                        ? 'Place Order (Cash on Delivery)'
                        : 'Pay Now',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
