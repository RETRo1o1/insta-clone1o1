import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta_clone/model/sec_user_screen.dart';
import 'package:insta_clone/screens/bodies/profile.dart';
import 'package:insta_clone/screens/bottomnav.dart';

class FollowingScreen extends StatefulWidget {
  final String followingID;
  FollowingScreen(this.followingID);

  @override
  _FollowingScreenState createState() => _FollowingScreenState(followingID);
}

class _FollowingScreenState extends State<FollowingScreen> {
  final followingID;
  _FollowingScreenState(this.followingID);

  User? user = FirebaseAuth.instance.currentUser;
  bool isButtonPressed = false;
  void _refresh() {
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
    var currentUser = user!.uid;

    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomNavigation(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Text(
          "Following",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 22.52,
            fontFamily: "Yaldevi",
          )
        )
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(followingID).collection('following').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData){
            return Center(
              child: Text(
                "No Data yet",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36.36,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                )
              ),
            );
          } else {
            final List<DocumentSnapshot> following = snapshot.data!.docs;
            return ListView(
              children: following.map((doc) => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(doc['followingId'] == user!.uid)... [
                    ListTile(
                      leading: doc['avatar'] != null ?
                          CircleAvatar(
                            radius: 25.25,
                            backgroundImage: NetworkImage(
                              doc['avatar'],
                            ),
                          ) :
                          CircleAvatar(
                            radius: 25.25,
                            backgroundColor: Colors.white,
                          ),
                      title: Text(
                        doc['following'],
                        style: TextStyle(
                          color: Colors.white,
                        )
                      ),
                      subtitle: Text(
                        doc['name'],
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>
                              ProfilePage()
                          ));
                      },
                    )
                  ] else ...[
                    Container(
                      child: StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('following').doc(doc['followingId']).snapshots(),
                        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if(snapshot.data!.exists != true){
                            return Column(
                              children: [
                                ListTile(
                                  leading: doc['avatar'] != null ?
                                      CircleAvatar(
                                        radius: 25.25,
                                        backgroundImage: NetworkImage(
                                          doc['avatar'],
                                        ),
                                      ) :
                                  CircleAvatar(
                                        radius: 25.25,
                                        backgroundColor: Colors.white24,
                                      ),
                                  title: Text(
                                    doc['following'],
                                    style: TextStyle(
                                      color: Colors.white,
                                    )
                                  ),
                                  subtitle: Text(
                                    doc['name'],
                                    style: TextStyle(
                                      color: Colors.white,
                                    )
                                  ),
                                  trailing: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: isButtonPressed ? Colors.black : Colors.blue,
                                      onPrimary: isButtonPressed ? Colors.black : Colors.blue,
                                      side: isButtonPressed ? BorderSide(
                                        color: Colors.white,
                                        width: 0.8
                                      ) : BorderSide(
                                        color: Colors.blue,
                                      )
                                    ),
                                    onPressed: ()  async{
                                      final database = FirebaseFirestore.instance;
                                      DocumentSnapshot documentSnapshot = await database.collection('users').doc(user!.uid).get();
                                      final avatar = documentSnapshot.get('profileImage').toString();
                                      final uname = documentSnapshot.get('displayName').toString();
                                      final fname = documentSnapshot.get('name').toString();
                                      final followingID = documentSnapshot.get('userid').toString();
                                      await FirebaseFirestore.instance.collection('users').doc(doc['followingId']).collection('Followers').doc(user!.uid).set({
                                        'avatar' : avatar,
                                        'follower' : uname,
                                        'followerId' : followingID,
                                        'name' : fname,
                                        'ownerId' : doc['followingId'],
                                      });
                                      await FirebaseFirestore.instance.collection('users').doc(doc['followingId']).update({
                                        'followers' : FieldValue.increment(1),
                                      });
                                      await FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('following').doc(doc['followingId']).set({
                                        'avatar' : doc['avatar'],
                                        'following' : doc['following'],
                                        'followingId' : doc['followingId'],
                                        'name' : doc['name'],
                                        'ownerId' : user!.uid,
                                      });
                                      await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
                                        'following' : FieldValue.increment(1),
                                      });
                                      setState(() {
                                        isButtonPressed = !isButtonPressed;
                                      });
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) =>
                                              FollowingScreen(followingID)
                                          ));

                                      },
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 10, right: 10),
                                      child: Text(
                                        isButtonPressed ?
                                        "Following" : "Follow",
                                        style: TextStyle(
                                          color: Colors.white,
                                        )
                                      )
                                    )
                                  ),
                                  onTap: () {
                                    var docId = doc['followingId'];
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) =>
                                            SecUser(docId)
                                        ));
                                  },
                                )
                              ],
                            );
                          } else if(snapshot.data!.exists) {
                            var thisUser = snapshot.data;
                            return Column(
                              children: [
                                ListTile(
                                  leading: doc['avatar'] != null ?
                                  CircleAvatar(
                                    radius: 25.25,
                                    backgroundImage: NetworkImage(
                                      doc['avatar'],
                                    ),
                                  ) :
                                  CircleAvatar(
                                    radius: 25.25,
                                    backgroundColor: Colors.white24,
                                  ),
                                  title: Text(
                                      doc['following'],
                                      style: TextStyle(
                                        color: Colors.white,
                                      )
                                  ),
                                  subtitle: Text(
                                      doc['name'],
                                      style: TextStyle(
                                        color: Colors.white,
                                      )
                                  ),
                                  trailing: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: isButtonPressed ? Colors.blue : Colors.black,
                                          onPrimary: isButtonPressed ? Colors.blue : Colors.black,
                                          side: isButtonPressed ?  BorderSide(
                                            color: Colors.blue,
                                          ) : BorderSide(
                                            color: Colors.white,
                                            width: 0.8,
                                          )
                                      ),
                                      onPressed: () {
                                        final snackBar = SnackBar(
                                          content: Text(""),
                                          action: SnackBarAction(
                                            label: "Un-Follow",
                                            onPressed: () async {
                                              await FirebaseFirestore.instance.collection('users').doc(doc['followingId']).collection('Followers').doc(user!.uid).delete();
                                              await FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('following').doc(doc['followingId']).delete();
                                              await FirebaseFirestore.instance.collection('users').doc(doc['followingId']).update({
                                                'followers' : FieldValue.increment(-1),
                                              });
                                              await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
                                                'following' : FieldValue.increment(-1),
                                              });
                                              setState(() {
                                                isButtonPressed = !isButtonPressed;
                                                Navigator.push(context,
                                                  MaterialPageRoute(builder: (context) =>
                                                      FollowingScreen(followingID)
                                                  ));
                                              });

                                            },
                                          ),
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        },
                                      child: Padding(
                                          padding: EdgeInsets.only(left: 10, right: 10),
                                          child: Text(
                                            isButtonPressed ?
                                              "Follow" : "Following",
                                              style: TextStyle(
                                                color: Colors.white,
                                              )
                                          )
                                      )
                                  ),
                                  onTap: () {
                                    var docId = doc['followingId'];
                                    Navigator.push(context,
                                      MaterialPageRoute(builder: (context) =>
                                          SecUser(docId)
                                      ));
                                  },
                                )
                              ],
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        }
                        )
                    )
                  ]
                ],
              )).toList(),
            );
          }
        }
      )
    );
  }
}
