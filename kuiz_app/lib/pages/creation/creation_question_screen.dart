import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kuiz_app/models/alternative_model.dart';
import 'package:kuiz_app/models/question_model.dart';
import 'package:kuiz_app/pages/creation/creation_alternative_screen.dart';

class CreationQuestionScreen extends StatefulWidget {
  final int? questionIndex;
  List<Question> questions;
  CreationQuestionScreen({super.key, this.questionIndex, required this.questions});

  @override
  State<CreationQuestionScreen> createState() => _CreationQuestionScreenState();
}

class _CreationQuestionScreenState extends State<CreationQuestionScreen> {


  Question currentQuestion = Question(name: '', quizId: '');
  final TextEditingController questionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if(widget.questionIndex != null){
      questionController.text = widget.questions[widget.questionIndex!].name;
      currentQuestion.alternatives = widget.questions[widget.questionIndex!].alternatives;
    }
  }

  void onQuestionChanged(){
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.7,
                child: TextField(
                  controller: questionController,
                  onChanged: (text){
                    currentQuestion.name = text;
                  },
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: currentQuestion.alternatives.length,
                itemBuilder: (context, index){
                 Alternative alternative = currentQuestion.alternatives[index];
                 return Dismissible(key: UniqueKey(),
                     direction: DismissDirection.endToStart,
                     onDismissed: (_){
                        setState(() {
                          currentQuestion.alternatives.removeAt(index);
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
                         await Navigator.push(context,
                             MaterialPageRoute(builder:
                                 (context)=>CreationAlternativeScreen(question: currentQuestion, alternativeIndex: index,)
                             )
                         ).then((_)=>setState(() {}));
                       },
                       child: ListTile(
                         title: Text(alternative.name),
                         trailing: alternative.isCorrect ? const Icon(Icons.check) : const Icon(Icons.close),
                       ),
                     )
                 );

                },
              ),
              Align(
                alignment: AlignmentDirectional.center,
                child: TextButton(
                    onPressed: (){
                      if(widget.questionIndex != null){
                        widget.questions.removeAt(widget.questionIndex!);
                        widget.questions.insert(widget.questionIndex!, currentQuestion);
                      }
                      else{
                        widget.questions.add(currentQuestion);
                      }
                      Navigator.pop(context);
                    },
                    child: const Text('Salvar')
                ),
              ),
              Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: IconButton(
                    onPressed: ()async{
                      await Navigator.push(context, MaterialPageRoute(builder: (context){

                      widget.questions.add(currentQuestion);
                      return CreationAlternativeScreen(question: widget.questions.last);
                    })
                  ).then((_){setState(() {});});
                }, icon: const Icon(Icons.add)),
              )
            ],
          )
      ),
    );
  }
}
