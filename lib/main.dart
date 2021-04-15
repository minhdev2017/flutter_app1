import 'dart:math';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: <String, WidgetBuilder>{
          '/cardDetails': (BuildContext context) {
            // return new CardDetails();
          }
        },
        home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  List<Widget> cardList = [];

  List<GlobalKey<FlipCardState>> keyList = [];

  void removeCards(index) {
    setState(() {
      cardList.removeAt(index);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cardList = _generateCards();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        title: Text("Tinder App"),
        backgroundColor: Colors.purple,
      ),
      body: Center(child: Stack(alignment: Alignment.center, children: cardList)),
    );
  }
  //Draggable
  List<Widget> _generateCards() {

    for (int x = 0; x < 5; x++) {
      int angle = Random().nextInt(5) * (Random().nextBool() ? 1 : -1);
      keyList.add(GlobalKey<FlipCardState>());
      cardList.add(
        Draggable(
          child: FlipCard(
            flipOnTouch: false,
            key: keyList[x],
            front: _card(Colors.grey, "$x A", angle, keyList[x]),
            back: _card(Colors.black, "$x B", angle, keyList[x]),
          ),
          feedback: _cardDrag(angle),
          childWhenDragging: Container(),
          onDragEnd: (detail){
            removeCards(x);
          },
        ),
      );
    }
    return cardList;
  }

  Widget _card(Color color, String side, int angle, GlobalKey<FlipCardState> key ){
    return RotationTransition(
      turns: new AlwaysStoppedAnimation(angle / 360),
      child: Card(
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          // color: Color.fromARGB(250, 112, 19, 179),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    color: color
                ),
                height: 400.0,
                width: 300.0,
              ),
              Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Text(
                  "SIDE $side",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.purple,
                  ),
                ),
              ),
              Positioned(
                  bottom: 20,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    onPressed: () {
                      key.currentState.toggleCard();
                    },
                    child: Text("Flipe to side $side"),
                  ))
            ],
          )),
    );
  }

  Widget _cardDrag(int angle ){
    return RotationTransition(
      turns: new AlwaysStoppedAnimation(angle / 360),
      child: Card(
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          // color: Color.fromARGB(250, 112, 19, 179),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    color: Colors.black
                ),
                height: 400.0,
                width: 300.0,
              ),

            ],
          )),
    );
  }
}
