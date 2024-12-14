import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:html' as html;
import 'package:flutter/foundation.dart';

class AdminReplyScreen extends StatefulWidget {
  final String userId;

  AdminReplyScreen({required this.userId});

  @override
  _AdminReplyScreenState createState() => _AdminReplyScreenState();
}

class _AdminReplyScreenState extends State<AdminReplyScreen> {
  final TextEditingController _replyController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();
  String? _imageBase64;

  // Send reply (text or image)
  void _sendReply() async {
    if (_replyController.text.trim().isEmpty && _imageBase64 == null) return;

    await _firestore.collection('chats').add({
      'text':
          _replyController.text.trim().isEmpty ? null : _replyController.text,
      'image': _imageBase64,
      'sender': 'Admin', // Admin is sending the reply
      'receiver': widget.userId, // Send to user by their userId
      'timestamp': FieldValue.serverTimestamp(),
    });

    _replyController.clear();
    setState(() {
      _imageBase64 = null; // Reset image after sending
    });
  }

  // Pick image logic
  // Future<void> pickImage() async {
  //   if (kIsWeb) {
  //     final html.FileUploadInputElement uploadInput =
  //         html.FileUploadInputElement();
  //     uploadInput.accept = 'image/*';
  //     uploadInput.click();

  //     uploadInput.onChange.listen((e) async {
  //       final files = uploadInput.files;
  //       if (files!.isEmpty) return;

  //       final reader = html.FileReader();
  //       reader.readAsArrayBuffer(files[0]);
  //       reader.onLoadEnd.listen((e) async {
  //         final Uint8List data = reader.result as Uint8List;
  //         final String encoded = base64Encode(data);
  //         setState(() {
  //           _imageBase64 = encoded;
  //         });
  //       });
  //     });
  //   } else {
  //     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  //     if (image != null) {
  //       Uint8List data = await image.readAsBytes();
  //       setState(() {
  //         _imageBase64 = base64Encode(data);
  //       });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat with User ${widget.userId}"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          // Display messages between the admin and the user
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chats')
                  .where('receiver', whereIn: ['Admin', widget.userId])
                  .where('sender', whereIn: ['Admin', widget.userId])
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data?.docs ?? [];
                return ListView.builder(
                  reverse: true,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final messageText = message['text'] ?? '';
                    final messageSender = message['sender'] ?? '';
                    final messageImage = message['image'] ?? '';

                    final isSentByAdmin = messageSender == 'Admin';

                    return Align(
                      alignment: isSentByAdmin
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 4),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color:
                              isSentByAdmin ? Colors.green : Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (messageText.isNotEmpty)
                              Text(
                                messageText,
                                style: TextStyle(
                                  color: isSentByAdmin
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            if (messageImage.isNotEmpty)
                              Image.memory(
                                base64Decode(messageImage),
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Display the selected image preview above the text field
          if (_imageBase64 != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                height: 50,
                width: 50,
                margin: EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                  image: DecorationImage(
                    image: MemoryImage(base64Decode(_imageBase64!)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          // Input field to send message to User
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _replyController,
                    decoration: InputDecoration(
                      hintText: "Write a reply",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                // SizedBox(width: 8),
                // IconButton(
                //   icon: Icon(Icons.image, color: Colors.blue),
                //   onPressed: pickImage, // Pick image
                // ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.green,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: _sendReply,
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
