class Quiz{
  final String uid;
  final String title;
  final String image;
  final bool public;
  final int questionsAmount;
  final String shareCode;

  Quiz({
    required this.uid,
    required this.title,
    required this.image,
    required this.public,
    required this.questionsAmount,
    required this.shareCode
  });

  Quiz.fromJSON(Map<String, dynamic> json):
      this(
        uid:json['uid']! as String,
        title:json['title']! as String,
        image:json['image']! as String,
        public:json['public']! as bool,
        questionsAmount:json['questionsAmount']! as int,
        shareCode:json['shareCode']! as String
      );

  Quiz copyWith(
      String? uid,
      String? title,
      String? image,
      bool? public,
      int? questionsAmount,
      String? shareCode
      ){
    return Quiz(
        uid: uid ?? this.uid,
        title: title ?? this.title,
        image: image ?? this.image,
        public: public ?? this.public,
        questionsAmount: questionsAmount ?? this.questionsAmount,
        shareCode: shareCode ?? this.shareCode
    );
  }

  Map<String, dynamic> toJSON(){
    return {
      'image':this.image,
      'public':this.public,
      'questionsAmount':this.questionsAmount,
      'shareCode':this.shareCode,
      'title':this.title,
      'uid':this.uid
    };
  }

}