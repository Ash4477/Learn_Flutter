import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'private_chat_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final TextEditingController _controller = TextEditingController();
  List<DocumentSnapshot>? _users;
  List<DocumentSnapshot>? _filteredUsers;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final data = await FirebaseFirestore.instance.collection('users').get();
    setState(() {
      _users = data.docs;
      _filteredUsers =
          _users!.where((user) => user.id != currentUserId).toList();
    });
  }

  void _filterSearchResults(String query) {
    setState(() {
      _filteredUsers = _users?.where((userDoc) {
        if (userDoc.id == FirebaseAuth.instance.currentUser!.uid) {
          return false;
        }
        return (userDoc['username'] ?? '')
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase());
      }).toList();
    });
  }

  Future<void> _addConversation(String otherUserId, String username) async {
    final convoQuery =
        await FirebaseFirestore.instance.collection('conversations').get();

    final convoRef;
    if (convoQuery.docs.isEmpty) {
      convoRef =
          await FirebaseFirestore.instance.collection('conversations').add({
        'participants': [currentUserId, otherUserId]
      });
    } else {
      convoRef = convoQuery.docs
          .where((doc) => doc['participants'].contains(otherUserId))
          .toList()[0];
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => PrivateChatScreen(
          username,
          convoRef.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Users'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 10),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Enter username...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filterSearchResults,
            ),
            SizedBox(height: 10),
            Expanded(
              child: _filteredUsers == null
                  ? Center(child: Text('Start Searching'))
                  : _filteredUsers!.isEmpty
                      ? Center(child: Text('No results found!'))
                      : ListView.builder(
                          itemCount: _filteredUsers!.length,
                          itemBuilder: (context, index) {
                            final userData = _filteredUsers![index];
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 5,
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: userData['image_url'] != null
                                      ? NetworkImage(userData['image_url'])
                                      : null,
                                  child: userData['image_url'] == null
                                      ? const Icon(Icons.person)
                                      : null,
                                ),
                                title: Text(
                                    userData['username'] ?? 'Unknown User'),
                                onTap: () => _addConversation(
                                  userData.id,
                                  userData['username'],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
