import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta_clone/model/sec_user_screen.dart';
import 'package:insta_clone/screens/bottomnav.dart';

class CurrentUserFollowers extends StatefulWidget {


  @override
  _CurrentUserFollowersState createState() => _CurrentUserFollowersState();
}

class _CurrentUserFollowersState extends State<CurrentUserFollowers> {
  User? user = FirebaseAuth.instance.currentUser;




  @override
  Widget build(BuildContext context) {
    final currentUser = user!.uid;
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomNavigation(),
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          title: Text(
              "Followers",
              style: TextStyle(
                color: Colors.white,
                fontSize: 25.25,
                fontWeight: FontWeight.w800,
                fontFamily: "Yaldevi",
              )
          )
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').doc(currentUser).collection('Followers').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.hasData){
              final List<DocumentSnapshot> followers = snapshot.data!.docs;
              return ListView(
                children: followers.map((folowers) => ListTile(
                  leading: folowers['avatar'] != null ?
                  CircleAvatar(
                    radius: 25.25,
                    backgroundImage: NetworkImage(
                      folowers['avatar'],
                    ),
                  ) :
                  CircleAvatar(
                    radius: 25.25,
                    backgroundColor: Colors.white24,
                  ),
                  title: Text(
                      folowers['follower'],
                      style: TextStyle(
                        color: Colors.white,
                      )
                  ),
                  subtitle: Text(
                      folowers['name'],
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
                    onPressed: () async {
                      await FirebaseFirestore.instance.collection('users').doc(folowers['followerId']).collection('following').doc(user!.uid).delete();
                      await FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('Followers').doc(folowers['followerId']).delete();
                      await FirebaseFirestore.instance.collection('users').doc(folowers['followerId']).update({
                        'following' : FieldValue.increment(-1),
                      });
                      await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
                        'followers' : FieldValue.increment(-1),
                      });
                      },
                    child: Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                            "Remove",
                            style: TextStyle(
                              color: Colors.white,
                            )
                        )
                    ),
                  ),
                  onTap: () {
                    var docId = folowers['followerId'];
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
                      "No Followers yet",
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
          ),
    );
  }
}
