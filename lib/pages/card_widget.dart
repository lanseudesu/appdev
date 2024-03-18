import 'dart:math';
import 'package:appdev/models/card.dart';
import 'package:flutter/material.dart';

class CardWidget extends StatefulWidget {
  final Cards card;
  final Function(Cards)? onTap;

  const CardWidget({
    required this.card,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  AnimationStatus _status = AnimationStatus.dismissed;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400))
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            _status = status;
            if (_status == AnimationStatus.completed) {
              Future.delayed(Duration(milliseconds: 800), () {
                if (_status == AnimationStatus.completed) {
                  _controller.reverse();
                }
              });
            }
          });
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _isAnimating = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!_isAnimating) {
          if (_status == AnimationStatus.completed) {
            // Reverse animation if it's already completed
            _controller.reverse();
          } else {
            // Start animation if it's not already playing
            _controller.forward();
          }
          if (widget.onTap != null) {
            widget.onTap!(widget.card);
          }
        } else {
          // Reverse animation immediately if another card is tapped
          _controller.reverse();
          if (widget.onTap != null) {
            widget.onTap!(widget.card);
          }
        }
      },
      child: Container(
        height: 100, // Adjust the height as needed
        width: 100, // Adjust the width as needed
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            print('Animation value: ${_animation.value}');
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(_animation.value * pi),
              child: child,
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: _animation.value <= 0.5 ? Color(0xffFFBEF3) : Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(widget.card.val),
            ),
          ),
        ),
      ),
    );
  }
}