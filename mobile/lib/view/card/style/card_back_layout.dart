import 'package:flutter/material.dart';

class CardBackLayout {
  int index;
  double? width;
  double? height;
  Color? color;

  CardBackLayout({
    required this.index,
    this.width,
    this.height,
    this.color,
  });

  Widget layout1() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 30,
        ),
        Container(
          color: Colors.black,
          height: 50,
          width: width,
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: SizedBox(
                height: 50,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Offer ${index + 1}",
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w500,
                      color: color,
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget layout2() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 30,
        ),
        Container(
          color: Colors.black,
          height: 50,
          width: width,
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: SizedBox(
                height: 50,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Application ${index + 1}",
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w500,
                      color: color,
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget layout3() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 30,
        ),
        Container(
          color: Colors.black,
          height: 50,
          width: width,
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: SizedBox(
                height: 50,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Booking ${index + 1}",
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w500,
                      color: color,
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
