// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../api/apis.dart';
import '../constants/app_constants.dart';
import '../models/chat_user.dart';
import '../models/message.dart';
import '../widgets/message_card.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // for storaing all messages
  List<Message> _list = [];
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
        ),

        backgroundColor: Colors.blueGrey.shade100,

        // body
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: APIs.getAllMessages(widget.user),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      // if data is loading
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const Center(
                          child: SizedBox(),
                        );

                      // if some or all data is loaded then show it
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        _list = data
                                ?.map((e) => Message.fromJson(e.data()))
                                .toList() ??
                            [];

                        if (_list.isNotEmpty) {
                          return ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.only(
                                  top: mq.height * .01,
                                  bottom: mq.height * .065),
                              itemCount: _list.length,
                              itemBuilder: (context, index) {
                                return MessageCard(message: _list[index]);
                              });
                        } else {
                          return const Center(
                            child: Text(
                              "Say Hii! 👋",
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                          );
                        }
                    }
                  }),
            ),
            _chatInput(),
          ],
        ),
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          // back button
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
            color: Colors.black54,
          ),

          // user profile picture
          ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * .03),
            child: CachedNetworkImage(
              progressIndicatorBuilder: (context, url, progress) => Center(
                child: CircularProgressIndicator(
                  value: progress.progress,
                ),
              ),
              imageUrl: widget.user.image.toString(),
              height: mq.height * .05,
              width: mq.height * .05,
            ),
          ),

          // for adding some space
          const SizedBox(width: 10),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // user name
              Text(
                widget.user.name.toString(),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),

              // for adding some space
              const SizedBox(height: 1),

              // last seen time of user
              const Text(
                "Last Seen not available",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: mq.height * .01,
        horizontal: mq.width * .025,
      ),
      child: Row(
        children: [
          Expanded(
            child: Card(
              child: Row(
                children: [
                  // emoji button
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.emoji_emotions,
                    ),
                    color: Colors.blueGrey,
                  ),

                  // message textfield
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: "Type Something...",
                        hintStyle: TextStyle(color: Colors.blueGrey.shade400),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  // pick image from gallery button
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.image,
                    ),
                    color: Colors.blueGrey,
                  ),

                  // take image from camera button
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.camera_alt_rounded,
                    ),
                    color: Colors.blueGrey,
                  ),

                  // adding some space
                  SizedBox(width: mq.width * .01),
                ],
              ),
            ),
          ),

          // send message button
          MaterialButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                APIs.sendMessage(widget.user, _textController.text);
                _textController.clear();
              }
            },
            minWidth: 0,
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
              right: 5,
              left: 10,
            ),
            shape: const CircleBorder(),
            color: Colors.blueGrey,
            child: Icon(
              Icons.send,
              color: Colors.blueGrey.shade100,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
