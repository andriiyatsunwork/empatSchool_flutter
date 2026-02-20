/*
 * @author Andrii Yatsun
 */

import 'package:flutter/material.dart';

// сторінка детального перегляду для Hero анімації

/**
 * Screen (Widget) that show profile picture on all screen.
 */
class AvatarDetailPage extends StatelessWidget {
  const AvatarDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Hero(
          tag: 'profile_pic',
          child: Container(
            width: double.infinity,
            height: 400,
            color: Colors.grey[500],
            child: const Icon(Icons.person, size: 200, color: Colors.white),
          ),
        ),
      ),
    );
  }
}