import 'package:flutter/material.dart';
import 'package:kuiz_app/models/alternative_model.dart';
import 'package:kuiz_app/models/question_model.dart';

class CreationAlternativeScreen extends StatefulWidget {
  Question question;
  late int? alternativeIndex;
  CreationAlternativeScreen({super.key, required this.question, this.alternativeIndex});

  @override
  State<CreationAlternativeScreen> createState() => _CreationAlternativeScreenState();
}

class _CreationAlternativeScreenState extends State<CreationAlternativeScreen> {
  final TextEditingController alternativeController = TextEditingController();

  bool isCorrect = false;

  @override
  void initState() {
    super.initState();
    if(widget.alternativeIndex != null) {
      alternativeController.text = widget.question.alternatives![widget.alternativeIndex!].name;
      isCorrect = widget.question.alternatives![widget.alternativeIndex!].isCorrect;
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 9,
                      child: SizedBox(
                        width: 325,
                        height: 50,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Digite aqui a alternativa'
                          ),
                          controller: alternativeController,
                        ),
                      )
                    ),
                    Expanded(
                      flex: 1,
                        child: Checkbox(value: isCorrect, onChanged: (value)=>setState(() {
                          isCorrect = !isCorrect;
                        }))
                    ),
                  ],
                ),
                 Container(
                   margin: EdgeInsets.all(15),
                   child: ElevatedButton(
                       onPressed:(){
                         if(widget.alternativeIndex != null){
                           widget.question.alternatives!.removeAt(widget.alternativeIndex!);
                           widget.question.alternatives!.insert(widget.alternativeIndex!, Alternative(alternativeId: '', questionId: '', name: alternativeController.text, isCorrect: isCorrect));
                         }
                         else{
                           widget.question.alternatives!.add(Alternative(alternativeId: '', questionId: '', name: alternativeController.text, isCorrect: isCorrect));
                         }
                         Navigator.pop(context);
                       },
                       child: const Text('Salvar')
                   ),
                 )
              ],
            ),
          )
      ),
    );
  }
}
