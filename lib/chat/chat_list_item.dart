import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

var currentUserEmail;

class ChatMessageWrapper extends StatelessWidget {
  ChatMessageWrapper({
    this.messageData,
    this.animation,
  });

  final Animation animation;
  final DocumentSnapshot messageData;

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor:
          new CurvedAnimation(parent: animation, curve: Curves.decelerate),
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          children: currentUserEmail == messageData['email']
              ? getSendMessageLayout(context)
              : getReceivedMessageLayout(context),
        ),
      ),
    );
  }

  List<Widget> getReceivedMessageLayout(BuildContext context) {
    return <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(messageData['senderName'],
                style: Theme.of(context).textTheme.subhead),
            Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: (messageData['image'] != null)
                  ? Image.network(
                      messageData['image'],
                      width: 250.0,
                      scale: 1.5,
                      repeat: ImageRepeat.noRepeat,
                    )
                  : Text(messageData['text']),
            ),
          ],
        ),
      ),
      Container(
        margin: const EdgeInsets.only(left: 16.0),
        child: CircleAvatar(child: Text(messageData['senderName'][0])),
      ),
    ];
  }

  List<Widget> getSendMessageLayout(BuildContext context) {
    return <Widget>[
      Container(
        margin: const EdgeInsets.only(right: 16.0),
        child: messageData['senderPhotoUrl'] != null
            ? CircleAvatar(
                backgroundImage: NetworkImage(messageData['senderPhotoUrl']))
            : CircleAvatar(child: Text(messageData['senderName'][0])),
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(messageData['senderName'],
                style: Theme.of(context).textTheme.subhead),
            Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: messageData['image'] != null
                  ? _hadleLoadImage(messageData['image'])
                  : Text(messageData['text']),
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
