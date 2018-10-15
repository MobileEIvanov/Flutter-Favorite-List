import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/chat/chat_list_item.dart';
import 'package:google_sign_in/google_sign_in.dart';

final _googleSignIn = GoogleSignIn();

class ChatScreen extends StatefulWidget {
  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = TextEditingController();
  bool _isComposing = false;
  bool _isSignedIn = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("ChatScreen"),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: _onBackNavigation(),
          )
        ],
      ),
      body: _buildBody(),
    );
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }

  Widget _buildBody() {
    return Container(
      decoration: Theme.of(context).platform == TargetPlatform.iOS
          ? BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey[200])))
          : null,
      child: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(16.0),
              reverse: true,
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
            ),
          ),
          Divider(
            height: 1.0,
          ),
          _buildInputMessageView(),
        ],
      ),
    );
  }

  Widget _buildInputMessageView() {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(color: Theme.of(context).cardColor),
        child: IconTheme(
          data: IconThemeData(color: Theme.of(context).accentColor),
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: Row(
              children: <Widget>[
                Flexible(
                  child: TextField(
                    controller: _textController,
                    onChanged: (String text) {
                      setState(() {
                        _isComposing = text.length > 0;
                      });
                    },
                    onSubmitted: _sendMessage,
                    decoration:
                        InputDecoration.collapsed(hintText: "Send Message"),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Theme.of(context).platform == TargetPlatform.iOS
                      ? CupertinoButton(
                          child: Text("Send"),
                          onPressed: _isComposing
                              ? () => _sendMessage(_textController.text)
                              : null,
                        )
                      : IconButton(
                          icon: Icon(
                            Icons.send,
                          ),
                          onPressed: () async {
                            (_isComposing && _isSignedIn)
                                ? () => _sendMessage(_textController.text)
                                : await _handleSignIn();
                          }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onBackNavigation() {}

  _sendMessage(String text) {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    ChatMessage message = ChatMessage(
        text: text,
        animationController: AnimationController(
            vsync: this, duration: Duration(microseconds: 3000)));
    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();
  }

  //https://github.com/flutter/flutter/issues/15168

  Future<Null> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }
}
