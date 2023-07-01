import 'dart:convert';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:praktika/chatelement.dart';
import 'package:praktika/user.dart';

class ChatsView extends StatefulWidget {
  const ChatsView({super.key});

  @override
  State<StatefulWidget> createState() => _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView> {
  List<User> users = [];

  @override
  initState() {
    super.initState();
    loadJsonFromAssets();
    initializeDateFormatting();
  }

  Future<void> loadJsonFromAssets() async {
    String data = await rootBundle.loadString("assets/bootcamp.json");
    List<dynamic> list = jsonDecode(data)['data'] as List<dynamic>;
    setState(() => {
          users = list.map((e) => User.fromJson(e)).toList(),
          users.sort(
            (a, b) => a.date == null
                ? 1
                : b.date == null
                    ? -1
                    : b.date!.compareTo(a.date!),
          ),
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search_sharp),
          ),
        ],
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.menu),
        ),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) => ChatElement(users[index]),
        ),
      ),
    );
  }
}
