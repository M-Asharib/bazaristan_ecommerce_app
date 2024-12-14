// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:ecommerce/screen/admin/categries/sub_categries.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:html' as html;
// import 'package:flutter/foundation.dart';

// class AddCategoryScreen extends StatefulWidget {
//   @override
//   _AddCategoryScreenState createState() => _AddCategoryScreenState();
// }

// class _AddCategoryScreenState extends State<AddCategoryScreen> {
//   final titleController = TextEditingController();
//   final descriptionController = TextEditingController();
//   String? _uploadedImageBase64;
//   final ImagePicker _picker = ImagePicker();

//   // Fetch Categories
//   Stream<QuerySnapshot> getCategoriesStream() {
//     return FirebaseFirestore.instance.collection('categories').snapshots();
//   }

//   // Pick Image Logic (Web and Mobile)
//   Future<void> pickImage() async {
//     if (kIsWeb) {
//       final html.FileUploadInputElement uploadInput =
//           html.FileUploadInputElement();
//       uploadInput.accept = 'image/*';
//       uploadInput.click();

//       uploadInput.onChange.listen((e) async {
//         final files = uploadInput.files;
//         if (files!.isEmpty) return;

//         final reader = html.FileReader();
//         reader.readAsArrayBuffer(files[0]);
//         reader.onLoadEnd.listen((e) async {
//           final Uint8List data = reader.result as Uint8List;
//           setState(() {
//             _uploadedImageBase64 = base64Encode(data);
//           });
//           Fluttertoast.showToast(msg: "Image selected successfully");
//         });
//       });
//     } else {
//       final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//       if (image != null) {
//         Uint8List data = await image.readAsBytes();
//         setState(() {
//           _uploadedImageBase64 = base64Encode(data);
//         });
//         Fluttertoast.showToast(msg: "Image selected successfully");
//       }
//     }
//   }

//   // Add Category to Firestore
//   Future<void> addCategoryToFirestore() async {
//     if (titleController.text.isNotEmpty &&
//         descriptionController.text.isNotEmpty &&
//         _uploadedImageBase64 != null) {
//       try {
//         await FirebaseFirestore.instance.collection('categories').add({
//           'title': titleController.text,
//           'description': descriptionController.text,
//           'image': _uploadedImageBase64,
//         });

//         Fluttertoast.showToast(msg: "Category added successfully");
//         titleController.clear();
//         descriptionController.clear();
//         setState(() {
//           _uploadedImageBase64 = null;
//         });
//       } catch (error) {
//         Fluttertoast.showToast(msg: "Error adding category: $error");
//       }
//     } else {
//       Fluttertoast.showToast(msg: "Please fill all fields before submitting");
//     }
//   }

//   // Update Category
//   Future<void> updateCategory(
//       String id, String title, String description) async {
//     try {
//       await FirebaseFirestore.instance.collection('categories').doc(id).update({
//         'title': title,
//         'description': description,
//         'image': _uploadedImageBase64, // Update image if new one is selected
//       });

//       Fluttertoast.showToast(msg: "Category updated successfully");
//       setState(() {
//         _uploadedImageBase64 = null;
//       });
//     } catch (error) {
//       Fluttertoast.showToast(msg: "Error updating category: $error");
//     }
//   }

//   // Delete Category
//   Future<void> deleteCategory(String id) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('categories')
//           .doc(id)
//           .delete();
//       Fluttertoast.showToast(msg: "Category deleted successfully");
//     } catch (error) {
//       Fluttertoast.showToast(msg: "Error deleting category: $error");
//     }
//   }

//   // Show dialog for adding or updating sub-category
//   void showSubCategoryDialog(String parentCategoryId) {
//     // showDialog(
//     //   context: context,
//     //   builder: (context) {
//     //     // return SubCategoryDialog(parentCategoryId: parentCategoryId);
//     //     return context;
//     //   },
//     // );
//   }

//   // Show Dialog for Adding or Updating Category
//   void showCategoryDialog({String? id, String? title, String? description}) {
//     titleController.text = title ?? '';
//     descriptionController.text = description ?? '';
//     _uploadedImageBase64 = null;

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(id == null ? "Add Category" : "Update Category"),
//           content: SingleChildScrollView(
//             child: Column(
//               children: [
//                 TextField(
//                   controller: titleController,
//                   decoration: InputDecoration(labelText: "Category Title"),
//                 ),
//                 SizedBox(height: 10),
//                 TextField(
//                   controller: descriptionController,
//                   decoration:
//                       InputDecoration(labelText: "Category Description"),
//                   maxLines: 3,
//                 ),
//                 SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: pickImage,
//                   child: Text("Select Image"),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text("Cancel"),
//             ),
//             TextButton(
//               onPressed: () {
//                 if (id == null) {
//                   addCategoryToFirestore();
//                 } else {
//                   updateCategory(
//                     id,
//                     titleController.text,
//                     descriptionController.text,
//                   );
//                 }
//                 Navigator.pop(context);
//               },
//               child: Text(id == null ? "Add" : "Update"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Manage Categories")),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: getCategoriesStream(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text("No categories found"));
//           }

//           final categories = snapshot.data!.docs;

//           return ListView.builder(
//             itemCount: categories.length,
//             itemBuilder: (context, index) {
//               final doc = categories[index];
//               return ListTile(
//                 title: Text(doc['title']),
//                 subtitle: Text(doc['description']),
//                 leading: doc['image'] != null
//                     ? Image.memory(
//                         base64Decode(doc['image']),
//                         width: 50,
//                         height: 50,
//                         fit: BoxFit.cover,
//                       )
//                     : Icon(Icons.image, size: 50, color: Colors.grey),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.edit, color: Colors.blue),
//                       onPressed: () => showCategoryDialog(
//                         id: doc.id,
//                         title: doc['title'],
//                         description: doc['description'],
//                       ),
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.delete, color: Colors.red),
//                       onPressed: () => deleteCategory(doc.id),
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.add, color: Colors.green),
//                       onPressed: () => showSubCategoryDialog(doc.id),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => showCategoryDialog(),
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
