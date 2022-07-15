import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lucky_draw/lucky_draw/lucky_draw.dart';
import 'package:lucky_draw/lucky_draw/lucky_prizes.dart';

class PrizesSettingPage extends StatefulWidget {
  const PrizesSettingPage({Key? key}) : super(key: key);

  @override
  State<PrizesSettingPage> createState() => _PrizesSettingPageState();
}

class _PrizesSettingPageState extends State<PrizesSettingPage> {

  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  Color colorBg = Colors.white;

  List<LuckyPrizes> _list = [
    LuckyPrizes('家里蹲', Colors.grey),
    LuckyPrizes('三亚', Colors.greenAccent),
    LuckyPrizes('迪士尼', Colors.green),
    LuckyPrizes('珠穆朗玛峰', Colors.amber),
    LuckyPrizes('月球', Colors.deepPurpleAccent),
  ];

  void addPrizes() {
    var text = _contentController.text;
    var color = _colorController.text;
    if (text.isEmpty || color.length < 9) {
      return;
    }
    LuckyPrizes prizes = LuckyPrizes(text, HexColor(color));
    _list.add(prizes);
    setState(() {
    });
  }

  void removePrizes(LuckyPrizes prizes) {
    _list.removeWhere((e) => prizes.color == e.color && prizes.content == e.content);
    setState(() {
    });
  }

  void goLuckyDraw() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return LuckyDraw(
        luckyPrizes: _list,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: _list.length,
          itemBuilder: (context, index) {
            var prizes = _list[index];
            return _buildItem(prizes);
          },
        ),
        _buildAddContainer(),
        const Spacer(),
        GestureDetector(
          onTap: goLuckyDraw,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.circular(15),
            ),
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text(
              '生成轮盘',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItem(LuckyPrizes prizes) {
    return Container(
      width: double.maxFinite,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          const Text(
            '文本:',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),

          Expanded(
            flex: 2,
            child: Text(
              prizes.content,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 10),

          const Text(
            '颜色',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: prizes.color,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          const SizedBox(width: 10),

          GestureDetector(
            onTap: () {
              removePrizes(prizes);
            },
            child: const Icon(
              Icons.remove_circle,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddContainer() {
    return Container(
      width: double.maxFinite,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          const Text(
            '文本',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),

          Expanded(
            flex: 2,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                Container(
                  height: 50,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: _contentController,
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                    decoration: const InputDecoration(
                      hintText: "轮盘文案",
                      hintStyle: TextStyle(
                        fontSize: 13,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(width: 10),

          const Text(
            '颜色',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: colorBg,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),

                Container(
                  height: 50,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: _colorController,
                    onChanged: (value) {
                      if (value.length == 9) {
                        var temColor = HexColor(value);
                        setState(() {
                          colorBg = temColor;
                        });
                      } else {
                        if (colorBg.value != Colors.white.value) {
                          setState(() {
                            colorBg = Colors.white;
                          });
                        }
                      }
                    },
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                    decoration: const InputDecoration(
                      hintText: "#FFFFFFFF",
                      hintStyle: TextStyle(
                        fontSize: 13,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(width: 10),

          GestureDetector(
            onTap: addPrizes,
            child: const Icon(
              Icons.add_circle,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

}
