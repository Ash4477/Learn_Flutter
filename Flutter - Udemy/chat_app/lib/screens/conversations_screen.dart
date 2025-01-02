import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/private_chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'search_screen.dart';

class ConversationsScreen extends StatelessWidget {
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  ConversationsScreen({super.key});

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
            icon: const Icon(Icons.search),
            onPressed: () => {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => SearchScreen()),
              )
            },
            tooltip: 'general chat',
          ),
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('conversations')
            .where(
              'participants',
              arrayContains: currentUserId,
            )
            .snapshots(),
        builder: (ctx, convoSnapshot) {
          if (convoSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!convoSnapshot.hasData || convoSnapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No conversations found!"));
          }

          final convoDocs = convoSnapshot.data!.docs;

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

                  return Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 5,
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage: userData['image_url'] != null
                                ? NetworkImage(userData['image_url'])
                                : null,
                            child: userData['image_url'] == null
                                ? const Icon(Icons.person)
                                : null,
                          ),
                          title: Text(userData['username'] ?? 'Unknown User'),
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
                        ),
                        Divider(color: Colors.black26),
                      ],
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
