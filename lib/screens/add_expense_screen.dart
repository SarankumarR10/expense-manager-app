import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constants/app_language.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final amountController = TextEditingController();
  final noteController = TextEditingController();

  String? selectedPersonId;
  String? selectedPersonName;

  String transactionType =
  AppLanguage.isTamil ? "செலவு" : "Spent";

  String selectedCategory =
  AppLanguage.isTamil ? "உணவு" : "Food";

  Future<void> saveExpense() async {
    if (selectedPersonId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLanguage.isTamil
                ? "நபரை தேர்வு செய்யவும்"
                : "Please select a person",
          ),
        ),
      );
      return;
    }

    if (amountController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLanguage.isTamil
                ? "தொகையை உள்ளிடவும்"
                : "Enter amount",
          ),
        ),
      );
      return;
    }

    await FirebaseFirestore.instance
        .collection('expenses')
        .add({
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'personId': selectedPersonId,
      'personName': selectedPersonName,
      'type': transactionType,
      'amount': double.parse(amountController.text),
      'category': selectedCategory,
      'note': noteController.text.trim(),
      'createdAt': Timestamp.now(),
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLanguage.isTamil
              ? "செலவு வெற்றிகரமாக சேமிக்கப்பட்டது"
              : "Expense Added Successfully",
        ),
      ),
    );

    Navigator.pop(context);
  }

  List<DropdownMenuItem<String>> categoryItems() {
    if (AppLanguage.isTamil) {
      return const [
        DropdownMenuItem(
          value: "உணவு",
          child: Text("உணவு"),
        ),
        DropdownMenuItem(
          value: "பயணம்",
          child: Text("பயணம்"),
        ),
        DropdownMenuItem(
          value: "வாங்குதல்",
          child: Text("வாங்குதல்"),
        ),
        DropdownMenuItem(
          value: "மருத்துவம்",
          child: Text("மருத்துவம்"),
        ),
        DropdownMenuItem(
          value: "வீட்டு செலவு",
          child: Text("வீட்டு செலவு"),
        ),
        DropdownMenuItem(
          value: "கல்வி",
          child: Text("கல்வி"),
        ),
        DropdownMenuItem(
          value: "மற்றவை",
          child: Text("மற்றவை"),
        ),
      ];
    }

    return const [
      DropdownMenuItem(
        value: "Food",
        child: Text("Food"),
      ),
      DropdownMenuItem(
        value: "Travel",
        child: Text("Travel"),
      ),
      DropdownMenuItem(
        value: "Shopping",
        child: Text("Shopping"),
      ),
      DropdownMenuItem(
        value: "Medical",
        child: Text("Medical"),
      ),
      DropdownMenuItem(
        value: "House Expense",
        child: Text("House Expense"),
      ),
      DropdownMenuItem(
        value: "Education",
        child: Text("Education"),
      ),
      DropdownMenuItem(
        value: "Other",
        child: Text("Other"),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLanguage.addExpense),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('persons')
                  .where('uid', isEqualTo: uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final persons = snapshot.data!.docs;

                return DropdownButtonFormField<String>(
                  value: selectedPersonId,
                  decoration: InputDecoration(
                    labelText:
                    AppLanguage.selectPerson,
                    border:
                    const OutlineInputBorder(),
                  ),
                  items: persons.map((doc) {
                    return DropdownMenuItem<String>(
                      value: doc.id,
                      child: Text(doc['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    final personDoc =
                    persons.firstWhere(
                          (doc) => doc.id == value,
                    );

                    setState(() {
                      selectedPersonId = value;
                      selectedPersonName =
                      personDoc['name'];
                    });
                  },
                );
              },
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: transactionType,
              decoration: InputDecoration(
                labelText: AppLanguage.type,
                border:
                const OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(
                  value: AppLanguage.isTamil
                      ? "செலவு"
                      : "Spent",
                  child: Text(
                    AppLanguage.spentType,
                  ),
                ),
                DropdownMenuItem(
                  value: AppLanguage.isTamil
                      ? "பெற்றது"
                      : "Received",
                  child: Text(
                    AppLanguage.receivedType,
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  transactionType = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            TextField(
              controller: amountController,
              keyboardType:
              TextInputType.number,
              decoration: InputDecoration(
                labelText:
                AppLanguage.amount,
                border:
                const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: InputDecoration(
                labelText:
                AppLanguage.category,
                border:
                const OutlineInputBorder(),
              ),
              items: categoryItems(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            TextField(
              controller: noteController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText:
                AppLanguage.note,
                border:
                const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: saveExpense,
                child: Text(
                  AppLanguage.saveExpense,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}