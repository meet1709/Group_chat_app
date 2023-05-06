
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_app_pic/pages/auth/loginpage.dart';
import 'package:group_chat_app_pic/pages/chat_page.dart';
import 'package:group_chat_app_pic/pages/homepage.dart';
import 'package:group_chat_app_pic/service/auth_service.dart';
import 'package:group_chat_app_pic/widget/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

  DocumentReference df = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);
  //late DocumentSnapshot ds;
  String imageDownloaded="";
  String image ="1";


class ProfilePage extends StatefulWidget {
  String userName;
  String email;
  ProfilePage({ Key? key ,required this.email ,required this.userName}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  AuthService authService = AuthService();
  File? imagefile;
  




  //  Future getProfileImages() async{

  //   ImagePicker picker = ImagePicker();

  //   await picker.pickImage(source: ImageSource.gallery).then((value) {




  //     if(value != null)
  //     {
  //       imagefile = File(value.path);

  //       uploadProfilePic();

  //     }
  //   });



  // }


  
  // Future uploadProfilePic() async{

  //   String fileName = Uuid().v1();

  //   String name = widget.userName;

  //   int status = 1;

  //   var ref = FirebaseStorage.instance.ref().child('images').child("Profile_pics").child("$name.jpg");

  //   var uploadTask = await ref.putFile(imagefile!).catchError((val){


  //     showSnackBar(context, Colors.red, "Error in uploading profile pic");
  //     status = 0;


  //   });

  //   if(status == 1)
  //   {
  //     imageDownloaded = await uploadTask.ref.getDownloadURL().whenComplete(() async{

  //        await df.update({

  //       'profilepic': imageDownloaded

  //     }).whenComplete(() {

  //       setState(() {
          
  //          getimage();
  //       });




  //     });

      




  //     }); 
      
     

     

      


     

    


    

   

      
      
      
      
      
  //     print(imageDownloaded);


  //   }



  // }

  // getimage()async{

  //   image = "";

  //   DocumentSnapshot ds = await df.get();

    

  //   image = ds['profilepic'];

    

  // }









  @override
  Widget build(BuildContext context){

    

    

    



    return Scaffold(

        appBar: AppBar(
          iconTheme: IconThemeData().copyWith(color: Colors.white),

          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          //elevation: 0,
          title: const Text("Profile" , style: TextStyle(fontSize: 27 , fontWeight: FontWeight.bold , color: Colors.white),),

        ),
        

        drawer: Drawer(
          child: ListView(
          padding: EdgeInsets.symmetric(vertical: 50),
          children: <Widget>[
           
        
            Image.asset("assets/drawer.png",),
                
                
                
            const SizedBox(
              height: 15,
            ),
            Text(
              widget.userName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            ListTile(
              onTap: () {

                NextScreen(context, const HomePage());
              },
              
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              leading: const Icon(Icons.group),
              title: const Text(
                "Groups",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () {
                
              },
              selected: true,
              selectedColor: Theme.of(context).primaryColor,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              leading: const Icon(Icons.group),
              title: const Text(
                "Profile",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () async {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text("Are you sure you want to logout?"),
                        title: const Text("Logout"),
                        actions: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.red,
                              )),
                          IconButton(
                              onPressed: () async {
                                await authService.signOut();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LogInPage()),
                                    (route) => false);
                              },
                              icon: const Icon(
                                Icons.done,
                                color: Colors.green,
                              ))
                        ],
                      );
                    });
              },
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              leading: const Icon(Icons.exit_to_app),
              title: const Text(
                "Logout",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),


        ),



        body: SingleChildScrollView(   //editable
          child: Container(
        
            padding: EdgeInsets.symmetric(vertical: 100 /*edited 170*/ , horizontal: 40),
        
            child: Column(
        
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

    
               const Icon(Icons.account_circle, size: 200 , color: Colors.grey,)

                
                
                ,
                const SizedBox(height: 15,),
        
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
        
                  children: [
        
                    const Text("Full Name" , style: TextStyle(fontSize: 17),),
        
                    Text(widget.userName , style: TextStyle(fontSize: 17),),
                    
        
                  ],
        
        
                ),

                const Divider(height: 20,),

                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
        
                  children: [
        
                    const Text("Email" , style: TextStyle(fontSize: 17),),
        
                    Text(widget.email , style: TextStyle(fontSize: 17),),
                    
        
                  ],
        
        
                ),



        
        
        
        
              ],
        
            ),
            
        
        
        
          ),
        ),


    );
  }
}

