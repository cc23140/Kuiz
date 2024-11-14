import 'package:flutter/material.dart';
import 'package:kuiz_app/models/question_model.dart';
import 'package:kuiz_app/services/database_service.dart';

class AnswerQuizScreen extends StatefulWidget {
  final String quizId;
  final int currentIndex;
  const AnswerQuizScreen({super.key, required this.currentIndex, required this.quizId});

  @override
  State<AnswerQuizScreen> createState() => _AnswerQuizScreenState();
}

class _AnswerQuizScreenState extends State<AnswerQuizScreen> {

  final DatabaseService _databaseService = DatabaseService();
  late List<Question> questions;


  void loadQuestions()async{
    questions = await _databaseService.getQuestions(widget.quizId);
  }

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text(widget.quizId)
        ],
      ),
    );
  }
}
