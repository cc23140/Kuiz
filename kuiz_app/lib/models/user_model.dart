import 'package:cloud_firestore/cloud_firestore.dart';

class UserKuiz {
  final String uid;
  final String username;
  final String email;
  final double completedQuizzes;

  UserKuiz({
    required this.uid,
    required this.username,
    required this.email,
    required this.completedQuizzes
  });

  UserKuiz.fromJSON(Map<String, dynamic> json) :
        this(uid:json['uid']! as String,
          username: json['username']! as String,
          email: json['email'] as String,
          completedQuizzes: json['completedQuizzes']! as double
      );

  UserKuiz copyWith(
      String? uid,
      String? username,
      String? email,
      double? completedQuizzes
      ){
    return UserKuiz(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      email: email ?? this.email,
      completedQuizzes: completedQuizzes ?? this.completedQuizzes
    );
  }

  Map<String, dynamic> toJSON(){
    return {
      'uid':this.uid,
      'username':this.username,
      'email':this.email,
      'completedQuizzes':this.completedQuizzes
    };
  }
}