import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:praktika/avatarcontainer.dart';
import 'package:praktika/user.dart';
import 'package:text_scroll/text_scroll.dart';

class ChatElement extends StatelessWidget {
  final User user;
  const ChatElement(this.user, {super.key});

  @override
  Widget build(BuildContext context) => ListTile(
        leading: AvatarContainer(user: user),
        title: Text(user.userName),
        subtitle: Text(user.lastMessage ?? "",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.montserrat(color: Colors.black87)),
        trailing: user.lastMessage == null
            ? null
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child:
                        Text(user.date!.difference(DateTime.now()).inDays < -7
                            ? DateFormat.MMMd("ru").format(user.date!)
                            : user.date!.difference(DateTime.now()).inDays < -1
                                ? DateFormat.EEEE('ru').format(user.date!)
                                : DateFormat.Hm().format(user.date!)),
                  ),
                  user.countUnreadMessages > 0
                      ? Expanded(
                          child: Container(
                          width: 35,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: user.isSurpressed
                                ? const Color.fromARGB(255, 170, 170, 170)
                                : const Color.fromARGB(255, 26, 38, 56),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              user.countUnreadMessages < 100
                                  ? "${user.countUnreadMessages}"
                                  : "99+",
                              style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ))
                      : Spacer(),
                ],
              ),
        onLongPress: () => showDialog(
          context: context,
          builder: (context) => Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                height: 200,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  color: Color.fromARGB(255, 26, 38, 56),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            AvatarContainer(
                              user: user,
                              radius: 45,
                            ),
                            TextScroll(
                              user.userName,
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.bold,
                                fontSize: 32,
                                color: Colors.white,
                              ),
                              delayBefore: Duration(seconds: 1),
                            ),
                          ])
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
