import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
    const HomeScreen({super.key});

    @override
    Widget build(BuildContext context){
        return Scaffold(
        appBar: AppBar(
        title: const Text("chol'App - Menu de Navegacion"),
        backgroundColor: Colors.orangeAccent,
        foregroundColor: Colors.white24,
        ),
        body: const Center(
        child: Text('Bienvenido al Menu principal de cholapp', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ),
        );
        }
    }
