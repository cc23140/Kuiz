import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:kuiz_app/pages/home/home.dart';
import 'package:kuiz_app/pages/signup/signup.dart';

class AuthService {

  Future<void> signup({
    required String email,
    required String password,
    required BuildContext context
  }) async{
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      await Future.delayed(const Duration(seconds: 1));
      Navigator.push(context, MaterialPageRoute(builder: (context)=> const Home()));
    }on FirebaseAuthException catch(e){
      String message = '';
      if(e.code == 'weak-password'){
        message = 'The password provided is too weak';
      }else if(e.code == 'email-already-in-use'){
        message = 'An account already exists with that email';
      }

      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14
      );
    }
    catch(e){

    }
  }

  Future<void> signin({
    required String email,
    required String password,
    required BuildContext context
  }) async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      await Future.delayed(const Duration(seconds: 1));

      Navigator.push(context, MaterialPageRoute(builder: (context)=> const Home()));
    }on FirebaseAuthException catch(e){
      String message = '';
      if(e.code == 'user-not-found'){
        message = 'No user found for that email';
      }
      else if(e.code == 'wrong-password'){
        message = 'Wrong password provided for that user';
      }

      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 14
      );
    }
    catch (e){

    }
  }


  Future<void> signout({required BuildContext context}) async{
    try{
      await FirebaseAuth.instance.signOut();
      await Future.delayed(const Duration(seconds: 1));
      Navigator.push(context, MaterialPageRoute(builder: (context)=> Signup()));
    }on FirebaseAuthException catch(e){

    }
  }
}