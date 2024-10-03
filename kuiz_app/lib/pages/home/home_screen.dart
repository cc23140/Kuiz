import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kuiz_app/pages/login/login.dart';
import 'package:kuiz_app/pages/signup/signup.dart';
import 'package:kuiz_app/services/auth_service.dart';
import 'package:kuiz_app/services/database_service.dart';
import 'package:async/async.dart';
import 'package:kuiz_app/widgets/card_widget.dart';
import 'package:kuiz_app/models/quiz_model.dart';

import '../../models/user_model.dart';

class HomeScreen extends StatelessWidget {

  HomeScreen({super.key});

  final _databaseService = DatabaseService();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: Builder(
                builder: (context) {
                  return IconButton(
                      icon: const Icon(Icons.menu, size: 40,),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      }
                  );
                }
            )
        ),
        body: Column(
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
              child: _buildCreatedQuizzes(context, _databaseService),
            ),

            const Text(
              'Quizzes da comunidade'
            ),

            SizedBox(
              height: 225,
              width: MediaQuery.sizeOf(context).width,
              child: _buildGeneralQuizzes(context, _databaseService),
            )
          ],
        ),
        drawer: Drawer(
            child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(
                        color: Colors.blue
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.settings),
                        Text('Configurações'),
                      ],
                    )

                  ),

                  const ListTile(
                      title: const Text('Conta')
                  ),
                  ListTile(
                      title: const Text('Acessar perfil'),
                      onTap: () {
                          ///TODO
                      }
                  ),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.4,),
                  ListTile(
                    title: Text('Sair da conta'),
                    leading: Icon(Icons.exit_to_app),
                    onTap: (){
                      AuthService().signout(context: context);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
                    },
                  )
                ]
            )
        )
    );
  }
}


Widget _buildCreatedQuizzes(BuildContext context, DatabaseService _databaseService){
  return StreamBuilder(stream: _databaseService.getCreatedQuizzes(uid: FirebaseAuth.instance.currentUser!.uid),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return const CircularProgressIndicator();
        }
        else if(snapshot.hasError){
          return Text('Um erro ocorreu!');
        }
        else if(!snapshot.hasData || snapshot.data == null){
          return const Text('Você não criou nenhum quiz');
        }

        return snapshot.data!.docs.isNotEmpty ? ListView.builder(
          scrollDirection: Axis.horizontal,
            physics: const ScrollPhysics(),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index){
              final quiz = snapshot.data!.docs[index].data() as Quiz;
              return FutureBuilder(future: _databaseService.getUser(uid: quiz.uid),
                  builder: (context, userSnapshot){
                    if(userSnapshot.connectionState == ConnectionState.waiting){
                    return const CircularProgressIndicator();
                    }
                    else if(userSnapshot.hasError || !userSnapshot.hasData || userSnapshot.data == null){
                    return const Text('Ve oq deu errado aí');
                    }
                    final user = userSnapshot!.data! as UserKuiz;
                    return CardWidget(title: quiz.title, creatorUsername: user.username, image: quiz.image);

                  });
            }
        ) : Container(alignment: Alignment.center,
        child: Text(
          "Você ainda não criou um quiz",
          style: TextStyle(fontSize: 14),)
          ,);
      }
  );
}

Widget _buildGeneralQuizzes(BuildContext context, DatabaseService _databaseService){
  return StreamBuilder(stream: _databaseService.getGeneralQuizzes(),
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return const CircularProgressIndicator();
        }
        else if(snapshot.hasError){
          return Text('Erro: ${snapshot.error}');
        }
        else if(!snapshot.hasData || snapshot.data == null){
          return const Text('Não há quizzes gerais');
        }
        return ListView.builder(itemCount: snapshot.data!.docs.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index){
              final quiz = snapshot.data!.docs[index].data() as Quiz;
              return FutureBuilder(future: _databaseService.getUser(uid: quiz.uid),
                      builder: (context, userSnapshot){
                        if(userSnapshot.connectionState == ConnectionState.waiting){
                          return const CircularProgressIndicator();
                        }
                        else if(userSnapshot.hasError || !userSnapshot.hasData || userSnapshot.data == null){
                          return const Text('Ve oq deu errado aí');
                        }
                        final user = userSnapshot!.data! as UserKuiz;
                        return CardWidget(title: quiz.title, creatorUsername: user.username, image: quiz.image);
                      }
                  );
            }
        );
      }
  );
}