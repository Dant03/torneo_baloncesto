import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../models/team.dart';
import '../models/player.dart';
import '../providers/team_provider.dart';
import '../providers/player_provider.dart';
import 'player_form_screen.dart';

class TeamDetailsScreen extends StatefulWidget {
  final String teamId;
  final String teamName;

  TeamDetailsScreen({required this.teamId, required this.teamName});

  @override
  _TeamDetailsScreenState createState() => _TeamDetailsScreenState();
}

class _TeamDetailsScreenState extends State<TeamDetailsScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTeamDetails();
  }

  Future<void> _fetchTeamDetails() async {
    try {
      final teamProvider = Provider.of<TeamProvider>(context, listen: false);
      final playerProvider = Provider.of<PlayerProvider>(context, listen: false);

      await teamProvider.getTeamById(widget.teamId);
      await playerProvider.fetchPlayersByTeamId(widget.teamId);

      setState(() {
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      // Manejar errores
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        if (sizingInformation.deviceScreenType == DeviceScreenType.mobile) {
          return _buildMobileLayout(context);
        } else {
          return _buildWebLayout(context);
        }
      },
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    final teamProvider = Provider.of<TeamProvider>(context);
    final playerProvider = Provider.of<PlayerProvider>(context);

    final team = teamProvider.getTeamById(widget.teamId);
    final players = playerProvider.players;

    return Scaffold(
      appBar: AppBar(
        title: Text('${team.nombre} - ${teamProvider.getTeamCategory(widget.teamId) ?? ''}'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                if (team.logotipo != null)
                  Image.network(
                    team.logotipo!,
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                Text('Nombre del equipo: ${team.nombre}'),
                Text('Categoría: ${teamProvider.getTeamCategory(widget.teamId) ?? ''}'),
                _buildTeamOptions(),
                _buildPlayerList(players),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PlayerFormScreen(teamId: widget.teamId)));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildWebLayout(BuildContext context) {
    final teamProvider = Provider.of<TeamProvider>(context);
    final playerProvider = Provider.of<PlayerProvider>(context);

    final team = teamProvider.getTeamById(widget.teamId);
    final players = playerProvider.players;

    return Scaffold(
      appBar: AppBar(
        title: Text('${team.nombre} - ${teamProvider.getTeamCategory(widget.teamId) ?? ''}'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Row(
              children: [
                Expanded(
                  flex: 1,
                  child: _buildPlayerList(players),
                ),
                VerticalDivider(),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      if (team.logotipo != null)
                        Image.network(
                          team.logotipo!,
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      Text('Nombre del equipo: ${team.nombre}'),
                      Text('Categoría: ${teamProvider.getTeamCategory(widget.teamId) ?? ''}'),
                      _buildTeamOptions(),
                    ],
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PlayerFormScreen(teamId: widget.teamId)));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildTeamOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed: () {},
          child: Text('Plantilla'),
        ),
        TextButton(
          onPressed: () {},
          child: Text('Calendario'),
        ),
        TextButton(
          onPressed: () {},
          child: Text('Resultados'),
        ),
        TextButton(
          onPressed: () {},
          child: Text('Estadísticas'),
        ),
      ],
    );
  }

  Widget _buildPlayerList(List<Player> players) {
    return Expanded(
      child: ListView.builder(
        itemCount: players.length,
        itemBuilder: (context, index) {
          final player = players[index];
          return ListTile(
            title: Text(player.nombre),
            subtitle: Text('Registro: ${player.fechaCreacion} - Estatus: ${player.estado}'),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PlayerFormScreen(teamId: widget.teamId, player: player),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
