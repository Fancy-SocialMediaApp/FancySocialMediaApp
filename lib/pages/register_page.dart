import 'package:flutter/material.dart';
import 'package:tugasbesar/components/button.dart';
import 'package:tugasbesar/components/text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //text editing controller
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

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
                Icon(
                  Icons.lock,
                  size: 100,
                ),
            
                const SizedBox(height: 50),
            
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
                  onTap: (){}, 
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
                      onTap: (){},
                      child: const Text(
                        'Register Now', 
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}