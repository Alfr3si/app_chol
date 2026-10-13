import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ui/screens/splash_screen.dart';

void main() {
    WidgetsFlutterBinding.ensureInitialized();

    // Orientacion de la pantalla
    SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    ]);

  runApp(const AppChol());
}

class AppChol extends StatelessWidget {
    const AppChol({super.key});

    @override
    Widget build(BuildContext context){
        return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Cho'lApp",
        theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
        ),
        home: const SplashScreen(),
        );
        }
}
