import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text('Flutter Chess', style: TextStyle(color: Colors.amber),),
        ),
        body: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          children: [
            buildGameType(
              label: 'vs Computer', 
              icon: Icons.computer, 
              onTap: (){
                print('player vs computer');
              }),
            buildGameType(
              label: 'vs Player', 
              icon: Icons.person, 
              onTap: (){
                print('player vs player');
              }),
              buildGameType(
              label: 'Settings', 
              icon: Icons.settings, 
              onTap: (){
                print('settings');
              }),
              buildGameType(
              label: 'About', 
              icon: Icons.info, 
              onTap: (){
                print('about');
              }),
            
          ],)
        
    );
  }
}

Widget buildGameType({required label, String? gameTime, IconData? icon, required Function() onTap}){
  return InkWell(
    onTap: onTap,
    child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    icon !=null ? Icon(icon): Text(gameTime!),
                    const SizedBox(height: 10,),
                    Text(label, style: TextStyle(fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
  );
}