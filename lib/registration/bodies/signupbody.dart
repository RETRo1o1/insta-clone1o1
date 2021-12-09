import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/screens/bodies/mainbody.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta_clone/screens/feed_screen.dart';


class SignUpBody extends StatefulWidget {
  // const SignUpBody({Key? key}) : super(key: key);

  @override
  _SignUpBodyState createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<SignUpBody> {
  final _formKey = GlobalKey<FormState>();
  final databaseReference = FirebaseDatabase.instance.reference().child("users");
  final _auth = FirebaseAuth.instance;


  late String txtemail = '';
  late String name = '';
  late String uname = '';
  late String txtpassword = '';
  late String role = '';
  late String decsription = '';
  late String photoURL = '';
  late String title = '';
  late String profileImage = '';
  late String bio = '';
  late String website = '';
  late String pronouns = '';
  late int posts = 0;
  late int followers = 0;
  late int following = 0;


  Future _saveData() async {
    try{
      final newUser = await _auth.createUserWithEmailAndPassword(
          email:  txtemail,
          password: txtpassword,
      );
      if(newUser != null) {
        final User user = _auth.currentUser!;
        final userID = user.uid;
        _addusers(userID);
      }


    } catch(error) {
      print(error);
    }
  }

  void _addusers(String ID) {
    final User? user = _auth.currentUser;
    final userID = user!.uid;
    try{
      FirebaseFirestore.instance.collection('users').doc(userID).set({
        'name' : name,
        'displayName' : uname,
        'email' : txtemail,
        'password' : txtpassword,
        'userid' : userID,
        'profileImage' : profileImage,
        'bio' : bio,
        'pronouns' : pronouns,
        'website' : website,
        'posts' : posts,
        'followers' : followers,
        'following' : following,

      });


      databaseReference.child(ID).set({
        'name' : name,
        'displayName' : uname,
        'email' : txtemail,
        'password' : txtpassword,
        'userid' : userID,
        'profileImage' : profileImage,
        'bio' : bio,
        'pronouns' : pronouns,
        'website' : website,
        'posts' : posts,
        'followers' : followers,
        'following' : following,
      });

    } catch (error){
      print (error);
    }




  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 65.0),
                  child: Text(
                    "Join Platform",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.22,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Yaldevi'
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: TextFormField(
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            labelText: "Full name",
                            labelStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            fillColor: Colors.black38,
                            filled: true,
                          ),
                          onSaved: (value){
                            name = value!;
                          },
                          validator: validateFname,
                        ),
                      ),
                      SizedBox(height: 10),


                      Padding(
                        padding: EdgeInsets.all(10.0),
                          child:TextFormField(
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              labelText: "Enter email",
                              labelStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              fillColor: Colors.black38,
                              filled: true,
                            ),
                            onSaved: (value) {
                              txtemail = value!;
                            },
                            validator: validateEmail,
                          ),
                      ),
                      SizedBox(height: 10),

                      Padding(
                          padding: EdgeInsets.all(10.0),
                          child: TextFormField(
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              labelText: "Username",
                              labelStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              fillColor: Colors.black38,
                              filled: true,
                            ),
                            onSaved: (value){
                              uname = value!;
                            },
                            validator: validateUname,

                          ),
                      ),
                      SizedBox(height: 10),

                      Padding(
                          padding: EdgeInsets.all(10.0),
                          child:TextFormField(
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              fillColor: Colors.black38,
                              filled: true,
                            ),
                            obscureText: true,
                            onSaved: (value) {
                              txtpassword = value!;
                            },
                            validator: validatePassword,
                          ),
                      ),
                      SizedBox(height: 10),

                      Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                              onPrimary: Colors.blue,
                            ),
                            onPressed: () {
                              if(_formKey.currentState!.validate()){
                                _formKey.currentState!.save();
                              }
                              _saveData();
                              // final User? user = FirebaseAuth.instance.currentUser;
                              // FirebaseFirestore.instance
                              // .collection('users')
                              // .doc(user!.uid)
                              // .collection('usersData')
                              //     .add({
                              //   'photoURL' : photoURL,
                              //   'title' : title,
                              //   'decsription' : decsription,
                              // });
                              Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (context) => FeedScreen(),
                              ));},
                            child: Padding(
                                padding: EdgeInsets.only(right: 150, left: 150),
                                child: Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      color: Colors.white,
                                    )
                                )
                            )
                        )
                      ),
                      SizedBox(height: 10),
                      Text(
                        "or",
                        style: TextStyle(
                          color: Colors.grey,
                        )
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                          onPrimary: Colors.black,
                        ),
                          onPressed: () {},
                          icon: Icon(
                            Icons.facebook,
                            color: Colors.blue,
                          ),
                          label: Text(
                              "Log in with facebook",
                            style: TextStyle(
                              color: Colors.white,
                            )
                          ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Padding(
                              padding: EdgeInsets.only(left: 100),
                              child: Text(
                                  "Already have an account ?",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w700,
                                  )
                              )
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.black,
                              onPrimary: Colors.black,
                            ),
                              onPressed: () {
                              Navigator.push(context,
                              MaterialPageRoute(
                                builder: (context) => MainBody(),
                              ));},
                              child: Text(
                                  "Log In",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w700,
                                  )
                              )
                          )],
                      )
                    ],
                  )
                )
            ],
          )

        )
      )
    );
  }


  String? validateEmail (String? email) {
    if(email!.isEmpty){
      return "Enter an Email";
    }
    return null;
  }

  String? validateFname (String? name) {
    if(name!.isEmpty){
      return "Please Enter Your Name";
    }
    return null;
  }

  String? validateUname (String? uname) {
    if(uname!.isEmpty){
      return "Please Enter an username";
    }
    return null;
  }

  String? validatePassword (String? password){
    if(password!.length < 8){
      return "Please Enter a passowrd which is 8 characters long";
    }
    return null;
  }

}
