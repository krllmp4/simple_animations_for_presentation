import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AnimatedFlipWrapper(), //меняйте тут виджеты и все
    );
  }
}

class AnimatedRotationLogo extends StatefulWidget {
  const AnimatedRotationLogo({super.key});

  @override
  State<AnimatedRotationLogo> createState() => _AnimatedRotationLogoState();
}

class _AnimatedRotationLogoState extends State<AnimatedRotationLogo> {
  double turns = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        turns += 1;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 300,
          width: 300,
          child: AnimatedRotation(
              turns: turns,
              duration: const Duration(milliseconds: 1000),
              child: const FlutterLogo()),
        ),
      ),
    );
  }
}

class AnimatedCrossFadeWidget extends StatefulWidget {
  const AnimatedCrossFadeWidget({super.key});

  @override
  State<AnimatedCrossFadeWidget> createState() =>
      _AnimatedCrossFadeWidgetState();
}

class _AnimatedCrossFadeWidgetState extends State<AnimatedCrossFadeWidget> {
  bool show = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        show = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedCrossFade(
          duration: const Duration(milliseconds: 5000),
          firstChild: Container(
            height: 100,
            width: 100,
            color: Colors.red,
          ),
          secondChild: Container(
            height: 100,
            width: 100,
            color: Colors.amber,
          ),
          crossFadeState:
              show ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        ),
      ),
    );
  }
}

//tween animation builder

class TweenAnimationBuilderExample extends StatefulWidget {
  const TweenAnimationBuilderExample({super.key});

  @override
  State<TweenAnimationBuilderExample> createState() =>
      _TweenAnimationBuilderExampleState();
}

class _TweenAnimationBuilderExampleState
    extends State<TweenAnimationBuilderExample> {
  bool show = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CupertinoButton(
            child: const Text('animate'),
            onPressed: () {
              setState(() {
                show = !show;
              });
            },
          ),
          TweenAnimationBuilder(
            curve: CustomCurve(),
            tween: Tween<double>(
              begin: show ? 0.1 : 1,
              end: show ? 1 : 0.1,
            ),
            duration: const Duration(milliseconds: 1000),
            builder: (BuildContext context, double value, Widget? child) {
              return Opacity(
                opacity: value,
                child: Container(
                  height: 500 * value,
                  width: 200 * value,
                  color: Colors.amber,
                ),
              );
            },
            onEnd: () {
              setState(() {
                //show = !show;
              });
            },
          ),
        ],
      ),
    );
  }
}
//тут конечно tween builder не особо надо, приемущество - синхронищзация
//позволяет анимаировать то что аниматед виджеты не могут анимировать
//прямой необходимости очен часто нет

class HeroAnimation extends StatelessWidget {
  const HeroAnimation({super.key});

  Widget build(BuildContext context) {
    timeDilation = 1;
    const photo =
        'https://farm3.staticflickr.com/2378/2178054924_423324aac8.jpg';
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: Center(
        child: PhotoHero(
          photo: photo,
          width: 300.0,
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute<void>(builder: (context) {
              return Scaffold(
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.endFloat,
                appBar: AppBar(),
                body: Container(
                  color: Colors.lightBlueAccent,
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.topLeft,
                  child: PhotoHero(
                    photo: photo,
                    width: 100.0,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              );
            }));
          },
        ),
      ),
    );
  }
}

class PhotoHero extends StatelessWidget {
  const PhotoHero({
    super.key,
    required this.photo,
    this.onTap,
    required this.width,
  });

  final String photo;
  final VoidCallback? onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Hero(
        tag: photo,

        // placeholderBuilder: (
        //   context,
        //   size,
        //   child,
        // ) {
        //   return Container(
        //     width: 10,
        //     height: 10,
        //     color: Colors.red,
        //   );
        // },
        flightShuttleBuilder: (
          BuildContext flightContext,
          Animation<double> animation,
          HeroFlightDirection flightDirection,
          BuildContext fromHeroContext,
          BuildContext toHeroContext,
        ) {
          return RotationTransition(
            turns: animation,
            child: toHeroContext.widget,
          );
        },
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Image.network(
              photo,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomCurve extends Curve {
  @override
  double transformInternal(double t) {
    print(t);
    final f = 0.5 * (1 - cos(4 * pi * t) * (1 - t) + t);
    print(f);
    return f;
  }
}

class AnimatedFlip extends StatelessWidget {
  final Widget front;
  final Widget back;
  final VoidCallback onTap;
  final bool isFlipped;

  const AnimatedFlip({
    required this.front,
    required this.back,
    required this.onTap,
    required this.isFlipped,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: TweenAnimationBuilder(
        duration: const Duration(milliseconds: 1500),
        curve: CustomCurve(),
        tween: Tween<double>(
          begin: 0,
          end: isFlipped ? 180 : 0,
        ),
        builder: (context, value, child) {
          final content = value < 90
              ? front
              : RotationOnYWidget(
                  rotationY: 180,
                  child: back,
                );

          return RotationOnYWidget(
            rotationY: value,
            child: content,
          );
        },
      ),
    );
  }
}

class AnimatedFlipWrapper extends StatefulWidget {
  const AnimatedFlipWrapper({super.key});

  @override
  State<AnimatedFlipWrapper> createState() => _AnimatedFlipWrapperState();
}

class _AnimatedFlipWrapperState extends State<AnimatedFlipWrapper> {
  bool isFlipped = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedFlip(
          front: Container(
            width: 150,
            height: 150,
            color: Colors.red,
            child: const Center(
              child: Text('front side'),
            ),
          ),
          back: Container(
            width: 150,
            height: 150,
            color: Colors.blue,
            child: const Center(
              child: Text('back side'),
            ),
          ),
          isFlipped: isFlipped,
          onTap: () {
            setState(() {
              isFlipped = !isFlipped;
            });
          },
        ),
      ),
    );
  }
}

class RotationOnYWidget extends StatelessWidget {
  static const double _radians = pi / 180;

  final Widget child;
  final double rotationY;

  const RotationOnYWidget({
    required this.child,
    this.rotationY = 0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: FractionalOffset.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(rotationY * _radians),
      child: child,
    );
  }
}
