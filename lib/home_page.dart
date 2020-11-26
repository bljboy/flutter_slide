import 'package:flutter/material.dart';
import 'package:flutter_slide/bg_widget.dart';
import 'package:flutter_slide/front_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  double left = 0;
  // double top = 0;
  double direction;
  double MAX_LEFT = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(),
        preferredSize: Size.fromHeight(0),
      ),
      body: Builder(
        builder: (context) {
          MAX_LEFT = MediaQuery.of(context).size.width * 1.0 - 80;
          // MAX_LEFT = MediaQuery.of(context).size.width;
          return _buildBody();
        },
      ),
    );
  }

  Widget _buildBody() {
    return GestureDetector(
      onHorizontalDragUpdate: (update) {
        left = left + update.delta.dx;
        direction = update.delta.direction;
        if (left <= 0) {
          left = 0;
        }
        if (left > MAX_LEFT) {
          left = MAX_LEFT;
        }
        setState(() {});
      },
      onHorizontalDragEnd: (end) {
        animateWidget();
      },
      child: Container(
        color: Color(0xff191f39),
        child: Stack(
          children: [
            Container(
              child: BgWidget(open),
            ),
            Positioned(
              top: left * 0.2,
              bottom: left * 0.2,
              left: left,
              child: FrontWidget(open),
            )
          ],
        ),
      ),
    );
  }

  void open() {
    if (left == MAX_LEFT) {
      direction = 1;
    } else {
      direction = 0;
    }
    animateWidget();
  }

  Animation _animation;

  void animateWidget() {
    // bool increment = left != MAX_LEFT;
    bool increment = direction <= 0;

    AnimationController _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    )..addListener(() {
        left = _animation.value;
        // top = left * 0.3;
        setState(() {});
      });
    double temp_left = left;
    _animation = Tween(
      begin: temp_left,
      end: increment ? MAX_LEFT : 0.0,
    ).animate(CurvedAnimation(
        curve: Curves.fastLinearToSlowEaseIn, parent: _controller));
    _controller.forward();
  }
}
