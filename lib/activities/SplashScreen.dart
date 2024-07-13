import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meme_generator/activities/Home.dart';


class Splashscreen extends StatefulWidget{
  @override
  _Splashscreen createState()=> _Splashscreen();
}

class _Splashscreen extends State<Splashscreen>{

  @override
  void initState(){
    super.initState();
    Timer(Duration(seconds: 3), (){
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context)=>Home())
      );
    });
  }
  @override
  Widget build(BuildContext context){
    var wid = MediaQuery.of(context).size.width;
    var hei = MediaQuery.of(context).size.height;
    return Scaffold(
            body: Container(
                height: hei,
                width: wid,
                color: Colors.blue,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Text('Meme', style: TextStyle(
                          fontSize: 60,
                          color: Colors.white,
                          fontWeight: FontWeight.bold))
                      ,
                       Text('Generator', style: TextStyle(
                          fontSize:30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                          ),
                          textAlign: TextAlign.left,
                        ),

                      Text('😅', style: TextStyle(
                          fontSize: 60,
                          color: Colors.white,
                          fontWeight: FontWeight.bold))
                    ]
                )

        )

    );
  }
}