import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lucky_draw/lucky_draw/lucky_prizes.dart';
import 'package:lucky_draw/lucky_draw/triangle_radius.dart';

class LuckyDraw extends StatefulWidget {
  const LuckyDraw({Key? key, required this.luckyPrizes})
      : super(key: key);

  final List<LuckyPrizes> luckyPrizes;

  @override
  State<LuckyDraw> createState() => _LuckyDrawState();

  /// 两边边距
  static const double screenMargin = 35;

  /// 圆盘半径
  static const double radius = 150;
}

class _LuckyDrawState extends State<LuckyDraw>
    with SingleTickerProviderStateMixin {

  final int _circleTime = 12;
  double _angle = 0;
  double _prizeResult = 0;
  late AnimationController _angleController;
  late Animation<double> _angleAnimation;

  int userLotteryCount = 0;

  List<LuckyPrizes> _luckyPrizesList = [];

  @override
  void initState() {
    super.initState();
    _luckyPrizesList = widget.luckyPrizes;
    _angleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
      upperBound: 1.0,
      lowerBound: 0.0,
    );
    _angleAnimation =
    CurvedAnimation(parent: _angleController, curve: Curves.easeOutCirc)
      ..addListener(() {
        if (mounted) {
          setState(() {
            _angle = _angleAnimation.value * _circleTime;
          });
        }
      })
      ..addStatusListener((status) async {
        if (status == AnimationStatus.completed) {

        }
      });

  }

  /// 开始抽奖
  void goDraw() async {
    var index = Random().nextInt(_luckyPrizesList.length);
    _prizeResult =
        (index / _luckyPrizesList.length) + _midTweenDouble;
    _angleController.forward(from: 0);
  }

  @override
  void dispose() {
    _angleController.dispose();
    super.dispose();
  }

  double get _midTweenDouble {
    if (_luckyPrizesList.isEmpty) {
      return 0;
    }
    double piTween = 1 / _luckyPrizesList.length;
    double midTween = piTween / 2;
    return midTween;
  }

  double get _prizeResultPi {
    return _prizeResult * pi * 2;
  }

  @override
  Widget build(BuildContext context) {
    Widget child = buildLuckyDisc();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lucky Draw'),
        centerTitle: true,
      ),
      backgroundColor: Colors.blue,
      body: Container(
        width: double.maxFinite,
        alignment: Alignment.center,
        child: child,
      ),
    );
  }

  /// 轮盘抽奖
  Widget buildLuckyDisc() {
    var radius = LuckyDraw.radius;
    const screenMargin = LuckyDraw.screenMargin;
    return Container(
      width: double.maxFinite,
      height: radius * 2,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: screenMargin),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 0,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                // 轮盘
                Transform.rotate(
                  angle: _angle * (pi * 2) - _prizeResultPi,
                  child: CustomPaint(
                    size: Size.fromRadius(radius),
                    painter: LuckyDrawPaint(
                      selectSize: _luckyPrizesList.length,
                      colors: _luckyPrizesList
                          .map((e) => e.color)
                          .toList(),
                      contents: _luckyPrizesList
                          .map((e) => e.content)
                          .toList(),
                    ),
                  ),
                ),

                // 外层白圈
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                ),

                // 箭头
                const Positioned(
                  top: -3,
                  child: TriangleRadius(
                    size: Size(30, 30),
                    color: Colors.black,
                  ),
                ),

                // 轮盘按钮
                Positioned(
                  child: GestureDetector(
                    onTap: goDraw,
                    child: Container(
                      width: 52,
                      height: 52,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        'GO',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 等比例圆盘
/// @author jm
class LuckyDrawPaint extends CustomPainter {
  LuckyDrawPaint({
    required this.contents,
    required this.selectSize,
    required this.colors,
  })  : assert(contents.length == selectSize && colors.length == selectSize),
        super();

  int selectSize;

  List<String> contents;

  List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    // 画笔
    Paint paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 1.0
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    // 定义一个Rect，指定扇形的面积
    Rect rect = Rect.fromCircle(
      center: Offset(
        size.width / 2,
        size.height / 2,
      ),
      radius: size.width / 2,
    );

    double startAngles = 0;

    // 根据总扇形数划分各扇形对应结束角度
    List<double> angles = List.generate(
        selectSize, (index) => (2 * pi / selectSize) * (index + 1));

    for (int i = 0; i < selectSize; i++) {
      paint.color = colors[i];
      // - (pi / 2) 是为了圆形绘制起始点在头部，而不是右手边
      double acStartAngles = startAngles - (pi / 2);
      canvas.drawArc(rect, acStartAngles, angles[i] - startAngles, true, paint);
      startAngles = angles[i];
    }

    startAngles = 0;
    for (int i = 0; i < contents.length; i++) {
      // 先保存位置
      canvas.save();

      // 记得 - (pi / 2) 跟上边的处理一样，保证起始标准一致
      double acStartAngles = startAngles - (pi / 2);
      double acTweenAngles = angles[i] - (pi / 2);
      // + pi 的原因是 文本做了向左偏移到另一边的操作，为了文本方向是从外到里，偏移后旋转半圈，即一个pi
      double roaAngle = acStartAngles / 2 + acTweenAngles / 2 + pi;

      // canvas移动到中间
      canvas.translate(size.width / 2, size.height / 2);
      // 旋转画布
      canvas.rotate(roaAngle);

      // 定义文本的样式
      TextSpan span = TextSpan(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: -1.0,
          shadows: [
            Shadow(
              color: Color(0x80000000),
              offset: Offset(0, 2),
            ),
          ],
        ),
        text: contents[i],
      );
      // 文本的画笔
      TextPainter tp = _getTextPainter(span, size, angles.first);
      // 需要给定
      tp.layout(minWidth: size.width / 4, maxWidth: size.width / 4);
      tp.paint(canvas, Offset(-size.width / 2 + 20, 0 - (tp.height / 2)));

      // 转回来
      canvas.restore();
      startAngles = angles[i];
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  double maxHeight(Size size, double angle) {
    final double radius = size.width / 2;
    var maxHeight = radius * 2 * sin(angle / 2);
    maxHeight = maxHeight * 0.75;
    return maxHeight;
  }

  TextPainter _getTextPainter(TextSpan span, Size size, double angle) {
    // 文本的画笔
    TextPainter tp = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      textWidthBasis: TextWidthBasis.longestLine,
    );
    tp.layout(minWidth: size.width / 4, maxWidth: size.width / 4);
    // 计算文本高度，超出自适应大小
    if (tp.height > maxHeight(size, angle)) {
      var temSpan = TextSpan(
        style: span.style!.copyWith(
          fontSize: span.style!.fontSize! - 1.0,
        ),
        text: span.text,
      );
      tp = _getTextPainter(temSpan, size, angle);
    }
    return tp;
  }
}