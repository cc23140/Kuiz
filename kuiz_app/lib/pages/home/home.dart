import 'package:kuiz_app/models/user_model.dart';
import 'package:kuiz_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kuiz_app/services/database_service.dart';

import '../../services/auth_service.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final _databaseService = DatabaseService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Hello👋',
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    )
                ),
              ),
              const SizedBox(height: 10,),
              _username(_databaseService, context),
              Text(
                FirebaseAuth.instance.currentUser!.email!.toString(),
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    )
                ),
              ),
              const SizedBox(height: 30,),
              _logout(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _logout(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff0D6EFD),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        minimumSize: const Size(double.infinity, 60),
        elevation: 0,
      ),
      onPressed: () async {
        await AuthService().signout(context: context);
      },
      child: const Text("Sign Out"),
    );
  }
}

Widget _username(DatabaseService _databaseService, BuildContext context) {
  return FutureBuilder<UserKuiz>(future: _databaseService.getUser(uid: FirebaseAuth.instance.currentUser!.uid),
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return CircularProgressIndicator();
        }
        else if(snapshot.hasError){
          return Text('Erro ${snapshot.error}');
        }
        else if(!snapshot.hasData || snapshot.data == null){
          return Text('Erro');
        }

        final user = snapshot.data!;

        return Text(user.username);
      });
}