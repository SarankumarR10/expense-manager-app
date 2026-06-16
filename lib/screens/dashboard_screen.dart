import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/app_language.dart';
import 'add_person_screen.dart';
import 'person_list_screen.dart';
import 'add_expense_screen.dart';
import 'expense_list_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    Navigator.popUntil(
      context,
          (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid =
        FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLanguage.dashboard),
        actions: [

          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              setState(() {
                AppLanguage.isTamil =
                !AppLanguage.isTamil;
              });
            },
          ),

          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => logout(context),
          ),
        ],
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('expenses')
            .where('uid', isEqualTo: uid)
            .snapshots(),

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final expenses = snapshot.data!.docs;

          double todayTotal = 0;
          double weekTotal = 0;
          double monthTotal = 0;
          double totalSpent = 0;
          double totalReceived = 0;

          final now = DateTime.now();

          for (var doc in expenses) {

            final expense =
            doc.data() as Map<String, dynamic>;

            final amount =
                (expense['amount'] as num?)
                    ?.toDouble() ??
                    0;

            final date =
            (expense['createdAt'] as Timestamp)
                .toDate();

            final type =
                expense['type'] ?? 'செலவு';

            if (date.year == now.year &&
                date.month == now.month &&
                date.day == now.day) {
              todayTotal += amount;
            }

            if (now.difference(date).inDays <= 7) {
              weekTotal += amount;
            }

            if (date.year == now.year &&
                date.month == now.month) {
              monthTotal += amount;
            }

            if (type == "செலவு") {
              totalSpent += amount;
            } else {
              totalReceived += amount;
            }
          }

          final balance =
              totalReceived - totalSpent;

          return ListView(
            padding:
            const EdgeInsets.all(16),

            children: [

              Card(
                child: ListTile(
                  leading:
                  const Icon(Icons.today),
                  title: Text(
                    AppLanguage.today,
                  ),
                  trailing: Text(
                    "₹${todayTotal.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),
              ),

              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.calendar_view_week,
                  ),
                  title: Text(
                    AppLanguage.week,
                  ),
                  trailing: Text(
                    "₹${weekTotal.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),
              ),

              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.calendar_month,
                  ),
                  title: Text(
                    AppLanguage.month,
                  ),
                  trailing: Text(
                    "₹${monthTotal.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),
              ),

              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.arrow_upward,
                    color: Colors.red,
                  ),
                  title: Text(
                    AppLanguage.spent,
                  ),
                  trailing: Text(
                    "₹${totalSpent.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),
              ),

              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.arrow_downward,
                    color: Colors.green,
                  ),
                  title: Text(
                    AppLanguage.received,
                  ),
                  trailing: Text(
                    "₹${totalReceived.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),
              ),

              Card(
                color: balance >= 0
                    ? Colors.green.shade100
                    : Colors.red.shade100,
                child: ListTile(
                  leading: const Icon(
                    Icons.account_balance_wallet,
                  ),
                  title: Text(
                    AppLanguage.balance,
                  ),
                  trailing: Text(
                    "₹${balance.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontWeight:
                      FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon:
                  const Icon(Icons.person_add),
                  label: Text(
                    AppLanguage.addPerson,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const AddPersonScreen(),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.people),
                  label: Text(
                    AppLanguage.viewPersons,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const PersonListScreen(),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon:
                  const Icon(Icons.add_card),
                  label: Text(
                    AppLanguage.addExpense,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const AddExpenseScreen(),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon:
                  const Icon(Icons.receipt_long),
                  label: Text(
                    AppLanguage.viewExpenses,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ExpenseListScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}