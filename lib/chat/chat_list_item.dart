import 'dart:io';

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

var currentUserEmail = "received";

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.image, this.animationController});

  String _name = "Your name";
  final String text;
  final Object image;
  final AnimationController animationController;
  String avatarImage = null;

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
              child: (image != null)
                  ? Image.network(
                      image,
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
              child: image != null
                  ? _hadleLoadImage(image)
                  : Text(text),
            ),
          ],
        ),
      ),
    ];
  }

  Widget _hadleLoadImage(Object image) {
    if (image is File) {
      return _loadImageFromFile(image);
    } else {
      return _loadImageFromNetwork(image);
    }
  }

  Widget _loadImageFromFile(File image) {
    return Image.file(
      image,
      width: 250.0,
      scale: 1.5,
      repeat: ImageRepeat.noRepeat,
    );
  }

  Widget _loadImageFromNetwork(String image) {
    return Image.network(
      image,
      width: 250.0,
      scale: 1.5,
      repeat: ImageRepeat.noRepeat,
    );
  }
}
