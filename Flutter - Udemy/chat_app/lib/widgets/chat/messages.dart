import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import './message_bubble.dart';

class Messages extends StatelessWidget {
  final String? chatId;
  const Messages({this.chatId, super.key});

  Widget _globalMessagesBuilder(BuildContext context) {
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

  Widget _privateMessagesBuilder(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('conversations')
          .doc(chatId)
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        print(chatSnapshot.hasData);
        if (!chatSnapshot.hasData || chatSnapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No messages found!"));
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

  @override
  Widget build(BuildContext context) {
    if (chatId == null) {
      return _globalMessagesBuilder(context);
    }

    return _privateMessagesBuilder(context);
  }
}
