import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kuiz_app/models/user_model.dart';
import 'package:kuiz_app/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountDetailsScreen extends StatefulWidget {

  AccountDetailsScreen({super.key});

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  DatabaseService _databaseService = DatabaseService();
  final TextEditingController usernameController = TextEditingController();
  late final String uid;
  late final SharedPreferences sharedPreferences;
  bool isReadOnly = true;

  @override
  void initState(){
    super.initState();
    _loadUserData()
    .then((_)=>setState(() {}));
  }

  Future<void> _loadUserData()async{
    sharedPreferences = await SharedPreferences.getInstance();
    uid = sharedPreferences.getString('uid')!;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: const Text('Informações da Conta', style: TextStyle(color: Color(0xff0D6EFD)),),
          ),
        ),
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back), color: Color(0xff0D6EFD),),
      ),
      body: FutureBuilder(future: _databaseService.getUser(uid: uid),
              builder: (context, snapshot){
                if(snapshot.connectionState == ConnectionState.waiting) {
                  return const Align(alignment: AlignmentDirectional.center, child: SizedBox(width: 200, height: 200, child: CircularProgressIndicator(),),);
                }

                if(snapshot.hasError || !snapshot.hasData || snapshot.data == null){
                  return const Align(alignment: AlignmentDirectional.center, child: SizedBox(width: 200, height: 200, child: const Text('Um erro inesperado ocorreu! Tente novamente mais tarde'),),);
                }

                UserKuiz currentUser = snapshot.data as UserKuiz;
                usernameController.text = currentUser.username;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      height: 10,
                      color: Colors.grey,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 5, 0, 3),
                      child: Text('Conta cadastrada:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
                      child: Text(currentUser.email, style: TextStyle(fontSize: 16),),
                    ),
                    Divider(
                      height: 10,
                      color: Colors.grey,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 5, 0, 3),
                      child: Text('Username:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                      child: TextField(
                        controller: usernameController,
                        readOnly: isReadOnly,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: ()=>setState(()=>isReadOnly = !isReadOnly),
                                icon: isReadOnly ? const Icon(Icons.edit) : const Icon(Icons.cancel, color: Colors.redAccent,)
                            )
                        ),
                      ),
                    ),
                    Divider(
                      height: 30,
                      color: Colors.grey,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(onPressed: (){
                        //Salvar alteracoes do nome de usuário
                      },
                          child: const Text('Salvar Alterações')),
                    )
                  ],
                );

              })
      );
  }
}
