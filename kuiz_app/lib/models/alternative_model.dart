class Alternative {
    final String idQuestion;
    final String name;
    final bool isCorrect;

    Alternative({
      required this.idQuestion,
      required this.name,
      required this.isCorrect
    });

    Alternative.fromJSON(Map<String, dynamic> json):
          this(
            idQuestion: json['idQuestion'] as String,
            name: json['name'] as String,
            isCorrect: json['isCorrect'] as bool
        );

    Map<String, dynamic> toJSON(){
      return {
        'idQuestion':this.idQuestion,
        'name':this.name,
        'isCorrect':this.isCorrect
      };
    }


}