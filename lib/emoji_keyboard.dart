library emoji_keyboard;

import 'package:emoji_keyboard/emojis/emoji_data.dart';
import 'package:emoji_keyboard/emojis/emoji_model.dart';
import 'package:flutter/material.dart';

class EmojiKeyboard extends StatefulWidget {
  EmojiKeyboard(
      {Key key, this.emojiFont, this.onEmojiPressed, this.height = 250})
      : super(key: key);

  /// The font for emoji keyboard to use, if not supplied default emoijs are used
  final String emojiFont;

  /// The callback which is called when emoji is pressed
  final Function(Emoji) onEmojiPressed;

  /// Height of the keyboard
  final double height;

  @override
  _EmojiKeyboardState createState() => _EmojiKeyboardState();
}

class _EmojiKeyboardState extends State<EmojiKeyboard> {
  PageController _pageController;
  List<bool> _isTabSelected;
  List<List<Emoji>> _allEmojis;

  List<bool> _getTabSelected({int page}) {
    return _allEmojis.asMap().entries.map((entry) {
      if (page != null)
        return page == entry.key;
      else {
        if (_pageController.hasClients)
          return _pageController.page == entry.key;
        else
          return _pageController.initialPage == entry.key;
      }
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _allEmojis = [
      Emoji.emojiListFromJson(smileysAndPeople),
      Emoji.emojiListFromJson(animalsAndNature),
      Emoji.emojiListFromJson(foodAndDrinks),
      Emoji.emojiListFromJson(travelAndPlaces),
      Emoji.emojiListFromJson(activity),
      Emoji.emojiListFromJson(symbols),
      Emoji.emojiListFromJson(flags),
      Emoji.emojiListFromJson(objects),
    ];
    _isTabSelected = _getTabSelected();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      color: Colors.grey[100],
      width: double.infinity,
      child: Column(
        children: <Widget>[
          StatefulBuilder(builder: (context, setToggleButtonState) {
            return Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                border: BorderDirectional(
                  bottom: BorderSide(),
                ),
              ),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ToggleButtons(
                    children:
                        _allEmojis.map((e) => Text(e.first.emoji)).toList(),
                    renderBorder: false,
                    onPressed: (int index) {
                      setToggleButtonState(
                        () {
                          for (int i = 0; i < _isTabSelected.length; i++) {
                            if (i == index) {
                              _isTabSelected[i] = true;
                              _pageController.animateToPage(
                                i,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                            } else {
                              _isTabSelected[i] = false;
                            }
                          }
                        },
                      );
                    },
                    isSelected: _isTabSelected,
                  ),
                ],
              ),
            );
          }),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (page) {
                this.setState(() {
                  _isTabSelected = _getTabSelected(page: page);
                });
              },
              children: _allEmojis
                  .map(
                    (e) => EmojiGrid(
                      emojis: e,
                      emojiFont: widget.emojiFont,
                      onEmojiTap: widget.onEmojiPressed,
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class EmojiGrid extends StatelessWidget {
  const EmojiGrid(
      {Key key,
      @required this.emojis,
      this.emojiFont,
      @required this.onEmojiTap})
      : super(key: key);

  final List<Emoji> emojis;
  final String emojiFont;
  final Function(Emoji) onEmojiTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: emojis.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
      ),
      itemBuilder: (context, index) => EmojiButton(
        emoji: emojis[index].emoji,
        emojiFont: emojiFont,
        onTap: () {
          onEmojiTap(emojis[index]);
        },
      ),
    );
  }
}

class EmojiButton extends StatelessWidget {
  const EmojiButton(
      {Key key, @required this.emoji, this.emojiFont, @required this.onTap})
      : super(key: key);

  final String emoji;
  final Function onTap;
  final String emojiFont;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      margin: EdgeInsets.all(5),
      child: FlatButton(
        shape: CircleBorder(),
        padding: EdgeInsets.all(5),
        onPressed: onTap,
        child: Text(
          emoji,
          style: TextStyle(
            fontSize: 25,
            fontFamily: emojiFont,
          ),
        ),
      ),
    );
  }
}
