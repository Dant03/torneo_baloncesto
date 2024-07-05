import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'providers/auth_provider.dart';
import 'providers/category_provider.dart';
import 'providers/championship_provider.dart';
import 'providers/match_provider.dart';
import 'providers/player_provider.dart';
import 'providers/position_provider.dart';
import 'providers/referee_provider.dart';
import 'providers/team_provider.dart';
import 'providers/user_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/create_championship_screen.dart';
import 'screens/admin_dashboard_screen.dart';
import 'screens/championship_details_screen.dart';
import 'screens/team_details_screen.dart';
import 'supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSupabase(); // Inicializar Supabase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String apiKey = 'AIzaSyDeS24DUcDHpcU187F_PlbYL0Gsl8Zgl3E';

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider(Supabase.instance.client)),
        ChangeNotifierProvider(create: (_) => ChampionshipProvider()),
        ChangeNotifierProvider(create: (_) => MatchProvider()),
        ChangeNotifierProvider(create: (_) => PlayerProvider()),
        ChangeNotifierProvider(create: (_) => PositionProvider()),
        ChangeNotifierProvider(create: (_) => RefereeProvider()),
        ChangeNotifierProvider(create: (_) => TeamProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'Campeonatos de Baloncesto',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/admin': (context) => AdminDashboardScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/create-championship') {
            return MaterialPageRoute(
              builder: (context) => CreateChampionshipScreen(apiKey: apiKey),
            );
          }
          if (settings.name == '/team-details') {
            final args = settings.arguments as Map<String, dynamic>;
            final String teamId = args['teamId'];
            final String teamName = args['teamName'];
            return MaterialPageRoute(
              builder: (context) => TeamDetailsScreen(teamId: teamId, teamName: teamName),
            );
          }
          return null;
        },
      ),
    );
  }
}
