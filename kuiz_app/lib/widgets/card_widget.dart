

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {

  final String title;
  final String creatorUsername;
  final String image;

  const CardWidget({
    super.key,
    required this.title,
    required this.creatorUsername,
    required this.image
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius:  BorderRadius.all(Radius.circular(10))
      ),
      width: MediaQuery.sizeOf(context).width * 0.45,
      height: MediaQuery.sizeOf(context).height * 0.1,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        textDirection: TextDirection.ltr,
        children: [
          Expanded(
            flex: 3,
            child: Image.network(image),
          ),
          Expanded(
            flex: 2,
              child: Text(
                title,
                style: TextStyle(
                    fontSize: 20
                ),
              ),
          ),
          Expanded(
            flex: 1,
              child: Text(
                creatorUsername,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14
                ),
              )
          )


        ],
      ),
    );
  }
}
