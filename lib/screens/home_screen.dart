import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void _navigateToViewChampionships(BuildContext context) {
    Navigator.pushNamed(context, '/view-championships');
  }

  void _navigateToCreateChampionship(BuildContext context) {
    Navigator.pushNamed(context, '/create-championship');
  }

  void _logout(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _navigateToViewChampionships(context),
              child: const Text('Ver Campeonatos'),
            ),
            if (authProvider.user?.role == 'Administrador')
              const SizedBox(height: 16),
            if (authProvider.user?.role == 'Administrador')
              ElevatedButton(
                onPressed: () => _navigateToCreateChampionship(context),
                child: const Text('Crear Campeonato'),
              ),
          ],
        ),
      ),
    );
  }
}
