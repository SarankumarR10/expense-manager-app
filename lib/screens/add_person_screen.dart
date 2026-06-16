import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddPersonScreen extends StatefulWidget {
  const AddPersonScreen({super.key});

  @override
  State<AddPersonScreen> createState() => _AddPersonScreenState();
}

class _AddPersonScreenState extends State<AddPersonScreen> {
  final personController = TextEditingController();

  Future<void> savePerson() async {
    if (personController.text.trim().isEmpty) return;

    await FirebaseFirestore.instance.collection('persons').add({
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'name': personController.text.trim(),
      'createdAt': Timestamp.now(),
    });

    personController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Person Added')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Person'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: personController,
              decoration: const InputDecoration(
                labelText: 'Person Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: savePerson,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}