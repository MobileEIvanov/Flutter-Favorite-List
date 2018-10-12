import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

var currentUserEmail = "received";

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});

  String _name = "Your name";
  final String text;
  final AnimationController animationController;
  var imageUri =
      "https://blog.spoongraphics.co.uk/wp-content/uploads/2014/07/Untitled-11.jpg";
  var avatarImage =
      "https://blog.spoongraphics.co.uk/wp-content/uploads/2014/07/Untitled-11.jpg";

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(
        begin: 0.0,
        end: 1.0,
      ).animate(animationController),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
            children: text == "received"
                ? getReceivedMessageLayout(context)
                : getSendMessageLayout(context)),
      ),
    );
  }

  List<Widget> getReceivedMessageLayout(BuildContext context) {
    return <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(_name, style: Theme.of(context).textTheme.subhead),
            Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: imageUri != null
                  ? Image.network(
                      imageUri,
                      width: 250.0,
                      scale: 1.5,
                      repeat: ImageRepeat.noRepeat,
                    )
                  : Text(text),
            ),
          ],
        ),
      ),
      Container(
        margin: const EdgeInsets.only(left: 16.0),
        child: CircleAvatar(child: Text(_name[0])),
      ),
    ];
  }

  List<Widget> getSendMessageLayout(BuildContext context) {
    return <Widget>[
      Container(
        margin: const EdgeInsets.only(right: 16.0),
        child: avatarImage != null
            ? CircleAvatar(backgroundImage: NetworkImage(avatarImage))
            : CircleAvatar(child: Text(_name[0])),
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(_name, style: Theme.of(context).textTheme.subhead),
            Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: imageUri != null
                  ? Image.network(
                      imageUri,
                      width: 250.0,
                      scale: 1.5,
                      repeat: ImageRepeat.noRepeat,
                    )
                  : Text(text),
            ),
          ],
        ),
      ),
    ];
  }
}
