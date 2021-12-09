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








class TestFeed extends StatefulWidget {
  @override
  _TestFeedState createState() => _TestFeedState();
}

class _TestFeedState extends State<TestFeed> {
  final data = FirebaseFirestore.instance.collection('users');
  bool isHeart = false;
  TextEditingController _commentController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;












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
            builder:(context, AsyncSnapshot<QuerySnapshot> snapshot){
              if(snapshot.hasData){
                final List<DocumentSnapshot> document = snapshot.data!.docs;
                return ListView(
                  children: document.map((doc) => Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(
                        color: Colors.white24,
                      ),
                      ListTile(
                        leading: doc['profileImage'][0] == null ?
                        CircleAvatar(
                          radius: 16.6,
                          backgroundColor: Colors.white24,
                        ) :
                        CircleAvatar(
                          radius: 16.6,
                          backgroundImage: NetworkImage(
                            doc['profileImage'][0],
                          ),
                        ),
                        title: Text(
                            doc['displayName'][0],
                            style: TextStyle(
                              color: Colors.white,
                            )
                        ),
                        subtitle: doc['title'] != null ?
                        Text(
                            doc['title'],
                            style: TextStyle(
                              color: Colors.white,
                            )
                        ) :
                        Text(
                            "PUTA"
                        ),
                        trailing: IconButton(
                          onPressed: () {  },
                          icon: Icon(
                            FontAwesomeIcons.ellipsisV,
                            color: Colors.white38,
                          )
                        ),
                        onTap: () {
                          if(doc['userid'] == user!.uid) {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) =>
                                    ProfilePage(),
                                ));
                          }
                          else {
                            String docId = doc['userid'];
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context) =>
                                  SecUser(docId),
                              ));}
                          },
                  ),
                  Container(
                      height: 400,
                      width: 400,
                      decoration: doc['photoURL'] != null ?
                      BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              doc['photoURL'],
                            ),
                            fit: BoxFit.contain,
                          )
                      ) :
                      BoxDecoration(
                        color: Colors.white24,
                      )
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 0),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () async {
                            final Stroking = FirebaseFirestore.instance;
                            QuerySnapshot querySnapshot = await Stroking.collection('users')
                                .where('userid', isEqualTo: user!.uid).get();
                            final usernAME = querySnapshot.docs.map((doc) => doc.get('displayName')).toList();
                            final img = querySnapshot.docs.map((doc) => doc.get('profileImage')).toList();
                            final fname = querySnapshot.docs.map((doc) => doc.get('name')).toList();

                            isHeart == false ?
                                setState(() {
                                  isHeart = true;
                                  FirebaseFirestore.instance.collection('feedData').doc(doc.id).update({
                                    'likes' : FieldValue.increment(1),
                                  });
                                  FirebaseFirestore.instance.collection('feedData').doc(doc.id).collection('likes').add({
                                    'name' : usernAME[0] + ": likes your Post",
                                    'image' : img[0],
                                    'fname' : fname[0],
                                  });
                                }) :
                                setState(() {
                                  isHeart = false;
                                  FirebaseFirestore.instance.collection('feedData').doc(doc.id).update({
                                    'likes' : FieldValue.increment(-1),
                                  });

                                });
                            },
                          icon: Icon(
                            Icons.favorite,
                            size: 32.2,
                            color: isHeart == true ?
                                Colors.red : Colors.white,
                          )
                        ),
                        IconButton(
                            onPressed: () async {
                              var commentID = doc.id;
                              Navigator.push(context,
                              MaterialPageRoute(builder: (context) =>
                                  CommentSection(commentID),
                              ));
                              },
                            icon: Icon(
                              FontAwesomeIcons.commentAlt,
                              color: Colors.white,
                            )
                        ),
                      ],
                    ),
                  ),
                      Divider(
                        thickness: 0.8,
                        color: Colors.white24,
                      ),
                      if(doc['likes'] == 0) ...[
                        Text(""),

                      ] else ... [
                        Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Row(
                            children: [
                              Icon(
                                Icons.favorite,
                                size: 16.8,
                                color: Colors.white,
                              ),
                              Text( " " +
                                  doc['likes'].toString() + " Likes",
                                  style: TextStyle(
                                    color: Colors.white,

                                  )
                              )
                            ],
                          ),
                        )
                      ],
                      ListTile(
                          leading: Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text( "@" +
                                  doc['displayName'][0] + ":",
                                  style: TextStyle(
                                    color: Colors.white,
                                  )
                              )
                          ),
                          title: Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: doc['decsription'] != null ?
                              Text(
                                  doc['decsription'],
                                  style: TextStyle(
                                    color: Colors.white,
                                  )
                              ) :
                              Text(
                                  "Decsription",
                                  style: TextStyle(
                                    color: Colors.white,
                                  )
                              )
                          )
                      ),

                      ListTile(
                    title: TextField(
                      controller: _commentController,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: "Leave a comment",
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    trailing: IconButton(
                        onPressed: () async {
                          final _stroke =  FirebaseFirestore.instance;
                          QuerySnapshot querySnapshot = await _stroke.collection('users')
                              .where('userid', isEqualTo: user!.uid)
                              .get();
                          final Uname = querySnapshot.docs.map((doc) => doc.get('displayName')).toList();
                          final profile = querySnapshot.docs.map((doc) => doc.get('profileImage')).toList();
                          FirebaseFirestore.instance
                              .collection('feedData')
                              .doc(doc.id)
                              .collection('comments')
                              .add({
                            'comments' : _commentController.text,
                            'displayName' : Uname,
                            'profileImage' : profile,
                            'photoURL' : doc['photoURL'],
                          });
                        },
                        icon: Icon(
                          Icons.send,
                          color: Colors.white,
                        )
                    ),
                  )
                ],
              )).toList(),
            );
          }
          else{

            return CircularProgressIndicator();
          }
            }
            )
    );
  }
}
















