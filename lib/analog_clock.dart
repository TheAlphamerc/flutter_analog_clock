// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:analog_clock/utility/widgetHelper.dart';
import 'package:analog_clock/utility/widgetHelper.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show radians;
import 'container_hand.dart';

/// Total distance traveled by a second or a minute hand, each second or minute,
/// respectively.
final radiansPerTick = radians(360 / 60);

/// Total distance traveled by an hour hand, each hour, in radians.
final radiansPerHour = radians(360 / 12);
double _clockSizeFActor = 4/5;

/// A basic analog clock.
///
/// You can do better than this!
class AnalogClock extends StatefulWidget {
  @override
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock> {
  bool isStartTime = false,isEndTime = false;

  var _now = DateTime.now();
  Timer _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _updateTime();
  }

  void _updateTime() {
    setState(() {
      _now = DateTime.now();
      // Update once per second. Make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _now.millisecond),
        _updateTime,
      );
    });
  }

  Widget _horizontalSmallLine(bool isreverse ){
    return Container(
        width: 15,height: 3,
         decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: isreverse ? Radius.circular(0) : Radius.circular(5),
            bottomRight: isreverse ? Radius.circular(0) : Radius.circular(5),
            topLeft: !isreverse ? Radius.circular(0): Radius.circular(5),
            bottomLeft: !isreverse ? Radius.circular(0) : Radius.circular(5),
            ),
            color: Color(0xffb9c6d5),
          ),
      );
  }

  Widget _verticalSmallLine(bool isreverse ){
    return Container(
      width: 3,height: 15,
       decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: isreverse ? Radius.circular(5) : Radius.circular(0),
          bottomLeft: !isreverse ? Radius.circular(5) : Radius.circular(0),
          bottomRight: isreverse ? Radius.circular(0) : Radius.circular(5),
          topLeft: !isreverse ? Radius.circular(0): Radius.circular(5),
          ),
          color: Color(0xffb9c6d5),
        ),
    );
  }

  Widget _clock(){
    var size = fullWidth(context);
    var clockWidth =  size * _clockSizeFActor;
    return Container(
      width: MediaQuery.of(context).size.width ,
      child:  AspectRatio(
        aspectRatio: 5/3,
        child: Container(
                    margin: EdgeInsets.only(top: 10,bottom: 10),
                    height: clockWidth,
                    width: clockWidth,
                    decoration: decoration(context),
                    child: _innerClockBody(),
                 
              ),
      ),
    );
  }

   Widget _innerClockBody(){
     var size = fullWidth(context);
    return LayoutBuilder(
      builder: (context,contraints){
       var innerClockWidth =contraints.maxHeight;// clockWidth - 50;
       var clockWidth = size * _clockSizeFActor;
        return Container(
          width: innerClockWidth,
          child:  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: innerClockWidth,
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           crossAxisAlignment: CrossAxisAlignment.center,
                           children: <Widget>[
                            _horizontalSmallLine(false),
                            _horizontalSmallLine(true),
                         ],),
                         Column(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           crossAxisAlignment: CrossAxisAlignment.center,
                           children: <Widget>[
                             _verticalSmallLine(false),
                             _verticalSmallLine(true),
                         ],)
                        ],
                      ),
                   ),
                   /// [ Inner Circle ]
                     Container(
                       height: clockWidth/2,
                       width: clockWidth/2,
                     constraints: BoxConstraints(minHeight: innerClockWidth/2,minWidth: innerClockWidth/3,maxHeight: clockWidth/2,maxWidth:clockWidth/2),
                       decoration:  decoration(context)
                     ),
                   ///  [ Minute Hand ]
                    ContainerHand(
                     color: Colors.transparent,
                     size: .6,
                     angleRadians: _now.minute * radiansPerTick, 
                     child: Transform.translate(
                       offset: Offset(0.0, - clockWidth*.2),
                       child: Container(
                         width: 4,
                         height: clockWidth * .58,
                         decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                           color:  customTheme(context).highlightColor,
                         ),
                       ),
                     ),
                   ),
                   ///  [ Hour Hand ]
                   ContainerHand(
                     color: Colors.transparent,
                     size: 0.6,
                     angleRadians: _now.hour * radiansPerHour + (_now.minute / 60) * radiansPerHour,
                     child: Transform.translate(
                       offset: Offset(0.0,- clockWidth*.2),
                       child: Container(
                         width: 8,
                         height: clockWidth *.58,
                         decoration: BoxDecoration(
                           color: Color(0xff5E6086),
                            borderRadius: BorderRadius.circular(10)
                         ),
                       ),
                     ),
                   ),
                   ///  [ Second Hand ]
                   ContainerHand(
                     color: Colors.transparent,
                     size: 0.65,
                     angleRadians:  _now.second * radiansPerTick,
                     child: Transform.translate(
                       offset: Offset(0.0, clockWidth * .2),
                       child: Container(
                         width: 2,
                         height: clockWidth * .6 ,
                         decoration: BoxDecoration(
                           color: Colors.red,
                            borderRadius: BorderRadius.circular(10)
                         ),
                       ),
                     ),
                   ),
                    Container(
                     constraints: BoxConstraints(minHeight: 5,minWidth: 5,maxHeight: 10,maxWidth:10),
                       decoration:   BoxDecoration(
                         shape: BoxShape.circle,
                        color: Colors.red,
                     ),
                    ),
                  ],
                 ),
        );
      },
    );
               
  }

  @override
  Widget build(BuildContext context) {
     _clockSizeFActor = 3/5;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor:  Color(0xfff1f3f6),
        body: SafeArea(
          child: MediaQuery.of(context).orientation == Orientation.landscape ? _clock() :
            Column(
              mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20,),
                   Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30,vertical: 20),
                      child:  Text('Analog Clock',style: TextStyle(color: customTheme(context).primaryColor,fontSize: 30,fontWeight: FontWeight.w700),),
                    ),
                  SizedBox(height: 20,),
                  _clock(),
              ],)
        )
      ),
    );
  }
}
