import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tugasbesar/components/like_button.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final List<String> likes;

  const WallPost({
    Key? key,
    required this.message,
    required this.user,
    required this.postId,
    required this.likes,
  }) : super(key: key);

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {

  //user
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  //toggle like
  void toggleLike(){
    setState(() {
      isLiked = !isLiked;
    });

    //access the document in firebase
    DocumentReference postRef = 
        FirebaseFirestore.instance.collection('User Post').doc(widget.postId);

    if(isLiked){
      //if the post is now liked, add the user's email to the 'Likes' field
      postRef.update({
        'Likes':FieldValue.arrayUnion([currentUser.email])
      });
    }else{
      //if the post is now unliked, remove the user's email from the 'Likes' field
      postRef.update({
        'Likes':FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.all(25),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Atur poros lintang menjadi start
        children: [
          Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Tombol suka
            LikeButton(
              isLiked: isLiked, 
              onTap: toggleLike,
            ),

            const SizedBox(height: 5,),
            
            // Like Count
            Text(
              widget.likes.length.toString(),
              style: TextStyle(color: Colors.grey),
            ),
            
          ],
        ),

          const SizedBox(width: 20), // Tambahkan jarak horizontal antara profil dan teks
          // Message and user email
          Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Atur poros lintang menjadi start
            children: [
              Text(
                widget.user,
                style: TextStyle(color: Colors.grey[500]),
              ),
              const SizedBox(height: 10),
              Text(widget.message),
            ],
          ),
        ],
      ),
    );
  }
}
