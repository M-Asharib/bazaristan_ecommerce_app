import 'package:ecommerce/screen/home/payment.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/services.dart';

class CheckoutPage extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final String currency;
  final List<String> pakistanProvinces1 = [
    "Punjab",
    "Sindh",
    "Balochistan",
    "KPK"
  ];
  final Map<String, List<String>> provinceCities1 = {
    "Punjab": ["Lahore", "Multan", "Faisalabad"],
    "Sindh": ["Karachi", "Hyderabad", "Sukkur"],
    "Balochistan": ["Quetta", "Gwadar", "Turbat"],
    "KPK": ["Peshawar", "Mardan", "Abbottabad"]
  };

  CheckoutPage({required this.cartItems, required this.currency});

  @override
  Widget build(BuildContext context) {
    final selectedItems =
        cartItems.where((item) => item['isSelected']).toList();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();
    final streetController = TextEditingController();
    final cityController = TextEditingController();
    final provinceController = TextEditingController();
    final countryController = TextEditingController(text: 'Pakistan');
    final List<String> pakistanCities = [];

    double totalPrice = selectedItems.fold(
        0, (sum, item) => sum + (item['price'] * item['quantity']));

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout', style: TextStyle(color: Colors.green)),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (phoneController.text.isEmpty ||
              addressController.text.isEmpty ||
              cityController.text.isEmpty ||
              streetController.text.isEmpty ||
              provinceController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Please fill all required fields.")),
            );
            return;
          }

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
                  'province': provinceController.text,
                },
              ),
            ),
          );
        },
        label: Row(
          children: [
            Text(
              '₹ ${totalPrice.toStringAsFixed(2)}',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(width: 8),
            Text('Proceed to Payment', style: TextStyle(color: Colors.white)),
          ],
        ),
        icon: Icon(Icons.payment, color: Colors.white),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  hintText: 'e.g., 03123456789',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Only allows numbers
                  LengthLimitingTextInputFormatter(11), // Limits to 11 digits
                ],
              ),
              SizedBox(height: 16),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Delivery Address',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: streetController,
                decoration: InputDecoration(
                  labelText: 'Street Address (Optional)',
                  prefixIcon: Icon(Icons.streetview),
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: countryController,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Country',
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
                        provinceController.text = newValue ?? '';
                        final cities = provinceCities1[newValue] ?? [];
                        cityController.text =
                            cities.isNotEmpty ? cities.first : '';
                        pakistanCities.clear();
                        pakistanCities.addAll(cities);
                      },
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: 'Province',
                          prefixIcon: Icon(Icons.location_city),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none),
                        ),
                      ),
                      popupProps: PopupProps.menu(showSearchBox: true),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: DropdownSearch<String>(
                      items: pakistanCities,
                      selectedItem: cityController.text.isEmpty
                          ? null
                          : cityController.text,
                      onChanged: (String? newValue) {
                        cityController.text = newValue ?? '';
                      },
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: 'City',
                          prefixIcon: Icon(Icons.location_city),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none),
                        ),
                      ),
                      popupProps: PopupProps.menu(showSearchBox: true),
                    ),
                  ),
                ],
              ),
              Divider(),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: selectedItems.length,
                itemBuilder: (context, index) {
                  final item = selectedItems[index];
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    leading: item['image'] != null
                        ? Image.memory(item['image'],
                            width: 40, height: 40, fit: BoxFit.cover)
                        : Icon(Icons.computer, size: 40),
                    title: Text(item['name'], style: TextStyle(fontSize: 16)),
                    subtitle: Text('Qty: ${item['quantity']}',
                        style: TextStyle(fontSize: 14)),
                    trailing: Text(
                        '${currency} ${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 16)),
                  );
                },
              ),
              SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}

class PhoneInputFormatter extends TextInputFormatter {
  final int maxLength;

  PhoneInputFormatter(
      {this.maxLength = 13}); // Default limit: +923XXXXXXXXX (12 characters)

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;

    // Ensure text always starts with +92
    if (!text.startsWith('+92')) {
      text = '+92' + text.replaceAll('+92', '').trim();
    }

    // Only allow digits and restrict formatting
    text = text.replaceAll(RegExp(r'[^0-9+]'), ''); // Allow digits and +

    // Ensure the first digit after +92 is '3'
    if (text.length > 3 && text[3] != '3') {
      return oldValue; // Revert if invalid
    }

    // Enforce max length
    if (text.length > maxLength) {
      text = text.substring(0, maxLength); // Trim to max length
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

// class PaymentPage extends StatelessWidget {
//   final Map<String, String> shippingDetails;

//   PaymentPage({required this.shippingDetails});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Payment"),
//       ),
//       body: Center(
//         child: Text("Proceed with Payment for ${shippingDetails['address']}"),
//       ),
//     );
//   }
// }
