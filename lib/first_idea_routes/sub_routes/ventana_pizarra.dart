import 'package:flutter/material.dart';

class VentanaPizarra extends StatefulWidget {
  @override
  createState() => _VentanaPizarra();
}

class _VentanaPizarra extends State<VentanaPizarra> {
  final Map choices = {
    '♥': Colors.green,
    '♂': Colors.yellow,
    '♀': Colors.red,
    '♦': Colors.purple,
    '♣': Colors.brown,
    '♠': Colors.orange,
    '3': Colors.green,
    '4': Colors.yellow,
    '5': Colors.red,
    '6': Colors.purple,
    '7': Colors.brown,
    '8': Colors.orange,
    '9': Colors.green,
    '10': Colors.yellow,
    '11': Colors.red,
    '☼': Colors.purple,
    '►': Colors.brown,
    '◄': Colors.orange
  };

  //int seed = 0;
  int index = 0;

  ScrollController _controller = new ScrollController();

  void _goToElement(int index) {
    _controller.animateTo((100.0 * index),
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  disabledColor: Colors.orange,
                  onPressed: /*(index<=0) ? null :*/() {
                    if(index<=0) {
                      return null;
                    }
                    index -= 6;
                    _goToElement(index);
                    print(index);
                  },
                  child: Text("Anterior"),
                ),
                FlatButton(
                  onPressed: () {
                    if(index>=choices.length) {
                      return null;
                    }
                    index += 6;
                    _goToElement(index);
                    print(index);
                  },
                  child: Text("Siguiente"),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                controller: _controller,
                scrollDirection: Axis.horizontal,
                children: choices.keys.map((emoji) {
                  return Draggable<String>(
                    data: emoji,
                    child: Emoji(emoji: emoji),
                    //Emoji(emoji: score[emoji] == true ? '•' : emoji),
                    feedback: Emoji(emoji: emoji),
                    childWhenDragging: Emoji(emoji: '↕'),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
/*
  Widget _buildDragTarget(emoji) {
    return DragTarget<String>(
      builder: (BuildContext context, List<String> incoming, List rejected) {
        if (score[emoji] == true) {
          return  Container(
            color: Colors.white,
            child: Text('Correct!'),
            alignment: Alignment.center,
            height: 80,
            width: 200,
          );
        } else {
          return  Container(
            color: choices[emoji],
            height: 80,
            width: 200,
          );
        }
      },
      onWillAccept: (data) => data == emoji,
      onAccept: (data) {
        setState(() {
          score[emoji] = true;
        });
      },
      onLeave: (data) {},
    );
  }
  */
}

class Emoji extends StatelessWidget {
  Emoji({Key key, this.emoji}) : super(key: key);

  final String emoji;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      color: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        height: 50,
        padding: EdgeInsets.all(10),
        child: Text(
          emoji,
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
      ),
    );
  }
}
