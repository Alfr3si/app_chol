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
        backgroundColor: Colors.orangeAccent,
        body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

        const SizedBox(height: 24),
        const Text(
        "Cho'lApp",
        style: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: Colors.white70,
        letterSpacing: 1.2,
        ),
        ),
        const SizedBox(height: 8),
        const Text(
        'Aprende, preserva y revitaliza',
        style: TextStyle(
        fontSize: 14,
        color: Colors.white10,
        ),
        ),
        const SizedBox(height: 48),
        const SizedBox(
        width: 32,
        height: 32,
        child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.white70),
        strokeWidth: 3,),)

        ],),)
        );
        }
}
