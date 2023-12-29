// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tugasbesar/components/button.dart';
import 'package:tugasbesar/components/square_tile.dart';
import 'package:tugasbesar/components/text_field.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({
    super.key,
    required this.onTap
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  //text editing controller
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  //sign user in method
  void signIn() async {
    //show loading circle
    showDialog(context: context, 
    builder: (context) => const Center(
      child: CircularProgressIndicator(),
      )
    );

    //try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailTextController.text, 
      password: passwordTextController.text,
    );

    //pop loading circle
    if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      //pop loading circle
      Navigator.pop(context);
      //display error message
      displayMessage(e.code);
    }
  }

  //display a dialog message
  void displayMessage(String message){
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //logo
                Image.asset('lib/images/fancypedialogo.png', height: 150,),
                // SquareTile(imagePath: 'lib/images/fancypedialogo.png'),
                // Icon(
                //   Icons.login,
                //   size: 100,
                // ),
            
                const SizedBox(height: 30),

                //welcomeback message
                Text(
                  "Welcome back, you've been missed!",
                  style: TextStyle(
                    color: Colors.grey[700]),
                ),
            
                const SizedBox(height: 25),
            
                //email textfield
                MyTextField(
                  controller: emailTextController, 
                  hintText: 'Email', 
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                //password textfield
                MyTextField(
                  controller: passwordTextController, 
                  hintText: 'Password', 
                  obscureText: true),

                  const SizedBox(height: 10),

                //signin button
                MyButton(
                  onTap: signIn, 
                  text: 'Sign In'),

                  const SizedBox(height: 10),
                  
                //go to register page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?', 
                    style: TextStyle(
                      color: Colors.grey[700]
                      ),
                    ),
                    const SizedBox(width: 4,),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Register Now', 
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        color: Colors.blue),
                      ),
                    ),
                  ],
                ),

                  const SizedBox(height: 30),

                //or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                  
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text('Or continue with',
                        style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                  
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                  
                    ],
                  ),
                ),

                const SizedBox(height: 30,),

                //google + apple signin buttons
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //google button
                    SquareTile(imagePath: 'lib/images/google.png',),

                    SizedBox(width: 50,),

                    //apple button
                    SquareTile(imagePath: 'lib/images/apple.png',)
                  ],
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}