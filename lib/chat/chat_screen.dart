import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("ChatScreen"),
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

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        Flexible(
          child: ListView.builder(padding: EdgeInsets.all(8.0),
            reverse: true,
            itemBuilder: (_, int index) => _messages[index],
            itemCount: _messages.length,
          ),
        ),
        Divider(height: 1.0,),

        _buildSendMessage(),
      ],
    );
  }

  Widget _buildSendMessage() {
    return Container(
      decoration: BoxDecoration(color: Theme
          .of(context)
          .cardColor),
      child: IconTheme(
        data: IconThemeData(color: Theme
            .of(context)
            .accentColor),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                  controller: _textController,
                  onSubmitted: _sendMessage,
                  decoration: InputDecoration.collapsed(
                      hintText: "Send Message"),
                ),
              ),
              Container(
                child: IconButton(
                    icon: Icon(
                      Icons.send,
                    ),
                    onPressed: () => _sendMessage(_textController.text)),
              )
            ],
          ),
        ),
      ),
    );
  }

  _onBackNavigation() {}

  _sendMessage(String text) {
    _textController.clear();
    ChatMessage message = new ChatMessage(
        text: text,
    );
    setState(() {
      _messages.insert(0, message);
    });
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text});

  String _name = "Your name";
  final String text;

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: new CircleAvatar(child: new Text(_name[0])),
          ),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(_name, style: Theme
                  .of(context)
                  .textTheme
                  .subhead),
              new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: new Text(text),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
