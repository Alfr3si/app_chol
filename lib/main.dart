import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // 1. Importa dotenv
import 'ui/screens/splash_screen.dart';

Future<void> main() async { // 2. Vuelve la función main asíncrona
    WidgetsFlutterBinding.ensureInitialized();

    // 3. Carga el archivo .env antes de iniciar la app y configurar la pantalla
    await dotenv.load(fileName: ".env");

    // Orientacion de la pantalla
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
    ]);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

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
