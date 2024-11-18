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
  Future<void> addQuiz(Quiz quiz, List<Question> questions) async{
    final _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final _random = Random();
    String quizId = List.generate(20, (index)=> _chars[_random.nextInt(_chars.length)]).join();
    quiz = quiz.copyWith(quizId: quizId);
    _quizzesRef.add(quiz);
    for (var question in questions) {
      String questionId = List.generate(26, (index)=> _chars[_random.nextInt(_chars.length)]).join();
      final questionAlternatives = question.getAlternatives();
      question = question.copyWith(quizId: quizId, questionId: questionId);
      question.setAlternatives(questionAlternatives);
      _questionsRef.add(question);


      for (var alternative in question.alternatives!) {
        String alternativeId = List.generate(28, (index)=> _chars[_random.nextInt(_chars.length)]).join();
        alternative = alternative.copyWith(questionId: questionId, alternativeId: alternativeId);
        _alternativesRef.add(alternative);
      }
    }
  }

  Future<List<Question>> getQuestions(String quizId) async{
    Stream<QuerySnapshot> querySnapshots = _questionsRef.where('quizId', isEqualTo: quizId).snapshots();
    QuerySnapshot snapshot = await querySnapshots.first;
    return snapshot.docs.map((doc){
      Question question = doc.data() as Question;
      getAlternatives(question.questionId)
        .then((alternatives)=>question.setAlternatives(alternatives));
      return question;
    }).toList();
  }
  
  Future<List<Alternative>> getAlternatives(String questionId) async{
    Stream<QuerySnapshot> querySnapshots = _alternativesRef.where('questionId', isEqualTo: questionId).snapshots();
    QuerySnapshot snapshot = await querySnapshots.first;
    return snapshot.docs.map((doc){
      return doc.data() as Alternative;
    }).toList();
  }

  Future<Quiz?> getQuiz({required String quizId}) async{
    final querySnapshots = await _quizzesRef.where('quizId',isEqualTo: quizId).get();
    if(querySnapshots.docs.isNotEmpty){
      return querySnapshots.docs.first.data() as Quiz;
    }
  }

  Stream<QuerySnapshot?> getCreatedQuizzes({required String uid}) {
    return _quizzesRef.limit(15).where('uid', isEqualTo: uid).snapshots();
  }

  Stream<QuerySnapshot?> getGeneralQuizzes(){
    return _quizzesRef.limit(10).where('public', isEqualTo: true).snapshots();
  }
  
  Stream<QuerySnapshot?> getSearchedQuizzes({required String searchStr}){
    String endStr = searchStr.substring(0, searchStr.length - 1) +
        String.fromCharCode(searchStr.codeUnitAt(searchStr.length - 1) + 1);
    return _quizzesRef.where('public', isEqualTo: true).orderBy('title').startAt([searchStr]).endAt([endStr]).limit(10).snapshots();
  }

  Future<Quiz?> getQuizByCode({required String shareCode}) async{
    final querySnapshots = await _quizzesRef.where('shareCode', isEqualTo: shareCode).get();

    if(querySnapshots.docs.isNotEmpty){
      return querySnapshots.docs.first.data() as Quiz;
    }
  }


}