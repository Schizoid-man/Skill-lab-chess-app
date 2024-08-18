import 'package:flutter/material.dart';

class GameStartUpScreen extends StatefulWidget {
  const GameStartUpScreen({super.key});

  @override
  State<GameStartUpScreen> createState() => _GameStartUpScreenState();
}

class _GameStartUpScreenState extends State<GameStartUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text("Setup Game", style: TextStyle(color: Colors.amber),),
        leading: IconButton( icon: const Icon(Icons.arrow_back, color: Colors.amber,), onPressed: (){
          Navigator.pop(context);
        },),
      ),
      body: Column(
        children: [],
      ),
    );
  }
}