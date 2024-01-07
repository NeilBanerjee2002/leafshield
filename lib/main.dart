// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:leafshield/utilities/login.dart';
// import 'TfliteModel.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// import '../firebase_options.dart';
//
// void main()async{
//   runApp(MyApp());
//   await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform);
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home:  LoginPage(),
//     );
//   }
// }
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:leafshield/TfliteModel.dart';
import 'package:tflite/tflite.dart';

import '../firebase_options.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final user=_auth.currentUser;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: user!=null?TfliteModel():LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool showpw=false;
  Future<void> _handleLogin() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Successful login, navigate to the home page or perform desired action
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully Signed In'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TfliteModel(),));
      print('Login successful! User ID: ${userCredential.user?.uid}');
    } catch (e) {
      // Failed login, showa an error message
      print('Login failed. Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please Enter Correct Password'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              Image(image: AssetImage('images/leadfshield_logo.jpg')),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(50)
                ),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(hintText: '   Email'),
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(50)
                ),
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(hintText: '  Password',
                    suffixIcon: IconButton(onPressed: (){
                      setState(() {
                        showpw=!showpw;
                      });
                    }, icon: Icon(Icons.remove_red_eye))
                  ),
                  
                  obscureText: showpw?true:false,
                ),
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _handleLogin,
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                ),
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
