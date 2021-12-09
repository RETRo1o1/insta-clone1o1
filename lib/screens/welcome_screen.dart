import 'package:flutter/material.dart';
import 'package:insta_clone/registration/bodies/signupbody.dart';
import 'package:insta_clone/registration/signup.dart';
import 'package:insta_clone/screens/bodies/mainbody.dart';

class WelcomeScreen extends StatelessWidget {
  // const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Column(
              children: [
                Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        width: 180,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                              "Platform",
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                fontFamily: 'Yaldevi',
                                fontSize: 22.22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              )
                          ),
                        ),
                      )
                  ),


                SizedBox(height: 15),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SignUpBody(),
                          ));
                      },
                  child: Padding(
                      padding: EdgeInsets.only(right: 70, left: 70, top: 10, bottom: 10),
                      child: Text(
                        "Create New Account",
                      )
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.black,
                      primary: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MainBody(),
                          ));
                      },
                    child: Text(
                        "Log In",
                        style: TextStyle(
                          color: Colors.blue.shade200,
                        )
                    )
                ),
              ],
            )
          ),
        ],
      ),
    );
  }
}
