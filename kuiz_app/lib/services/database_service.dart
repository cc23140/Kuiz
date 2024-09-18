import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

const String USER_COLLECTION_REF = 'users';
const String QUIZ_COLLECTION_REF = 'quizzes';

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _usersRef;

  DatabaseService(){
    _usersRef = _firestore.collection(USER_COLLECTION_REF).withConverter<UserKuiz>(
        fromFirestore: (snapshots, _) => UserKuiz.fromJSON(snapshots.data()!,),
        toFirestore: (user, _) => user.toJSON()
    );

  }


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
}