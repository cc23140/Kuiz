import 'package:flutter/material.dart';
import 'package:kuiz_app/models/question_model.dart';
import 'package:kuiz_app/services/database_service.dart';

import '../home/home_screen.dart';

class AnswerQuizScreen extends StatefulWidget {
  final int score;
  final List<Question> questions;
  final int currentIndex;
  const AnswerQuizScreen({super.key, required this.currentIndex, required this.questions, required this.score});

  @override
  State<AnswerQuizScreen> createState() => _AnswerQuizScreenState();
}

class _AnswerQuizScreenState extends State<AnswerQuizScreen> {

  final DatabaseService _databaseService = DatabaseService();
  List<Color> alternativeColor = [];

  @override
  void initState() {
    super.initState();
    if(widget.currentIndex != widget.questions.length){
      alternativeColor = List.generate(widget.questions[widget.currentIndex].alternatives.length, (index)=>Colors.blue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.currentIndex == widget.questions.length ? _buildCongratulationsPage(context, widget.score, widget.questions.length) : Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
            padding: EdgeInsets.all(10),
          child: Text(
            'Questão: ${widget.currentIndex + 1} de ${widget.questions.length}',
            style: TextStyle(
                fontSize: 26
            ),
          ),
        )
      ),
      body: Column(
        children: [
          Divider(),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
                widget.questions[widget.currentIndex].name,
              style: TextStyle(fontSize: 18),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
              itemCount: widget.questions[widget.currentIndex].alternatives.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (context, index){
                return GestureDetector(
                  onTap: (){

                    setState(() {
                      if(widget.questions[widget.currentIndex].alternatives[index].isCorrect){
                        alternativeColor[index] = Colors.green[400]!;
                      }
                      else{
                        alternativeColor[index] = Colors.redAccent;
                      }
                    });
                    
                    Future.delayed(Duration(seconds: 1), (){
                      int updatedScore = widget.score + (widget.questions[widget.currentIndex].alternatives[index].isCorrect? 1 : 0);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AnswerQuizScreen(currentIndex: widget.currentIndex + 1, questions: widget.questions, score: updatedScore)));
                    });

                  },
                  child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Container(
                        decoration: BoxDecoration(
                          color: alternativeColor[index],
                          border: Border.all(
                            width: 1
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10)
                          )
                        ),
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            widget.questions[widget.currentIndex].alternatives[index].name,
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        )
                      ),
                    )
                );
              })
        ],
      ),
    );
  }
}

Widget _buildCongratulationsPage(BuildContext context,int finalScore, int questionsAmount){
  return Scaffold(
    appBar: AppBar(
      automaticallyImplyLeading: false,
    ),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 1, child: Container()),
        finalScore / questionsAmount == 1 ? const Padding(padding: EdgeInsets.all(15), child: Text('Parabéns! Pontuação Máxima!', style: TextStyle(fontSize: 24),),)  : const Padding(padding: EdgeInsets.all(15), child: Text('Muito Bem!', style: TextStyle(fontSize: 24),),),
        Padding(padding: EdgeInsets.all(15), child: Text('Você acertou ${finalScore} questões de ${questionsAmount}', style: TextStyle(color: Colors.blue, fontSize: 20),),),
        Expanded(flex: 1, child: Container()),
        Expanded(
          flex: 10,
            child: Align(
              alignment: Alignment.center,
              child:  ElevatedButton(
                  onPressed: () async{
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                  },
                  child: const Text('Voltar ao menu')
              ),
            )
        )
      ],
    ),
  );
}
