import 'package:flutter/material.dart';
import 'package:flutter_myid_integration/widget/app_header.dart';
class Welcome extends StatelessWidget {
  static const header = 'Food Waste Reduction Management';

  const Welcome({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: header,
      //theme: ThemeData(),
      home: WelcomePage(title: header),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 52,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: AppHeader),
        backgroundColor: Color(0xff083C5D),
      ),
      body: Center(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                margin: const EdgeInsets.only(
                    top: 48.0, right: 0, bottom: 0, left: 0),
                width: 608,
                child: Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "Welcome",
                        style: TextStyle(
                          fontFamily: 'AvenierBook',
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                          color: Color(0xff00233C),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Mickey Mouse",
                        style: TextStyle(
                          fontFamily: 'AvenierBook',
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff00233C),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                    top: 16, right: 0, bottom: 24, left: 0),
                width: 608,
                child: Center(
                  // alignment: Alignment.center,
                  child: Text(
                    "Please select your Location to start",
                    style: TextStyle(
                      fontFamily: 'AvenierBook',
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff00233C),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: 608,
            height: 400,
            padding: const EdgeInsets.only(
                top: 24.0, right: 48.0, bottom: 24.0, left: 48.0),
            decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.all(const Radius.circular(4.0)),
              border: Border.all(
                  color: Color(0xFFE6EDEF),
                  width: 1.0,
                  style: BorderStyle.solid),
            ),
          ),
        ]),
      ),
    );
  }
}
