class Alternative {
    final String alternativeId;
    final String questionId;
    final String name;
    final bool isCorrect;

    Alternative({
      required this.questionId,
      required this.name,
      required this.isCorrect,
      required this.alternativeId
    });

    Alternative.fromJSON(Map<String, dynamic> json):
          this(
            alternativeId: json['alternativeId'] as String,
            questionId: json['questionId'] as String,
            name: json['name'] as String,
            isCorrect: json['isCorrect'] as bool
        );

    Map<String, dynamic> toJSON(){
      return {
        'alternativeId':this.alternativeId,
        'questionId':this.questionId,
        'name':this.name,
        'isCorrect':this.isCorrect
      };
    }

    Alternative copyWith({
      String? alternativeId,
      String? questionId,
      String? name,
      bool? isCorrect
    }){
      return Alternative(
        alternativeId: alternativeId ?? this.alternativeId,
        questionId: questionId ?? this.questionId,
        name: name ?? this.name,
        isCorrect: isCorrect ?? this.isCorrect
      );
    }


}