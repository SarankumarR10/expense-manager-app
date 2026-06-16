import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dashboard_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
const LoginScreen({super.key});

@override
State<LoginScreen> createState() =>
_LoginScreenState();
}

class _LoginScreenState
extends State<LoginScreen> {
final emailController =
TextEditingController();

final passwordController =
TextEditingController();

bool loading = false;
bool obscurePassword = true;

Future<void> login() async {
try {
setState(() => loading = true);

await FirebaseAuth.instance
    .signInWithEmailAndPassword(
email:
emailController.text.trim(),
password:
passwordController.text.trim(),
);

User? user =
FirebaseAuth.instance.currentUser;

await user?.reload();

user =
FirebaseAuth.instance.currentUser;

if (user != null &&
!user.emailVerified) {
await FirebaseAuth.instance
    .signOut();

if (!mounted) return;

ScaffoldMessenger.of(context)
    .showSnackBar(
const SnackBar(
content: Text(
"Please verify your email first.",
),
),
);

return;
}

if (!mounted) return;

Navigator.pushReplacement(
context,
MaterialPageRoute(
builder: (_) =>
const DashboardScreen(),
),
);
} on FirebaseAuthException catch (e) {
ScaffoldMessenger.of(context)
    .showSnackBar(
SnackBar(
content: Text(
e.message ?? "Login Failed",
),
),
);
} finally {
if (mounted) {
setState(() => loading = false);
}
}
}

Future<void> forgotPassword() async {
if (emailController.text
    .trim()
    .isEmpty) {
ScaffoldMessenger.of(context)
    .showSnackBar(
const SnackBar(
content: Text(
"Enter your email first",
),
),
);
return;
}

try {
await FirebaseAuth.instance
    .sendPasswordResetEmail(
email:
emailController.text.trim(),
);

if (!mounted) return;

ScaffoldMessenger.of(context)
    .showSnackBar(
const SnackBar(
content: Text(
"Password reset email sent",
),
),
);
} catch (e) {
ScaffoldMessenger.of(context)
    .showSnackBar(
SnackBar(
content: Text(
e.toString(),
),
),
);
}
}

@override
void dispose() {
emailController.dispose();
passwordController.dispose();
super.dispose();
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar:
AppBar(title: const Text("Login")),
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

const SizedBox(height: 20),

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

Align(
alignment:
Alignment.centerRight,
child: TextButton(
onPressed:
forgotPassword,
child: const Text(
"Forgot Password?",
),
),
),

const SizedBox(height: 10),

SizedBox(
width:
double.infinity,
height: 50,
child:
ElevatedButton(
onPressed: loading
? null
    : login,
child: loading
? const CircularProgressIndicator(
color:
Colors.white,
)
    : const Text(
"Login",
),
),
),

const SizedBox(height: 20),

TextButton(
onPressed: () {
Navigator.push(
context,
MaterialPageRoute(
builder: (_) =>
const SignupScreen(),
),
);
},
child: const Text(
"Don't have an account? Sign Up",
),
),
],
),
),
);
}
}

