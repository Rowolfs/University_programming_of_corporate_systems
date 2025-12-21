import 'package:flutter/material.dart';
import 'package:tier_list_app/widgets/actionNavigationBar.dart';
import 'package:tier_list_app/widgets/actionAppBar.dart';


class EditorPage extends StatelessWidget {
  const EditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children:[
        Image(image: AssetImage('assets/images/start_wallpaper.png'), fit: BoxFit.cover),
        Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF141E30),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
        Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const ActionAppBar(),
        bottomNavigationBar: const ActionNavigationBar(),
        body: Stack(
          fit: StackFit.expand,
          children: [

          ],
        ),
      ),]
    );
    
  }
}
