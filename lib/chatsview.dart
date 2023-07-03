import 'dart:convert';
import 'dart:math';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:praktika/chatelement.dart';
import 'package:praktika/user.dart';
import 'package:quiver/iterables.dart';
import 'package:search_page/search_page.dart';
import 'avatarcontainer.dart';

class ChatsView extends StatefulWidget {
  const ChatsView({super.key});

  @override
  State<StatefulWidget> createState() => ChatsViewState();
}

class ChatsViewState extends State<ChatsView> {
  User mainUser = User(
      "Alex Kipelov",
      null,
      null,
      null,
      0,
      Color.fromARGB(255, 128 + Random().nextInt(128),
          128 + Random().nextInt(128), 128 + Random().nextInt(128)));
  List<User> usersFilter = [];
  List<User> usersList = [];
  List<User> usersRaw = [];
  bool showEmpty = true;
  bool showUnreadOnly = false;

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
          usersRaw = list.map((e) => User.fromJson(e)).toList(),
          usersList = usersRaw,
          usersFilter = multipleFilter(usersList, [
            (u) => u.lastMessage != null,
            (u) => u.countUnreadMessages > 0,
          ], [
            !showEmpty,
            showUnreadOnly
          ]),
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
                items: usersFilter,
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
            icon: const Icon(Icons.search_sharp),
          ),
        ],
      ),
      body: Center(
        child: usersFilter.isEmpty
            ? Text("Здесь будут отображаться ваши чаты",
                style: GoogleFonts.roboto())
            : ListView.builder(
                itemCount: usersFilter.length,
                itemBuilder: (context, index) =>
                    buildItem(context, usersFilter[index])),
      ),
      drawer: Drawer(
        child: ListView(children: [
          DrawerHeader(
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 26, 38, 56)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AvatarContainer(user: mainUser),
                  Text(
                    mainUser.userName,
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 32),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
          CheckboxListTile(
            title: Text("Отображать пустые чаты", style: GoogleFonts.roboto()),
            value: showEmpty,
            onChanged: (value) => setState(() {
              showEmpty = !showEmpty;
              usersFilter = multipleFilter(usersList, [
                (u) => u.lastMessage != null,
                (u) => u.countUnreadMessages > 0,
              ], [
                !showEmpty,
                showUnreadOnly
              ]);
            }),
          ),
          CheckboxListTile(
            title: Text("Только непрочитанные", style: GoogleFonts.roboto()),
            value: showUnreadOnly,
            onChanged: (value) => setState(() {
              showUnreadOnly = !showUnreadOnly;
              usersFilter = multipleFilter(usersList, [
                (u) => u.lastMessage != null,
                (u) => u.countUnreadMessages > 0,
              ], [
                !showEmpty,
                showUnreadOnly
              ]);
            }),
          ),
          ListTile(
            title: Text("Помеченные", style: GoogleFonts.roboto()),
            onTap: () => setState(() => {
                  usersList = usersList.where((u) => u.isStarred).toList(),
                  usersFilter = multipleFilter(usersList, [
                    (u) => u.lastMessage != null,
                    (u) => u.countUnreadMessages > 0,
                  ], [
                    !showEmpty,
                    showUnreadOnly
                  ]),
                }),
          ),
          ListTile(
            title: Text("Все чаты", style: GoogleFonts.roboto()),
            onTap: () => setState(() => {
                  usersList = usersRaw,
                  usersFilter = multipleFilter(usersList, [
                    (u) => u.lastMessage != null,
                    (u) => u.countUnreadMessages > 0,
                  ], [
                    !showEmpty,
                    showUnreadOnly
                  ]),
                }),
          ),
        ]),
      ),
    );
  }

  List<User> multipleFilter(List<User> origin, List<bool Function(User)> conds,
      List<bool> condEnabled) {
    List<User> filtered = origin;
    assert(conds.length == condEnabled.length);
    for (var pair in zip([condEnabled, conds])) {
      filtered = filtered
          .where(
              (u) => !(pair[0] as bool) | (pair[1] as bool Function(User))(u))
          .toList();
    }
    if (filtered.isNotEmpty) {
      filtered.sort((a, b) => a.date == null
          ? 1
          : b.date == null
              ? -1
              : b.date!.compareTo(a.date!));
    }
    return filtered;
  }

  Widget buildItem(BuildContext context, User user) => Slidable(
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => setState(() => user.isSurpressed = true),
            backgroundColor: const Color(0xFF7BC043),
            foregroundColor: Colors.white,
            icon:
                user.isSurpressed ? Icons.volume_down : Icons.volume_mute_sharp,
            label: user.isSurpressed ? "Включить уведомления" : "Заглушить",
          ),
          SlidableAction(
            onPressed: (context) =>
                setState(() => user.isStarred = !user.isStarred),
            backgroundColor: const Color(0xFF0392CF),
            foregroundColor: Colors.white,
            icon: user.isStarred ? Icons.star_border_sharp : Icons.star,
            label: user.isStarred ? "Убрать пометку" : "Пометить",
          ),
        ],
      ),
      child: ChatElement(user));
}
