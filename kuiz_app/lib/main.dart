import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kuiz_app/pages/home/home.dart';
import 'package:kuiz_app/pages/home/home_screen.dart';
import 'package:kuiz_app/pages/signup/signup.dart';
import 'package:kuiz_app/theme/default_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled:true,
  );

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final uid = sharedPreferences.get('uid');
  runApp(
      MaterialApp(
        theme: defaultTheme,
          debugShowCheckedModeBanner:false,
          home: uid != null ? SafeArea(child: HomeScreen()) : SafeArea(child: Signup())));
}