import 'package:kuiz_app/models/alternative_model.dart';

class Question{

  late String name;
  final String questionId;
  String quizId;

  List<Alternative> alternatives = [];


  Question({required this.name, required this.quizId, required this.questionId});

  Question copyWith({
    String? name,
    String? quizId,
    String? questionId
  }){
    return Question(questionId: questionId ?? this.questionId, name: name ?? this.name, quizId: quizId ?? this.quizId);
  }

  Map<String, dynamic> toJSON(){
    return {
      'questionId':this.questionId,
      'name':this.name,
      'quizId':this.quizId
    };
  }

  Question.fromJSON(Map<String, dynamic> json):this(questionId: json['questionId'], name: json['name'] as String, quizId: json['quizId'] as String);


}