// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import 'package:group_chat_app_pic/pages/group_info.dart';
import 'package:group_chat_app_pic/service/database_service.dart';
import 'package:group_chat_app_pic/widget/message_tile.dart';
import 'package:group_chat_app_pic/widget/widgets.dart';

final _firestore = FirebaseFirestore.instance;
Stream<QuerySnapshot>? chats;
String? username;

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;

 

  ChatPage(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.userName})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  
  String admin = "";
  TextEditingController messagecontroller = TextEditingController();
   File? imagefile;

   String? imageDownloaded;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getChatAndAdmin();
  }

  getChatAndAdmin() {
    DataBaseService().getChats(widget.groupId).then((value) {
      setState(() {
        chats = value;
      });
    });

    DataBaseService().getGroupAdmin(widget.groupId).then((value) {
      setState(() {
        admin = value;
      });
    });
  }


  Future getImages() async{

    ImagePicker picker = ImagePicker();

    await picker.pickImage(source: ImageSource.gallery).then((value) {




      if(value != null)
      {
        imagefile = File(value.path);

        uploadImage();

      }
    });



  }


  Future uploadImage() async{

    String fileName = Uuid().v1();

    int status = 1;

    await _firestore.collection("groups").doc(widget.groupId).collection("messages").doc(fileName).set(

      {

         "message": messagecontroller.text,
        "sender" : widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch,
        "type": "img",
        "imageUrl" : ""



      }
    ); 


    var ref = FirebaseStorage.instance.ref().child('images').child("$fileName.jpg");

    var uploadTask = await ref.putFile(imagefile!).catchError((error)async{

      await _firestore.collection("groups").doc(widget.groupId).collection("messages").doc(fileName).delete();

      status=0;


    });

    if(status == 1)
    {
      imageDownloaded = await uploadTask.ref.getDownloadURL();

      await  _firestore.collection("groups").doc(widget.groupId).collection("messages").doc(fileName).update({

        'imageUrl':imageDownloaded,
      });

     _firestore.collection("groups").doc(widget.groupId).update({

      "recentMessage": imageDownloaded,
      "recentMessageSender":widget.userName,
      "recentMessageTime":DateTime.now().toString(),


    });


      print(imageDownloaded);


    }



  }









  @override
  Widget build(BuildContext context) {

    username = widget.userName;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(widget.groupName),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
              onPressed: () {
                NextScreen(
                    context,
                    GroupInfo(
                      groupId: widget.groupId,
                      groupName: widget.groupName,
                      adminName: admin,
                    ));
              },
              icon: Icon(Icons.info))
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            chatMessages(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 08),
                width: MediaQuery.of(context).size.width,
                color: Colors.grey.shade700,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: messagecontroller,
                        style: TextStyle(color: Colors.white),
                        decoration:  InputDecoration(
                          suffixIcon: IconButton(onPressed: (){
                            getImages();
                          }, icon: Icon(Icons.photo, color: Colors.blue, size: 30,)),
                          hintText: "Send a message.....",
                          hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  sendMessage() {

    if(messagecontroller.text.isNotEmpty)
    {
      Map<String , dynamic> chatMessageMap = {

        "message": messagecontroller.text,
        "sender" : widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch,
        "type": "text",
        "imageUrl" : ""



      };


      DataBaseService().sendMessage(widget.groupId, chatMessageMap);

      setState(() {
        messagecontroller.clear();
      });
    }



  }
}





class chatMessages extends StatelessWidget {
  const chatMessages({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
       
       if(!snapshot.hasData)
       {
         return const Center(
              child: CircularProgressIndicator(
            backgroundColor: Colors.lightBlueAccent,
          ));

       }

       final messages = snapshot.data!.docs.reversed;
       List<MessageTile> messagebubbles = [];

       for(var message in messages){

        final messagebubble = MessageTile(message: message['message'], sender: message['sender'], sentByme: username == message['sender'],
        
        type: message['type'], image: message['imageUrl'],
        
        );


        messagebubbles.add(messagebubble);
       }

       return Expanded(
         child: ListView(
          reverse: true,
       
         
       
          children: messagebubbles,
         ),
       );


           
      },
    );
  }
}



// class Imagebubble extends StatelessWidget {


//   String image;
//   String sender;
//   bool sentByme;
  
//   Imagebubble({
//     Key? key,
//     required this.image,
//     required this.sender,
//     required this.sentByme,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(

//       padding: EdgeInsets.only(top: 4 , bottom: 4 , left: sentByme ? 0 : 24 , right: sentByme ? 24:0,
      
//       ),

//       alignment: sentByme ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         padding: const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
//         margin: sentByme
//             ? const EdgeInsets.only(left: 30)
//             : const EdgeInsets.only(right: 30),
//         decoration: BoxDecoration(
//             color: sentByme
//                 ? Theme.of(context).primaryColor
//                 : Colors.grey.shade700,
//             borderRadius: sentByme
//                 ? const BorderRadius.only(
//                     topLeft: Radius.circular(20),
//                     topRight: Radius.circular(20),
//                     bottomLeft: Radius.circular(20),
//                   )
//                 : const BorderRadius.only(
//                     topLeft: Radius.circular(20),
//                     topRight: Radius.circular(20),
//                     bottomRight: Radius.circular(20),
//                   )),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               sender.toUpperCase(),
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white , letterSpacing: -0.5),
//             ),
//             const SizedBox(
//               height: 8,
//             ),
//             Container(

//               height: 200,
//               width: 150,

//               child:image == "" ? CircularProgressIndicator() : Image.network(image),
         

//             )
//               ],
//         ),
//       ),
//     );
//   }
// }


 
//             //  ListView.builder(
//             //   reverse: false,
//             //     itemCount: snapshot.data.docs.length,
//             //     itemBuilder: (context, index) {
//             //       return snapshot.data.docs[index]['type'] == "text"?
                  
//             //       MessageTile(
//             //           message: snapshot.data.docs[index]['message'],
//             //           sender: snapshot.data.docs[index]['sender'],
//             //           sentByme: widget.userName ==
//             //               snapshot.data.docs[index]['sender']) :

//             //               Imagebubble(image: snapshot.data.docs[index]['imageUrl'], sender: snapshot.data.docs[index]['sender'], sentByme: widget.userName ==
//             //               snapshot.data.docs[index]['sender'])


                          
//             //               ;
//             //     },
//             //   )
//             // : Container();