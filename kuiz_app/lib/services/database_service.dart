import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kuiz_app/models/alternative_model.dart';

import '../models/question_model.dart';
import '../models/quiz_model.dart';
import '../models/user_model.dart';

import 'dart:math';

const String USER_COLLECTION_REF = 'users';
const String QUIZ_COLLECTION_REF = 'quizzes';
const String QUESTIONS_COLLECTION_REF = 'questions';
const String ALTERNATIVES_COLLECTION_REF = 'alternatives';

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _usersRef;

  late final CollectionReference _quizzesRef;

  late final CollectionReference _questionsRef;

  late final CollectionReference _alternativesRef;

  DatabaseService(){
    _usersRef = _firestore.collection(USER_COLLECTION_REF).withConverter<UserKuiz>(
        fromFirestore: (snapshots, _) => UserKuiz.fromJSON(snapshots.data()!,),
        toFirestore: (user, _) => user.toJSON()
    );

    _quizzesRef = _firestore.collection(QUIZ_COLLECTION_REF).withConverter<Quiz>(
        fromFirestore: (snapshots, _) => Quiz.fromJSON(snapshots.data()!),
        toFirestore: (quiz, _) => quiz.toJSON()
    );

    _questionsRef = _firestore.collection(QUESTIONS_COLLECTION_REF).withConverter<Question>(
        fromFirestore: (snapshots, _) => Question.fromJSON(snapshots.data()!),
        toFirestore: (question, _) => question.toJSON()
    );

    _alternativesRef = _firestore.collection(ALTERNATIVES_COLLECTION_REF).withConverter<Alternative>(
        fromFirestore: (snapshots, _)=> Alternative.fromJSON(snapshots.data()!),
        toFirestore: (alternative, _)=> alternative.toJSON()
    );

  }


  //USER

  Stream<QuerySnapshot?> getUsers(){
    return _usersRef.snapshots();
  }
  
  Future<UserKuiz> getUser({required String uid}) async{
    final querySnapshot = await _usersRef.where('uid', isEqualTo: uid).get();

    if(querySnapshot.docs.isNotEmpty) {
      final doc = querySnapshot.docs.first;
      return doc.data() as UserKuiz;
    }
    throw Exception("User doesn't exist");
  }

  void addUser(UserKuiz user) async{
    _usersRef.add(user);
  }


  //QUIZ
  void addQuiz(Quiz quiz, List<Question> questions) async{
    final _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final _random = Random();
    String quizId = List.generate(20, (index)=> _chars[_random.nextInt(_chars.length)]).join();
    quiz = quiz.copyWith(quizId: quizId);
    _quizzesRef.add(quiz);
    questions.forEach((question){
      String questionId = List.generate(26, (index)=> _chars[_random.nextInt(_chars.length)]).join();
      question = question.copyWith(quizId: quizId,questionId: questionId);
      _questionsRef.add(question);

      question.alternatives.forEach((alternative){
        String alternativeId = List.generate(28, (index)=> _chars[_random.nextInt(_chars.length)]).join();
        alternative = alternative.copyWith(questionId: questionId, alternativeId: alternativeId);
        _alternativesRef.add(alternative);
      });
    });
  }

  Stream<QuerySnapshot?> getCreatedQuizzes({required String uid}) {
    return _quizzesRef.limit(7).where('uid', isEqualTo: uid).snapshots();
  }

  Stream<QuerySnapshot?> getGeneralQuizzes(){
    return _quizzesRef.limit(10).where('public', isEqualTo: true).snapshots();
  }
  
  Stream<QuerySnapshot?> getSearchedQuizzes({required String searchStr}){
    return _quizzesRef.where('public', isEqualTo: true).orderBy('title').startAt([searchStr]).endAt([searchStr]).limit(10)
        .snapshots();

        
  }

  Future<Quiz?> getQuizByCode({required String shareCode}) async{
    final querySnapshots = await _quizzesRef.where('shareCode', isEqualTo: shareCode).get();

    if(querySnapshots.docs.isNotEmpty){
      return querySnapshots.docs.first as Quiz;
    }
  }
  
  
  //QUESTION
  Stream<QuerySnapshot?> getQuestionsByQuizId({required String quizId}){
    return _questionsRef.where('quizId', isEqualTo: quizId).snapshots();
  }

}