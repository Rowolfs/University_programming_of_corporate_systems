import "package:flutter/material.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_corner/smooth_corner.dart';
import 'package:tier_list_app/widgets/actionButton.dart';

class ActionModal extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final List<Widget> children;
  const ActionModal({super.key,required this.label, required this.children, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: SmoothContainer(
          width: 350.w,
          height: 484.h,
          color: Color(0xFF101010),
          borderRadius: BorderRadiusGeometry.circular(10.r),
          smoothness: 1,
          child: Stack(
            children: [
              Center(child: Column(children: [for (final child in children) child])),
              Positioned(top: 411.h, left: 25.w, child: ActionButton(label: label, onPressed: onPressed))
            ]
            
          ) 
          
        ),
      ),
    );
  }
}