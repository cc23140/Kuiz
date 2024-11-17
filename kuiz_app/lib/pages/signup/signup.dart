import 'package:firebase_auth/firebase_auth.dart';
import 'package:kuiz_app/models/user_model.dart';
import 'package:kuiz_app/pages/home/home_screen.dart';
import 'package:kuiz_app/pages/login/login.dart';
import 'package:kuiz_app/services/auth_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kuiz_app/services/database_service.dart';

import '../../services/auth_service.dart';
import '../login/login.dart';

class Signup extends StatelessWidget {
  Signup({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  final _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: _signin(context),
        body: SafeArea(
          child:  SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
            child: Column(
              children: [
                Center(
                  child: Text(
                    'Olá,',
                    style: GoogleFonts.raleway(
                        textStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24
                        )
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'bem-vindo ao Kuiz',
                    style: GoogleFonts.raleway(
                        textStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 30
                        )
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    '-seu app de criação de quizzes',
                    style: GoogleFonts.raleway(
                        textStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        )
                    ),
                  ),
                ),
                const SizedBox(height: 80,),
                _username(),
                const SizedBox(height: 20,),
                _emailAddress(),
                const SizedBox(height: 20,),
                _password(),
                const SizedBox(height: 50,),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: _signup(context),
                ),
              ],
            ),

          ),
        )
    );
  }

  Widget _username(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            'Username',
        ),
        const SizedBox(height: 8,),
        SizedBox(
          width: 325,
          height: 50,
          child: TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              hintText: 'Crie seu username aqui',
            ),
          ),
        )

      ],
    );
  }

  Widget _emailAddress() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email',
        ),
        const SizedBox(height: 8,),
        SizedBox(
          width: 325,
          height: 50,
          child: TextField(
            controller: _emailController,
            decoration: InputDecoration(
              hintText: 'Digite seu email aqui',
            ),
          ),
        )

      ],
    );
  }

  Widget _password() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Senha',
        ),
        const SizedBox(height: 8,),
        SizedBox(
          width: 325,
          height: 50,
          child: TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
                hintText: 'Crie sua senha aqui'
            ),
          ),
        )

      ],
    );
  }

  Widget _signup(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 50,
      child: ElevatedButton(

        onPressed: () async {
          bool? response = await AuthService().signup(
              email: _emailController.text,
              password: _passwordController.text,
              context: context
          );
          if(response == null) {
            return;
          }

          _databaseService.addUser(UserKuiz(uid: FirebaseAuth.instance.currentUser!.uid,
              username: _usernameController.text,
              email: FirebaseAuth.instance.currentUser!.email!,
              completedQuizzes: 0));

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
        },
        child: Text("Cadastrar"),
      ),
    );
  }

  Widget _signin(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              children: [
                const TextSpan(
                  text: "Já está com a gente? ",
                  style: TextStyle(
                      color: Color(0xff6A6A6A),
                      fontWeight: FontWeight.normal,
                      fontSize: 16
                  ),
                ),
                TextSpan(
                    text: "Entre por aqui",
                    style: const TextStyle(
                        color: Color(0xff1A1D1E),
                        fontWeight: FontWeight.normal,
                        fontSize: 16
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Login()
                        ),
                      );
                    }
                ),
              ]
          )
      ),
    );
  }
}