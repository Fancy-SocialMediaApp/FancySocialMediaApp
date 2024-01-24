import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tugasbesar/components/drawer.dart';
import 'package:tugasbesar/components/text_box.dart';
import 'package:tugasbesar/pages/home_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  //sign user out
  void signOut(){
    FirebaseAuth.instance.signOut();
  }

  //navigate to profile page
  void goToProfilePage(){
    //pop menu drawer
    Navigator.pop(context);
  }

  //navigate to home page
    void goToHomePage(){
      //pop menu drawer
      Navigator.pop(context);

      //go to Home page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    }

  //user
  final currentUser = FirebaseAuth.instance.currentUser!;

  //alluser
  final usersCollection = FirebaseFirestore.instance.collection("Users");

  //edit field
  Future<void> editField(String field) async{
    String newValue = "";

    await showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text("Edit $field",
        style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Enter new $field",
            hintStyle: const TextStyle(color: Colors.grey),
          ),
          onChanged: (value){
            newValue = value;
          },

        ),
        actions: [
          //cancel  button
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context), 
            ),
          //save button
            TextButton(
              child: const Text('Save', style: TextStyle(color: Colors.white),
              ),
              onPressed: () => Navigator.of(context).pop(newValue), 
            ),
        ],
      ),
    );

    //update in firestore
    if (newValue.trim().isNotEmpty){
      //only update if there is something in the textfield
      await usersCollection.doc(currentUser.email).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile Page",
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   color: Colors.black, // Adjust the color as needed
        //   onPressed: signOut,
        // ),
      ),
      drawer: MyDrawer(
          onHomeTap: goToHomePage,
          onProfileTap: goToProfilePage,
          onSignOut: signOut,
        ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection("Users").doc(currentUser.email).snapshots(),
        builder: (context, snapshot){
            //get user data 
            if (snapshot.hasData){
              final userData = snapshot.data!.data() as Map <String, dynamic>;

            return ListView(
              children: [
                const SizedBox(height: 50,),
                //profile pic
                const Icon(
                  Icons.person,
                  size: 72,
                ),

                const SizedBox(height: 10,),

                //user email
                Text(
                  currentUser.email!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700]),
                ),

                const SizedBox(height: 50,),

                //user details
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    'My Detail',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),

                //username
                MyTextBox(
                  text: userData['username'], 
                  sectionName: 'username',
                  onPressed: () => editField ('username'),
                ),

                //bio
                MyTextBox(
                  text: userData['bio'], 
                  sectionName: 'bio',
                  onPressed: () => editField ('bio'),
                ),

                const SizedBox(height: 50,),

                //user post
                // Padding(
                //   padding: const EdgeInsets.only(left: 25.0),
                //   child: Text(
                //     'My Post',
                //     style: TextStyle(color: Colors.grey[600]
                //     ),
                //   ),
                // ),

              ],
            );
          }else if (snapshot.hasError) {
            return Center(
              child: Text ('Error${snapshot.error}'),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
