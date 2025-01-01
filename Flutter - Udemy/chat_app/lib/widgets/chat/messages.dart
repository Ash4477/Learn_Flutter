import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import './message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final chatDocs = chatSnapshot.data!.docs;
        final currentUserId = FirebaseAuth.instance.currentUser!.uid;
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (ctx, idx) => MessageBubble(
            chatDocs[idx]['username'],
            chatDocs[idx]['userImage'],
            chatDocs[idx]['text'],
            chatDocs[idx]['userId'] == currentUserId,
            key: ValueKey(chatDocs[idx].id),
          ),
        );
      },
    );
  }
}
