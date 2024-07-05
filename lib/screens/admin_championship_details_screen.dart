import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../models/championship.dart';
import '../models/category.dart';
import '../models/team.dart';
import '../providers/auth_provider.dart';
import '../providers/category_provider.dart';
import '../providers/team_provider.dart';
import '../widgets/create_team_modal.dart'; // Importa el modal aquí
import 'login_screen.dart';

class AdminChampionshipDetailsScreen extends StatefulWidget {
  final Championship championship;

  AdminChampionshipDetailsScreen({required this.championship});

  @override
  _AdminChampionshipDetailsScreenState createState() => _AdminChampionshipDetailsScreenState();
}

class _AdminChampionshipDetailsScreenState extends State<AdminChampionshipDetailsScreen> {
  int _selectedIndex = 0;
  String _searchQuery = '';
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchTeams();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _openMap(String location) async {
    String googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$location';
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  Future<void> _fetchCategories() async {
    await Provider.of<CategoryProvider>(context, listen: false).fetchCategoriesByChampionship(widget.championship.id!);
  }

  Future<void> _fetchTeams() async {
    await Provider.of<TeamProvider>(context, listen: false).fetchTeams(widget.championship.id!);
  }

  Widget _buildInformationTab() {
    final categories = Provider.of<CategoryProvider>(context).categorias;
    final categoryIds = categories.map((category) => category.id).toList();
    final categoryNames = categories.map((category) => category.nombre).toList();

    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Image.network(
                'https://sezusjbiuccuqlyjjkud.supabase.co/storage/v1/object/public/ImagenesApp/background.jpg', // URL de una imagen de fondo
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 16,
                left: 16,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(widget.championship.imagen), // URL del logo del campeonato
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.championship.nombre,
                          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Baloncesto',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        GestureDetector(
                          onTap: () => _openMap(widget.championship.ubicacion),
                          child: Text(
                            widget.championship.ubicacion,
                            style: TextStyle(color: Colors.white, fontSize: 16, decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(MdiIcons.calendar, 'Fecha de inicio', widget.championship.fechaInicio.toLocal().toString().split(' ')[0]),
                _buildDetailRow(MdiIcons.calendar, 'Días de juego', widget.championship.diasDeJuego.join(', ')),
                _buildDetailRow(MdiIcons.currencyUsd, 'Costo del torneo', '\$${widget.championship.costoCampeonato}'),
                _buildDetailRow(MdiIcons.cash, 'Costo de inscripción', '\$${widget.championship.costoInscripcion}'),
                _buildDetailRow(MdiIcons.cashMultiple, 'Costo por partido', '\$${widget.championship.costoPartido}'),
                _buildDetailRow(MdiIcons.phone, 'Teléfono de contacto', widget.championship.telefonoContacto),
                if (widget.championship.reglamento != null)
                  _buildDetailRow(MdiIcons.fileDocument, 'Reglamento', 'Ver reglamento', onTap: () {
                    // Acción para ver el reglamento
                  }),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final authProvider = Provider.of<AuthProvider>(context, listen: false);
                    if (authProvider.user == null) {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => CreateTeamModal(
                          championshipId: widget.championship.id!,
                          categoryIds: categoryIds,
                          categoryNames: categoryNames,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade300,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text('Inscribir Equipo'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamsTab() {
    final teams = Provider.of<TeamProvider>(context).teams.where((team) {
      return (team.nombre.toLowerCase().contains(_searchQuery.toLowerCase()) &&
          (_selectedCategoryId == null || team.id == _selectedCategoryId));
    }).toList();
    final categories = Provider.of<CategoryProvider>(context).categorias;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Buscar equipos...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white70,
            ),
            onChanged: (query) {
              setState(() {
                _searchQuery = query;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: DropdownButton<String>(
            hint: Text('Filtrar por categoría'),
            value: _selectedCategoryId,
            items: categories.map((Category category) {
              return DropdownMenuItem<String>(
                value: category.id,
                child: Text(category.nombre),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCategoryId = value;
              });
            },
            isExpanded: true,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: teams.length,
            itemBuilder: (context, index) {
              final team = teams[index];
              return ListTile(
                title: Text(team.nombre),
                subtitle: Text('Categoría: ${categories.firstWhere((category) => category.id == team.id).nombre}'),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPlayersTab() {
    return Center(
      child: Text('Jugadores'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.championship.nombre),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Acciones para el botón de configuración
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildInformationTab(),
          _buildTeamsTab(),
          _buildPlayersTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Información',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Equipos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Jugadores',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String detail, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          SizedBox(width: 8),
          Text(
            '$title:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Text(
                detail,
                style: TextStyle(fontSize: 16, color: onTap != null ? Colors.blue : Colors.black, decoration: onTap != null ? TextDecoration.underline : null),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
