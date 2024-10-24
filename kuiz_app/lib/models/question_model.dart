import 'package:kuiz_app/models/alternative_model.dart';

class Question{

  late final String name;
  final String quizId;

  List<Alternative> alternatives = [];


  Question({required this.name, required this.quizId});

  Question copyWith(
      String? name,
      String? quizId
      ){
    return Question(name: name ?? this.name, quizId: quizId ?? this.quizId);
  }

  Map<String, dynamic> toJSON(){
    return {
      'name':this.name,
      'quizId':this.quizId
    };
  }

  Question.fromJSON(Map<String, dynamic> json):this(name: json['name'] as String, quizId: json['quizId'] as String);


}