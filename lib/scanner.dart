import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'dart:async';


class Scanner extends StatefulWidget {
  @override
  _ScannerState createState() => _ScannerState();
}  


class _ScannerState extends State<Scanner> {

  String scanRes = "Scan Result";

  Future doScan() async
  {
    try {
      String qrResult = "";
      setState(() {
        scanRes = qrResult;
      });
    } on PlatformException catch(e) {
      setState(() {
        scanRes = "Error";
      });
    } on FormatException {
      setState(() {
        scanRes = "Scan Incomplete";
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan Label"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text(
              "Press to scan",
              style: new TextStyle(
                fontSize:15
              ),
            ),
            onPressed: doScan,
          ),

          Text(
              scanRes,
              style: new TextStyle(
                fontSize:15
              ),
            )

        ],
      )
    );
  }
}