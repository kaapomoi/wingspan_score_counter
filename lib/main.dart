import 'score_counter.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(systemNavigationBarColor: Color(0xff121212)));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wingspan score counter',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: "Wingspan score counter"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int sum = 0;
  bool scoreRevealed = false;

  void addToSum(int value) {
    setState(() {
      sum += value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Padding(padding: EdgeInsets.all(16.0)),
            ScoreCounter(
                iconPath: "assets/EndGameSlider_1_birds.png", cb: addToSum),
            ScoreCounter(
                iconPath: "assets/EndGameSlider_2_bonus.png", cb: addToSum),
            ScoreCounter(
                iconPath: "assets/EndGameSlider_3_goals.png", cb: addToSum),
            ScoreCounter(
                iconPath: "assets/EndGameSlider_4_eggs.png", cb: addToSum),
            ScoreCounter(
                iconPath: "assets/EndGameSlider_5_food.png", cb: addToSum),
            ScoreCounter(
                iconPath: "assets/EndGameSlider_6_tucked.png", cb: addToSum),
            ScoreCounter(
                iconPath: "assets/EndGameSlider_7_nectar.png", cb: addToSum),
            SizedBox(
              width: 320.0,
              height: 80.0,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    scoreRevealed = !scoreRevealed;
                  });
                  HapticFeedback.vibrate();
                },
                child: scoreRevealed
                    ? DigitScrollAnimation(
                        value: sum, // Your three-digit variable here
                        duration: const Duration(seconds: 5),
                      )
                    : Text(
                        'reveal score',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DigitScrollAnimation extends StatefulWidget {
  final int value;
  final Duration duration;

  const DigitScrollAnimation(
      {super.key, required this.value, required this.duration});

  @override
  State<DigitScrollAnimation> createState() => _DigitScrollAnimationState();
}

class _DigitScrollAnimationState extends State<DigitScrollAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = IntTween(
      begin: 0,
      end: widget.value,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuint));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final fontSize = 24.0 + (_animation.value / 3.0);

        return Text(
          _animation.value.toString(),
          style: TextStyle(fontSize: fontSize),
        );
      },
    );
  }
}
