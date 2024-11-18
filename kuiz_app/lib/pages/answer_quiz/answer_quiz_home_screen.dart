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
    await loadQuestions();
    setState(() {});
    
  }

  Future<void> loadQuestions() async{
    final questions = await _databaseService.getQuestions(selectedQuiz!.quizId);
    selectedQuiz!.questions = questions;
  }

  @override
  void initState() {
    super.initState();
    loadQuiz();
  }
  
  @override
  Widget build(BuildContext context) {
    return selectedQuiz == null ? Container() : Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){ Navigator.pop(context);}, icon: const Icon(Icons.arrow_back, color: Colors.blue,)),
        title: const Text('Informações do Quiz', style: TextStyle(color: Colors.blue),),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Divider(
              height: 2,
            ),
            Container(
              child: Image.network(selectedQuiz!.image),
            ),
            Container(
              child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    selectedQuiz!.title,
                    style: TextStyle(
                        fontSize: 20
                    ),
                  )
              ),
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 0, 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Text('Número de questões: ${selectedQuiz!.questionsAmount}'),
                  ),
                )
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 0, 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      const Text('Código de Compartilhamento: '),
                      Text(selectedQuiz!.shareCode, style: TextStyle(color: Colors.blueGrey),)
                    ],
                  )
                )
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.all(50),
                  child: ElevatedButton(
                      onPressed: () async{
                          Navigator.pushReplacement(context, MaterialPageRoute(builder:
                              (context) =>
                              AnswerQuizScreen(currentIndex: 0,
                                questions: selectedQuiz!.questions,
                                score: 0,)
                            )
                          );
                      },
                      child: const Text('Iniciar Kuiz!')
                  ),
                )
            )
          ],
        ),
      )
    );
  }
}
