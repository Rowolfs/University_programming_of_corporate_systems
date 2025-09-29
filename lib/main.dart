import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());

}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int counter = 0;

  void increment() {
    setState(() {
      counter++;
    });
  }

  void decrement() {
    setState(() {
      counter--;
      if (counter<0) setZero();
    });
  }

  void onLongIncrement(){
    setState(() {
      counter += 10;
    });
  }
  void onLongDicrement(){
    setState(() {
      counter -= 10;
      if (counter<0) setZero();
    });
  }
  void setZero(){
    setState(() {
      counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("(Волков Роман ЭФБО-09-23) привет это моя 4 практика 👽"),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Счетчик: $counter",
                style: GoogleFonts.anekMalayalam(fontSize: 94),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Container(decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(10)), padding: EdgeInsets.all(16), child:
                  ElevatedButton(
                    onPressed: increment,
                    onLongPress: onLongIncrement,
                    child: Text("Увеличить"),
                  )),

                  Container(decoration: BoxDecoration(color: Colors.teal, borderRadius: BorderRadius.circular(10)), padding: EdgeInsets.all(16), child:
                  ElevatedButton(
                    onPressed: decrement,
                    onLongPress: onLongDicrement,
                    child: Text("Уменьшить"),
                  ))

                ],),
              Container(decoration: BoxDecoration(color: Colors.deepOrange, borderRadius: BorderRadius.circular(10)), padding: EdgeInsets.all(16), child:
                  ElevatedButton(
                    onPressed: setZero,
                    child: Text("Сбросить"),
                  ))
              
            ],
          ),
        ),
      ),
    );
  }
}
