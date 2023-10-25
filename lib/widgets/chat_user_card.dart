import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/chat_user.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: mq.width * .02,
        vertical: 4,
      ),
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        onTap: () {},
        child: ListTile(
          // user profile pic
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * .03),
            child: CachedNetworkImage(
              progressIndicatorBuilder: (context, url, progress) => Center(
                child: CircularProgressIndicator(
                  value: progress.progress,
                ),
              ),
              imageUrl: widget.user.image.toString(),
              height: mq.height * .055,
              width: mq.height * .055,
            ),
          ),

          // user name
          title: Text(
            widget.user.name.toString(),
          ),

          // last message
          subtitle: Text(
            widget.user.about.toString(),
          ),

          // last message time
          trailing: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              color: Colors.greenAccent.shade400,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          // Text(
          //   widget.user.lastActive.toString(),
          //   style: const TextStyle(
          //     color: Colors.black54,
          //   ),
          // ),
        ),
      ),
    );
  }
}
