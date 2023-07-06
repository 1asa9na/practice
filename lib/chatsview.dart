import 'dart:convert';
import 'dart:math';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:praktika/apptheme.dart';
import 'package:praktika/chatelement.dart';
import 'package:praktika/colorpalette.dart';
import 'package:praktika/themepickerwidget.dart';
import 'package:praktika/user.dart';
import 'package:quiver/iterables.dart';
import 'package:search_page/search_page.dart';
import 'avatarcontainer.dart';
import 'constants.dart';

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
  bool isLightThemeOn = false;
  AppTheme appTheme = AppTheme(Constants.colorSchemes[0]);

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
      backgroundColor: appTheme.mainThemeAmbientColor,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: appTheme.mainThemeElementColor),
        toolbarTextStyle: appTheme.mainTextStyle,
        backgroundColor: appTheme.mainThemeAccentColor,
        actions: [
          IconButton(
            onPressed: () => showSearch(
              context: context,
              delegate: SearchPage(
                barTheme: ThemeData(
                  appBarTheme: AppBarTheme(
                      titleTextStyle: appTheme.mainTextStyle,
                      foregroundColor: appTheme.mainThemeElementColor,
                      iconTheme:
                          IconThemeData(color: appTheme.mainThemeElementColor),
                      backgroundColor: appTheme.mainThemeAccentColor),
                ),
                searchStyle: appTheme.mainTextStyle,
                items: usersFilter,
                suggestion: Center(
                  child: Text(
                    'Поиск чатов по сообщению или имени пользователя',
                    style: appTheme.mainTextStyle,
                  ),
                ),
                failure: Center(
                  child:
                      Text('Ничего не найдено', style: appTheme.mainTextStyle),
                ),
                filter: (user) => [user.userName, user.lastMessage],
                builder: (user) => ChatElement(user, appTheme),
              ),
            ),
            icon: const Icon(
              Icons.search_sharp,
            ),
          ),
          IconButton(
              onPressed: () => setState(() {
                    isLightThemeOn = !isLightThemeOn;
                    updateTheme(appTheme.colorScheme);
                  }),
              icon: Icon(
                isLightThemeOn
                    ? Icons.brightness_2_sharp
                    : Icons.brightness_4_sharp,
              ))
        ],
      ),
      body: Center(
        child: usersFilter.isEmpty
            ? Text("Здесь будут отображаться ваши чаты",
                style: appTheme.mainTextStyle)
            : ListView.builder(
                itemCount: usersFilter.length,
                itemBuilder: (context, index) =>
                    buildItem(context, usersFilter[index])),
      ),
      drawer: Drawer(
        backgroundColor: appTheme.mainThemeAmbientColor,
        child: ListView(children: [
          DrawerHeader(
            decoration: BoxDecoration(color: appTheme.mainThemeAccentColor),
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
                    style: appTheme.headerTextStyle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
          CheckboxListTile(
            title:
                Text("Отображать пустые чаты", style: appTheme.mainTextStyle),
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
            title: Text("Только непрочитанные", style: appTheme.mainTextStyle),
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
            title: Text("Помеченные", style: appTheme.mainTextStyle),
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
            title: Text("Все чаты", style: appTheme.mainTextStyle),
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
      bottomNavigationBar: BottomAppBar(
        color: appTheme.mainThemeAccentColor,
        shape: CircularNotchedRectangle(),
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.contacts_sharp,
                color: appTheme.mainThemeElementColor,
              ),
            ),
            IconButton(
              onPressed: () => showDialog(
                  context: context,
                  builder: (context) => ThemePickerWidget(updateTheme)),
              icon: Icon(Icons.brush_sharp,
                  color: appTheme.mainThemeElementColor),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: appTheme.mainThemeAccentColor,
        onPressed: () {},
        child: Icon(
          Icons.add,
          color: appTheme.mainThemeElementColor,
        ),
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
      child: ChatElement(user, appTheme));

  void updateTheme(ColorPalette colorScheme) => setState(
      () => appTheme = AppTheme(colorScheme, isLightThemeOn: isLightThemeOn));
}
