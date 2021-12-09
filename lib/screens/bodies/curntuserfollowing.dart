import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_clone/model/sec_user_screen.dart';
import 'package:insta_clone/screens/bottomnav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class currentUserFollowing extends StatefulWidget {
  @override
  _currentUserFollowingState createState() => _currentUserFollowingState();
}

class _currentUserFollowingState extends State<currentUserFollowing> {
  User? user = FirebaseAuth.instance.currentUser;


  @override
  Widget build(BuildContext context) {
    final curentUser = user!.uid;
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
            fontSize: 25.25,
            fontWeight: FontWeight.w700,
            fontFamily: "Yaldevi",
          )
        )
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(curentUser).collection('following').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasData){
            final List<DocumentSnapshot> following = snapshot.data!.docs;
            return ListView(
              children: following.map((folu) => ListTile(
                leading: folu['avatar'] != null ?
                    CircleAvatar(
                      radius: 25.25,
                      backgroundImage: NetworkImage(
                        folu['avatar'],
                      ),
                    ) :
                    CircleAvatar(
                      radius: 25.25,
                      backgroundColor: Colors.white24,
                    ),
                title: Text(
                  folu['following'],
                  style: TextStyle(
                    color: Colors.white,
                  )
                ),
                subtitle: Text(
                  folu['name'],
                  style: TextStyle(
                    color: Colors.white,
                  )
                ),
                trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.black,
                              onPrimary: Colors.black,
                              side: BorderSide(
                                width: 0.8,
                                color: Colors.white,
                              )
                          ),
                    onPressed: () {
                      final snackBar = SnackBar(
                        content: Text(''),
                        action: SnackBarAction(
                          label: 'Un-Follow',
                          onPressed: () async {
                            await FirebaseFirestore.instance.collection('users').doc(folu['followingId']).collection('Followers').doc(user!.uid).delete();
                            await FirebaseFirestore.instance.collection('users').doc(folu['followingId']).update({
                              'followers' : FieldValue.increment(-1),
                            });
                            await FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('following').doc(folu['followingId']).delete();
                            await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
                              'following' : FieldValue.increment(-1),
                            });
                          },
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                          child: Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                  "Following",
                                  style: TextStyle(
                                    color: Colors.white,
                                  )
                              )
                          )
                      ),
                onTap: () {
                  var docId = folu['followingId'];
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>
                        SecUser(docId)
                    ));
                },
              )).toList(),
            );

          }else {
            return Center(
              child: Text(
                "No Data Yet",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36.6,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                )
              )
            );
          }
        }
      )


    );
  }
}
