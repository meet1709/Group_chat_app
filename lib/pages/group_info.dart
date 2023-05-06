import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_app_pic/hepler/hepler_function.dart';
import 'package:group_chat_app_pic/pages/homepage.dart';
import 'package:group_chat_app_pic/service/database_service.dart';
import 'package:group_chat_app_pic/widget/widgets.dart';


class GroupInfo extends StatefulWidget {

  final String groupId;
  final String groupName;
  final String adminName;


  const GroupInfo({ Key? key , required this.groupId , required this.groupName , required this.adminName }) : super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {

  Stream? members ;

  String? userName;




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMembers();
    getCurrentUserIdandName();

  }

   getCurrentUserIdandName() async
  {
    await HelperFunctions.getUserNameFromSF().then((value) {


      setState(() {
        userName = value!;
      });
    });

    //user = FirebaseAuth.instance.currentUser;

  }

  getMembers() async
  {
      DataBaseService(uid: FirebaseAuth.instance.currentUser!.uid).getGroupMembers(widget.groupId).then((val){

        setState(() {
          members = val;
        });



      });
  }

  getName(String r)
  {

    return r.substring(r.indexOf("_")+1);

  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(

     appBar: AppBar(centerTitle: true,
     iconTheme: IconThemeData().copyWith(color: Colors.white),

     //elevation: 0,
     backgroundColor: Theme.of(context).primaryColor,
     title: Text("Group Info", style: TextStyle(color:Colors.white),),
     actions: [

      IconButton(onPressed: () async{
        showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text("Are you sure you want to exit the group? "),
                        title: const Text("Exit"),
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


                           
                                DataBaseService(uid: FirebaseAuth.instance.currentUser!.uid).toggleGroupJoin(widget.groupId, userName!, widget.groupName).whenComplete(() {



                                  NextScreenReplace(context, HomePage());
                                });
                              },
                              icon: const Icon(
                                Icons.done,
                                color: Colors.green,
                              ))
                        ],
                      );
                    });



      }, icon: Icon(Icons.exit_to_app)),


     ],



     

     
     ),

     body: Container(

        padding: EdgeInsets.symmetric(horizontal: 20 , vertical: 20) ,

        child: Column(

          children: [

            Container(

              padding: EdgeInsets.all(20),

              decoration: BoxDecoration(

                borderRadius: BorderRadius.circular(30),
                color: Theme.of(context).primaryColor.withOpacity(0.2),

              ),

              child: Row(

                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  CircleAvatar(

                    radius: 30,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(widget.groupName.substring(0,1).toUpperCase(),

                    style: TextStyle(fontWeight: FontWeight.w500 , color: Colors.white),
                    
                    ),

                  ),


                  SizedBox(width: 20,),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      Text("Group : ${widget.groupName}" , style: TextStyle(
                        fontWeight: FontWeight.w500,


                      ),),

                      const SizedBox(height: 5,),

                      Text("Admin : ${getName(widget.adminName)}")


                     


                    ],


                  ),



                ],


              ),




            ),

            memberList(),



          ],


        ) ,

      

     ),


    );
  }


  memberList()
  {
    return StreamBuilder(

      stream: members,

      builder: (context , AsyncSnapshot snapshot){

        if(snapshot.hasData)
        {

          if(snapshot.data['members'] != null)
          {

            if(snapshot.data['members'].length !=0)
            {

              return ListView.builder(itemCount: snapshot.data['members'].length,

              shrinkWrap: true,
              itemBuilder: (comtext,index){

                return Container(

                  padding: EdgeInsets.symmetric(horizontal: 5 , vertical: 10),
                  child: ListTile(leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(getName(snapshot.data['members'][index]).substring(0,1).toUpperCase() ,

                    style: TextStyle(color: Colors.white , fontSize: 15 , fontWeight: FontWeight.bold),
                    
                    
                    ),



                  ),
                  title: Text(getName(snapshot.data['members'][index])),
                  subtitle: Text(getId(snapshot.data['members'][index])),
                  
                  
                  ),

                  

                );


              },
              
              );

            }
            else
            {
              return Center(child: Text("NO MEMBERS"),);
            }

          }
          else
          {
            return Center(child: Text("NO MEMBERS"),);
          }

        }
        else
        {
          return Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),);
        }
      },



    );
  }
}