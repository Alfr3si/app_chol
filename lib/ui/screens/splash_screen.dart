import 'package:flutter/material.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
    const SplashScreen({super.key});

    @override
    State<SplashScreen> createState() => _SplashScreenState();
    }

class _SplashScreenState extends State<SplashScreen> {
    @override
    void initState(){
        super.initState();

        Future.delayed(const Duration(seconds: 3), () {
            if (!mounted) return;

            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
            });
        }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
        body: Stack(
        fit: StackFit.expand,
        children: [
        Image.asset('assets/images/fondos/img_splash.webp', fit: BoxFit.cover,),
        const Positioned(
        bottom: 40,
        left: 0,
        right: 0,
        child: Center(child: SizedBox(
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
        ]),
        );
    }
}
