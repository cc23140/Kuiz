class Question{

  final String name;
  final String quizId;


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