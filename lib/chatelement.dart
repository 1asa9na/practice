import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:praktika/user.dart';

class ChatElement extends StatelessWidget {
  final User user;
  const ChatElement(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Colors.white,
                user.mainColor,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            image: user.userAvatar != null
                ? DecorationImage(
                    image: AssetImage('assets/avatars/${user.userAvatar}'),
                    fit: BoxFit.fill,
                  )
                : null,
          ),
          child: user.userAvatar == null
              ? Center(
                  child: Text(
                    user.userName[0],
                    style: GoogleFonts.montserrat(
                        fontSize: 24,
                        color: Color.fromARGB(
                            255,
                            255 - user.mainColor.red,
                            255 - user.mainColor.green,
                            255 - user.mainColor.blue),
                        fontWeight: FontWeight.w900),
                  ),
                )
              : null,
        ),
      ),
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
                  child: Text(user.date!.difference(DateTime.now()).inDays < -7
                      ? DateFormat.MMMd("ru").format(user.date!)
                      : user.date!.difference(DateTime.now()).inDays < -1
                          ? DateFormat.EEEE('ru').format(user.date!)
                          : DateFormat.Hm().format(user.date!)),
                ),
                user.countUnreadMessages > 0
                    ? Expanded(
                        child: Container(
                        width: 35,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(255, 26, 38, 56),
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
    );
  }
}
