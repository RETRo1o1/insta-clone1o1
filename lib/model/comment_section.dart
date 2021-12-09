import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CommentSection extends StatefulWidget {
  final String commentID;
  CommentSection(this.commentID);


  @override
  _CommentSectionState createState() => _CommentSectionState(commentID);
}

class _CommentSectionState extends State<CommentSection> {
  final commentID;
  _CommentSectionState(this.commentID);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Text(
          "Comments",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22.5,
          ),
        )
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('feedData').doc(commentID).collection('comments').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.hasData){
            final List<DocumentSnapshot> comments = snapshot.data!.docs;
            return Column(
              children: comments.map((cmts) => Column(
                children: [
                  Divider(
                    thickness: 1,
                    color: Colors.white24,
                  ),
                  ListTile(
                    leading: cmts['profileImage'][0] != null ?
                    CircleAvatar(
                      radius: 18.8,
                      backgroundImage: NetworkImage(
                        cmts['profileImage'][0],
                      ),
                    ) :
                    CircleAvatar(
                      radius: 18.8,
                      backgroundColor: Colors.white24,
                    ),
                    title: Text(
                        cmts['displayName'][0],
                        style: TextStyle(
                          color: Colors.white,
                        )
                    ),
                    subtitle: Text(
                        cmts['comments'],
                        style: TextStyle(
                          color: Colors.white,
                        )
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        FontAwesomeIcons.ellipsisV,
                        color: Colors.white38,
                      ),
                      onPressed: () {},

                    ),
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.white24,
                  ),

                ],

              )).toList(),
            );
          } else {
            return Center(
              child: Text(
                "No Comments Yet",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36.6,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.bold,
                )
              ),
            );
          }
        }
      ),
    );
  }
}
