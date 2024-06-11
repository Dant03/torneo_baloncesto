import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final String message;

  LoadingScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(message, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
