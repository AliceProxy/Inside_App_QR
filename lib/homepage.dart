import 'package:flutter/material.dart';
import 'package:whatsInsideQR/generate.dart';
import 'package:whatsInsideQR/scanner.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:barcode_scan/barcode_scan.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with TickerProviderStateMixin {

  String scanContents = "";

  PageController _pageController;
  AnimationController rippleController;
  AnimationController scaleController;
  AnimationController scanScaleController;
  Animation<double> rippleAnimation;
  Animation<double> scaleAnimation;
  Animation<double> scanScaleAnimation;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      initialPage: 0
    );

    rippleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100)
    );

    scaleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100)
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Generator())
        ).then((value) {
          scaleController.reset();
        });
      }
    });

    Future doScan() async{
      try{
        ScanResult scanRes = await BarcodeScanner.scan();
        setState(() {
          scanContents = scanRes.toString();
        });
      } on PlatformException catch(ex) {
        print("Platform Exception!");
      }
      
    }

    scanScaleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100)
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        /*Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Scanner())
        ).then((value) {
          scanScaleController.reset();
        });
        */
        doScan().then((value) {
          scanScaleController.reset();
        });
      }
    });

    rippleAnimation = Tween<double>(
      begin: 80.0,
      end: 90.0
    ).animate(rippleController)..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        rippleController.reverse();
      } else if(status == AnimationStatus.dismissed) {
        rippleController.forward();
      }
    });

    scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 30.0
    ).animate(scaleController);

    scanScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 30.0
    ).animate(scanScaleController);

    //rippleController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        title: Text("What's Inside QR"),
        centerTitle: true
      ),

      body: PageView( 
        controller: _pageController,
        children: <Widget>
        [
          Container(
            decoration: BoxDecoration(
              gradient: new LinearGradient(
                colors: [const Color(0xffff6e7f), const Color(0xffbfe9ff)],
                begin: FractionalOffset.bottomRight,
                end: FractionalOffset.topLeft,
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp
              )
            ),
            padding: EdgeInsets.all(50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Image(image: NetworkImage("https://i.imgur.com/f01aCnR.png")),
                //flatButton("Scan Label", Scanner()),
                //flatButton("Create Label", Generator())

              ]
            )
          ),
        ]
      ),
      
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      
      floatingActionButton: 
      Stack(
        children: <Widget>[


Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Generate QR Button
          AnimatedBuilder(
            animation: rippleAnimation,
            builder: (context, child) => Container(
              width: rippleAnimation.value,
              height: rippleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.withOpacity(0.4)
                ),
                child: InkWell(
                  onTap: () {
                    scaleController.forward();
                  },
                  child: AnimatedBuilder(
                    animation: scaleAnimation,
                    builder: (context, child) => Transform.scale(
                      scale: scaleAnimation.value,
                      child: Container(
                        child: scaleAnimation.status != AnimationStatus.dismissed ? Container() : Icon(Icons.add, size: 30,),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red[400]
                        ),

                      ),
                    )
                  ),
                ),
              ),
            )
          ),

          // Scan QR Button
           AnimatedBuilder(
            animation: rippleAnimation,
            builder: (context, child) => Container(
              width: rippleAnimation.value,
              height: rippleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.withOpacity(0.4)
                ),
                child: InkWell(
                  onTap: () {
                    scanScaleController.forward();
                  },
                  child: AnimatedBuilder(
                    animation: scanScaleAnimation,
                    builder: (context, child) => Transform.scale(
                      scale: scanScaleAnimation.value,
                      child: Container(
                        child: scanScaleAnimation.status != AnimationStatus.dismissed ? Container() : Icon(Icons.camera_alt, size: 30),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red[400]
                        ),

                      ),
                    )
                  ),
                ),
              ),
            )
          )
        ],
      )


        ]
      )
      
    );
  }

/*
  Widget flatButton(String text, Widget widget)
  {
    return FlatButton(
      child: Text(text),
      onPressed: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>widget));
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      )
    );
  }
  */
}