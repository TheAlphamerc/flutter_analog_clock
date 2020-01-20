import 'package:flutter/material.dart';

double fullWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
} 
double fullHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
} 
 double getDimention(context, double unit){
  if(fullWidth(context) <= 360.0){
    return unit / 1.3;
  }
  else {
    return unit;
  }
}

ThemeData customTheme(BuildContext context){
  return  Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).copyWith(
            // Hour hand.
            primaryColor: Color(0xff5E6086),
            // Minute hand.
            highlightColor: Color(0xff909abb),
            // Second hand.
            accentColor: Colors.red,
            backgroundColor: Color(0xfff1f3f6),
          )
        : Theme.of(context).copyWith(
            primaryColor: Color(0xFFD2E3FC),
            highlightColor: Color(0xFF4285F4),
            accentColor: Color(0xFF8AB4F8),
            backgroundColor: Color(0xFFe3edf7),
          );
}

BoxDecoration decoration(BuildContext context,{BoxShape shape = BoxShape.circle}){
  return  BoxDecoration(
       boxShadow: <BoxShadow>[
            BoxShadow(blurRadius: 20,offset: Offset(10, 10),color: Color(0xff3753aa).withAlpha(25),spreadRadius:5),
            BoxShadow(blurRadius: 20,offset: Offset(-10,-10),color: Color(0xaaffffff),spreadRadius:5),
            BoxShadow(blurRadius: 4,offset: Offset(2,2),color: Color(0xaaffffff).withAlpha(125),spreadRadius:1)
      ],
      color: Color(0xfff1f3f6),
      shape: shape
  );
}