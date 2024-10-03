import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final String title;
  final String creatorUsername;
  final String image;

  const CardWidget(
      {super.key,
      required this.title,
      required this.creatorUsername,
      required this.image});

  @override
  Widget build(BuildContext context) {
    final double raio = 10;
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(raio)), border: Border.all(color: Colors.black, style: BorderStyle.solid, width: 2)),
      width: 300,
      height: MediaQuery.sizeOf(context).height,
      margin: EdgeInsets.all(10),
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: TextDirection.ltr,
        children: [
          Expanded(
            flex: 6,
            child: ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(raio), topRight: Radius.circular(raio)),
              child: Image.network(image, fit: BoxFit.fill, width: MediaQuery.sizeOf(context).width,),
            )
          ),
          Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 5, 0, 1),
                child: Text("${title.substring(0, 25)}...", style: TextStyle(fontSize: 12)),
              )
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 1, 0, 2),
              child: Text("@${creatorUsername}", style: TextStyle(fontSize: 8, fontWeight: FontWeight.w400),),
            ),
          )
        ],
        
      ),
    );
  }
}
