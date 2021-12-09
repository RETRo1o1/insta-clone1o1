import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/model/comment_section.dart';
import 'package:insta_clone/model/sec_user_screen.dart';
import 'package:insta_clone/screens/bodies/profile.dart';
import 'package:insta_clone/screens/bottomnav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insta_clone/screens/bodies/profile.dart';










class FeedScreen extends StatefulWidget {



  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {


  final data = FirebaseFirestore.instance.collection('users');



  TextEditingController _commentController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  User? user = FirebaseAuth.instance.currentUser;

  Color _heart = Colors.white;













  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomNavigation(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Text(
          "Platform",
          style: TextStyle(
            color: Colors.white,
            fontSize: 32.6,
            fontWeight: FontWeight.bold,
            fontFamily: "Yaldevi",
          )
        )
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('feedData').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot2){
          if(!snapshot2.hasData) {
            return CircularProgressIndicator();
          } else {
            final List<DocumentSnapshot> doc = snapshot2.data!.docs;
            return ListView(
              children: doc.map((docs) => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('following').doc(docs['userid']).snapshots(),
                        builder:(context, AsyncSnapshot<DocumentSnapshot> snapshot1){
                          if(!snapshot1.data!.exists){
                            return Center(
                              child: Text(
                                  "No Following No Data",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 36.36,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none,
                                  )
                              ),
                            );
                          } else {
                            var users = snapshot1.data;
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                if(docs['userid'] == users!['followingId']  || docs['userid'] == user!.uid) ... [
                                  ListTile(
                                    leading: docs['profileImage'][0] != null ?
                                    CircleAvatar(
                                      radius: 16.16,
                                      backgroundImage: NetworkImage(
                                        docs['profileImage'][0],
                                      ),
                                    ) : CircleAvatar(
                                      radius: 16.16,
                                      backgroundColor: Colors.white24,
                                    ),
                                    title: docs['displayName'][0] != null ?
                                    Text(
                                        docs['displayName'][0],
                                        style: TextStyle(
                                          color: Colors.white,
                                        )
                                    ): Text(
                                        "@username",
                                        style: TextStyle(
                                          color: Colors.white,
                                        )
                                    ),
                                    subtitle: docs['title'] != null ?
                                    Text(
                                        docs['title'],
                                        style: TextStyle(
                                          color: Colors.white,
                                        )
                                    ) : Text(
                                        ""
                                    ),
                                    onTap: () {
                                      if(users['userid'] == user!.uid){
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                              builder:(context) =>
                                                  ProfilePage(),
                                            ));
                                      } else {
                                        var docId = users['userid'];
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) =>
                                                SecUser(docId)
                                            ));
                                      }
                                    },
                                  )
                                ]

                              ],
                            );

                          }
                        }
                    ),
                  )
                ],
              )).toList(),


            );
          }
        }
      )

    );
  }
}
















