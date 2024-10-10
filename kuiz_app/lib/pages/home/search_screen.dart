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
      appBar: HomeScreenFunctions.buildAppBar(context, searchController),
      body: StreamBuilder(stream: _databaseService.getSearchedQuizzes(searchStr: searchController.text),
          builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.waiting){
              return SizedBox(width: 50, height: 50, child: CircularProgressIndicator(),);
            }
            if(snapshot.hasError){
              throw Exception('Erro: ${snapshot.error}');
            }
            if(!snapshot.hasData || snapshot.data == null){
              return Align(alignment: Alignment.center, child: Text('Não há quizzes encontrados!'),);
            }

            return GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemBuilder: (context, index){
                  final quiz = snapshot.data!.docs[index].data() as Quiz;
                  FutureBuilder(future: _databaseService.getUser(uid: quiz.uid),
                    builder: (context, userSnapshot){
                      if(userSnapshot.connectionState == ConnectionState.waiting){
                        return SizedBox(width: 50, height: 50, child: CircularProgressIndicator(),);
                      }
                      if(userSnapshot.hasError){
                        return Text('${userSnapshot.error}');
                      }
                      if(!userSnapshot.hasData || userSnapshot.data == null){
                        return Text('Usuário não encontrado!');
                      }

                      final user = userSnapshot.data as UserKuiz;
                      return CardWidget(title: quiz.title, creatorUsername: user.username, image: quiz.image);
                    });
                }
            );
          }),
      drawer: HomeScreenFunctions.buildAppDrawer(context),
        
    );
  }
}

