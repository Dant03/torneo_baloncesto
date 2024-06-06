import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/view_championships_screen.dart';
import 'screens/create_championship_screen.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/championship_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ChampionshipProvider()),
      ],
      child: MaterialApp(
        title: 'Torneo Baloncesto',
        theme: ThemeData(
          primaryColor: const Color(0xFF44788D),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color(0xFF44788D),
            secondary: const Color(0xFFC7E6EF),
            background: const Color(0xFFFEFEFE),
          ),
          scaffoldBackgroundColor: const Color(0xFFFEFEFE),
          textTheme: const TextTheme(
            headlineLarge: TextStyle(color: Color(0xFF833E19)),
            bodyLarge: TextStyle(color: Color(0xFF6DA9B4)),
          ),
          buttonTheme: const ButtonThemeData(
            buttonColor: Color(0xFF44788D),
            textTheme: ButtonTextTheme.primary,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF44788D),
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            iconTheme: IconThemeData(color: Colors.white),
          ),
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const HomeScreen(),
          '/view-championships': (context) => const ViewChampionshipsScreen(),
          '/create-championship': (context) => const CreateChampionshipScreen(),
        },
      ),
    );
  }
}
