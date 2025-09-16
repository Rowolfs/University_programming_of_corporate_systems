import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text("(Волков Роман ЭФБО-09-23) привет это моя 3 практика 👽"), centerTitle: true,),
        body: Center(child: Column( 
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Что то тут надо написать"),
            ElevatedButton(
              onPressed: () {},
              child: Text("Попробуй нажать "),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Проверка   ", style: GoogleFonts.montserratAlternates(color: Colors.amber, fontSize: 35)),
              Text("      🥶", style: TextStyle(fontSize: 67),)
            ],),
            Container(width: 50, height: 50, decoration:  BoxDecoration(color: Color(0xFFefe4b0), borderRadius: BorderRadius.circular(10)),)
          ],
        ),
      ),
      )

    );
  }
}