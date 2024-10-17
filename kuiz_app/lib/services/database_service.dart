import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/question_model.dart';
import '../models/quiz_model.dart';
import '../models/user_model.dart';

const String USER_COLLECTION_REF = 'users';
const String QUIZ_COLLECTION_REF = 'quizzes';
const String QUESTIONS_COLLECTION_REF = 'questions';

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _usersRef;

  late final CollectionReference _quizzesRef;

  late final CollectionReference _questionsRef;

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

  Stream<QuerySnapshot?> getCreatedQuizzes({required String uid}) {
    return _quizzesRef.limit(7).where('uid', isEqualTo: uid).snapshots();
  }

  Stream<QuerySnapshot?> getGeneralQuizzes(){
    return _quizzesRef.limit(10).where('public', isEqualTo: true).snapshots();
  }
  
  Stream<QuerySnapshot?> getSearchedQuizzes({required String searchStr}){
    searchStr = searchStr.toLowerCase();
    ///TODO
    return _quizzesRef.where('public', isEqualTo: true).orderBy('title').startAt(['Filo']).endAt(['Filo']).limit(10)
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