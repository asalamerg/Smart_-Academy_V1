
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class Loading extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return LoadingIndicator(
        indicatorType: Indicator.ballPulse, /// Required, The loading type of the widget
        colors: const [Colors.white],       /// Optional, The color collections
        strokeWidth: 2,                     /// Optional, The stroke of the line, only applicable to widget which contains line
        backgroundColor: Colors.black,      /// Optional, Background of the widget
        pathBackgroundColor: Colors.black   /// Optional, the stroke backgroundColor
    );
  }
}