import 'package:flutter/material.dart';
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

  @override
  void initState() async{
    super.initState();
    _loadUserData();

  }

  void _loadUserData()async{
    sharedPreferences = await SharedPreferences.getInstance();
    uid = sharedPreferences.getString('uid')!;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          FutureBuilder(future: _databaseService.getUser(uid: uid),
              builder: (context, snapshot){
                ///TODO
              })
        ],
      ),
    );
  }
}
