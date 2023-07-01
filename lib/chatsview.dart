import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:praktika/chatelement.dart';
import 'package:praktika/user.dart';
import 'package:search_page/search_page.dart';

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
        backgroundColor: const Color.fromARGB(255, 26, 38, 56),
        actions: [
          IconButton(
            onPressed: () => showSearch(
              context: context,
              delegate: SearchPage(
                onQueryUpdate: print,
                barTheme: ThemeData(
                  appBarTheme: const AppBarTheme(
                      backgroundColor: Color.fromARGB(255, 26, 38, 56)),
                ),
                searchStyle: GoogleFonts.roboto(color: Colors.white),
                items: users,
                suggestion: const Center(
                  child:
                      Text('Поиск чатов по сообщению или имени пользователя'),
                ),
                failure: const Center(
                  child: Text('Ничего не найдено'),
                ),
                filter: (user) => [user.userName, user.lastMessage],
                builder: (user) => ChatElement(user),
              ),
            ),
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
