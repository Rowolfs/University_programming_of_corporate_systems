import 'package:flutter/material.dart';
import 'package:tier_list_app/widgets/actionNavigationBar.dart';
import 'package:tier_list_app/widgets/actionAppBar.dart';
import 'package:tier_list_app/widgets/tierListCard.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
            // Background image
            
      
            // Gradient overlay
            
      
            // Content
            GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.215,
              ),
              itemCount: 8,
              itemBuilder: (context, index) {
                return TierListCard();
              },
            ),
          ],
        ),
      ),]
    );
    
  }
}
