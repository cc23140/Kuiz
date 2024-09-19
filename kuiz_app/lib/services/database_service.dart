import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/quiz_model.dart';
import '../models/user_model.dart';

const String USER_COLLECTION_REF = 'users';
const String QUIZ_COLLECTION_REF = 'quizzes';

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _usersRef;

  late final CollectionReference _quizzesRef;

  DatabaseService(){
    _usersRef = _firestore.collection(USER_COLLECTION_REF).withConverter<UserKuiz>(
        fromFirestore: (snapshots, _) => UserKuiz.fromJSON(snapshots.data()!,),
        toFirestore: (user, _) => user.toJSON()
    );

    _quizzesRef = _firestore.collection(QUIZ_COLLECTION_REF).withConverter<Quiz>(
        fromFirestore: (snapshots, _) => Quiz.fromJSON(snapshots.data()!),
        toFirestore: (quiz, _) => quiz.toJSON()
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

  Future<List<QueryDocumentSnapshot?>?> getSearchQuizzes({required String title}) async{
    final querySnapshot = await _quizzesRef.where('title', isEqualTo: title).where('public', isEqualTo: true).get();

    if(querySnapshot.docs.isNotEmpty){
      return querySnapshot.docs.toList();
    }
  }


  Future<Quiz?> getQuizByCode({required String shareCode}) async{
    final querySnapshots = await _quizzesRef.where('shareCode', isEqualTo: shareCode).get();

    if(querySnapshots.docs.isNotEmpty){
      return querySnapshots.docs.first as Quiz;
    }
  }
  

}