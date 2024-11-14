import 'package:flutter/material.dart';
import 'package:kuiz_app/models/question_model.dart';
import 'package:kuiz_app/services/database_service.dart';

class AnswerQuizScreen extends StatefulWidget {
  final int currentIndex;
  const AnswerQuizScreen({super.key, required this.currentIndex});

  @override
  State<AnswerQuizScreen> createState() => _AnswerQuizScreenState();
}

class _AnswerQuizScreenState extends State<AnswerQuizScreen> {

  final DatabaseService _databaseService = DatabaseService();
  late final List<Question> questions = [];


  void loadQuestions()async{
    questions = await _databaseService.getQuestions(quiz);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
