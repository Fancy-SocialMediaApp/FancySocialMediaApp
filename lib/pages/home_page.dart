import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tugasbesar/components/text_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>   {

  //user
  final currentUser = FirebaseAuth.instance.currentUser!;

  //text controller
  final textController = TextEditingController();

  //sign user out
  void signOut(){
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: const Text(
            'The Wall',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true, // Teks akan diatur di tengah
          backgroundColor: Colors.grey[900],
          actions: [
            // sign out button
            IconButton(
              onPressed: signOut,
              icon: const Icon(Icons.logout),
              color: Colors.white,
            ),
          ],
        ),
        body: Center(
          child: Column(
            children: [
              //the wall
          
              //post message
              Row(
                children: [
                  //textfield
                  Expanded(
                    child: MyTextField(
                      controller: textController,
                      hintText: 'Write Something on The Wall',
                      obscureText: false,
                    ),
                  )
                ],
              ),

              //logged in as
              Text("Logged in as ${currentUser.email!}"),
            ],
          ),
        ),
      ),
    );
  }
}