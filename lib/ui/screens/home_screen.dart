import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../game_canvas/menu_game.dart';

class HomeScreen extends StatelessWidget{
    const HomeScreen({super.key});

    @override
    Widget build(BuildContext context){
        return Scaffold(
        body: Stack(
        fit: StackFit.expand,
        children: [
        GameWidget(game: MenuGame()),

        SafeArea(child: Padding(padding: const EdgeInsets.all(24.0),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        const Text("Cho'lApp",
        style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        shadows: [
        Shadow(
        blurRadius: 10.0,
        color: Colors.black45,
        offset: Offset(2, 2),
        )
        ]
        ),
        ),
        const SizedBox(height: 10),
        const Text(
        'Menu Principal',
        style: TextStyle(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.w600,

        ),
        ),
        ],
        ),
        ))
        ],
        ),
        );
        }
    }
