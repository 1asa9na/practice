import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class User {
  String userName;
  String? lastMessage;
  DateTime? date;
  String? userAvatar;
  int countUnreadMessages;
  Color mainColor;
  bool isSurpressed = false;
  bool isStarred = false;

  User(
    this.userName,
    this.lastMessage,
    this.date,
    this.userAvatar,
    this.countUnreadMessages,
    this.mainColor,
  );

  factory User.fromJson(Map json) => User(
      json['userName'],
      json['lastMessage'],
      json['date'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['date']),
      json['userAvatar'],
      json['countUnreadMessages'],
      Color.fromARGB(255, 128 + Random().nextInt(128),
          128 + Random().nextInt(128), 128 + Random().nextInt(128)));
}
