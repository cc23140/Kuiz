import 'package:flutter/material.dart';
import 'package:kuiz_app/models/question_model.dart';
import 'package:kuiz_app/services/database_service.dart';

class CreationQuizScreen extends StatefulWidget {
  CreationQuizScreen({super.key});

  @override
  State<CreationQuizScreen> createState() => _CreationQuizScreenState();
}

class _CreationQuizScreenState extends State<CreationQuizScreen> {
  final DatabaseService _databaseService = DatabaseService();

  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _linkImgController = TextEditingController();

  List<List<Question>> questions = <List<Question>>[];

  bool isPublic = true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criação de Quiz'),
        toolbarHeight: 100,
      ),
      body: Column(
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
          SizedBox(height: 40,),
          Text('Quem pode acessar?'),
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.7, height: 50,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(margin: EdgeInsets.all(10),
                    child: TextButton(onPressed: (){
                      setState(() {
                        isPublic = true;
                      });

                    },
                        style: isPublic ? ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(5)), backgroundColor: WidgetStateProperty.all(Colors.blue[700]), foregroundColor: WidgetStatePropertyAll(Colors.white),) : ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.black), padding: WidgetStatePropertyAll(EdgeInsets.all(5))),
                        child: const Text('Público')),),

                  Container(margin: EdgeInsets.all(10),
                    child: TextButton(onPressed: (){
                      setState(() {
                        isPublic = false;
                      });
                    },
                        style: isPublic ? ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.black), padding: WidgetStatePropertyAll(EdgeInsets.all(5))) : ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.blue[700]), foregroundColor: WidgetStatePropertyAll(Colors.white), padding: WidgetStatePropertyAll(EdgeInsets.all(5))),
                        child: const Text('Privado')),
                  )
                ],
            ),
          ),
          const SizedBox(height: 50,),

          ListView(
            scrollDirection: Axis.vertical,
            children: [
              //Iterar por toda a lista de questoes!
              IconButton(
                  onPressed: (){

                  },
                  icon: const Icon(Icons.plus_one))
            ],
          ),

          const SizedBox(height: 50,)



        ],
      ),
    );
  }
}
