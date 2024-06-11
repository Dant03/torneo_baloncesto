import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/championship_provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'create_championship_screen.dart';
import '../widgets/loading_indicator.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final championshipProvider = Provider.of<ChampionshipProvider>(context, listen: false);
    championshipProvider.fetchChampionships();
  }

  Future<void> _refreshChampionships() async {
    final championshipProvider = Provider.of<ChampionshipProvider>(context, listen: false);
    await championshipProvider.fetchChampionships();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final championshipProvider = Provider.of<ChampionshipProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Campeonatos'),
        actions: [
          if (authProvider.user != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: Text('Hola, ${authProvider.user!.name}', style: TextStyle(color: Colors.white)),
              ),
            ),
            TextButton(
              onPressed: () {
                authProvider.signOut();
              },
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              child: Text('Cerrar sesión', style: TextStyle(color: Colors.white)),
            ),
          ] else ...[
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterScreen()));
              },
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              child: Text('Registrarse', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              child: Text('Iniciar sesión', style: TextStyle(color: Colors.white)),
            ),
          ]
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://sezusjbiuccuqlyjjkud.supabase.co/storage/v1/object/public/ImagenesApp/background.jpg?t=2024-06-05T06%3A06%3A18.729Z'),
            fit: BoxFit.cover,
          ),
        ),
        child: RefreshIndicator(
          onRefresh: _refreshChampionships,
          child: Consumer<ChampionshipProvider>(
            builder: (context, provider, child) {
              if (provider.championships.isEmpty) {
                return Center(child: Text('No existen campeonatos', style: TextStyle(color: Colors.white, fontSize: 18)));
              } else {
                return ListView.builder(
                  itemCount: provider.championships.length,
                  itemBuilder: (context, index) {
                    final championship = provider.championships[index];
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5.0,
                            spreadRadius: 1.0,
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(championship.name, style: TextStyle(color: Colors.black)),
                        subtitle: Text('Fecha: ${championship.formattedStartDate}', style: TextStyle(color: Colors.black54)),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: authProvider.user?.role == 'admin'
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateChampionshipScreen()));
              },
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}
