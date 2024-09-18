import 'package:cloud_firestore/cloud_firestore.dart';

class UserKuiz {
  final String uid;
  final String username;
  final double completedQuizzes;

  UserKuiz({
    required this.uid,
    required this.username,
    required this.completedQuizzes
  });

  UserKuiz.fromJSON(Map<String, dynamic> json) :
        this(uid:json['uid']! as String,
          username: json['username']! as String,
          completedQuizzes: json['completedQuizzes']! as double
      );

  UserKuiz copyWith(
      String? uid,
      String? username,
      double? completedQuizzes
      ){
    return UserKuiz(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      completedQuizzes: completedQuizzes ?? this.completedQuizzes
    );
  }

  Map<String, Object?> toJSON(){
    return {
      'uid':this.uid,
      'username':this.username,
      'completedQuizzes':this.completedQuizzes
    };
  }
}