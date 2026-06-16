import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants/app_language.dart';
import 'edit_expense_screen.dart';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ExpenseListScreen extends StatefulWidget {
const ExpenseListScreen({super.key});

@override
State<ExpenseListScreen> createState() =>
_ExpenseListScreenState();
}

class _ExpenseListScreenState
extends State<ExpenseListScreen> {
String selectedPerson = "All";
String selectedMonth = "All";
DateTime? selectedDate;
Future<void> exportToExcel(
    List<QueryDocumentSnapshot> expenses) async {

  var excel = Excel.createExcel();

  Sheet sheet = excel['Expenses'];

  sheet.appendRow([
    TextCellValue('Person'),
    TextCellValue('Type'),
    TextCellValue('Category'),
    TextCellValue('Amount'),
    TextCellValue('Note'),
    TextCellValue('Date'),
  ]);

  for (var doc in expenses) {

    final expense =
    doc.data() as Map<String, dynamic>;

    final expenseDate =
    (expense['createdAt'] as Timestamp)
        .toDate();

    bool show = true;

    if (selectedPerson != "All" &&
        expense['personName'] != selectedPerson) {
      show = false;
    }

    if (selectedMonth != "All" &&
        expenseDate.month !=
            int.parse(selectedMonth)) {
      show = false;
    }

    if (selectedDate != null) {
      if (expenseDate.day != selectedDate!.day ||
          expenseDate.month != selectedDate!.month ||
          expenseDate.year != selectedDate!.year) {
        show = false;
      }
    }

    if (!show) continue;

    sheet.appendRow([
      TextCellValue(
          expense['personName'] ?? ''),
      TextCellValue(
          expense['type'] ?? ''),
      TextCellValue(
          expense['category'] ?? ''),
      TextCellValue(
          expense['amount'].toString()),
      TextCellValue(
          expense['note'] ?? ''),
      TextCellValue(
          "${expenseDate.day}-${expenseDate.month}-${expenseDate.year}"),
    ]);
  }

  final directory =
  await getTemporaryDirectory();

  final path =
      "${directory.path}/expenses.xlsx";

  final file = File(path);

  await file.writeAsBytes(
    excel.encode()!,
  );

  await Share.shareXFiles(
    [XFile(path)],
    text: "Filtered Expenses Report",
  );
}
@override
Widget build(BuildContext context) {
final uid =
FirebaseAuth.instance.currentUser!.uid;

return Scaffold(
appBar: AppBar(
title: Text(AppLanguage.expenses),
),
body: StreamBuilder<QuerySnapshot>(
stream: FirebaseFirestore.instance
    .collection('expenses')
    .where('uid', isEqualTo: uid)
    .orderBy(
'createdAt',
descending: true,
)
    .snapshots(),
builder: (context, snapshot) {
if (snapshot.hasError) {
return Center(
child: Text(
AppLanguage.isTamil
? "பிழை ஏற்பட்டது"
    : "Error loading expenses",
),
);
}

if (!snapshot.hasData) {
return const Center(
child: CircularProgressIndicator(),
);
}

final expenses =
snapshot.data!.docs;

if (expenses.isEmpty) {
return Center(
child: Text(
AppLanguage.noExpenses,
),
);
}

final personNames = <String>{};

double filteredTotal = 0;

for (var doc in expenses) {
final expense =
doc.data()
as Map<String, dynamic>;

personNames.add(
expense['personName'] ??
AppLanguage.unknown,
);

final expenseDate =
(expense['createdAt']
as Timestamp)
    .toDate();

bool show = true;

if (selectedPerson != "All" &&
expense['personName'] !=
selectedPerson) {
show = false;
}

if (selectedMonth != "All" &&
expenseDate.month !=
int.parse(
selectedMonth)) {
show = false;
}

if (selectedDate != null) {
if (expenseDate.day !=
selectedDate!.day ||
expenseDate.month !=
selectedDate!.month ||
expenseDate.year !=
selectedDate!.year) {
show = false;
}
}

if (show) {
filteredTotal +=
(expense['amount']
as num)
    .toDouble();
}
}

return Column(
children: [
Padding(
padding:
const EdgeInsets.all(10),
child: Column(
children: [
DropdownButtonFormField<
String>(
value:
selectedPerson,
decoration:
InputDecoration(
labelText:
AppLanguage
    .filterPerson,
border:
const OutlineInputBorder(),
),
items: [
DropdownMenuItem(
value: "All",
child: Text(
AppLanguage
    .allPersons,
),
),
...personNames.map(
(person) =>
DropdownMenuItem(
value:
person,
child:
Text(
person,
),
),
),
],
onChanged:
(value) {
setState(() {
selectedPerson =
value!;
});
},
),

const SizedBox(
height: 10),

DropdownButtonFormField<
String>(
value:
selectedMonth,
decoration:
InputDecoration(
labelText:
AppLanguage
    .filterMonth,
border:
const OutlineInputBorder(),
),
items: [
DropdownMenuItem(
value: "All",
child: Text(
AppLanguage
    .allMonths,
),
),
const DropdownMenuItem(
value: "1",
child: Text(
"January"),
),
const DropdownMenuItem(
value: "2",
child: Text(
"February"),
),
const DropdownMenuItem(
value: "3",
child:
Text("March"),
),
const DropdownMenuItem(
value: "4",
child:
Text("April"),
),
const DropdownMenuItem(
value: "5",
child: Text("May"),
),
const DropdownMenuItem(
value: "6",
child: Text("June"),
),
const DropdownMenuItem(
value: "7",
child: Text("July"),
),
const DropdownMenuItem(
value: "8",
child: Text(
"August"),
),
const DropdownMenuItem(
value: "9",
child: Text(
"September"),
),
const DropdownMenuItem(
value: "10",
child: Text(
"October"),
),
const DropdownMenuItem(
value: "11",
child: Text(
"November"),
),
const DropdownMenuItem(
value: "12",
child: Text(
"December"),
),
],
onChanged:
(value) {
setState(() {
selectedMonth =
value!;
});
},
),

const SizedBox(
height: 10),

ElevatedButton.icon(
icon: const Icon(
Icons.calendar_month,
),
label: Text(
selectedDate == null
? AppLanguage
    .selectDate
    : "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
),
onPressed:
() async {
DateTime? picked =
await showDatePicker(
context:
context,
firstDate:
DateTime(
2020),
lastDate:
DateTime(
2100),
initialDate:
DateTime
    .now(),
);

if (picked !=
null) {
setState(() {
selectedDate =
picked;
});
}
},
),

TextButton(
onPressed: () {
setState(() {
selectedPerson =
"All";
selectedMonth =
"All";
selectedDate =
null;
});
},
child: Text(
AppLanguage
    .clearFilters,
),
),

Card(
child: ListTile(
title: Text(
AppLanguage
    .filteredTotal,
),
trailing: Text(
"₹${filteredTotal.toStringAsFixed(2)}",
style:
const TextStyle(
fontWeight:
FontWeight
    .bold,
),
),
),
),
  const SizedBox(height: 10),

  SizedBox(
    width: double.infinity,
    child: ElevatedButton.icon(
      icon: const Icon(Icons.download),
      label: const Text("Download Excel"),
      onPressed: () {
        exportToExcel(expenses);
      },
    ),
  ),
],
),
),

Expanded(
child: ListView.builder(
itemCount:
expenses.length,
itemBuilder:
(context, index) {
final expense =
expenses[index]
    .data()
as Map<String,
dynamic>;

final expenseDate =
(expense[
'createdAt']
as Timestamp)
    .toDate();

if (selectedPerson !=
"All" &&
expense[
'personName'] !=
selectedPerson) {
return const SizedBox();
}

if (selectedMonth !=
"All" &&
expenseDate.month !=
int.parse(
selectedMonth)) {
return const SizedBox();
}

if (selectedDate !=
null) {
if (expenseDate.day !=
selectedDate!
    .day ||
expenseDate.month !=
selectedDate!
    .month ||
expenseDate.year !=
selectedDate!
    .year) {
return const SizedBox();
}
}

return Card(
margin:
const EdgeInsets
    .all(8),
elevation: 3,
child: Padding(
padding:
const EdgeInsets
    .all(12),
child: Column(
crossAxisAlignment:
CrossAxisAlignment
    .start,
children: [
Text(
"👤 ${expense['personName'] ?? AppLanguage.unknown}",
style:
const TextStyle(
fontSize:
18,
fontWeight:
FontWeight
    .bold,
),
),

const SizedBox(
height:
10),

Container(
padding:
const EdgeInsets.symmetric(
horizontal:
10,
vertical:
5,
),
decoration:
BoxDecoration(
color: expense['type'] ==
"செலவு" ||
expense['type'] ==
"Spent"
? Colors
    .red
    .shade100
    : Colors
    .green
    .shade100,
borderRadius:
BorderRadius.circular(
8),
),
child: Text(
expense['type'] ??
"",
),
),

const SizedBox(
height:
10),

Text(
"₹${expense['amount']}",
style:
const TextStyle(
fontSize:
24,
fontWeight:
FontWeight
    .bold,
),
),

Text(
"${AppLanguage.categoryLabel}: ${expense['category']}",
),

Text(
"${AppLanguage.noteLabel}: ${expense['note']}",
),

Text(
"${AppLanguage.date}: ${expenseDate.day}-${expenseDate.month}-${expenseDate.year}",
),

const SizedBox(
height:
10),

Row(
children: [
Expanded(
child:
ElevatedButton.icon(
icon:
const Icon(
Icons.edit,
),
label:
Text(
AppLanguage
    .edit,
),
onPressed:
() {
Navigator.push(
context,
MaterialPageRoute(
builder: (_) =>
EditExpenseScreen(
expenseId:
expenses[index].id,
expense:
expense,
),
),
);
},
),
),

const SizedBox(
width:
10),

Expanded(
child:
ElevatedButton.icon(
icon:
const Icon(
Icons.delete,
),
label:
Text(
AppLanguage
    .delete,
),
style:
ElevatedButton.styleFrom(
backgroundColor:
Colors.red,
foregroundColor:
Colors.white,
),
onPressed:
() async {
bool? confirm =
await showDialog(
context:
context,
builder:
(context) {
return AlertDialog(
title:
Text(
AppLanguage.deleteExpense,
),
content:
Text(
AppLanguage.deleteConfirm,
),
actions: [
TextButton(
onPressed: () => Navigator.pop(context, false),
child: Text(AppLanguage.cancel),
),
ElevatedButton(
onPressed: () => Navigator.pop(context, true),
child: Text(AppLanguage.delete),
),
],
);
},
);

if (confirm ==
true) {
await FirebaseFirestore
    .instance
    .collection(
'expenses')
    .doc(
expenses[index]
    .id)
    .delete();
}
},
),
),
],
),
],
),
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

