import 'package:flutter/material.dart';
import 'dart:math';

class SaturnLoading extends StatefulWidget {
  const SaturnLoading({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _SaturnLoading();

  void start() {
    _SaturnLoading().start();
  }
  void stop() {
    _SaturnLoading().stop();
  }
}

class _SaturnLoading extends State<SaturnLoading> with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation? _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _animation = Tween<double>(begin: 0, end: pi*2).animate(_animationController!);
    _animationController!.repeat();
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController!,
      builder: (context, child) {
        return SizedBox(
          width: 100,
          height: 100,
          child: Stack(
            children: [
              Image.asset('repo/images/circle.png', width: 100, height: 100,),
              Center(
                child: Image.asset('repo/images/sunny.png', width: 30, height: 30,),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Transform.rotate(
                  angle: _animation!.value,
                  origin: const Offset(35,35),  // 회전의 기준점 지정하기.
                  child: Image.asset('repo/images/saturn.png', width: 20, height: 20,),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void stop() {
    _animationController!.stop(canceled: true);
  }

  void start() {
    _animationController!.repeat();
  }
}
