import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kuiz_app/pages/creation/creation_quiz_screen.dart';
import 'package:kuiz_app/pages/login/login.dart';
import 'package:kuiz_app/pages/signup/signup.dart';
import 'package:kuiz_app/services/auth_service.dart';
import 'package:kuiz_app/services/database_service.dart';
import 'package:async/async.dart';
import 'package:kuiz_app/widgets/card_widget.dart';
import 'package:kuiz_app/models/quiz_model.dart';
import './functions/home_functions.dart';

import '../../models/user_model.dart';

class HomeScreen extends StatelessWidget {

  HomeScreen({super.key});

  final _databaseService = DatabaseService();
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HomeScreenFunctions.buildAppBar(context, _searchController),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            textDirection: TextDirection.ltr,
            children: [
              const Text(
                'Quizzes criados',
                style: TextStyle(
                    fontSize: 28
                ),
              ),
              SizedBox(
                height: 225,
                width: MediaQuery.sizeOf(context).width,
                child: HomeScreenFunctions.buildCreatedQuizzes(context, _databaseService),
              ),

              const Text(
                  'Quizzes da comunidade'
              ),

              SizedBox(
                height: 225,
                width: MediaQuery.sizeOf(context).width,
                child: HomeScreenFunctions.buildGeneralQuizzes(context, _databaseService),
              )
            ],
          ),
        ),
        drawer: HomeScreenFunctions.buildAppDrawer(context)
    );
  }
}

