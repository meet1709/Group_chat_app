// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

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
      child: Container(
        padding: const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        margin: widget.sentByme
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30),
        decoration: BoxDecoration(
            color: widget.sentByme
                ? Theme.of(context).primaryColor
                : Colors.grey.shade700,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.sender.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white , letterSpacing: -0.5),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              widget.message,
              textAlign: TextAlign.center,
              style:const  TextStyle(
                fontSize: 16,
                color: Colors.white
              ),
            )
          ],
        ),
      ),
    ):



    Container(

      padding: EdgeInsets.only(top: 4 , bottom: 4 , left: widget.sentByme ? 0 : 24 , right: widget.sentByme ? 24:0,
      
      ),

      alignment: widget.sentByme ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        margin: widget.sentByme
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30),
        decoration: BoxDecoration(
            color: widget.sentByme
                ? Theme.of(context).primaryColor
                : Colors.grey.shade700,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.sender.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white , letterSpacing: -0.5),
            ),
            const SizedBox(
              height: 8,
            ),
            InkWell(
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
            
                child:widget.image == "" ? CircularProgressIndicator(color: Colors.lightBlueAccent,) : Image.network(widget.image),
                     
            
              ),
            )
              ],
        ),
      ),
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
