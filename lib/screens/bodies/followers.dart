import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_clone/model/sec_user_screen.dart';
import 'package:insta_clone/screens/bodies/profile.dart';
import 'package:insta_clone/screens/bottomnav.dart';
import 'package:firebase_auth/firebase_auth.dart';


class FollowersScreen extends StatefulWidget {
  final String followID;
  FollowersScreen(this.followID);

  @override
  _FollowersScreenState createState() => _FollowersScreenState(followID);
}

class _FollowersScreenState extends State<FollowersScreen> {
  final followID;
  _FollowersScreenState(this.followID);
  User? user = FirebaseAuth.instance.currentUser;
  bool isButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Text(
          "Followers",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.52,
            fontWeight: FontWeight.w700,
            fontFamily: 'Yaldevi',
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(followID).collection('Followers').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasData){
            final List<DocumentSnapshot> followers = snapshot.data!.docs;
            return ListView(
              children: followers.map((foll) => Column(
                children: [
                  if(foll['followerId'] == user!.uid) ... [
                    ListTile(
                      leading: foll['avatar'] != null ?
                      CircleAvatar(
                        radius: 25.25,
                        backgroundImage: NetworkImage(
                          foll['avatar'],
                        ),
                      ) :
                      CircleAvatar(
                        radius: 25.25,
                        backgroundColor: Colors.white24,
                      ),
                      title: Text(
                          foll['follower'],
                          style: TextStyle(
                            color: Colors.white,
                          )
                      ),
                      subtitle: Text(
                          foll['name'],
                          style: TextStyle(
                            color: Colors.white,
                          )
                      ),
                      onTap: () {
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>
                              ProfilePage()
                          ));
                      },
                    )
                  ] else ... [
                    Container(
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('following').doc(foll['followerId']).snapshots(),
                        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot){
                          if(!snapshot.data!.exists) {
                            return Column(
                              children: [
                                ListTile(
                                  leading: foll['avatar'] != null ?
                                  CircleAvatar(
                                    radius: 25.25,
                                    backgroundImage: NetworkImage(
                                      foll['avatar'],
                                    ),
                                  ) :
                                  CircleAvatar(
                                    radius: 25.25,
                                    backgroundColor: Colors.white,
                                  ),
                                  title: Text(
                                      foll['follower'],
                                      style: TextStyle(
                                        color: Colors.white,
                                      )
                                  ),
                                  subtitle: Text(
                                      foll['name'],
                                      style: TextStyle(
                                        color: Colors.white,
                                      )
                                  ),
                                  // trailing: ElevatedButton(
                                  //     onPressed: () {},
                                  //     child: Padding(
                                  //         padding: EdgeInsets.only(left: 10, right: 10),
                                  //         child: Text(
                                  //             "Follow",
                                  //             style: TextStyle(
                                  //               color: Colors.white,
                                  //             )
                                  //         )
                                  //     )
                                  // ),
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

                                        await FirebaseFirestore.instance.collection('users').doc(foll['followerId']).collection('Followers').doc(user!.uid).set({
                                          'avatar' : avatar,
                                          'follower' : uname,
                                          'followerId' : user!.uid,
                                          'name' : fname,
                                          'ownerId' : foll['followerId'],
                                        });
                                        await FirebaseFirestore.instance.collection('users').doc(foll['followerId']).update({
                                          'followers' : FieldValue.increment(1),
                                        });
                                        await FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('following').doc(foll['followerId']).set({
                                          'avatar' : foll['avatar'],
                                          'following' : foll['follower'],
                                          'followingId' : foll['followerId'],
                                          'name' : foll['name'],
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
                                                FollowersScreen(followID)
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
                                    var docId = foll['followerId'];
                                    Navigator.push(context,
                                      MaterialPageRoute(builder: (context) =>
                                          SecUser(docId)
                                      ));
                                  },
                                )
                              ],
                            );
                          } else {
                            var thisDoc = snapshot.data;
                            return Column(
                              children: [
                                ListTile(
                                  leading: CircleAvatar(
                                    radius: 25.25,
                                    backgroundImage: NetworkImage(
                                        foll['avatar']
                                    ),
                                  ),
                                  title: Text(
                                    foll['follower'],
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  subtitle: Text(
                                      foll['name'],
                                      style: TextStyle(
                                        color: Colors.white,
                                      )
                                  ),
                                  // trailing: ElevatedButton(
                                  //   style: ElevatedButton.styleFrom(
                                  //       primary: Colors.black,
                                  //       onPrimary: Colors.black,
                                  //       side: BorderSide(
                                  //         width: 0.8,
                                  //         color: Colors.white,
                                  //       )
                                  //   ),
                                  //   onPressed : () {},
                                  //   child: Padding(
                                  //     padding: EdgeInsets.only(left: 10, right: 10),
                                  //     child: Text(
                                  //         "Following",
                                  //         style: TextStyle(
                                  //           color: Colors.white,
                                  //         )
                                  //     ),
                                  //   ),
                                  // ),
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
                                              await FirebaseFirestore.instance.collection('users').doc(foll['followerId']).collection('Followers').doc(user!.uid).delete();
                                              await FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('following').doc(foll['followerId']).delete();
                                              await FirebaseFirestore.instance.collection('users').doc(foll['followerId']).update({
                                                'followers' : FieldValue.increment(-1),
                                              });
                                              await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
                                                'following' : FieldValue.increment(-1),
                                              });
                                              setState(() {
                                                isButtonPressed = !isButtonPressed;
                                                Navigator.push(context,
                                                    MaterialPageRoute(builder: (context) =>
                                                        FollowersScreen(followID)
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
                                    var docId = foll['followerId'];
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) =>
                                            SecUser(docId)
                                        ));
                                  },
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    )
                  ]
                ],
              )).toList(),
            );
          }else {
            return Center(
              child: Text(
                "No Follower Yet",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36.6,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                )
              ),
            );
          }
        }
      )
    );
  }
}












