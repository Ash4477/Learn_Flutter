import 'dart:io';

// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  Future<void> _submitAuthForm(
    String email,
    String password,
    String username,
    File? userImage,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential userCred;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        userCred = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        userCred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // final ref = FirebaseStorage.instance
        //     .ref()
        //     .child('user_image')
        //     .child('${userCred.user!.uid}.jpg');

        // await ref.putFile(userImage).whenComplete(() {}); // ? check this shit

        final url =
            'https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1667809932i/57515859.jpg';

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCred.user!.uid)
            .set({
          'username': username,
          'email': email,
          'image_url': url,
        });
      }
    } on FirebaseAuthException catch (e) {
      var message = 'An error occurred, please check your credentials!';
      if (e.message != null) {
        message = e.message ?? '';
      }
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).colorScheme.error,
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      rethrow;
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Chatter App',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          AuthForm(
            _submitAuthForm,
            _isLoading,
          ),
        ],
      ),
    );
  }
}
