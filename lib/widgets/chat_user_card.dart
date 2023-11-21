import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../api/apis.dart';
import '../constants/app_constants.dart';
import '../constants/routes.dart';
import '../helper/my_date_util.dart';
import '../models/chat_user.dart';
import '../models/message.dart';
import '../screens/chat_screen.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  // last message info (if null --> no messgae)
  Message? _message;

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
        onTap: () {
          // for navigating to chat screen
          Routes.instance
              .push(widget: ChatScreen(user: widget.user), context: context);
        },
        child: StreamBuilder(
            stream: APIs.getLastMessage(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
              if (list.isNotEmpty) {
                _message = list[0];
              }

              return ListTile(
                // user profile pic
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * .03),
                  child: CachedNetworkImage(
                    progressIndicatorBuilder: (context, url, progress) =>
                        Center(
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
                  _message != null
                      ? _message!.type == Type.image
                          ? "image"
                          :   _message!.msg.toString()
                      : widget.user.about.toString(),
                  maxLines: 1,
                ),

                // last message time
                trailing: _message == null
                    ? null // show nothing when no message is sent
                    : _message!.read!.isEmpty &&
                            _message!.fromId != APIs.user.uid
                        ?
                        // show for unread message
                        Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              color: Colors.greenAccent.shade400,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          )
                        :
                        // message sent time
                        Text(
                            MyDateUtil.getLastMessageTime(
                                context: context, time: _message!.sent!),
                            style: const TextStyle(
                              color: Colors.black54,
                            ),
                          ),
              );
            }),
      ),
    );
  }
}
