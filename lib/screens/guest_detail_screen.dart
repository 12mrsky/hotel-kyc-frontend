import 'package:flutter/material.dart';

class GuestDetailScreen extends StatelessWidget {
  final dynamic guest;

  const GuestDetailScreen({super.key, required this.guest});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Guest Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              guest.toString(),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}