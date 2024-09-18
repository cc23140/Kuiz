class HomeScreen extends StatelessWidget(

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        leading: Build(
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
              child: Text('Configurações'),
            ),

            ListTile(
              title: const Text('Conta')
            ),
            ListTile(
              title: const Text('Acessar perfil'),
              onTap: (){
                
              }
            )
          ]
        )
      )
    );
 }
)