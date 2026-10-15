import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../core/widgets/menu_buttons_widget.dart';
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

        const Positioned(
            bottom: 25,
            left: 0,
            right: 0,
            child: MenuButtonsWidget(),
        ),
        ],
        ),
        );
        }
    }
