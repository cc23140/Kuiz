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
      alternativeController.text = widget.question.alternatives[widget.alternativeIndex!].name;
      isCorrect = widget.question.alternatives[widget.alternativeIndex!].isCorrect;
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: Column(
            children: [
              TextField(
                controller: alternativeController,
              ),
              Checkbox(value: isCorrect, onChanged: (value)=>setState(() {
                isCorrect = !isCorrect;
              })),
              TextButton(
                  onPressed:(){
                    if(widget.alternativeIndex != null){
                      widget.question.alternatives.removeAt(widget.alternativeIndex!);
                      widget.question.alternatives.insert(widget.alternativeIndex!, Alternative(idQuestion: '', name: alternativeController.text, isCorrect: isCorrect));
                    }
                    else{
                      widget.question.alternatives.add(Alternative(idQuestion: '', name: alternativeController.text, isCorrect: isCorrect));
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('Salvar')
              )
            ],
          )
      ),
    );
  }
}
