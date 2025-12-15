import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});
  

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return isLandscape ?  SignInPageHorizontal() : SignInPageVertical();
  }
}


class SignInPageVertical extends StatefulWidget {
  const SignInPageVertical({super.key});

  @override
  State<SignInPageVertical> createState() => _SignInPageVerticalState();
}

class _SignInPageVerticalState extends State<SignInPageVertical> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


class SignInPageHorizontal extends StatefulWidget {
  const SignInPageHorizontal({super.key});

  @override
  State<SignInPageHorizontal> createState() => _SignInPageHorizontalState();
}

class _SignInPageHorizontalState extends State<SignInPageHorizontal> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}