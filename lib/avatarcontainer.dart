import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:praktika/user.dart';

class AvatarContainer extends StatelessWidget {
  final User user;
  final double? radius;
  const AvatarContainer({super.key, required this.user, this.radius});

  @override
  Widget build(BuildContext context) => CircleAvatar(
        radius: radius,
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
                    style: GoogleFonts.roboto(
                        fontSize: radius ?? 24,
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
      );
}
