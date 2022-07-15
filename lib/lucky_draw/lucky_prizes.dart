import 'package:flutter/cupertino.dart';

/// content : "123"

class LuckyPrizes {
  LuckyPrizes(this.content, this.color);

  factory LuckyPrizes.fromJson(dynamic json) {
    var content = json['content'];
    var color = Color(json['color']);
    return LuckyPrizes(content, color);
  }
  String content;
  Color color;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['content'] = content;
    map['color'] = color.value;
    return map;
  }

}