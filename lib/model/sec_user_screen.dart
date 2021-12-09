import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_clone/screens/bodies/followers.dart';
import 'package:insta_clone/screens/bodies/following.dart';
import 'package:insta_clone/screens/bottomnav.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SecUser extends StatefulWidget {
  final String docId;
  SecUser(this.docId);


  @override
  _SecUserState createState() => _SecUserState(docId);
}

class _SecUserState extends State<SecUser> {
  final docId;
  _SecUserState(this.docId);

  User? user = FirebaseAuth.instance.currentUser;
  bool isButtonPressed = false;

  getCurrentUser() async {
    final dta = FirebaseFirestore.instance;
    DocumentSnapshot documentSnapshot = await dta.collection('users').doc(user!.uid).get();
    final username = documentSnapshot.get('displayName').toString();
    final docid = documentSnapshot.get('userid').toString();
    final profile = documentSnapshot.get('profileImage').toString();
    final fname = documentSnapshot.get('name').toString();

    DocumentSnapshot docsnap = await dta.collection('users').doc(docId).get();
    final docname = docsnap.get('displayName').toString();
    final docID = docsnap.get('userid').toString();
    final docprofile = docsnap.get('profileImage').toString();
    final docfname = docsnap.get('name').toString();

    await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
      'following' : FieldValue.increment(1),
    });

    await FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('following').doc(docId).set({
      'following' : docname,
      'ownerId' : user!.uid,
      'avatar' : docprofile,
      'name' : docfname,
      'followingId' : docId,

    });

    await FirebaseFirestore.instance.collection('users').doc(docId).collection('Followers').doc(user!.uid).set({
      'follower' : username,
      'ownerId' : docId,
      'avatar' : profile,
      'name' : fname,
      'followerId' : user!.uid,

    });
    await FirebaseFirestore.instance.collection('users').doc(docId).update({
      'followers' : FieldValue.increment(1),
    });
    print(docid);

  }

  unFollow () async {
    FirebaseFirestore.instance.collection('users').doc(docId).update({
      'followers' : FieldValue.increment(-1),
    });
    FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
      'following' : FieldValue.increment(-1),
    });

  }













  @override
  Widget build(BuildContext context) {

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(docId).snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot){
        if(!snapshot.hasData){
          return Center(
              child: Text("No Data Found", style: TextStyle(color: Colors.white, fontSize: 36.6))
          );
        } else {
          var thisUser = snapshot.data;
          return Scaffold(
              backgroundColor: Colors.black,
              bottomNavigationBar: BottomNavigation(),
              appBar: AppBar(
                  backgroundColor: Colors.black,
                  automaticallyImplyLeading: false,
                  title: Text(
                      thisUser!['displayName'],
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.8,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Yaldevi"
                      )

                  )
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: EdgeInsets.only(left: 10, top: 5),
                      child: Row(
                        children: [
                          thisUser['profileImage'] != null ?
                          CircleAvatar(
                            radius: 36.6,
                            backgroundImage: NetworkImage(
                              thisUser['profileImage'],
                            ),
                          ) :
                          CircleAvatar(
                            radius: 36.6,
                            backgroundColor: Colors.white24,
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 40),
                              child: TextButton(
                                  onPressed: () {  },
                                  child: Text(
                                      "     ${thisUser['posts']}" + "\n Posts",
                                      // CurrentUser['posts'].toString() + "\n Posts",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.5


                                      )
                                  )
                              )
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 3),
                              child: TextButton(
                                  onPressed: () {
                                    var followID = docId;
                                    Navigator.push(context,
                                      MaterialPageRoute(builder: (context) =>
                                          FollowersScreen(followID),
                                      ));
                                    },
                                  child: Text(
                                      "        ${thisUser['followers']}" + "\n Followers",
                                      // CurrentUser['posts'].toString() + "\n Posts",
                                      style: TextStyle(
                                        color: Colors.white,
                                          fontSize: 15.5


                                      )
                                  )
                              )
                          ),
                          Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: TextButton(
                                  onPressed: () {
                                    var followingID = docId;
                                    Navigator.push(context,
                                      MaterialPageRoute(builder: (context) =>
                                          FollowingScreen(followingID)
                                      ));
                                  },
                                  child: Text(
                                      "        ${thisUser['following']}" + "\n Following",
                                      // CurrentUser['posts'].toString() + "\n Posts",
                                      style: TextStyle(
                                        color: Colors.white,
                                          fontSize: 15.5

                                      )
                                  )
                              )
                          ),
                        ],
                      )
                  ),
                  ListTile(
                    title: Text(
                      thisUser['displayName'],
                      style: TextStyle(
                        color: Colors.white,
                      )
                    ),
                    subtitle: Text(
                      thisUser['bio'],
                      style: TextStyle(
                        color: Colors.white,
                      )
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if(thisUser['followers'] != 0) ... [
                          Padding(
                            padding: EdgeInsets.only(left: 0),
                            child:  StreamBuilder(
                                stream: FirebaseFirestore.instance.collection('users').doc(docId).collection('Followers').doc(user!.uid).snapshots(),
                                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if(!snapshot.hasData || !snapshot.data!.exists) {
                                   return  Row(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            isButtonPressed == false ?
                                            getCurrentUser() :
                                            unFollow();
                                            setState(() {
                                              isButtonPressed = !isButtonPressed;
                                            });
                                            setState(() {});
                                          },
                                          onLongPress: () {
                                            setState(() {
                                              isButtonPressed = false;
                                            });
                                            final snackBar = SnackBar(
                                              content: Text(''),
                                              action: SnackBarAction(
                                                label: 'Un-Follow',
                                                onPressed: () {
                                                  FirebaseFirestore.instance.collection('users').doc(docId).update({
                                                    'followers' : FieldValue.increment(-1),
                                                  });
                                                  FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
                                                    'following' : FieldValue.increment(-1),
                                                  });
                                                },
                                              ),
                                            );
                                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                          },
                                          style: isButtonPressed == true ? ElevatedButton.styleFrom(
                                            onPrimary: Colors.white24,
                                            primary: Colors.white24,
                                          ) :
                                          ElevatedButton.styleFrom(
                                            primary: Colors.blue,
                                            onPrimary: Colors.blue,
                                          ),
                                          child: Padding(
                                              padding: isButtonPressed == true ? EdgeInsets.only(left: 45 ,  right:45 ) : EdgeInsets.only(left: 55 ,  right:55 ),
                                              child: isButtonPressed == true ? Text(
                                                  "Following",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  )
                                              ) :
                                              Text(
                                                  "Follow",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  )
                                              )
                                          ),
                                        ),
                                      ],
                                    );
                                  }else {
                                    var following = snapshot.data;
                                    isButtonPressed = true;
                                    return Row(
                                      children: [
                                        if(following!['followerId'] == user!.uid)... [
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: isButtonPressed == true ? Colors.white24 : Colors.blue ,
                                                onPrimary: isButtonPressed == true ?  Colors.white24 : Colors.blue ,
                                              ),
                                              onPressed: () {
                                                final snackBar = SnackBar(
                                                  content: Text(''),
                                                  action: SnackBarAction(
                                                    label: 'Un-Follow',
                                                    onPressed: () async {
                                                      await FirebaseFirestore.instance.collection('users').doc(docId).collection('Followers').doc(user!.uid).delete();
                                                      await FirebaseFirestore.instance.collection('users').doc(docId).update({
                                                        'followers' : FieldValue.increment(-1),
                                                      });
                                                      await FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('following').doc(docId).delete();
                                                      await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
                                                        'following' : FieldValue.increment(-1),
                                                      });
                                                      setState(() {
                                                        isButtonPressed = false;
                                                      });


                                                    },
                                                  ),
                                                );
                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                              },
                                              child: Padding(
                                                  padding: isButtonPressed == true ? EdgeInsets.only(left: 45, right: 45) : EdgeInsets.only(left: 50, right: 50),
                                                  child: Text(
                                                    isButtonPressed == true ?
                                                      "Following" : "Follow",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      )
                                                  )
                                              )
                                          )
                                        ] else ... [
                                          ElevatedButton(
                                            onPressed: () {
                                              isButtonPressed == false ?
                                              getCurrentUser() :
                                              unFollow();
                                              setState(() {
                                                isButtonPressed = !isButtonPressed;
                                              });
                                              setState(() {});
                                            },
                                            onLongPress: () {
                                              setState(() {
                                                isButtonPressed = false;
                                              });
                                              final snackBar = SnackBar(
                                                content: Text(''),
                                                action: SnackBarAction(
                                                  label: 'Un-Follow',
                                                  onPressed: () {
                                                    FirebaseFirestore.instance.collection('users').doc(docId).update({
                                                      'followers' : FieldValue.increment(-1),
                                                    });
                                                    FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
                                                      'following' : FieldValue.increment(-1),
                                                    });
                                                  },
                                                ),
                                              );
                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                            },
                                            style: isButtonPressed == true ? ElevatedButton.styleFrom(
                                              onPrimary: Colors.white24,
                                              primary: Colors.white24,
                                            ) :
                                            ElevatedButton.styleFrom(
                                              primary: Colors.blue,
                                              onPrimary: Colors.blue,
                                            ),
                                            child: Padding(
                                                padding: isButtonPressed == true ? EdgeInsets.only(left: 45 ,  right:45 ) : EdgeInsets.only(left: 55 ,  right:55 ),
                                                child: isButtonPressed == true ? Text(
                                                    "Following",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    )
                                                ) :
                                                Text(
                                                    "Follow",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    )
                                                )
                                            ),
                                          ),
                                        ]
                                      ],
                                    );
                                  }
                                }
                            ),
                          ),
                        ] else if(thisUser['followers'] == 0) ...[
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  isButtonPressed == false ?
                                  getCurrentUser() :
                                  unFollow();
                                  setState(() {
                                    isButtonPressed = !isButtonPressed;
                                  });
                                  setState(() {});
                                },
                                onLongPress: () {
                                  setState(() {
                                    isButtonPressed = false;
                                  });
                                  final snackBar = SnackBar(
                                    content: Text(''),
                                    action: SnackBarAction(
                                      label: 'Un-Follow',
                                      onPressed: () {
                                        FirebaseFirestore.instance.collection('users').doc(docId).update({
                                          'followers' : FieldValue.increment(-1),
                                        });
                                        FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
                                          'following' : FieldValue.increment(-1),
                                        });
                                      },
                                    ),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                },
                                style: isButtonPressed == true ? ElevatedButton.styleFrom(
                                  onPrimary: Colors.white24,
                                  primary: Colors.white24,
                                ) :
                                ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                  onPrimary: Colors.blue,
                                ),
                                child: Padding(
                                    padding: isButtonPressed == true ? EdgeInsets.only(left: 45 ,  right:45 ) : EdgeInsets.only(left: 55 ,  right:55 ),
                                    child: isButtonPressed == true ? Text(
                                        "Following",
                                        style: TextStyle(
                                          color: Colors.white,
                                        )
                                    ) :
                                    Text(
                                        "Follow",
                                        style: TextStyle(
                                          color: Colors.white,
                                        )
                                    )
                                ),
                              ),
                            ],
                          ),

                        ],


                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white24,
                              onPrimary: Colors.black,
                            ),
                            onPressed: (){},
                            child: Padding(
                              padding: EdgeInsets.only(left: 55, right: 55),
                              child: Text(
                                "Message",
                                style: TextStyle(
                                  color: Colors.white,
                                )
                              )
                            )),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.white24,
                  ),
                  Container(
                   height: 380,
                   width: 380,
                   child: StreamBuilder<QuerySnapshot>(
                       stream: FirebaseFirestore.instance.collection('users').doc(docId).collection('images').snapshots(),
                       builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                         if(snapshot.hasData){
                           final List<DocumentSnapshot> images = snapshot.data!.docs;
                           return GridView.count(
                             childAspectRatio: 1.1,
                             mainAxisSpacing: 8.8,
                             crossAxisSpacing: 2.9,
                             crossAxisCount: 3,
                             children: List.generate(snapshot.data!.docs.length, (index) {
                               return Container(
                                   decoration: BoxDecoration(
                                     image: DecorationImage(
                                       image: NetworkImage(
                                         snapshot.data!.docs[index]['photoURL'],
                                       ),
                                       fit: BoxFit.fitHeight,
                                     ),
                                   )
                               );
                             }),
                           );
                         } else {
                           return CircularProgressIndicator();
                         }
                       })
                  ),
                ],
              )
          );
        }
      }
    );
  }
}
