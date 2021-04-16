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

        home: Builder(
          builder: (context) {
            return Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: (){
                    Navigator.push<dynamic>(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) => HomePage(),
                      ),
                    );
                  },
                  child: Text("Click Me"),
                ),
              ),
            );
          }
        )
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin  {

  late AnimationController controller;
  bool _isAnimation = false;
  late List<dynamic> datas;

  final double cardWith = 350;
  final double cardHeight = 500;

  double _dragEndX = 100.0;
  double _dragEndY = 100.0;

  bool sideA = true;
  void removeCards(card) {
    setState(() {
      datas.remove(card);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = new AnimationController(
        duration: Duration(milliseconds: 450), vsync: this)..addStatusListener((status){
          print("status $status");
        if(status == AnimationStatus.completed){
          _isAnimation = false;
          controller.reverse();
        }else if(status == AnimationStatus.dismissed){
          //controller.forward();
        }
    });
    _generateCards();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(

      body: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          print("AnimatedBuilder $child");
          return Center(child: Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Stack(
                alignment: Alignment.center,
                children: datas.map((e){
                  print("create card");
                  return Draggable(
                    child: Container(
                      child: _isAnimation ? Transform.translate(
                        offset: Offset(Tween(begin: (e["offset"] as Offset).dx, end: 0.0).animate(controller).value,
                            Tween(begin: (e["offset"] as Offset).dy, end: 0.0).animate(controller).value),
                        child: FlipCard(
                          flipOnTouch: false,
                          key: e["key"],
                          onFlipDone: (result){
                            sideA = result;
                          },
                          front: _card(e["color"],e["title"], "A", e["angle"], e["key"]),
                          back: _card(e["color"],e["title"], "B", e["angle"], e["key"]),
                        ),
                      ) :  FlipCard(
                        flipOnTouch: false,
                        key: e["key"],
                        onFlipDone: (result){
                          setState(() {
                            sideA = result;
                          });

                        },
                        front: _card(e["color"],e["title"], "A", e["angle"], e["key"]),
                        back: _card(e["color"],e["title"], "B", e["angle"], e["key"]),
                      ),
                    ),
                    feedback: _cardDrag(e["color"],e["title"], sideA? "A" : "B", e["angle"]),
                    childWhenDragging: Container(),
                    onDragStarted: (){
                      print("onDragStarted");
                    },
                    onDragEnd: (detail){
                      print("onDragEnd");
                      if(_dragEndX < 20 || _dragEndX > MediaQuery.of(context).size.width - 20
                          ||_dragEndY < 50 || _dragEndY > MediaQuery.of(context).size.height - 50){
                        removeCards(e);
                      }
                    },
                    onDragUpdate: (detail){
                      _dragEndX = detail.globalPosition.dx;
                      _dragEndY = detail.globalPosition.dy;
                    },
                  );
                }).toList()),
          ),
          );
        },
      ),
      bottomNavigationBar: Row(
        children: [
          IconButton(
            icon: Icon(Icons.replay_circle_filled),
            onPressed: (){
              //_generateCards(hasAnimation: true);
              _isAnimation = true;
              _generateCards();
              controller.forward();
            },
          )
        ],
      ),
    );
  }
  //Draggable
  _generateCards({bool hasAnimation = true}) {
    datas = [];
    List<GlobalKey<FlipCardState>> keyList = [];
    List<Color> colorList = [Colors.grey, Colors.deepPurple, Colors.blueGrey, Colors.cyan, Colors.deepOrangeAccent];
    List<Offset> postions = [Offset(-300, 0), Offset(-300, -100), Offset(500, 0), Offset(-500, -100), Offset(500, 400)];
    for (int x = 0; x < 5; x++) {
      int angle = Random().nextInt(5) * (Random().nextBool() ? 1 : -1);
      if (x == 4) {
        angle = 0;
      }
      Color color = colorList[x];
      keyList.add(GlobalKey<FlipCardState>());
      datas.add(
          {
            "color": color,
            "angle": angle,
            "key": GlobalKey<FlipCardState>(),
            "title": "Card $x",
            "offset" : postions[x]
          }
      );
    }

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
                      key.currentState?.toggleCard();
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
                    child: Text("Flipe to side ${side == "A" ? "B": "A"}"),
                  ))
            ],
          )),
    );
  }
}
