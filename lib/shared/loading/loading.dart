
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class Loading extends StatelessWidget{
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoadingIndicator(
        indicatorType: Indicator.ballPulse,
        colors: [Colors.white],
        strokeWidth: 1,
        backgroundColor: Colors.blue,
        pathBackgroundColor: Colors.black
    );
  }
}