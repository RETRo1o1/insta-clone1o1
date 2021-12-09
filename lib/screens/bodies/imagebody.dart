// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart' as Path;
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:uuid/uuid.dart';
//
//
// class Posts extends StatefulWidget {
//   // const Posts({Key? key}) : super(key: key);
//
//   @override
//   _PostsState createState() => _PostsState();
// }
//
// class _PostsState extends State<Posts> {
//   List<File> imageList = [];
//   File? image;
//   final picker = ImagePicker();
//   int i = 0;
//
//   var title = '';
//   var desc = ' ';
//   String url = '';
//
//
//   Reference reference = FirebaseStorage.instance.ref();
//   final User? user = FirebaseAuth.instance.currentUser;
//   final _formKey = GlobalKey<FormState>();
//
//
//
//
//
//   Future _upload() async {
//     final isValid = _formKey.currentState!.validate();
//     FocusScope.of(context).unfocus();
//
//     if(isValid){
//       _formKey.currentState!.save();
//       print(title);
//       print(desc);
//     }
//
//     if(isValid){
//       _formKey.currentState!.save();
//       for( var img in imageList){
//
//         reference = FirebaseStorage.instance
//             .ref()
//             .child('instaImages/${Path.basename(img.path)}');
//         await reference.putFile(img).whenComplete(() async{
//           reference.getDownloadURL().then((value) {
//             FirebaseFirestore.instance
//                 .collection('users')
//                 .doc(user!.uid)
//                 .collection('usersImage')
//                 .doc(user!.uid)
//                 .set({
//               'imgID' : {"$i" : value},
//               'title' : title,
//               'description' : desc,
//             });
//
//             i++;
//
//
//
//
//           });
//         });
//       }
//     }
//
//
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//         backgroundColor: Colors.black,
//         appBar: AppBar(
//             backgroundColor: Colors.black,
//             automaticallyImplyLeading: false,
//             title: Row(
//               children: [
//                 Text(
//                   "New Post",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 22.2,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//                 Text("                                    "),
//                 ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       onPrimary: Colors.black,
//                       primary: Colors.black,
//                     ),
//                     onPressed: _upload,
//                     child: Text(
//                       "Upload",
//                       style: TextStyle(
//                         color: Colors.white,
//                       ),
//                     ))
//               ],
//             )
//         ),
//         body: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                     margin: EdgeInsets.only(left: 15, right: 15),
//                     height: height * 0.18,
//                     child: Row(
//                         children: [
//                           InkWell(
//                             child: Container(
//                               width: width * 0.30,
//                               decoration: BoxDecoration(
//                                   color: Colors.grey.shade100,
//                                   borderRadius: BorderRadius.circular(10)),
//                               margin: EdgeInsets.only(right: 10),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Icons.photo_camera,
//                                     color: Colors.blue.shade900,
//                                     size: 32,
//                                   ),
//                                   Text(
//                                     "Add Image",
//                                     style: TextStyle(
//                                         fontSize: 16, color: Colors.blue.shade900),
//                                   )
//                                 ],
//                               ),
//                             ),
//                             onTap: () {
//                               chooseImages();
//                               },
//                           ),
//                           imageList == null
//                               ? Container()
//                               : Expanded(child: imagesData(imageList))
//                         ])
//                 ),
//                 Padding(
//                   padding: EdgeInsets.all(10),
//                   child: Column(
//                     children: [
//                       Form(
//                         key: _formKey,
//                         child: Column(
//                           children: [
//                             TextFormField(
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                 ),
//                                 decoration: InputDecoration(
//                                   labelText: "Title",
//                                   labelStyle: TextStyle(
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 onSaved: (value){
//                                   title = value!;
//                                 }
//                             ),TextFormField(
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                 ),
//                                 decoration: InputDecoration(
//                                   labelText: "Description",
//                                   labelStyle: TextStyle(
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 onSaved: (value){
//                                   desc = value!;
//                                 }
//                             ),
//                             // ElevatedButton.icon(
//                             //     onPressed: _pickedImagegallery,
//                             //     icon: Icon(
//                             //       Icons.add,
//                             //       color: Colors.white,
//                             //     ),
//                             //     label: Text(
//                             //       "Create Post",
//                             //       style: TextStyle(
//                             //         color: Colors.white,
//                             //       ),
//                             //     ))
//
//                           ],
//                         ),
//                       ),
//
//                     ],
//                   ),
//
//                 )
//
//
//
//
//
//
//
//               ],
//             )
//         )
//
//
//
//
//     );
//   }
//
//   chooseImages() async {
//     final pickedFile = await picker.getImage(source: ImageSource.gallery);
//     setState(() {
//       imageList.add(File(pickedFile!.path));
//     });
//     if (pickedFile == null) retrieveLostData();
//   }
//
//   Future<void> retrieveLostData() async {
//     final LostData response = await picker.getLostData();
//     if (response.isEmpty) {
//       return;
//     }
//     if (response.file != null) {
//       setState(() {
//         imageList.add(File(response.file!.path));
//       });
//     } else {
//       print(response.file);
//     }
//   }
//
//   Widget imagesData(List<File>? imageList) {
//     return ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: imageList!.length,
//         itemBuilder: (context, index) {
//           return Container(
//             width: MediaQuery.of(context).size.width * 0.30,
//             height: MediaQuery.of(context).size.height * 0.17,
//             margin: EdgeInsets.only(left: 2, right: 2),
//             decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
//             child: Stack(children: [
//               Container(
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(25),
//                   child: Image.file(
//                     imageList[index],
//                     width: MediaQuery.of(context).size.width,
//                     height: MediaQuery.of(context).size.height * 0.17,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               Positioned(
//                 child: InkWell(
//                   onTap: () {
//                     print("${imageList[index]}");
//                     setState(() {
//                       imageList.remove(imageList[index]);
//                     });
//                   },
//                   child: Icon(
//                     Icons.cancel,
//                     color: Colors.white,
//                   ),
//                 ),
//                 right: 10,
//                 top: 10,
//               )
//             ]),
//           );
//         });
//   }
// }
