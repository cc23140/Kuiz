import "package:carousel_slider/carousel_slider.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:kuiz_app/models/card_info.dart";
import "package:kuiz_app/pages/account_details/account_details_screen.dart";
import "package:kuiz_app/pages/answer_quiz/answer_quiz_home_screen.dart";
import "package:kuiz_app/pages/answer_quiz/answer_quiz_screen.dart";
import "package:kuiz_app/pages/home/home_screen.dart";
import "package:kuiz_app/pages/home/search_screen.dart";

import "../../../models/quiz_model.dart";
import "../../../models/user_model.dart";
import "../../../services/auth_service.dart";
import "../../../services/database_service.dart";
import "../../../widgets/card_widget.dart";
import "../../creation/creation_quiz_screen.dart";
import "../../login/login.dart";

class HomeScreenFunctions {
  static PreferredSizeWidget buildAppBar(BuildContext context, TextEditingController _searchController){
    return AppBar(
        leading: Builder(
            builder: (context) {
              return Align(
                alignment: Alignment.center,
                child: IconButton(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0  ),
                    icon: const Icon(Icons.menu, size: 36,color: Colors.blue,),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    }
                ),
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
              maxLines: 1,
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
                    if(_searchController.text.length > 0){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen(searchController: _searchController)));
                    }
                    else{
                      //Avisar ao usuário escrever sobre o que pesquisar
                    }

                  },
                  icon: Icon(Icons.search, size: 20)  ,
                ),
                suffixIconColor: Colors.grey,
                isDense: true
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
    List<CardInfo> items = [];
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

          return snapshot.data!.docs.isNotEmpty ? FutureBuilder(
                    future: Future.wait(snapshot.data!.docs.map((doc)async{
                      final quiz = doc.data() as Quiz;
                      final user = await _databaseService.getUser(uid: quiz.uid);
                      return CardInfo(title: quiz.title, username: user.username, image: quiz.image, quizId: quiz.quizId);
                    }).toList()),
                    builder: (context, userSnapshot){

                      if(userSnapshot.connectionState == ConnectionState.waiting){
                        return const CircularProgressIndicator();
                      }
                      if(userSnapshot.hasError){
                        return Text('Erro: ${userSnapshot.error}');
                      }
                      if( !userSnapshot.hasData || userSnapshot.data == null){
                        return const Text('Você não criou nenhum quiz!');
                      }
                      items = userSnapshot.data as List<CardInfo>;
                      return CarouselSlider(
                        options: CarouselOptions(
                          viewportFraction: 0.8,
                            height: 300.0,
                            enableInfiniteScroll: false,
                            scrollPhysics: BouncingScrollPhysics()
                        ),
                        items: items.map((cardInfo) {
                          return Builder(
                            builder: (BuildContext context) {
                              return CardWidget(
                                  title: cardInfo.title,
                                  creatorUsername: cardInfo.username,
                                  image: cardInfo.image,
                                  quizId: cardInfo.quizId,
                              );
                            },
                          );
                        }).toList(),
                      );
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
    List<CardInfo> items = [];
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
          return FutureBuilder(future: Future.wait(snapshot.data!.docs.map((doc)async{
                  final quiz = doc.data() as Quiz;
                  final user = await _databaseService.getUser(uid: quiz.uid);
                  return CardInfo(title: quiz.title, username: user.username, image: quiz.image, quizId: quiz.quizId);
                }).toList()),
                    builder: (context, cardSnapshot){
                      if(cardSnapshot.connectionState == ConnectionState.waiting){
                        return const CircularProgressIndicator();
                      }
                      else if(cardSnapshot.hasError || !cardSnapshot.hasData || cardSnapshot.data == null){
                        return const Text('Usuário não encontrado!');
                      }

                      items = cardSnapshot.data as List<CardInfo>;
                      return CarouselSlider(
                        options: CarouselOptions(
                            viewportFraction: 0.8,
                            height: 300.0,
                            enableInfiniteScroll: false,
                            scrollPhysics: BouncingScrollPhysics()
                        ),
                        items: items.map((cardInfo) {
                          return Builder(
                            builder: (BuildContext context) {
                              return CardWidget(title: cardInfo.title, creatorUsername: cardInfo.username, image: cardInfo.image, quizId: cardInfo.quizId,);
                            },
                          );
                        }).toList(),
                      );
                    }
                );
        }
    );


  }

  static Widget buildAppDrawer(BuildContext context){
    return Drawer(
        backgroundColor: Colors.white,
        child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.white
                  ),
                  child: Row(
                      children: [
                        Icon(Icons.settings, color: Colors.grey, size: 32,),
                        SizedBox(width: 10,),
                        Text('Configurações', style: TextStyle(fontSize: 22, color: Colors.black54),),
                      ],
                    )
              ),
              ListTile(
                title: const Text('Acessar perfil'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> AccountDetailsScreen()));
                },
                trailing: const Icon(Icons.person),
              ),
              const Divider(
                color: Colors.grey,
                thickness: 0.5,
              ),
              ListTile(
                title: const Text('Criar quiz'),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> CreationQuizScreen()));
                },
                trailing: const Icon(Icons.create),
              ),
              const Divider(
                color: Colors.grey,
                thickness: 0.5,
              ),
              ListTile(
                title: const Text('Acessar quiz'),
                onTap: (){
                  buildDialog(context);
                },
                trailing: const Icon(Icons.code),
              ),
              const Divider(
                color: Colors.grey,
                thickness: 0.5,
              ),
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.3,),
              ListTile(
                title: Text('Sair da conta'),
                trailing: Icon(Icons.exit_to_app, color: Colors.redAccent,),
                onTap: (){
                  AuthService().signout(context: context);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
                },
              )
            ]
        )
    );
  }

  static void buildDialog(BuildContext context){
    final _databaseService = DatabaseService();
    final acessCodeController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            height: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(
                  flex: 2,
                    child: Text(
                      'Código de Compartilhamento',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    )
                ),
                Expanded(flex: 1,child: TextField(controller: acessCodeController, decoration: const InputDecoration(hintText: 'Digite aqui o código de acesso'),)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async{
                    await _databaseService.getQuizByCode(shareCode: acessCodeController.text)
                    .then((quiz){
                      if(quiz != null){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>AnswerQuizHomeScreen(quizId: quiz.quizId)));
                      }
                    });
                  },
                  child: const Text('Acessar Quiz'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}