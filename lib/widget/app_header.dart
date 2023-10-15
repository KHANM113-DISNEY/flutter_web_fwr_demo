import 'package:flutter/material.dart';

List<Widget> get AppHeader {
  return <Widget>[
    Column(
      children: <Widget>[
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(
                width: 7,
              ),
              SizedBox(
                width: 24.0,
                height: 24.0,
                child: Image.asset(
                    'asset/images/ic_hamburger.png'), // Your image widget here
              ),
              Padding(padding: EdgeInsets.only(left: 20.0)),
              SizedBox(
                child: Text(
                  'Food Waste Management',
                  style: TextStyle(
                      fontFamily: 'AvenierBook',
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.normal),
                ),
              ),
            ]),
      ],
    ),
    Row(
      children: <Widget>[
        // SizedBox(
        //   width: 225.0,
        //   height: 36.0,
        //   child: TextField(
        //     style: TextStyle(
        //       fontSize: 14,
        //       fontFamily: 'AvenierBook',
        //     ),
        //     decoration: InputDecoration(
        //       border: OutlineInputBorder(
        //         borderSide:
        //             new BorderSide(color: Color(0xFF8596AA), width: 1.0),
        //         borderRadius: BorderRadius.only(
        //           topRight: Radius.circular(0),
        //           bottomRight: Radius.circular(0),
        //           topLeft: Radius.circular(2.0),
        //           bottomLeft: Radius.circular(2.0),
        //         ),
        //       ),
        //       filled: true,
        //       fillColor: const Color(0xFFFFFFFF),
        //       hoverColor: const Color(0xFFFFFFFF),
        //       focusedBorder: OutlineInputBorder(
        //         borderSide:
        //             const BorderSide(color: Color(0xFF8596AA), width: 1.0),
        //         borderRadius: BorderRadius.only(
        //           topRight: Radius.circular(0),
        //           bottomRight: Radius.circular(0),
        //           topLeft: Radius.circular(2.0),
        //           bottomLeft: Radius.circular(2.0),
        //         ),
        //       ),
        //       contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
        //       hintText: "Search",
        //       hintStyle: const TextStyle(
        //         fontFamily: 'AvenierBook',
        //         fontSize: 14,
        //         color: Color(0xFFB3B1B1),
        //       ),
        //     ),
        //   ),
        // ),
        // const SizedBox(
        //   width: 32.0,
        //   height: 34.0,
        //   child: DecoratedBox(
        //     decoration: BoxDecoration(
        //       color: Color(0xFFffffff),
        //       image: DecorationImage(
        //         image: AssetImage('asset/images/ic_search.png'),
        //       ),
        //     ),
        //   ),
        // ),
        // SizedBox(
        //   width: 20,
        // ),
        Container(
          width: 28.0,
          height: 28.0,
          decoration: BoxDecoration(
            color: Color(0xffffffff),
            borderRadius: BorderRadius.circular(14.0),
          ),
          child: Center(
            child: Text('MM',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'AvenierBook',
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                  color: Color(0xFF253b56),
                )),
          ),
        ),
        SizedBox(
          width: 4,
        ),
      ],
    ),
  ];
}
