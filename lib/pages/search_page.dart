import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_app_pic/hepler/hepler_function.dart';
import 'package:group_chat_app_pic/pages/chat_page.dart';
import 'package:group_chat_app_pic/service/database_service.dart';
import 'package:group_chat_app_pic/widget/group_tile.dart';
import 'package:group_chat_app_pic/widget/widgets.dart';


class SearchPage extends StatefulWidget {
  const SearchPage({ Key? key }) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {


  TextEditingController SearchController = TextEditingController();
  bool _isLoading = false;
  QuerySnapshot? searchSnapshot ;
  bool hasUSerSearched = false;
  String userName = "";
  User? user ;
  bool isjoinded = false;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUserIdandName();
  }

   getName(String r)
  {

    return r.substring(r.indexOf("_")+1);

  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }



  getCurrentUserIdandName() async
  {
    await HelperFunctions.getUserNameFromSF().then((value) {


      setState(() {
        userName = value!;
      });
    });

    user = FirebaseAuth.instance.currentUser;

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(

          iconTheme:IconThemeData().copyWith(color: Colors.white),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          //elevation: 0,
          title: const Text("Search" , style: TextStyle(fontSize: 27 , fontWeight: FontWeight.bold , color: Colors.white),),

        ),


        body: Column(

          children: [


            Container(
              color: Theme.of(context).primaryColor,

              padding: const EdgeInsets.symmetric(horizontal: 15 , vertical: 10) ,


              child: Row(children: [

                Expanded(child: TextField(

                  controller: SearchController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(

                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.white , fontSize: 16 , ),
                    hintText: "Search Groups..."


                  ),



                ),),

                GestureDetector(
                  onTap: () {

                    initiateSearchMethod();
                    


                  },
                  child: Container(
                
                    width: 40,
                    height: 40,
                   decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(40),
                               
                
                
                
                   ),
                   child: const Icon(Icons.search , color: Colors.white,) ,
                
                  ),
                )



              ]),


            ),

            _isLoading ? Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,)) : groupList(),
          ],



        ),

    );
  }

  initiateSearchMethod() async
  {

    if(SearchController.text.isNotEmpty)
    {
        setState(() {
          _isLoading = true;
        });

        await DataBaseService().SearchByName(SearchController.text).then((snapshot){


          setState(() {

            searchSnapshot = snapshot;
            _isLoading = false;
            hasUSerSearched = true;
            
          });
        });
    }


  }

  groupList()
  {
    return hasUSerSearched ? ListView.builder(

      shrinkWrap: true,
      itemCount: searchSnapshot!.docs.length,
      itemBuilder: (context , index){
        return groupTile(userName, searchSnapshot!.docs[index]['groupId'], searchSnapshot!.docs[index]['groupName'], searchSnapshot!.docs[index]['admin']);


      },


    ) : Container();

  }


  joinedOrNot(String userName , String groupId , String groupName, String admin) async
  {
    await DataBaseService(uid: user!.uid).isUserJoined(groupName, groupId, userName).then((value) {

      setState(() {
        isjoinded = value;
      });





    });

  }

  Widget groupTile(String userName , String groupId , String groupName , String admin)
  {

    //function to check wheather user already exist in group
    joinedOrNot(userName , groupId , groupName , admin);

  
    return ListTile(


        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),

        leading: CircleAvatar(radius: 30, backgroundColor: Theme.of(context).primaryColor,

        child: Text(groupName.substring(0,1).toUpperCase() , style: TextStyle(color: Colors.white),),

         
        
        
        ),

        title: Text(groupName , style: TextStyle(fontWeight: FontWeight.w600),),
    
        subtitle: Text("Admin : ${getName(admin)}"),

        trailing: InkWell(

          onTap: () async{

            await DataBaseService(uid: user!.uid).toggleGroupJoin(groupId, userName, groupName);

            if(isjoinded)
            {
              setState(() {
                isjoinded = !isjoinded;
              });

              showSnackBar(context, Colors.green, "Successfully joined the group");
              Future.delayed(const Duration(seconds: 2));
              NextScreen(context, ChatPage(groupId: groupId, groupName: groupName, userName: userName));
            }
            else
            {
              setState(() {
                isjoinded = !isjoinded;
              });

              showSnackBar(context, Colors.red, "Left the group $groupName");

            }



            
          },

          child: isjoinded ? Container(

            decoration: BoxDecoration(

              borderRadius: BorderRadius.circular(10),
              color: Colors.black ,

              border: Border.all(color: Colors.white , width: 1),

            ),

            padding: EdgeInsets.symmetric(horizontal: 20 , vertical: 10),
            child: Text("Joined" , style: TextStyle(color: Colors.white ),),



          ) : Container(

              decoration: BoxDecoration(

              borderRadius: BorderRadius.circular(10),
              color:Theme.of(context).primaryColor ,

//              border: Border.all(color: Colors.white , width: 1),

            ),

            padding: EdgeInsets.symmetric(horizontal: 20 , vertical: 10),
            child: Text("Join now" , style: TextStyle(color: Colors.white ),),




          ),


        ),

    );
  }




}