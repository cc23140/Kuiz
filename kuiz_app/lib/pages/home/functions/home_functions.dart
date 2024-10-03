import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:kuiz_app/pages/home/search_screen.dart";

import "../../../models/quiz_model.dart";
import "../../../models/user_model.dart";
import "../../../services/database_service.dart";
import "../../../widgets/card_widget.dart";

class HomeScreenFunctions {
  static PreferredSizeWidget buildAppBar(BuildContext context, TextEditingController _searchController){
    return AppBar(
        leading: Builder(
            builder: (context) {
              return IconButton(
                  icon: const Icon(Icons.menu, size: 40,),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  }
              );

            }
        ),

        title: Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.6,
            height: 40,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5)
                ),
                hintText: "Pesquise aqui",
                hintStyle: TextStyle(
                    color: Colors.grey
                ),
                suffixIcon: IconButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen(searchController: _searchController)));
                  },
                  icon: Icon(Icons.search, size: 20)  ,
                ),
                suffixIconColor: Colors.grey,
              ),
              style: TextStyle(
                  height: 1
              ),
              textAlignVertical: TextAlignVertical.center,
            ),
          ),
        )
    );
  }


  static Widget buildCreatedQuizzes(BuildContext context, DatabaseService _databaseService){
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

  static Widget buildGeneralQuizzes(BuildContext context, DatabaseService _databaseService){
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
                        return const Text('Usuário não encontrado!');
                      }
                      final user = userSnapshot.data as UserKuiz;
                      return CardWidget(title: quiz.title, creatorUsername: user.username, image: quiz.image);
                    }
                );
              }
          );
        }
    );
  }
}