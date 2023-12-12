import 'package:flutter/material.dart';
import '../models/user.dart';

class MahasiswaScreen extends StatelessWidget {
  final User user;

  MahasiswaScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mahasiswa Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome, ${user.nama}!'),
            SizedBox(height: 20),
            Text('NIM: ${user.nim}'),
            Text('No. KTP: ${user.noKtp}'),
            Text('Role: ${user.role}'),
            Text('Phone: ${user.nomorHandphone}'),
            Text('Email: ${user.email}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement logout or any other action
                Navigator.pop(context);
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
