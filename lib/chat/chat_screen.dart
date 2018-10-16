import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/chat/chat_list_item.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_ui/firestore_ui.dart';

final googleSignIn = GoogleSignIn(scopes: <String>['email']);
final auth = FirebaseAuth.instance;

class ChatScreen extends StatefulWidget {
  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessageWrapper> _messages = <ChatMessageWrapper>[];
  final TextEditingController _textController = TextEditingController();
  bool _isComposing = false;
  bool _isIOS;
  FirebaseUser currentUser;
  final users = Firestore.instance.collection("users");
  final _keeperBot = "JsSTTVVlGjVeOHgt2WxS";

  @override
  Widget build(BuildContext context) {
    _isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return new Scaffold(
      appBar: AppBar(
        title: Text("ChatScreen"),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: _signOut,
          )
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      decoration: _isIOS
          ? BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey[200])))
          : null,
      child: Column(
        children: <Widget>[
          _buildListContentView(),
          Divider(
            height: 1.0,
          ),
          _buildInputMessageView(),
        ],
      ),
    );
  }

  ScrollController _scrollController = ScrollController();

  void _goToElement(int index) {
    _scrollController.animateTo((100.0 * index),
        // 100 is the height of container and index of 6th element is 5
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut);
  }

  Widget _buildListContentView() {
    if (currentUser != null) {
      return new Flexible(
        child: FirestoreAnimatedList(
          query: users
              .document(currentUser.uid)
              .collection("chats")
              .document(_keeperBot)
              .collection("messages")
              .snapshots(),
          padding: const EdgeInsets.all(8.0),
          reverse: false,
          controller: _scrollController,
          itemBuilder: (
            BuildContext context,
            DocumentSnapshot snapshot,
            Animation<double> animation,
            int index,
          ) {
            return FadeTransition(
              opacity: animation,
              child: ChatMessageWrapper(
                messageData: snapshot,
                animation: animation,
              ),
            );
          },
        ),
      );
    } else {
      return Flexible(
        child: Center(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Please login to see coversation history."),
        )),
      );
    }
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
                _isIOS
                    ? CupertinoButton(
                        child: FlatButton.icon(
                            onPressed: _handleImagePick,
                            icon: Icon(CupertinoIcons.photo_camera),
                            label: null),
                      )
                    : IconButton(
                        icon: Icon(Icons.image),
                        onPressed: _handleImagePick,
                      ),
                Flexible(
                  child: TextField(
                    controller: _textController,
                    onChanged: (String text) {
                      setState(() {
                        _isComposing = text.length > 0;
                      });
                    },
                    decoration:
                        InputDecoration.collapsed(hintText: "Send Message"),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  child: _isIOS
                      ? CupertinoButton(
                          child: Text("Send"),
                          onPressed: _isComposing
                              ? () => _sendMessage(_textController.text, null)
                              : null,
                        )
                      : IconButton(
                          icon: Icon(
                            Icons.send,
                          ),
                          onPressed: () async {
                            if (currentUser == null) {
                              await _handleSignIn();
                            }
                            if (_isComposing) {
                              _sendMessage(_textController.text, null);
                            }
                          }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _sendMessage(String text, Object image) {
    if (text != null || image != null) {
      _textController.clear();
      setState(() {
        _isComposing = false;
      });
      _storeMessage(text, image);
    }
  }

  //https://github.com/flutter/flutter/issues/15168

  Future<Null> _handleSignIn() async {
    await googleSignIn.signOut();
    await auth.signOut();
    GoogleSignInAccount signInUser = googleSignIn.currentUser;
    if (signInUser == null) {
      signInUser = await googleSignIn.signInSilently();
    }
    if (signInUser == null) {
      await googleSignIn.signIn();
    }

    currentUserEmail = googleSignIn.currentUser.email;

    if (await auth.currentUser() == null) {
      GoogleSignInAuthentication credentials =
          await googleSignIn.currentUser.authentication;
      var user = await auth.signInWithGoogle(
          idToken: credentials.idToken, accessToken: credentials.accessToken);
      setState(() {
        currentUser = user;
      });
      users.document(currentUser.uid).setData({
        'name': currentUser.displayName,
        'email': currentUser.email,
      });
    }
  }

  Future _signOut() async {
    await auth.signOut();
    googleSignIn.signOut();
    setState(() {
      currentUser = null;
    });
    Scaffold.of(context)
        .showSnackBar(new SnackBar(content: new Text('User logged out')));
  }

  Future _handleImagePick() async {
    if (currentUser == null) {
      await _handleSignIn();
    }
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    int timestamp = DateTime.now().microsecondsSinceEpoch;
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child(currentUser.uid)
        .child("img_" + timestamp.toString() + ".jpg");

    StorageUploadTask storageUploadTask = storageReference.putFile(image);

    await storageUploadTask.onComplete
        .then((StorageTaskSnapshot storageTask) async {
      String download = await storageTask.ref.getDownloadURL();
      _sendMessage(null, download);
    });
  }

  Future _storeMessage(String text, String image) {
    var messageData = {
      'text': text,
      'image': image,
      'email': currentUser.email,
      'senderId': currentUser.uid,
      'senderName': currentUser.displayName,
      'senderPhotoUrl': currentUser.photoUrl,
    };

    // Store the current message for the user.
    users
        .document(currentUser.uid)
        .collection("chats")
        .document(_keeperBot)
        .collection("messages")
        .add(messageData);
    // Create reference for the bot. Might be moved to functions.
    users
        .document(_keeperBot)
        .collection("chats")
        .document(currentUser.uid)
        .collection("messages")
        .add(messageData);
  }
}
