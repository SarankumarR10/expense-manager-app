import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
const SignupScreen({super.key});

@override
State<SignupScreen> createState() =>
_SignupScreenState();
}

class _SignupScreenState
extends State<SignupScreen> {
final nameController =
TextEditingController();

final emailController =
TextEditingController();

final passwordController =
TextEditingController();

bool loading = false;
bool obscurePassword = true;

Future<void> signUp() async {
if (nameController.text.trim().isEmpty ||
emailController.text.trim().isEmpty ||
passwordController.text.trim().isEmpty) {
ScaffoldMessenger.of(context)
    .showSnackBar(
const SnackBar(
content: Text(
"Please fill all fields",
),
),
);
return;
}

try {
setState(() {
loading = true;
});

UserCredential userCredential =
await FirebaseAuth.instance
    .createUserWithEmailAndPassword(
email:
emailController.text.trim(),
password:
passwordController.text.trim(),
);

await FirebaseFirestore.instance
    .collection('users')
    .doc(userCredential.user!.uid)
    .set({
'name':
nameController.text.trim(),
'email':
emailController.text.trim(),
'createdAt':
Timestamp.now(),
});

await userCredential.user!
    .sendEmailVerification();

if (!mounted) return;

ScaffoldMessenger.of(context)
    .showSnackBar(
const SnackBar(
content: Text(
"Verification email sent. Please verify your email.",
),
),
);

Navigator.pushReplacement(
context,
MaterialPageRoute(
builder: (_) =>
const LoginScreen(),
),
);
} on FirebaseAuthException catch (e) {
ScaffoldMessenger.of(context)
    .showSnackBar(
SnackBar(
content: Text(
e.message ??
"Signup Failed",
),
),
);
} finally {
if (mounted) {
setState(() {
loading = false;
});
}
}
}

@override
void dispose() {
nameController.dispose();
emailController.dispose();
passwordController.dispose();
super.dispose();
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title:
const Text("Create Account"),
),
body: SingleChildScrollView(
padding:
const EdgeInsets.all(20),
child: Column(
children: [
const Icon(
Icons.account_balance_wallet,
size: 90,
color: Colors.green,
),

const SizedBox(height: 10),

const Text(
"Expense Manager",
style: TextStyle(
fontSize: 24,
fontWeight:
FontWeight.bold,
),
),

const SizedBox(height: 30),

TextField(
controller:
nameController,
decoration:
InputDecoration(
labelText: "Name",
prefixIcon:
const Icon(
Icons.person,
),
border:
OutlineInputBorder(
borderRadius:
BorderRadius
    .circular(
12,
),
),
),
),

const SizedBox(height: 15),

TextField(
controller:
emailController,
keyboardType:
TextInputType
    .emailAddress,
decoration:
InputDecoration(
labelText: "Email",
prefixIcon:
const Icon(
Icons.email,
),
border:
OutlineInputBorder(
borderRadius:
BorderRadius
    .circular(
12,
),
),
),
),

const SizedBox(height: 15),

TextField(
controller:
passwordController,
obscureText:
obscurePassword,
decoration:
InputDecoration(
labelText:
"Password",
prefixIcon:
const Icon(
Icons.lock,
),
suffixIcon:
IconButton(
icon: Icon(
obscurePassword
? Icons
    .visibility
    : Icons
    .visibility_off,
),
onPressed: () {
setState(() {
obscurePassword =
!obscurePassword;
});
},
),
border:
OutlineInputBorder(
borderRadius:
BorderRadius
    .circular(
12,
),
),
),
),

const SizedBox(height: 25),

SizedBox(
width:
double.infinity,
height: 50,
child:
ElevatedButton(
onPressed: loading
? null
    : signUp,
child: loading
? const CircularProgressIndicator(
color:
Colors.white,
)
    : const Text(
"Sign Up",
),
),
),

const SizedBox(height: 15),

TextButton(
onPressed: () {
Navigator.pop(
context);
},
child: const Text(
"Already have an account? Login",
),
),
],
),
),
);
}
}

