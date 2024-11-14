import 'package:flutter/material.dart';
import 'package:kuiz_app/pages/answer_quiz/answer_quiz_screen.dart';
import 'package:kuiz_app/services/database_service.dart';

import '../../models/quiz_model.dart';


class AnswerQuizHomeScreen extends StatefulWidget {
  final String quizId;
  const AnswerQuizHomeScreen({super.key, required this.quizId});

  @override
  State<AnswerQuizHomeScreen> createState() => _AnswerQuizHomeScreenState();
}

class _AnswerQuizHomeScreenState extends State<AnswerQuizHomeScreen> {
  Quiz? selectedQuiz;
  final DatabaseService _databaseService = DatabaseService();

  void loadQuiz() async{
    selectedQuiz = (await _databaseService.getQuiz(quizId: widget.quizId))!;
    setState(() {});
    
  }

  @override
  void initState() {
    super.initState();
    loadQuiz();
  }
  
  @override
  Widget build(BuildContext context) {
    return selectedQuiz == null ? Container() : Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
            Container(
              child: Image.network(selectedQuiz!.image),
            ),
            Container(
              child: Text(selectedQuiz!.title),
            ),
            Container(
              child: Text('Número de questões: ${selectedQuiz!.questionsAmount}'),
            ),
          Container(
            child: TextButton(
                onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>AnswerQuizScreen(currentIndex: 0, quizId: widget.quizId))),
                child: const Text('Iniciar Kuiz!')
            ),
          )
        ],
      ),
    );
  }
}
