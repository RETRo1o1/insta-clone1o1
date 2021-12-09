import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/registration/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:insta_clone/screens/feed_screen.dart';


class MainBody extends StatefulWidget {
  // const MainBody({Key? key}) : super(key: key);

  @override
  _MainBodyState createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  final _formKey = GlobalKey<FormState>();

  late String txtemail = ' ';
  late String txtpassword = ' ';


  final dbref = FirebaseDatabase.instance.reference().child('users');
  final _auth = FirebaseAuth.instance;


  void _signIn() async {
    try{

      final newUser = await _auth.signInWithEmailAndPassword(
          email: txtemail,
          password: txtpassword,
      );

      if(newUser != null) {
        final User user = _auth.currentUser!;
        final userID = user.uid;
        await FirebaseDatabase.instance
        .reference()
        .child("users")
        .child(userID)
        .once()
        .then((DataSnapshot snapshot){
          Navigator.push(context,
            MaterialPageRoute(
              builder: (context) =>
                  FeedScreen(),
            ));

        });
        print("Success Cyka blyat");
      }else {
        print("sucks");
      }

    } catch(error) {
      print(error);
    }
  }


  _signIN() async{
    try{
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: txtemail,
          password: txtpassword
      );

      if(userCredential != null){
        final User? user = _auth.currentUser;
        final userID = user!.uid;
        await FirebaseFirestore.instance.collection('users').get();
        Navigator.push(context,
          MaterialPageRoute(builder: (context) =>
              FeedScreen()
          ));
      }



    } on FirebaseAuthException catch (e) {
      if(e.code == 'user-not-found') {
        print('No user found for provided Credentials');
      } else if(e.code == 'wrong-password'){
        print('Wron password was provided for given field');
      }
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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 120.0),
                    child: Column(
                      children: [
                        Text(
                          "Welcome To Platform",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.20,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Yaldevi'
                          ),
                        ),
                        SizedBox(height: 30),
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
                                        labelText: "Enter email or username",
                                        labelStyle: TextStyle(
                                          color: Colors.grey,
                                        ),
                                        fillColor: Colors.black12,
                                        filled: true,
                                      ),
                                      onChanged: (value) {
                                        txtemail = value;
                                      },
                                      validator: validateEmail,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: TextFormField(
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: "Password",
                                        labelStyle: TextStyle(
                                          color: Colors.grey,
                                        ),
                                        fillColor: Colors.black12,
                                        filled: true,
                                      ),
                                      obscureText: true,
                                      onChanged: (value){
                                        txtpassword = value;
                                      },
                                      validator: validatePassword,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(left: 245),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.black,
                                              onPrimary: Colors.black,
                                            ),
                                            onPressed: () {},
                                            child: Text(
                                              "Forget password?",
                                              style: TextStyle(
                                                color: Colors.blue,
                                              )
                                            )
                                          )
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Padding(
                                    padding: EdgeInsets.all(20),
                                    child: ElevatedButton(
                                        onPressed: () {
                                          _signIN();

                                        },
                                        child: Padding(
                                            padding: EdgeInsets.only(left: 130, right: 130, top: 15, bottom: 15),
                                            child: Text("Log In"))
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.black,
                                        onPrimary: Colors.black,
                                      ),
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.facebook_outlined,
                                        color: Colors.blue,
                                      ),
                                      label: Text(
                                          "Log In With Facebook",
                                          style: TextStyle(
                                            color: Colors.blue,
                                          )
                                      )),
                                  SizedBox(height: 50),
                                  Center(
                                    child: Text(
                                      "OR",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Center(
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left:100.0),
                                            child: Text(
                                              "Don`t have an account?",
                                              style: TextStyle(
                                                color: Colors.white54,
                                              ),
                                            ),
                                          ),
                                          ElevatedButton(onPressed: () {
                                            Navigator.push(context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SignUp(),
                                            ));

                                          },
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.black,
                                                onPrimary: Colors.black,
                                              ),
                                              child: Text(
                                                  "Sign Up",
                                                  style: TextStyle(
                                                    color: Colors.blueAccent,
                                                  )
                                              )
                                          ),
                                        ],
                                      )
                                  ),
                                ]
                            ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox( height: 100),
                  Text(
                      "Platform from 1O1",
                      style: TextStyle(
                        color: Colors.white38,
                      )
                  )


                ]

            ),

        ),
      ),


    )
    );
  }




  String? validateEmail(String? email) {
    if(email!.isEmpty){
      return "Please Enter Your username or email";
    }
    return null;
  }

  String? validatePassword(String? passowrd) {
    if(txtpassword.isEmpty){
      return "Please Enter your Password";
    }
    return null;
  }



}








