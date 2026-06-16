import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PersonListScreen extends StatelessWidget {
  const PersonListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Persons'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('persons')
            .where('uid', isEqualTo: uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error loading persons'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final persons = snapshot.data!.docs;

          if (persons.isEmpty) {
            return const Center(
              child: Text('No persons added yet'),
            );
          }

          return ListView.builder(
            itemCount: persons.length,
            itemBuilder: (context, index) {
              final person =
              persons[index].data() as Map<String, dynamic>;

              return ListTile(
                leading: const Icon(Icons.person),
                title: Text(person['name'] ?? ''),
              );
            },
          );
        },
      ),
    );
  }
}