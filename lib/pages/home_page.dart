import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tugasbesar/components/drawer.dart';
import 'package:tugasbesar/components/text_field.dart';
import 'package:tugasbesar/helper/helper_methods.dart';
import 'package:tugasbesar/pages/profile_page.dart';
import 'package:tugasbesar/pages/wall_post.dart';

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
      FirebaseFirestore.instance.collection("User Post").add({
        'UserEmail': currentUser.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
      });
    }

    //clear the textfield
    setState(() {
      textController.clear();
    });
  }

  //navigate to profile page
  void goToProfilePage(){
    //pop menu drawer
    Navigator.pop(context);

    //go to profile page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  }

  //navigate to home page
  void goToHomePage(){
    //pop menu drawer
    Navigator.pop(context);

    //go to profile page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: Text(
            'The Walls of FancyApp',
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          actions: [
            IconButton(
              onPressed: signOut, 
              icon: const Icon(Icons.logout),
            ),
          ],
          centerTitle: true, // Teks akan diatur di tengah
          // backgroundColor: Colors.white,
        ),
        drawer: MyDrawer(
          onHomeTap: goToHomePage,
          onProfileTap: goToProfilePage, 
          onSignOut: signOut, 
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
                    descending: true,
                  )
                  .snapshots(),
                  builder: (context, snapshot){
                    if (snapshot.hasData){
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index){
                          //get the message
                          final post = snapshot.data!.docs[index];
                          return WallPost(
                          message: post["Message"], 
                          user: post["UserEmail"], 
                          postId: post.id, 
                          likes: List<String>.from(post['Likes'] ?? []), 
                          time: formatDate(post["TimeStamp"]),
                          );
                        },
                      );
                    }else if (snapshot.hasError){
                      return Center(
                        child: Text('Error${snapshot.error}'),
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
                        hintText: 'Ketik sesuatu disini....',
                        obscureText: false,
                      ),
                    ),
                
                    //post button
                    IconButton(
                      onPressed: postMessage, 
                      icon: const Icon(Icons.arrow_circle_up),
                    )
                  ],
                ),
              ),

              //logged in as
              Text("Logged in as : ${currentUser.email!}",
              style: const TextStyle(color: Colors.grey),
              ),

              const SizedBox(
                height: 25,
              )
            ],
          ),
        ),
    );
  }
}