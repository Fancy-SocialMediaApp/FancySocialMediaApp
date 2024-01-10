import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tugasbesar/components/comment.dart';
import 'package:tugasbesar/components/comment_button.dart';
import 'package:tugasbesar/components/like_button.dart';
import 'package:tugasbesar/helper/helper_methods.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String time;
  final String postId;
  final List<String> likes;

  const WallPost({
    Key? key,
    required this.message,
    required this.user,
    required this.time,
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

  //comment text controller
  final _commentTextController = TextEditingController();

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

  //add a comment
  void addComment (String commentText){
    //write the comment and store it to the firestore
    FirebaseFirestore.instance
    .collection("User Post")
    .doc(widget.postId)
    .collection("Comments")
    .add({
      "CommentText" : commentText,
      "CommentBy" : currentUser.email,
      "CommentTime" : Timestamp.now(), //remember to format this when displaying
    });
  }

  //show a dialog box for menambahkan comment
  void showCommentDialog(){
    showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Add Comment"),
      content: TextField(
        controller: _commentTextController,
        decoration: InputDecoration(hintText: "Write a comment here..."),
        
      ),
      actions: [
        //cancel button
            TextButton(
              onPressed: (){

                //pop box
                Navigator.pop(context);

                //clear controller
                _commentTextController.clear();
              }, 
              child: Text('Cancel', style: TextStyle(color: Colors.grey[900]),
              ),
            ),

          //post button
            TextButton(
              onPressed: () {

                //add comment
                addComment(_commentTextController.text);

                //pop box
                Navigator.pop(context);

                //clear controller
                _commentTextController.clear();
              },
              child: Text('Post', style: TextStyle(color: Colors.grey[900]),
              ),
            ),
      ],
    ),

   );
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Atur poros lintang menjadi start
        children: [
          
          const SizedBox(width: 20), // Tambahkan jarak horizontal antara profil dan teks
          // wall post
          Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Atur poros lintang menjadi start
            children: [
              
              //message
              Text(widget.message),

              const SizedBox(height: 5),

              //user
              Row(
              children: [
                Text(widget.user, style: TextStyle(color: Colors.grey[400]),),
                Text(" • ", style: TextStyle(color: Colors.grey[400]),),
                Text(widget.time, style: TextStyle(color: Colors.grey[400]),),
              ],  
            ),

              const SizedBox(height: 20),

            ],
          ),

          SizedBox(width: 20,),

          //buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              //LIKE
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

              const SizedBox(height: 10,),

              //COMMENT
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Tombol KOMENTAR
                  CommentButton(onTap: showCommentDialog),

                  const SizedBox(height: 5,),
                  
                  // COMMENT Count
                  Text(
                    '0',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
                
              ),
            ],
          ),

          const SizedBox(height: 20,),

          //comments under the post
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
            .collection("User Post")
            .doc(widget.postId)
            .collection("Comments")
            .orderBy("CommentTime", descending: true)
            .snapshots(),
            builder: (context, snapshot){
              //show loading circle
              if (!snapshot.hasData){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView(
                shrinkWrap: true, //for nested list
                physics: const NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((doc){
                  //get the comment
                  final commentData = doc.data() as Map<String, dynamic>;

                  //return the comment
                  return Comment(
                    text: commentData["CommentText"],
                    user: commentData["CommentBy"], 
                    time: formatDate(commentData["CommentTime"]),
                  );
                }).toList(),
              );
          },
        )

        ],
      ),
    );
  }
}
