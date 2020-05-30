import 'package:emoji_keyboard/emoji_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emoji Keyboard Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Emoji Keyboard Demo Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _controller;
  bool _isEmojiOpen;
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _isEmojiOpen = false;
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Center(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    focusNode: _focusNode,
                    controller: _controller,
                    onTap: () {
                      if (_isEmojiOpen) {
                        this.setState(() {
                          _isEmojiOpen = !_isEmojiOpen;
                        });
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _isEmojiOpen ? Icons.keyboard : Icons.insert_emoticon,
                  ),
                  onPressed: () {
                    this.setState(() {
                      _isEmojiOpen = !_isEmojiOpen;
                      if (_isEmojiOpen) {
                        if (!_focusNode.hasFocus) {
                          _focusNode.requestFocus();
                        }
                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                      } else
                        SystemChannels.textInput.invokeMethod('TextInput.show');
                    });
                  },
                )
              ],
            ),
          ),
          if (_isEmojiOpen)
            EmojiKeyboard(
              onEmojiPressed: (emoji) {
                final selection = _controller.value.selection;
                final oldText = _controller.value.text;

                final newText =
                    '${oldText.substring(0, selection.extent.offset)}${emoji.emoji}${oldText.substring(selection.extent.offset)}';
                _controller.value = _controller.value.copyWith(
                  text: newText,
                  selection: TextSelection.fromPosition(
                    TextPosition(
                      offset: selection.extent.offset + emoji.emoji.length,
                    ),
                  ),
                );
              },
            )
        ],
      ),
    );
  }
}
