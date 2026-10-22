import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _iniciarYcargar();
  }

  Future<void> _iniciarYcargar() async {
    await Flame.images.loadAll([
      'background/img_splash.webp',
      'elements/nubes_tira.webp',
    ]);

    await Future.delayed(const Duration(seconds: 4));

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/background/img_splash.webp',
            fit: BoxFit.cover,
          ),
          const Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 160,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.white30,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                    minHeight: 6,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
