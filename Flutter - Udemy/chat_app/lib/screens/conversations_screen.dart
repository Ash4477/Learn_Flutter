import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/private_chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ConversationsScreen extends StatelessWidget {
  const ConversationsScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (error) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.group),
            onPressed: () => {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => ChatScreen()),
              )
            },
            tooltip: 'general chat',
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => _logout(context),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('conversations')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (ctx, convoSnapshot) {
          if (convoSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!convoSnapshot.hasData || convoSnapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No conversations yet!'));
          }

          final currentUserId = FirebaseAuth.instance.currentUser!.uid;
          final convoDocs = convoSnapshot.data!.docs.where((doc) {
            return (doc['participants'] as List).contains(currentUserId);
          }).toList();

          if (convoDocs.isEmpty) {
            return const Center(child: Text('No conversations yet!'));
          }

          return ListView.builder(
            itemCount: convoDocs.length,
            itemBuilder: (ctx, idx) {
              final convo = convoDocs[idx];
              final otherUserId = (convo['participants'] as List)
                  .firstWhere((id) => id != currentUserId);

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(otherUserId)
                    .get(),
                builder: (ctx, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(
                      title: Text('Loading...'),
                    );
                  }

                  if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                    return const ListTile(
                      title: Text('User not found'),
                    );
                  }

                  final userData =
                      userSnapshot.data!.data() as Map<String, dynamic>;

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: userData['image_url'] != null
                          ? NetworkImage(userData['image_url'])
                          : null,
                      child: userData['image_url'] == null
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    title: Text(userData['username'] ?? 'Unknown User'),
                    subtitle: Text(convoDocs[idx]['lastMessage']),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => PrivateChatScreen(
                            userData['username'],
                            convo.id,
                          ),
                        ),
                      );
                    },
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
