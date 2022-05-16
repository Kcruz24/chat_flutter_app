import 'package:chat_flutter_app/widgets/chat/messages.dart';
import 'package:chat_flutter_app/widgets/chat/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // This is for iOS push notifications
  @override
  void initState() {
    super.initState();
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.configure(onMessage: (msg) {
      print('MESSAGE ON FOREGROUND: $msg');
      return;
    }, onLaunch: (msg) {
      print('MESSAGE ON LAUNCH: $msg');
      return;
    }, onResume: (msg) {
      print('MESSAGE ON RESUME: $msg');
      return;
    });

    // fbm.getToken(); // Get device token
    fbm.subscribeToTopic('chat'); // Any notifications to such topic will reach this device.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FlutterChat'),
        actions: <Widget>[
          DropdownButton(
            underline: Container(),
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: <DropdownMenuItem>[
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.exit_to_app),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Logout'),
                    ],
                  ),
                ),
                value: 'logout',
              ),
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              // Take as much space as available
              child: MessagesWidget(),
            ),
            NewMessageWidget(),
          ],
        ),
      ),
    );
  }
}
