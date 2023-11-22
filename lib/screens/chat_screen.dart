// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../api/apis.dart';
import '../constants/app_constants.dart';
import '../helper/my_date_util.dart';
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
  // for handling message text changes
  final _textController = TextEditingController();
  // for storing value of showing or hiding emoji
  bool _showEmoji = false;
  // for checking if image is uploading or not?
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: WillPopScope(
          // if emojis are shown & back button is pressed then hide emojis
          // or else simple close current screen on back button click
          onWillPop: () {
            if (_showEmoji) {
              setState(() {
                _showEmoji = !_showEmoji;
              });
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            // app bar
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
                                  reverse: true,
                                  physics: const BouncingScrollPhysics(),
                                  padding:
                                      EdgeInsets.only(top: mq.height * .01),
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

                // progress indicator for showing uploading
                if (_isUploading)
                  const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 20.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )),

                // chat input field
                _chatInput(),

                // show emojis on keyboard emoji button click & vice versa
                if (_showEmoji)
                  SizedBox(
                    height: mq.height * .35,
                    child: EmojiPicker(
                      textEditingController: _textController,
                      config: Config(
                        // bgColor: Colors.blueGrey.shade100,
                        columns: 8,
                        emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // app bar widget
  Widget _appBar() {
    return InkWell(
      onTap: () {},
      child: StreamBuilder(
          stream: APIs.getUserInfo(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list =
                data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

            return Row(
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
                    progressIndicatorBuilder: (context, url, progress) =>
                        Center(
                      child: CircularProgressIndicator(
                        value: progress.progress,
                      ),
                    ),
                    imageUrl:
                        list.isNotEmpty ? list[0].image! : widget.user.image!,
                    height: mq.height * .05,
                    width: mq.height * .05,
                    errorWidget: (context, url, error) => const CircleAvatar(
                      child: Icon(CupertinoIcons.person),
                    ),
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
                      list.isNotEmpty
                          ? list[0].name.toString()
                          : widget.user.name.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    // for adding some space
                    const SizedBox(height: 1),

                    // last seen time of user
                    Text(
                      list.isNotEmpty
                          ? list[0].isOnline!
                              ? "Online"
                              : MyDateUtil.getLastActiveTime(
                                  context: context,
                                  lastActive: list[0].lastActive!)
                          : MyDateUtil.getLastActiveTime(
                              context: context,
                              lastActive: widget.user.lastActive!),
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
    );
  }

  // bottom chat input field
  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: mq.height * .01,
        horizontal: mq.width * .025,
      ),
      child: Row(
        children: [
          // input field & buttons
          Expanded(
            child: Card(
              child: Row(
                children: [
                  // emoji button
                  IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      setState(() => _showEmoji = !_showEmoji);
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
                      onTap: () {
                        if (_showEmoji) {
                          setState(() => _showEmoji = !_showEmoji);
                        }
                      },
                      decoration: InputDecoration(
                        hintText: "Type Something...",
                        hintStyle: TextStyle(color: Colors.blueGrey.shade400),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  // pick image from gallery button
                  IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();

                      // Pick multiple images
                      final List<XFile> images =
                          await picker.pickMultiImage(imageQuality: 70);

                      // uploading & sending image one by one
                      for (var i in images) {
                        log("Image Path: ${i.path}");
                        setState(() => _isUploading = true);
                        await APIs.sendChatImage(widget.user, File(i.path));
                        setState(() => _isUploading = false);
                      }
                    },
                    icon: const Icon(
                      Icons.image,
                      color: Colors.blueGrey,
                      size: 26,
                    ),
                  ),

                  // take image from camera button
                  IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();

                      // Pick an image
                      final XFile? image = await picker.pickImage(
                        source: ImageSource.camera,
                        imageQuality: 70,
                      );
                      if (image != null) {
                        log("Image Path: ${image.path}");
                        setState(() => _isUploading = true);
                        await APIs.sendChatImage(widget.user, File(image.path));
                        setState(() => _isUploading = false);
                      }
                    },
                    icon: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.blueGrey,
                      size: 26,
                    ),
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
                APIs.sendMessage(widget.user, _textController.text, Type.text);
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
