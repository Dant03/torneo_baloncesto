import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as flutter_provider;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'create_championship_screen.dart';
import 'championship_details_screen.dart';
import '../providers/championship_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isLoading = true; // Estado de carga

  @override
  void initState() {
    super.initState();
    _fetchChampionships();
  }

  Future<void> _fetchChampionships() async {
    await flutter_provider.Provider.of<ChampionshipProvider>(context, listen: false).obtenerCampeonatos();
    setState(() {
      _isLoading = false; // Actualiza el estado de carga
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = flutter_provider.Provider.of<AuthProvider>(context);
    final apiKey = 'AIzaSyDeS24DUcDHpcU187F_PlbYL0Gsl8Zgl3E';
    final championshipProvider = flutter_provider.Provider.of<ChampionshipProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Campeonatos'),
        actions: [
          if (authProvider.user != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: Text('Hola, ${authProvider.user?.nombre ?? ''}', style: TextStyle(color: Colors.white)),
              ),
            ),
            TextButton(
              onPressed: () {
                authProvider.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar campeonatos...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white70,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                ),
                onChanged: (query) {
                  setState(() {
                    _searchQuery = query.toLowerCase();
                  });
                },
              ),
            ),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : flutter_provider.Consumer<ChampionshipProvider>(
                      builder: (context, provider, child) {
                        final campeonatos = provider.campeonatos
                            .where((championship) => championship.nombre.toLowerCase().contains(_searchQuery))
                            .toList();

                        if (campeonatos.isEmpty) {
                          return Center(child: Text('No existen campeonatos', style: TextStyle(color: Colors.white, fontSize: 18)));
                        }

                        return RefreshIndicator(
                          onRefresh: _fetchChampionships,
                          child: ListView.builder(
                            itemCount: campeonatos.length,
                            itemBuilder: (context, index) {
                              final championship = campeonatos[index];
                              final imageUrl = championship.imagen.isNotEmpty ? championship.imagen : 'https://sezusjbiuccuqlyjjkud.supabase.co/storage/v1/object/public/ImagenesApp/imgChamp.png';

                              // Comparar la fecha de inscripción con la fecha actual
                              final bool isOpen = DateTime.now().isBefore(championship.fechaInscripciones);

                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChampionshipDetailsScreen(championship: championship)));
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                  padding: EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(10.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 10.0,
                                        spreadRadius: 2.0,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8.0),
                                          child: Image.network(
                                            imageUrl,
                                            width: screenWidth * 0.25,
                                            height: screenHeight * 0.15,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Image.network(
                                                'https://sezusjbiuccuqlyjjkud.supabase.co/storage/v1/object/public/ImagenesApp/imgChamp.png',
                                                width: screenWidth * 0.25,
                                                height: screenHeight * 0.15,
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: screenWidth * 0.04),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              championship.nombre,
                                              style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: screenHeight * 0.01),
                                            Row(
                                              children: [
                                                Icon(Icons.location_on, color: Colors.white),
                                                SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(
                                                    championship.ubicacion,
                                                    style: TextStyle(color: Colors.white),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: screenHeight * 0.01),
                                            Text(
                                              'Baloncesto',
                                              style: TextStyle(color: Colors.white),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: screenHeight * 0.01),
                                            Container(
                                              padding: EdgeInsets.all(4.0),
                                              decoration: BoxDecoration(
                                                color: isOpen ? Colors.green : Colors.red,
                                                borderRadius: BorderRadius.circular(4.0),
                                              ),
                                              child: Text(
                                                isOpen ? 'Inscripción Abierta' : 'Inscripción Cerrada',
                                                style: TextStyle(color: Colors.white),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: authProvider.user?.rol == 'admin'
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateChampionshipScreen(apiKey: apiKey)));
              },
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}
