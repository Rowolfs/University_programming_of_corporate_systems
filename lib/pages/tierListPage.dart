import 'package:flutter/material.dart';
import 'package:tier_list_app/pages/greetingsPage.dart';


class TierListPage extends StatelessWidget {
  const TierListPage({super.key});

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          Color(0xFF8D8D8D),
          Color(0xFF272727)
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter
        )
      ),
        child: Stack(children: [
          Image.asset('assets/images/start_wallpaper.png', fit: BoxFit.cover,),
          GreetingsPage()
        ],),
    )
   );
  }
}





