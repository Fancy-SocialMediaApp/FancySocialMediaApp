import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tugasbesar/components/text_field.dart';
import 'package:tugasbesar/components/wall_post.dart';

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

  //post message
  void postMessage(){
    //only post if there is something in the textfield
    if (textController.text.isNotEmpty){
      //store in firebase
      FirebaseFirestore.instance.collection('User Post').add({
        'User Email': currentUser.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: Text(
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
              icon: Icon(Icons.logout),
              color: Colors.white,
            ),
          ],
        ),
        body: Center(
          child: Column(
            children: [
              //the wall
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                  .collection("User Post")
                  .orderBy(
                    "TimeStamp", 
                    descending: false,
                  )
                  .snapshots(),
                  builder: (context, snapshot){
                    if(snapshot.hasData){
                      return ListView.builder(
                        itemBuilder: (context, index){
                        //get the message
                          final post = snapshot.data!.docs[index];
                          return WallPost(
                            message: post['Message'], 
                            user: post['User Email'], 
                          );
                        },
                      );
                    }else if(snapshot.hasError){
                      return Center(
                        child: Text('Error:${snapshot.error}'),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),


              //post message
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Row(
                  children: [
                    //textfield
                    Expanded(
                      child: MyTextField(
                        controller: textController,
                        hintText: 'Write Something on The Wall',
                        obscureText: false,
                      ),
                    ),
                
                    //post button
                    IconButton(
                      onPressed: postMessage, 
                      icon: const Icon(Icons.arrow_circle_up))
                  ],
                ),
              ),

              //logged in as
              Text("Logged in as " + currentUser.email!),
            ],
          ),
        ),
      ),
    );
  }
}