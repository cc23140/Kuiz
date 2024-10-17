import 'package:flutter/material.dart';
import 'package:kuiz_app/models/alternative_model.dart';
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

  final _formKey = GlobalKey<FormState>();

  List<Question> questions = <Question>[];

  List<TextEditingController> listOfController = <TextEditingController>[];



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
            shrinkWrap: true,
            children: [
              //Iterar por toda a lista de questoes!
              for(Question question in questions)
                ListTile(title: Text(question.name),),

            ],
          ),
          const SizedBox(height: 50,),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: IconButton(
                        onPressed: () async{
                          await _buildFormDialog(context, _formKey);
                        },
                        style: ButtonStyle(shape: WidgetStatePropertyAll(CircleBorder())),
                        icon: const Icon(Icons.add)),
            ),
          )
    ,






        ],
      ),
    );
  }
}



 Future<List<String>> _buildFormDialog(BuildContext context,GlobalKey<FormState> formKey) async{
    final TextEditingController questionController = TextEditingController();
    final alternativeFormKey = GlobalKey<FormState>();
    List<String> alternatives = <String>[];

    await showDialog(context: context,
      builder:(context)=>
      AlertDialog(
        content: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(padding: EdgeInsets.all(10),
                    child: const Text('Pergunta:'),
                  ),
                  Padding(padding: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: questionController,
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Digite a pergunta';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 20,),
                  Padding(padding: EdgeInsets.all(10),
                    child: const Text('Alternativas:'),
                  ),
                  ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: <Widget>[
                      for(Alternative alternative in alternatives)
                        ListTile(
                          title: Text(alternative.name),
                          trailing: alternative.isCorrect ? const Icon(Icons.check) : const Icon(Icons.close),
                        ),

                    ],
                  ),

                  Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(onPressed: ()async{
                        await showDialog(context: context,
                            builder: (context)=>
                              AlertDialog(
                                content: Form(
                                    key: alternativeFormKey,
                                    child: Stack(
                                      alignment: ,
                                    )
                                ),
                                actions: [
                                  TextButton(onPressed: (){
                                    if(alternativeFormKey.currentState!.validate()){
                                      //Se tudo estiver correto, adicionar a alternativa na lista de alternativas
                                      alternatives.add()
                                    }
                                  },
                                  child: const Text('Adicionar'))
                                ],
                              )

                        );
                    },
                        icon: const Icon(Icons.add)
                    ),
                  )




                ],
              )
            )
          ],
        ),
        actions: [
          TextButton(
              onPressed: (){
                if(formKey.currentState!.validate()){
                  //Se tudo é válido, adicionar ao firestore!
                }
              },
              child: const Text('Adicionar')
          ),
          TextButton(
              onPressed: (){
                  Navigator.of(context).pop();
              },
              child: const Text('Cancelar')
          )
        ],
      )
    );

    return <String>[];


}
