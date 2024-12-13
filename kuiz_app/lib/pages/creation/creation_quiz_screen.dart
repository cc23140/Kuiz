import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kuiz_app/models/question_model.dart';
import 'package:kuiz_app/pages/creation/creation_question_screen.dart';
import 'package:kuiz_app/pages/home/home_screen.dart';
import 'package:kuiz_app/services/database_service.dart';
import '../../models/quiz_model.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

final _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
final _random = Random();
const String DEFAULT_IMAGE_URL = 'https://i.pinimg.com/originals/55/0c/80/550c80a326b9d687b038b5f5f72b0724.jpg';

class CreationQuizScreen extends StatefulWidget {
  CreationQuizScreen({super.key});

  @override
  State<CreationQuizScreen> createState() => _CreationQuizScreenState();
}

class _CreationQuizScreenState extends State<CreationQuizScreen> {
  final DatabaseService _databaseService = DatabaseService();

  String quizCode = '';

  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _linkImgController = TextEditingController();

  List<Question> questions = <Question>[];

  bool isPublic = true;

  @override
  void initState() {
    super.initState();
    _linkImgController.text = DEFAULT_IMAGE_URL;
    quizCode = List.generate(6, (index)=> _chars[_random.nextInt(_chars.length)]).join();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criação de Quiz'),
        toolbarHeight: 100,
      ),
      body:SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.8,
                    child: TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                          label: Text('Intitule seu quiz:', style: TextStyle()),
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                          prefixIcon: const Icon(Icons.quiz)
                      ),
                    ),
                  )
              ),
            ),

            Center(
              child: Padding(padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.8,
                    child: TextField(
                      controller: _linkImgController,
                      decoration: InputDecoration(
                          label: Text('Link da Imagem (Opcional)', style: TextStyle()),
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                          prefixIcon: const Icon(Icons.image)
                      ),
                    ),
                  )
              ),
            ),
            Center(
              child: Padding(padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.8,
                    child: TextField(
                      enabled: false,
                      decoration: InputDecoration(
                          label: Text(quizCode, style: TextStyle()),
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                          prefixIcon: Icon(Icons.code)
                      ),
                    ),
                  )
              ),
            ),
            SizedBox(height: 40,),
            Text('Quem pode acessar?'),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.7, height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(margin: EdgeInsets.all(10),
                    child: ElevatedButton(onPressed: (){
                      setState(() {
                        isPublic = true;
                      });

                    },
                        style: isPublic ? ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(5)), backgroundColor: WidgetStateProperty.all(Color(0xff0D6EFD)), foregroundColor: WidgetStatePropertyAll(Colors.white),) : ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.black), backgroundColor: WidgetStatePropertyAll(Colors.white),padding: WidgetStatePropertyAll(EdgeInsets.all(5))),
                        child: const Text('Público')),),

                  Container(margin: EdgeInsets.all(10),
                    child: ElevatedButton(onPressed: (){
                      setState(() {
                        isPublic = false;
                      });
                    },
                        style: isPublic ? ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.black), backgroundColor: WidgetStatePropertyAll(Colors.white),padding: WidgetStatePropertyAll(EdgeInsets.all(5))) : ButtonStyle(backgroundColor: WidgetStatePropertyAll(Color(0xff0D6EFD)), foregroundColor: WidgetStatePropertyAll(Colors.white),padding: WidgetStatePropertyAll(EdgeInsets.all(5))),
                        child: const Text('Privado')),
                  )
                ],
              ),
            ),
            const SizedBox(height: 50,),
            ListView.builder(
              itemCount: questions.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index){
                Question currentQuestion = questions[index];
                return Dismissible(key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_){
                      setState(() {
                        questions.removeAt(index);
                      });
                    },
                    background: Container(
                      color: Colors.red,
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      alignment: Alignment.centerRight,
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    child: GestureDetector(
                        onTap: ()async{
                          await Navigator.push(context, MaterialPageRoute(builder: (context)=>CreationQuestionScreen(questions: questions, questionIndex: index, isQuestionCreated: true,)))
                              .then((_)=>setState(() {}));
                        },
                        child: Column(
                          children: [
                            ListTile(
                              title: Text('${index + 1}. ${questions[index].name}', style: TextStyle(fontWeight: FontWeight.bold),),
                            ),
                            ...currentQuestion.alternatives.map((alternative){
                              return ListTile(
                                title: Align(
                                  alignment: Alignment.center,
                                  child: Text('Alternativa: ${alternative.name}'),
                                ),
                                trailing: alternative.isCorrect? Icon(Icons.check, color: Colors.green[400],) : const Icon(Icons.close, color: Colors.redAccent,),
                              );
                            })
                          ],
                        )
                    )
                );
              },
            ),
            const SizedBox(height: 50,),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: IconButton(
                    onPressed: () async{
                      await Navigator.push(context, MaterialPageRoute(builder: (context)=>CreationQuestionScreen(questions: questions)))
                          .then((_)=>setState(() {}));
                    },
                    style: ButtonStyle(shape: WidgetStatePropertyAll(CircleBorder()), backgroundColor: WidgetStatePropertyAll(Color(0xff0D6EFD)), foregroundColor: WidgetStatePropertyAll(Colors.white)),
                    icon: const Icon(Icons.add)),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                    onPressed: () async{
                      if(questions.length >= 1){
                        if(!(await isValidUrl(_linkImgController.text))){
                          _linkImgController.text = DEFAULT_IMAGE_URL;
                        }
                        if(_titleController.text.length >= 25){
                          _databaseService.addQuiz(
                              Quiz(
                                  quizId: '',
                                  uid: FirebaseAuth.instance.currentUser!.uid,
                                  title: _titleController.text,
                                  image: _linkImgController.text,
                                  public: isPublic,
                                  questionsAmount: questions.length,
                                  shareCode: quizCode
                              ),
                              questions
                          )
                              .then((_){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));});
                        }
                        else{
                          //Avisar ao usuário sobre o mínimo de caracteres no título
                        }
                      }
                    },
                    child: Text('Criar Kuiz')
                ),
              ),
            )
          ],
        ),
      )
    );
  }

  Future<bool> isValidUrl(String url) async{
    try{
      final response = await http.get(Uri.parse(url));

      //Verifica se de fato é uma imagem passada como URL
      if (response.statusCode == 200 &&
        response.headers['content-type'] != null &&
        response.headers['content-type']!.startsWith('image/')){
        return true;
      }
      return false;
    }
    catch(e){
      return false;
    }
  }
}