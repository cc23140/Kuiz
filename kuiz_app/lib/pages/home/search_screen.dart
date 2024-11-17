import "package:carousel_slider/carousel_slider.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:kuiz_app/models/card_info.dart";
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
    List<CardInfo> cardsInfo = [];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back, color: Colors.blue)),
        title: const Text("Voltar para o menu", style: TextStyle(color: Colors.blue),),

      ),
      body: StreamBuilder(stream: _databaseService.getSearchedQuizzes(searchStr: searchController.text),
          builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.waiting){
              return const Align(alignment: AlignmentDirectional.center, child: SizedBox(width: 200, height: 200, child: CircularProgressIndicator(),),);
            }
            if(snapshot.hasError){
              throw Exception('Erro: ${snapshot.error}');
            }
            if(!snapshot.hasData || snapshot.data == null){
              return const Align(alignment: Alignment.center, child: Text('Não há quizzes encontrados!'),);
            }

            return snapshot.data!.docs.isNotEmpty ? FutureBuilder(
                future: Future.wait(snapshot.data!.docs.map((doc)async{
                  final quiz = doc.data() as Quiz;
                  final user = await _databaseService.getUser(uid: quiz.uid);
                  return CardInfo(title: quiz.title, username: user.username, image: quiz.image, quizId: quiz.quizId);
                }).toList()),
                builder: (context, listOfCardsSnapshot){

                  if(listOfCardsSnapshot.connectionState == ConnectionState.waiting){
                    return const Align(alignment: AlignmentDirectional.center, child: SizedBox(width: 200, height: 200, child: CircularProgressIndicator(),),);
                  }
                  if(listOfCardsSnapshot.hasError){
                    return Align(alignment: AlignmentDirectional.center, child: SizedBox(width: 200, height: 200, child: Text('Erro: ${listOfCardsSnapshot.error}'),),);
                  }
                  if(!listOfCardsSnapshot.hasData || listOfCardsSnapshot.data == null){
                    return const Align(alignment: AlignmentDirectional.center, child: SizedBox(width: 200, height: 200, child: Text('Falha ao encontrar o criados de cada quiz'),),);
                  }


                  cardsInfo = listOfCardsSnapshot.data as List<CardInfo>;

                  return CarouselSlider(
                      options: CarouselOptions(
                          scrollDirection: Axis.vertical,
                          viewportFraction: 0.45,
                          height: MediaQuery.of(context).size.height,
                          enableInfiniteScroll: false,
                          scrollPhysics: BouncingScrollPhysics()
                      ),
                      items: cardsInfo.map((cardInfo) {
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
              child: const Text(
                "Nenhum quiz encontrado!",
                style: TextStyle(fontSize: 14),)
              ,);
            }
          )
        
    );
  }
}

