// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final bool sentByme;
  final String type;
  final String image;
  const MessageTile({
    Key? key,
    required this.message,
    required this.sender,
    required this.sentByme,
    required this.type,
    required this.image,
  }) : super(key: key);




  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return widget.type == "text" ? Container(

      padding: EdgeInsets.only(top: 4 , bottom: 4 , left: widget.sentByme ? 0 : 24 , right: widget.sentByme ? 24:0,
      
      ),

    
      alignment: widget.sentByme ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(

        crossAxisAlignment: widget.sentByme ? CrossAxisAlignment.end : CrossAxisAlignment.start,


        children: [

          Text(
              widget.sender.toUpperCase(),
              textAlign: TextAlign.start,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white , letterSpacing: -0.5),
            ),
            const SizedBox(
              height: 8,
            ),

                   
      Container(
        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
        margin: widget.sentByme
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30),
        decoration: BoxDecoration(
          
            color: widget.sentByme
                ? Color.fromRGBO(36, 87, 202, 1.0)
                : Colors.blueGrey[50],
            borderRadius: widget.sentByme
                ? const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  )
                : const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )),
        child: Text(
              widget.message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: widget.sentByme ? Colors.white : Colors.black
              ),
            )
      ),



        ],


      )

      
      
     
    ):



    Container(

      padding: EdgeInsets.only(top: 4 , bottom: 4 , left: widget.sentByme ? 0 : 24 , right: widget.sentByme ? 24:0,
      
      ),

      alignment: widget.sentByme ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(

        crossAxisAlignment: widget.sentByme ? CrossAxisAlignment.end : CrossAxisAlignment.start,

        children: [

           Text(
              widget.sender.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white , letterSpacing: -0.5),
            ),
            const SizedBox(
              height: 8,
            ),



           
      Container(
        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
        margin: widget.sentByme
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30),
        decoration: BoxDecoration(
            color: widget.sentByme
                ? Color.fromRGBO(36, 87, 202, 1.0)
                : Colors.blueGrey[50],
            borderRadius: widget.sentByme
                ? const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  )
                : const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )),
        child:InkWell(
              onTap: (){

                Navigator.of(context).push(


                  MaterialPageRoute(builder: (context){

                    return ImageShow(image: widget.image);
                  })
                );


              },
              child: Container(
            
                height: 200,
                width: 150,
            
                child:widget.image == "" ? LoadingAnimationWidget.threeRotatingDots(color: Colors.white
                , size: 50) : Image.network(widget.image),
                     
            
              ),
            ),
      ),








        ],








      )
      
      
      
     
    );
    
    
    
    
    
    ;
  }
}





class ImageShow extends StatelessWidget {

  final String image;
  const ImageShow({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(


      body: Container(

        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,

        child:Image.network(image) ,





      ),
    );
  }
}
