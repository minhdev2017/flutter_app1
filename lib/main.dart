import 'dart:math';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

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

  final double cardWith = 350;
  final double cardHeight = 500;

  double _dragEndX = 100.0;
  double _dragEndY = 100.0;
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
      body: Center(child: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Stack(
          alignment: Alignment.center,
            children: cardList),
      ),
      ),
      bottomNavigationBar: Row(
        children: [
          IconButton(
            icon: Icon(Icons.replay_circle_filled),
            onPressed: (){
              _generateCards();
              setState(() {

              });
            },
          )
        ],
      ),
    );
  }
  //Draggable
  List<Widget> _generateCards() {
    List<GlobalKey<FlipCardState>> keyList = [];
    List<Color> colorList = [Colors.grey, Colors.deepPurple, Colors.blueGrey, Colors.cyan, Colors.deepOrangeAccent];
    cardList.clear();
    for (int x = 0; x < 5; x++) {
      int angle = Random().nextInt(5) * (Random().nextBool() ? 1 : -1);
      Color color = colorList[x];
      keyList.add(GlobalKey<FlipCardState>());
      cardList.add(
        Draggable(
          child: FlipCard(
            flipOnTouch: false,
            key: keyList[x],
            onFlipDone: (result){
              print(result);
            },
            front: _card(color,"Card $x", "A", angle, keyList[x]),
            back: _card(color, "Card $x", "B", angle, keyList[x]),
          ),
          feedback: _cardDrag(color, "Card $x", "A", angle),
          childWhenDragging: Container(),
          onDragStarted: (){

          },
          onDragEnd: (detail){
           if(_dragEndX < 20 || _dragEndX > MediaQuery.of(context).size.width - 20
           ||_dragEndY < 50 || _dragEndY > MediaQuery.of(context).size.height - 50){
             removeCards(x);
           }
          },
          onDragUpdate: (detail){
            _dragEndX = detail.globalPosition.dx;
            _dragEndY = detail.globalPosition.dy;
          },
        ),
      );
    }
    return cardList;
  }

  Widget _card(Color color, String name, String side, int angle, GlobalKey<FlipCardState> key ){
    return RotationTransition(
      turns: new AlwaysStoppedAnimation(angle / 360),
      child: Card(
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          color: color,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              SizedBox(
                width: cardWith,
                height: cardHeight,
              ),
              Positioned(
                top: 20,
                child: Container(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Text(
                    name,
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Text(
                  "SIDE $side",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
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
                    child: Text("Flipe to side ${side == "A" ? "B": "A"}"),
                  ))
            ],
          )),
    );
  }

  Widget _cardDrag(Color color, String name, String side, int angle,){
    return RotationTransition(
      turns: new AlwaysStoppedAnimation(angle / 360),
      child: Card(
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          color: color,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              SizedBox(
                width: cardWith,
                height: cardHeight,
              ),
              Positioned(
                top: 20,
                child: Container(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Text(
                    name,
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Text(
                  "SIDE $side",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Positioned(
                  bottom: 20,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    onPressed: (){},
                    child: Text("Flipe to side $side"),
                  ))
            ],
          )),
    );
  }
}
