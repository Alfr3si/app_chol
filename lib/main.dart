import 'package:app_chol/core/audio_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ui/screens/splash_screen.dart';
import './core/app_brightness_overlay.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  // Monitoreo de bloqueo de pantalla para el audio
  AudioManager.instance.init();

  // Orientación de la pantalla
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(
    const ProviderScope(
      child: AppChol(),
    ),
  );
}

class AppChol extends StatelessWidget {
  const AppChol({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Cho'lApp",
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
      ),
      home: const SplashScreen(),
      builder: (context, child) => AppBrightnessOverlay(child: child!),
    );
  }
}
