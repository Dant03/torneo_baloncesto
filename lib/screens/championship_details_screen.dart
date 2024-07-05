import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart' as flutter_provider;
import '../models/championship.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/create_team_modal.dart'; // Importa el modal aquí
import '../providers/auth_provider.dart';
import 'login_screen.dart';

class ChampionshipDetailsScreen extends StatelessWidget {
  final Championship championship;

  ChampionshipDetailsScreen({required this.championship});

  void _openMap(String location) async {
    String googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$location';
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  Future<Map<String, String>> _fetchCategories() async {
    final response = await Supabase.instance.client
        .from('campeonato_categorias')
        .select('categoria_id, categorias(nombre)')
        .eq('campeonato_id', championship.id)
        .execute();

    if (response.error == null) {
      final data = response.data as List;
      return {for (var item in data) item['categoria_id']: item['categorias']['nombre']};
    } else {
      throw response.error!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(championship.nombre),
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
      body: FutureBuilder<Map<String, String>>(
        future: _fetchCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final categories = snapshot.data ?? {};
            final categoryIds = categories.keys.toList();
            final categoryNames = categories.values.toList();

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
                              backgroundImage: NetworkImage(championship.imagen), // URL del logo del campeonato
                            ),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  championship.nombre,
                                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Baloncesto',
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                                GestureDetector(
                                  onTap: () => _openMap(championship.ubicacion),
                                  child: Text(
                                    championship.ubicacion,
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
                        _buildDetailRow(MdiIcons.calendar, 'Fecha de inicio', championship.fechaInicio.toLocal().toString().split(' ')[0]),
                        _buildDetailRow(MdiIcons.calendar, 'Días de juego', championship.diasDeJuego.join(', ')),
                        _buildDetailRow(MdiIcons.currencyUsd, 'Costo del torneo', '\$${championship.costoCampeonato}'),
                        _buildDetailRow(MdiIcons.cash, 'Costo de inscripción', '\$${championship.costoInscripcion}'),
                        _buildDetailRow(MdiIcons.cashMultiple, 'Costo por partido', '\$${championship.costoPartido}'),
                        _buildDetailRow(MdiIcons.phone, 'Teléfono de contacto', championship.telefonoContacto),
                        if (championship.reglamento != null)
                          _buildDetailRow(MdiIcons.fileDocument, 'Reglamento', 'Ver reglamento', onTap: () {
                            // Acción para ver el reglamento
                          }),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            final authProvider = flutter_provider.Provider.of<AuthProvider>(context, listen: false);
                            if (authProvider.user == null) {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => CreateTeamModal(
                                  championshipId: championship.id!,
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
        },
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
