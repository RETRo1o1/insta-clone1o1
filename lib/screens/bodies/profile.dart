import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insta_clone/model/edit-profile.dart';
import 'package:insta_clone/screens/bodies/curntuserfollowing.dart';
import 'package:insta_clone/screens/bodies/currentuserfollowers.dart';
import 'package:insta_clone/screens/bodies/mainbody.dart';
import 'package:insta_clone/screens/bottomnav.dart';





class ProfilePage extends StatefulWidget {


  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;
  final ref = FirebaseFirestore.instance;

  getImg() async {
    final img = FirebaseFirestore.instance.collection('users');
    QuerySnapshot querySnapshot = await img.doc(user!.uid).collection('images').get();
    final photo = querySnapshot.docs.map((doc) => doc.get('photoURL')).toList();
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }







  @override
  Widget build(BuildContext context) {
    final CurrenttUser = user!.uid;

    // return Scaffold(
    //   backgroundColor: Colors.black,
    //   bottomNavigationBar: BottomNavigation(),
    //   body: StreamBuilder<QuerySnapshot>(
    //     stream: FirebaseFirestore.instance
    //         .collection('users')
    //         .where('userid', isEqualTo: user!.uid)
    //         .snapshots(),
    //     builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
    //       if(snapshot.hasData){
    //         final List<DocumentSnapshot> name = snapshot.data!.docs;
    //         return ListView(
    //           children: name.map((doc) => Column(
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               AppBar(
    //                 backgroundColor: Colors.black,
    //                 automaticallyImplyLeading: false,
    //                 title: Text(
    //                   doc['displayName'],
    //                   style: TextStyle(
    //                     color: Colors.white,
    //                     fontFamily: "Yaldevi",
    //                     fontSize: 18.8,
    //                     fontWeight: FontWeight.w500,
    //                   )
    //                 )
    //               ),
    //               Center(
    //                 child: Column(
    //                   children: [
    //                     doc['profileImage'] != null ?
    //                     CircleAvatar(
    //                       radius: 80,
    //                       backgroundImage: NetworkImage(
    //                         doc['profileImage'],
    //                       ),
    //                     ) :
    //                     CircleAvatar(
    //                       radius: 40.4,
    //                       backgroundColor: Colors.white24,
    //                     ),
    //                     SizedBox(height: 10),
    //                     Text(
    //                         doc['displayName'],
    //                             style: TextStyle(
    //                               color: Colors.white,
    //                             )
    //                     ),
    //                     doc['bio'] != null ?
    //                     Text(
    //                         doc['bio'],
    //                         style: TextStyle(
    //                           color: Colors.white,
    //                         )
    //                     ) :
    //                     Text(
    //                       "Bio",
    //                     ),
    //                   ],
    //                 )
    //
    //               ),
    //
    //
    //               SizedBox(height: 10),
    //               Center(
    //                 child: ElevatedButton(
    //                     onPressed: () {
    //                       Navigator.push(context,
    //                           MaterialPageRoute(builder: (context) =>
    //                               EditProfile(),
    //                           ));
    //                       },
    //                     child: Padding(
    //                       padding: EdgeInsets.only(left: 130, right: 130),
    //                       child: Text(
    //                           "Edit Profile",
    //                           style: TextStyle(
    //                             color: Colors.white,
    //                           )
    //                       ),
    //                     ),
    //                     style: ElevatedButton.styleFrom(
    //                         onPrimary: Colors.black,
    //                         primary: Colors.black,
    //                         side: BorderSide(
    //                           width: 1,
    //                           color: Colors.white24,
    //                         )
    //                     )
    //                 ),
    //               ),
    //               Divider(
    //                 color: Colors.white24,
    //                 thickness: 1,
    //               ),
    //               // StreamBuilder<QuerySnapshot>(
    //               //     stream: FirebaseFirestore.instance
    //               //         .collection('users')
    //               //         .doc(user!.uid)
    //               //         .collection('images')
    //               //         .snapshots(),
    //               //     builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
    //               //       if(snapshot.hasData){
    //               //         final List<DocumentSnapshot> images = snapshot.data!.docs;
    //               //         return Row(
    //               //           children: images.map((doc) => Container(
    //               //             child: Row(
    //               //               children: [
    //               //                 Row(
    //               //                   children: [
    //               //                     Container(
    //               //                       padding: EdgeInsets.all(1),
    //               //                       width: 2*width/6,
    //               //                       height: 2*width/8,
    //               //                       decoration: BoxDecoration(
    //               //                         image: DecorationImage(
    //               //                           image: NetworkImage(
    //               //                             doc['photoURL']
    //               //                           ),
    //               //                           fit: BoxFit.fitHeight
    //               //                         )
    //               //                       )
    //               //                     )
    //               //                   ],
    //               //                 )
    //               //               ],
    //               //             ),
    //               //           )).toList(),
    //               //         );
    //               //       }else {
    //               //         return CircularProgressIndicator();
    //               //       }
    //               //     })
    //             ],
    //           )).toList(),
    //         );
    //       } else {
    //         return CircularProgressIndicator();
    //       }
    //     }
    //   ),
    // );
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').doc(CurrenttUser).snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot){
        if(snapshot.hasData){
          var CurrentUser = snapshot.data;
          return Scaffold(
            backgroundColor: Colors.black,
            bottomNavigationBar: BottomNavigation(),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.black,
              title: Text(
                    CurrentUser!['displayName'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.2,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Yaldevi",
                    ),
                  ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: IconButton(
                      onPressed: () {
                        showDialog(context: context,
                            builder: (BuildContext context){
                          return Center(
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                height: 150,
                                width: 150,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        _signOut();
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) =>
                                                MainBody()
                                            ));
                                        },
                                      child: Text(
                                          "Sign Out",
                                          style: TextStyle(
                                            color: Colors.blue,
                                          )
                                      ),
                                    ),
                                    Divider(),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (context) =>
                                                  ProfilePage(),
                                              ));
                                          },
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(
                                              color: Colors.black
                                          ),
                                        )
                                    )
                                  ],
                                )
                            ),
                          );
                        });
                        },
                      icon: Icon(
                        Icons.clear_all,
                        color: Colors.white,
                        size: 32.32
                      )
                  ),
                )
              ],
            ),
            body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 11),
                    child: Row(
                      children: [
                        if(CurrentUser['profileImage'] != null)...[
                          CircleAvatar(
                            radius: 36.6,
                            backgroundImage: NetworkImage(
                              CurrentUser['profileImage'],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 40),
                            child: TextButton(
                              onPressed: () {  },
                              child: Text(
                                "     ${CurrentUser['posts']}" + "\n Posts",
                                  // CurrentUser['posts'].toString() + "\n Posts",
                                  style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.5,

                                )
                              )
                            )
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 0),
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(context,
                                  MaterialPageRoute(builder: (context) =>
                                      CurrentUserFollowers()
                                  ));
                              },
                              child: Text(
                                "        ${CurrentUser['followers']}" + "\n Followers",
                                  // CurrentUser['posts'].toString() + "\n Posts",
                                  style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.5,

                                )
                              )
                            )
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) =>
                                        currentUserFollowing()
                                    ));
                                },
                              child: Text(
                                "        ${CurrentUser['following']}" + "\n Following",
                                  // CurrentUser['posts'].toString() + "\n Posts",
                                  style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.5,

                                )
                              )
                            )
                          ),

                        ] else ... [
                          CircleAvatar(
                            radius: 36.6,
                            backgroundColor: Colors.white24,
                          )
                        ],
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text(
                      CurrentUser['displayName'],
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    subtitle: CurrentUser['bio'] != null ?
                        Text(
                          CurrentUser['bio'],
                          style: TextStyle(
                            color: Colors.white,
                          )
                        ) :
                        Text(
                          "Bio",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      onPrimary: Colors.black,
                      side: BorderSide(
                        color: Colors.white24,
                      )
                    ),
                    onPressed: () {
                      Navigator.push(context,
                      MaterialPageRoute(builder:(context) =>
                          EditProfile(),
                      ));
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 145, left: 145),
                      child: Text(
                        "Edit Profile",
                        style: TextStyle(
                          color: Colors.white,
                        )
                      )
                    )
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.white24,
                  ),
                  Container(
                      height: 380,
                      width: 380,
                      child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('images').snapshots(),
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
                          }
                      )
                  ),
                ],
              )




          );
        } else {
          return Center(
            child: Text(
              "No data to Show!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 50,
                fontWeight: FontWeight.bold,
              )
            )
          );
        }
      }
    );



  }



}





