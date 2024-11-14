import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuiz_app/pages/answer_quiz/answer_quiz_home_screen.dart';
import 'package:kuiz_app/pages/answer_quiz/answer_quiz_screen.dart';

class CardWidget extends StatelessWidget {
  final String quizId;
  final String title;
  final String creatorUsername;
  final String image;

  const CardWidget({
      super.key,
      required this.title,
      required this.creatorUsername,
      required this.image,
      required this.quizId
      });

  @override
  Widget build(BuildContext context) {
    final double raio = 14;
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>AnswerQuizHomeScreen(quizId: quizId)));
      },
      child: Container(
        decoration:
        BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(raio)),
            border: Border.all(color: Colors.black, style: BorderStyle.solid, width: 1.4),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 3
              )
            ]
        ),
        width: 300,
        height: MediaQuery.sizeOf(context).height,
        margin: EdgeInsets.all(10),
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: TextDirection.ltr,
          children: [
            Expanded(
                flex: 18,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(raio-2), topRight: Radius.circular(raio-2)),
                  child: Image.network(image, fit: BoxFit.fill, width: MediaQuery.sizeOf(context).width,),
                )
            ),
            Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 0, 1),
                  child: Text("${title.substring(0, 25)}...", style: TextStyle(fontSize: 12)),
                )
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 1, 0, 2),
                child: Text("@${creatorUsername}", style: TextStyle(fontSize: 8, fontWeight: FontWeight.w400),),
              ),
            )
          ],

        ),
      ),
    ) ;
  }
}
