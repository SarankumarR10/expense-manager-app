import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/app_language.dart';

class EditExpenseScreen extends StatefulWidget {
  final String expenseId;
  final Map<String, dynamic> expense;

  const EditExpenseScreen({
    super.key,
    required this.expenseId,
    required this.expense,
  });

  @override
  State<EditExpenseScreen> createState() =>
      _EditExpenseScreenState();
}

class _EditExpenseScreenState
    extends State<EditExpenseScreen> {
  late TextEditingController amountController;
  late TextEditingController noteController;

  String category = "";

  @override
  void initState() {
    super.initState();

    amountController = TextEditingController(
      text: widget.expense['amount'].toString(),
    );

    noteController = TextEditingController(
      text: widget.expense['note'] ?? '',
    );

    category = widget.expense['category'] ?? "";
  }

  Future<void> updateExpense() async {
    if (amountController.text.trim().isEmpty) {
      return;
    }

    await FirebaseFirestore.instance
        .collection('expenses')
        .doc(widget.expenseId)
        .update({
      'amount': double.parse(
        amountController.text.trim(),
      ),
      'note': noteController.text.trim(),
      'category': category,
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLanguage.isTamil
              ? "செலவு புதுப்பிக்கப்பட்டது"
              : "Expense Updated Successfully",
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLanguage.isTamil
              ? "செலவு திருத்து"
              : "Edit Expense",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: amountController,
              keyboardType:
              TextInputType.number,
              decoration: InputDecoration(
                labelText: AppLanguage.amount,
                border:
                const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: category.isEmpty
                  ? null
                  : category,
              decoration: InputDecoration(
                labelText:
                AppLanguage.category,
                border:
                const OutlineInputBorder(),
              ),
              items: categoryItems(),
              onChanged: (value) {
                setState(() {
                  category = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            TextField(
              controller: noteController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: AppLanguage.note,
                border:
                const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: updateExpense,
                child: Text(
                  AppLanguage.isTamil
                      ? "புதுப்பிக்கவும்"
                      : "Update Expense",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}