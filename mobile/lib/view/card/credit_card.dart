import 'dart:math';
import 'package:client/model/application.dart';
import 'package:client/model/booking.dart';
import 'package:client/model/offer.dart';
import 'package:client/view/card/style/card_back_layout.dart';
import 'package:client/view/card/style/card_front_layout.dart';
import 'package:flutter/material.dart';

class CreditCard extends StatefulWidget {
  final String type;
  final Offer? offer;
  final Application? application;
  final Booking? booking;
  final int index;
  final String name;
  final Color frontTextColor;
  final Color backTextColor;
  final bool showBackSide;
  final Widget frontBackground;
  final Widget backBackground;
  final Widget? frontLayout;
  final Widget? backLayout;
  final bool showShadow;
  final double? width;
  final double? height;
  final double horizontalMargin;

  CreditCard({
    Key? key,
    required this.type,
    this.offer,
    this.application,
    this.booking,
    required this.index,
    required this.name,
    this.showBackSide = false,
    required this.frontBackground,
    required this.backBackground,
    this.frontLayout,
    this.backLayout,
    this.frontTextColor = Colors.white,
    this.backTextColor = Colors.black,
    this.showShadow = false,
    this.width,
    this.height,
    this.horizontalMargin = 20,
  }) : super(key: key);

  @override
  _CreditCardState createState() => _CreditCardState();
}

class _CreditCardState extends State<CreditCard>
    with SingleTickerProviderStateMixin {
  double? cardWidth;
  double? cardHeight;
  late AnimationController _controller;
  Animation<double>? _moveToBack;
  Animation<double>? _moveToFront;

  @override
  void initState() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    _moveToBack = TweenSequence<double>([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: pi / 2)
              .chain(CurveTween(curve: Curves.easeInBack)),
          weight: 50.0),
      TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2), weight: 50.0)
    ]).animate(_controller);

    _moveToFront = TweenSequence<double>(
      [
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: -pi / 2, end: 0.0)
              .chain(CurveTween(curve: Curves.easeOutBack)),
          weight: 50.0,
        ),
      ],
    ).animate(_controller);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.width == null
        ? cardWidth =
            MediaQuery.of(context).size.width - (2 * widget.horizontalMargin)
        : cardWidth = widget.width;
    widget.height == null
        ? cardHeight = (cardWidth! / 2) + 24
        : cardHeight = widget.height;

    if (widget.showBackSide) {
      _controller.forward();
    } else {
      _controller.reverse();
    }

    return Center(
      child: Stack(
        children: <Widget>[
          AwesomeCard(
            animation: _moveToFront,
            child: _buildFrontCard(),
          ),
          AwesomeCard(
            animation: _moveToBack,
            child: _buildBackCard(),
          ),
        ],
      ),
    );
  }

  Widget _buildFrontCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: widget.horizontalMargin),
      width: cardWidth,
      height: cardHeight,
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.black54,
          blurRadius: 12.0,
          spreadRadius: 0.2,
          offset: Offset(
            3.0,
            3.0,
          ),
        )
      ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Stack(
          children: [
            // Background for card
            widget.frontBackground,

            // Front Side Layout
            widget.type == "offer"
                ? (widget.frontLayout ??
                    CardFrontLayout(
                      offer: widget.offer,
                      index: widget.index,
                      name: widget.name,
                      textColor: widget.frontTextColor,
                    ).layout1())
                : widget.type == "application"
                    ? (widget.frontLayout ??
                        CardFrontLayout(
                          application: widget.application,
                          index: widget.index,
                          name: widget.name,
                          textColor: widget.frontTextColor,
                        ).layout2())
                    : widget.frontLayout ??
                        CardFrontLayout(
                          booking: widget.booking,
                          index: widget.index,
                          name: widget.name,
                          textColor: widget.frontTextColor,
                        ).layout3(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: widget.horizontalMargin),
      width: cardWidth,
      height: cardHeight,
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.black54,
          blurRadius: 12.0,
          spreadRadius: 0.2,
          offset: Offset(
            3.0,
            3.0,
          ),
        )
      ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Stack(
          children: <Widget>[
            // Background for card
            widget.backBackground,

            // Back Side Layout
            widget.type == "offer"
                ? widget.backLayout ??
                    CardBackLayout(
                      index: widget.index,
                      width: cardWidth,
                      height: cardHeight,
                      color: widget.backTextColor,
                    ).layout1()
                : widget.type == "application"
                    ? widget.backLayout ??
                        CardBackLayout(
                          index: widget.index,
                          width: cardWidth,
                          height: cardHeight,
                          color: widget.backTextColor,
                        ).layout2()
                    : widget.backLayout ??
                        CardBackLayout(
                          index: widget.index,
                          width: cardWidth,
                          height: cardHeight,
                          color: widget.backTextColor,
                        ).layout3(),
          ],
        ),
      ),
    );
  }
}

class AwesomeCard extends StatelessWidget {
  final Animation<double>? animation;
  final Widget child;

  AwesomeCard({required this.animation, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation!,
      builder: (BuildContext context, Widget? child) {
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(animation!.value),
          alignment: Alignment.center,
          child: this.child,
        );
      },
    );
  }
}
