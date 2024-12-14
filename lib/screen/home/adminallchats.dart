import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'adminchat.dart'; // Ensure this imports your AdminReplyScreen

class AdminDashboard extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Dashboard"),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('chats')
            .where('receiver',
                isEqualTo: 'Admin') // Only fetch messages sent to Admin
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error fetching chats"));
          }

          final messages = snapshot.data?.docs ?? [];

          // Extract unique senders (userId)
          final uniqueUsers = messages
              .map((doc) => doc['sender']) // Change to 'sender' for userId
              .toSet()
              .toList();

          if (uniqueUsers.isEmpty) {
            return Center(child: Text("No chats available."));
          }

          return ListView.builder(
            itemCount: uniqueUsers.length,
            itemBuilder: (context, index) {
              final userId =
                  uniqueUsers[index]; // Get userId instead of userEmail

              return ListTile(
                title: Text(userId), // Display userId
                trailing: Icon(Icons.chat),
                onTap: () {
                  // Navigate to AdminReplyScreen with userId
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AdminReplyScreen(userId: userId), // Pass userId
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
