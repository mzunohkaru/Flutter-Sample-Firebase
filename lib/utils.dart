import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Firebase Auth Initialize
final FirebaseAuth auth = FirebaseAuth.instance;

/// Get UserID
final userID = auth.currentUser?.uid ?? '';

/// Firestoreのデータベース定義
final db = FirebaseFirestore.instance;

/// Firestoreのpostsデータベース定義
final dbPost = db.collection('users').doc(userID).collection('posts');

/// シンプルなプリローダー
const preloader =
    Center(child: CircularProgressIndicator(color: Colors.orange));