import 'package:flutter/material.dart';
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
                  TextButton(onPressed: (){
                    setState(() {
                      isPublic = true;
                    });

                  },
                    style: isPublic ? ButtonStyle() : ButtonStyle(),
                    child: const Text('Público')),

                  TextButton(onPressed: (){
                    setState(() {
                        isPublic = false;
                      });
                    },
                    style: isPublic ? ButtonStyle() : ButtonStyle(),
                    child: const Text('Privado'))
                ],
            ),
          )


        ],
      ),
    );
  }
}
