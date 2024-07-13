import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui' as ui;

import 'package:permission_handler/permission_handler.dart';

class Home extends StatefulWidget{
  @override
  _Home createState()=> _Home();
}

class _Home extends State<Home>{
  File? _imagePick;
  final picker = ImagePicker();
  String header = '';
  String footer = '';
  var _headSize = 16.0;
  var _footSize = 16.0;
  TextEditingController _headerCont = TextEditingController();
  TextEditingController _footerCont = TextEditingController();

   var _imageFile;
   GlobalKey _globalKey = GlobalKey();

  Future imagePic()async{
    try{
      var img = await picker.pickImage(source: ImageSource.gallery);
      if(img != null){
        setState((){
          _imagePick = File(img.path);
        });
      }
    }catch(err){
      print('Picking image err: $err');
    }
  }

  Future _takeScreen()async{
      try{
        RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
        ui.Image image = await boundary.toImage();
        ByteData? byteData =
        await (image.toByteData(format: ui.ImageByteFormat.png));
        if (byteData != null) {
          final result =
          await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
          print(result);
        }
        _headerCont.clear();
        _footerCont.clear();
        Fluttertoast.showToast(
            msg: 'Meme is saved!',
            toastLength: Toast.LENGTH_LONG,
            fontSize: 20,
            textColor: Colors.white,
            backgroundColor: Colors.blue,
            gravity: ToastGravity.BOTTOM,
        );
      }catch(err){
        print('error in taking screenShot: $err');
      }
  }
  @override
  Widget build(BuildContext context){
    var wid = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title:const Text('Meme Generator 😅', style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold
        )),
        backgroundColor: Colors.blue
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RepaintBoundary(
                    key: _globalKey,
                  child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 15),
                    height: 400,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade500,
                          offset: Offset(1,1),
                          blurRadius: 3
                        )
                      ]
                    ),
                    child: _imagePick != null ? Image.file(
                        _imagePick!,
                        height: 300,
                      fit: BoxFit.fill
                    )
                        : Container(
                      alignment: Alignment.center,
                      child: Text('Please pick an Image', style: TextStyle(
                        fontSize: 22, color: Colors.black
                      ))
                    )
                  ),

                  Container(
                        margin: EdgeInsets.only(top: 30),
                        padding:_headerCont.text.toString() != ''
                            ? EdgeInsets.only(left: 10, right: 10)
                            : EdgeInsets.all(0),
                        alignment: Alignment.center,
                        // color: Colors.black,
                        child: Text('${_headerCont.text.toString().toUpperCase()}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: _headSize,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ))
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 330),
                      padding: _footerCont.text.toString() != ''
                                ? EdgeInsets.only(left: 10, right: 10)
                                : EdgeInsets.all(0),
                      alignment: Alignment.center,
                      // color: Colors.black,
                      child: Text('${_footerCont.text.toString().toUpperCase()}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                          fontSize: _headSize,
                          color: Colors.white,
                              fontWeight: FontWeight.bold

                        )))

                  ])),
                  Container(
                    child: Column(
                      children: [
                        ElevatedButton(
                            child:const Text('Pick an Image', style: TextStyle(
                                fontSize: 22, color: Colors.white
                            )),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                )
                            ),
                            onPressed: (){
                              imagePic();
                            }
                        ),
                        Container(
                            margin: EdgeInsets.only(bottom: 5),
                            padding: EdgeInsets.only(top: 3, bottom: 3),
                            width: (wid/100) * 95,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue,
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Text('Font Size',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 20,
                                        color: Colors.white
                                      ))
                                  ),
                                  Container(
                                    height: 30,
                                  child: Slider( //slider is here
                                    value: _headSize,
                                    min: 15,
                                    max: 55,
                                    label: _headSize.round().toString(),
                                    divisions: 40,
                                    thumbColor: Colors.red,
                                    activeColor: Colors.red,
                                    inactiveColor: Colors.red.shade100,
                                    onChanged: (value){
                                      setState((){
                                        _headSize = value;
                                      });
                                    },
                                  )),
                                ]
                            )
                        ),
                        Container(
                          height: 50,
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: TextField(
                          controller: _headerCont,
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.black
                          ),
                          decoration: InputDecoration(
                            labelText: 'Header',
                            labelStyle: TextStyle(
                              fontSize: 22,
                              color: Colors.blue
                            ),
                            hintText: 'Header Text here',
                            hintStyle: TextStyle(
                              fontSize: 22,
                              color: Colors.grey.shade500
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.blue
                              ),
                              borderRadius: BorderRadius.circular(10)
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.blue
                              ),
                              borderRadius: BorderRadius.circular(10)
                            )
                          ),

                        ),),

                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 50,
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: TextField(
                            controller: _footerCont,
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.black
                            ),
                            decoration: InputDecoration(
                                labelText: 'Footer',
                                labelStyle: TextStyle(
                                    fontSize: 22,
                                    color: Colors.blue
                                ),
                                hintText: 'Footer Text here',
                                hintStyle: TextStyle(
                                    fontSize: 22,
                                    color: Colors.grey.shade500
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2,
                                        color: Colors.blue
                                    ),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2,
                                        color: Colors.blue
                                    ),
                                    borderRadius: BorderRadius.circular(10)
                                )
                            ),

                          ),),
                      ]
                    )
                  ),

                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          child: const Text('Save', style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                          )),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                            )
                          ),
                          onPressed: (){
                            _takeScreen();
                          }
                        ),
                        SizedBox(width: 20),
                        
                      ]
                    )
                  ),

                ]
              )
            )
          )
      )
    );
  }
}