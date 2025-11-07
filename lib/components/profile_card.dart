import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget{
  final Widget child;
  const ProfileCard({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: EdgeInsets.all(10),
        child: child,
      ),
    );
  }

}