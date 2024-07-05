import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/championship.dart';
import '../providers/auth_provider.dart';
import '../providers/championship_provider.dart';
import 'create_championship_screen.dart';
import 'admin_championship_details_screen.dart'; // Importa la pantalla de detalles del campeonato
import 'login_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchChampionships();
  }

  Future<void> _fetchChampionships() async {
    await Provider.of<ChampionshipProvider>(context, listen: false).obtenerCampeonatos();
  }

  void _editChampionship(Championship championship) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreateChampionshipScreen(
          championship: championship,
          apiKey: 'YOUR_API_KEY_HERE',
        ),
      ),
    );
  }

  void _deleteChampionship(String championshipId) async {
    await Provider.of<ChampionshipProvider>(context, listen: false).removeChampionship(championshipId);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Panel de Administrador'),
        actions: [
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
                    borderRadius: BorderRadius.circular(8.0),
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
              child: Consumer<ChampionshipProvider>(
                builder: (context, provider, child) {
                  final campeonatos = provider.campeonatos
                      .where((championship) =>
                          championship.nombre.toLowerCase().contains(_searchQuery))
                      .toList();

                  if (campeonatos.isEmpty) {
                    return Center(
                        child: Text('No existen campeonatos',
                            style: TextStyle(
                                color: Colors.white, fontSize: 18)));
                  }

                  return RefreshIndicator(
                    onRefresh: _fetchChampionships,
                    child: ListView.builder(
                      itemCount: campeonatos.length,
                      itemBuilder: (context, index) {
                        final championship = campeonatos[index];
                        final imageUrl = championship.imagen.isNotEmpty
                            ? championship.imagen
                            : 'https://sezusjbiuccuqlyjjkud.supabase.co/storage/v1/object/public/ImagenesApp/imgChamp.png';
                        final isOpen =
                            championship.estado.toLowerCase() == 'abierto';

                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdminChampionshipDetailsScreen(championship: championship)));
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Row(
                              children: [
                                Flexible(
                                  child: Image.network(
                                    imageUrl,
                                    width: screenWidth * 0.25,
                                    height: screenHeight * 0.15,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) {
                                      return Image.network(
                                        'https://sezusjbiuccuqlyjjkud.supabase.co/storage/v1/object/public/ImagenesApp/imgChamp.png',
                                        width: screenWidth * 0.25,
                                        height: screenHeight * 0.15,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.04),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        championship.nombre,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: screenWidth * 0.05,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: screenHeight * 0.01),
                                      Text(
                                        'Ubicación: ${championship.ubicacion}',
                                        style: TextStyle(color: Colors.white),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: screenHeight * 0.01),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.all(4.0),
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(4.0),
                                              ),
                                              child: Text(
                                                'Baloncesto',
                                                style: TextStyle(
                                                    color: Colors.white),
                                                overflow:
                                                    TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: screenWidth * 0.02),
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.all(4.0),
                                              decoration: BoxDecoration(
                                                color: isOpen
                                                    ? Colors.green
                                                    : Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(4.0),
                                              ),
                                              child: Text(
                                                isOpen
                                                    ? 'Inscripción Abierta'
                                                    : 'Inscripción Cerrada',
                                                style: TextStyle(
                                                    color: Colors.white),
                                                overflow:
                                                    TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit, color: Colors.white),
                                      onPressed: () => _editChampionship(championship),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _deleteChampionship(championship.id!),
                                    ),
                                  ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CreateChampionshipScreen(apiKey: 'YOUR_API_KEY_HERE')));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
