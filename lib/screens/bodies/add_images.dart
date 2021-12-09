import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/screens/bottomnav.dart';
import 'package:insta_clone/screens/feed_screen.dart';
import 'package:uuid/uuid.dart';
import 'package:photofilters/photofilters.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:image/image.dart' as imageLib;



class CreatePost extends StatefulWidget {
  const CreatePost({Key? key}) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  List<Filter> filters = presetFiltersList;




  final _formKey = GlobalKey<FormState>();
  File? _pickedImage;
  bool _isLoading = false;
  String? url;
  var uui = Uuid();


  final FirebaseAuth _auth = FirebaseAuth.instance;
  final User? user = FirebaseAuth.instance.currentUser;




  var _title = ' ';
  var _desc =  ' ';









  Future _pickedImagegallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 8000,
      maxWidth: 8000,
    );
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
  }


  Future _pickedImageCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 19200,
      maxHeight: 1080,
    );
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
  }


  Future _sendData() async {
    final isValid = _formKey.currentState!.validate();
    try{
      if(isValid){
        _formKey.currentState!.save();
        print(_title);
        print(_desc);
      }
      if(isValid){
        _formKey.currentState!.save();
        try{
          if(_pickedImage == null) {
            return null;
          }else{
            setState(() {
              _isLoading = true;
            });
            final ref = FirebaseStorage.instance
                .ref()
                .child("usersimages")
                .child(_title);
            await ref.putFile(_pickedImage!);
            url = await ref.getDownloadURL();


            User user = FirebaseAuth.instance.currentUser!;
            String? username = user.uid;

            final _firestore = FirebaseFirestore.instance;
            QuerySnapshot querySnapshot = await _firestore.collection('users').where('userid', isEqualTo: user.uid).get();
            final avatar = querySnapshot.docs.map((doc) => doc.get('profileImage')).toList();
            final name = querySnapshot.docs.map((doc) => doc.get('displayName')).toList();
            int likes = 0;


            await FirebaseFirestore.instance
                .collection('feedData')
                .add({
              'photoURL' : url ,
              'title' : _title ,
              'decsription' : _desc ,
              'userid' : username,
              'displayName' : name,
              'profileImage' : avatar,
              'likes' : likes,
            });
          }
        }catch(error){
          print(error);
        }
      }
    }catch (error){
      print(error);
    }

  }























  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigation(),
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          title: Text(
            "New Post",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.22,
              fontWeight: FontWeight.w700,
            ),
          ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: TextButton(
              onPressed: () async {
                _sendData();
                try {
                  await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
                    'posts' : FieldValue.increment(1)
                  });
                  final isValid = _formKey.currentState!.validate();
                  if(_pickedImage == null) {
                    return null;
                  }else{
                    setState(() {
                      _isLoading = true;
                    });
                    final ref = FirebaseStorage.instance
                        .ref()
                        .child("usersimages")
                        .child(_title);
                    await ref.putFile(_pickedImage!);
                    url = await ref.getDownloadURL();


                    final _firestore = FirebaseFirestore.instance;
                    QuerySnapshot querySnapshot = await _firestore.collection('users').where('userid', isEqualTo: user!.uid).get();
                    final avatar = querySnapshot.docs.map((doc) => doc.get('profileImage')).toList();
                    final name = querySnapshot.docs.map((doc) => doc.get('displayName')).toList();
                    int likes = 0;

                    await FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('images').add({
                      'photoURL' : url,
                      'profileImage' : avatar,
                      'displayName' : name,
                      'userid' : user!.uid,
                      'title': _title,
                      'decsription' : _desc,
                    });
                  }
                } catch (error) {
                  print(error);
                }

                Navigator.push(context,
                  MaterialPageRoute(builder: (context) =>
                      FeedScreen()
                  ));
              },
              child: Text(
                "Upload",
                style: TextStyle(
                  color: Colors.white,
                )
              )
            )
          )
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: this._pickedImage == null
                        ? Container(
                      height: 360,
                      width: 400,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.black,
                      ),
                    ) :
                    Container(
                      height: 360,
                      width: 400,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Image.file(
                          this._pickedImage!,
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                labelText: "Title",
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              onSaved: (value){
                                _title = value!;
                              }
                              ),TextFormField(
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                labelText: "Description",
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              onSaved: (value){
                                _desc = value!;
                              }
                              ),
                          Padding(
                            padding: EdgeInsets.only(left: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.purple,
                                    onPrimary: Colors.pink,
                                  ),
                                    onPressed: _pickedImagegallery,
                                    icon: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      "Create Post",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    )),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white24,
                                    onPrimary: Colors.white24,
                                  ),
                                  onPressed: _pickedImageCamera,
                                  icon: Icon(
                                    FontAwesomeIcons.cameraRetro,
                                    color: Colors.white,
                                  ),
                                  label: Padding(
                                    padding: EdgeInsets.only(left: 20, right: 20),
                                    child: Text(
                                        "Camera",
                                        style: TextStyle(
                                          color: Colors.white,
                                        )
                                    ),
                                  )


                                )
                              ],
                            )
                          )

                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
      ),
    );
  }
}
