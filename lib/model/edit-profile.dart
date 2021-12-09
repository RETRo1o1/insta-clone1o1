import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';


class EditProfile extends StatefulWidget {
  // const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  File? _pickedImage;
  String? url;
  bool _isLoading = false;


  User? user = FirebaseAuth.instance.currentUser;
  String initialText = ' ';





  late String name = ' ';
  late String uname = ' ';
  late String pronouns = ' ';
  late String website = ' ';
  late String bio = ' ';

  Future _pickedImageProfile() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 1900,
      maxWidth: 1080,
    );
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
  }


  Future update() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();


    if(isValid){
      _formKey.currentState!.save();
      try {
        if(name == null || uname == null || pronouns == null || website == null || bio == null || _pickedImage == null){
          return "PUTA";
        } else  {
          final ref = FirebaseStorage.instance
              .ref()
              .child("usersimages")
              .child(name);
          await ref.putFile(_pickedImage!);
          url = await ref.getDownloadURL();

          FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .update({
            'name' : name,
            'displayName' : uname,
            'profileImage' : url,
            'pronouns' : pronouns,
            'website' : website,
            'bio' : bio,
          });
        }
      } catch (error) {
        print(error);
      }
    }
  }









  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Row(
            children: [
              Text("Edit Profile",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.2,
                    fontWeight: FontWeight.w500,
                  )),
              Padding(
                padding: EdgeInsets.only(left: 140.0),
                child: IconButton(
                    onPressed: update,
                    icon: Icon(
                      Icons.check,
                      size: 30,
                      color: Colors.blue,
                    )),
              )
            ],
          ),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user!.uid)
                .snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot){
              if(snapshot.hasData){
                var LoggedInUser = snapshot.data;
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Center(
                              child: this._pickedImage == null
                                  ? CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.white24,
                              )
                                  : CircleAvatar(
                                  radius: 60,
                                  child: Image.file(
                                    this._pickedImage!,
                                    fit: BoxFit.fill,
                                  )
                              )
                          )
                      ),
                      Padding(
                          padding: EdgeInsets.all(0.0),
                          child: ElevatedButton(
                              onPressed: _pickedImageProfile,
                              child: Text(
                                  "Change Profile Photo",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.8,
                                  )),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.black,
                                onPrimary: Colors.black,
                              )
                          )
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                              padding: EdgeInsets.all(10.0),
                              child:  Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    TextFormField(
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                        decoration: InputDecoration(
                                          labelText: "Name",
                                          labelStyle: TextStyle(
                                            color: Colors.white,
                                          ),
                                          hintText: LoggedInUser!['name'],
                                          hintStyle: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        onSaved: (value){
                                          name = value!;
                                        }
                                    ),
                                    TextFormField(
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                        decoration: InputDecoration(
                                          labelText: "Username",
                                          labelStyle: TextStyle(
                                            color: Colors.white,
                                          ),
                                          hintText: LoggedInUser['displayName'],
                                          hintStyle: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        onSaved: (value) {
                                          uname = value!;
                                        }
                                    ),
                                    LoggedInUser['pronouns'] != null ?
                                    TextFormField(
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: LoggedInUser['pronouns'],
                                          hintStyle: TextStyle(
                                            color: Colors.white,
                                          ),
                                          labelText: "Pronouns",
                                          labelStyle: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        onSaved: (value) {
                                          pronouns = value!;
                                        }
                                    ) :
                                    TextFormField(
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: "Pronouns",
                                        labelStyle: TextStyle(
                                          color: Colors.white,
                                        )
                                      ),
                                      onSaved: (value){
                                        pronouns = value!;
                                      }
                                    ),
                                    LoggedInUser['website'] != null ?
                                    TextFormField(
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: LoggedInUser['website'],
                                          hintStyle: TextStyle(
                                            color: Colors.white,
                                          ),
                                          labelText: "Website",
                                          labelStyle: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        onSaved: (value) {
                                          website = value!;
                                        }
                                    ) :
                                    TextFormField(
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: "Website",
                                        labelStyle: TextStyle(
                                          color: Colors.white,
                                        )
                                      ),
                                      onSaved: (value){
                                        website = value!;
                                      }
                                    ),
                                    LoggedInUser['bio'] != null ?
                                    TextFormField(
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: LoggedInUser['bio'],
                                          hintStyle: TextStyle(
                                            color: Colors.white,
                                          ),
                                          labelText: "Bio",
                                          labelStyle: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        onSaved: (value) {
                                          bio = value!;
                                        }
                                    ) :
                                        TextFormField(
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: "Bio",
                                            hintStyle: TextStyle(
                                              color: Colors.white,
                                            ),
                                            labelText: "Bio",
                                            labelStyle: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          onSaved: (value) {
                                            bio = value!;
                                          }
                                        )
                                  ],
                                ),
                              )
                          ),

                        ],
                      )
                    ],
                  )
                );


              } else {
                return Text("Cyka Blyat");
              }
            }
            )
    );
  }
}





