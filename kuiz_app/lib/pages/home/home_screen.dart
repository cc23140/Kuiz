import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kuiz_app/pages/login/login.dart';
import 'package:kuiz_app/pages/signup/signup.dart';
import 'package:kuiz_app/services/auth_service.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: Builder(
                builder: (context) {
                  return IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      }
                  );
                }
            )
        ),
        drawer: Drawer(
            child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(
                        color: Colors.blue
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.settings),
                        Text('Configurações'),
                      ],
                    )

                  ),

                  const ListTile(
                      title: const Text('Conta')
                  ),
                  ListTile(
                      title: const Text('Acessar perfil'),
                      onTap: () {
                          ///TODO
                      }
                  ),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.4,),
                  ListTile(
                    title: Text('Sair da conta'),
                    leading: Icon(Icons.exit_to_app),
                    onTap: (){
                      AuthService().signout(context: context);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
                    },
                  )
                ]
            )
        )
    );
  }
}