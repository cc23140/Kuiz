import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:kuiz_app/models/user_model.dart";
import "package:kuiz_app/services/database_service.dart";
import "package:kuiz_app/widgets/card_widget.dart";
import "../../models/quiz_model.dart";
import "./functions/home_functions.dart";
class SearchScreen extends StatelessWidget {
  SearchScreen({super.key, required this.searchController});
  
  final TextEditingController searchController;
  final DatabaseService _databaseService = DatabaseService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Voltar para o menu")
      ),
      body: StreamBuilder(stream: _databaseService.getSearchedQuizzes(searchStr: searchController.text),
          builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.waiting){
              return const SizedBox(width: 50, height: 50, child: CircularProgressIndicator(),);
            }
            if(snapshot.hasError){
              throw Exception('Erro: ${snapshot.error}');
            }
            if(!snapshot.hasData || snapshot.data == null){
              return Align(alignment: Alignment.center, child: Text('Não há quizzes encontrados!'),);
            }

            final quizzes = snapshot.data!.docs;

            List<Future<UserKuiz>> users = quizzes.map((quizDoc){
              final quizData = quizDoc.data() as Quiz;
              return _databaseService.getUser(uid: quizData.uid);
            }).toList();

            return FutureBuilder(future: Future.wait(users),
              builder: (context, userSnapshot){
                  if(userSnapshot.connectionState == ConnectionState.waiting){
                    return const SizedBox(width: 50, height: 50, child: CircularProgressIndicator(),);
                  }
                  if(userSnapshot.hasError){
                    return Text('Erro: ${userSnapshot.error}');
                  }
                  if(!userSnapshot.hasData || userSnapshot.data == null){
                    return Text('Não foi possível carregar usuários!');
                  }
                  
                  return GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                      itemCount: quizzes.length,
                      itemBuilder: (context, index){
                        final quiz = quizzes[index].data() as Quiz;
                        final user = userSnapshot.data![index] as UserKuiz;


                        return CardWidget(title: quiz.title, creatorUsername: user.username, image: quiz.image);
                      });
              },
            );

            
          })
        
    );
  }
}

