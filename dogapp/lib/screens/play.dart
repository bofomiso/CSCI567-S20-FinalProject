import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Plays extends StatefulWidget {
  final String uid;
  final String dogName;

  const Plays({Key key, this.uid, this.dogName}) : super(key: key);

  @override
  State<Plays> createState() => _PlaysState();
}

class _PlaysState extends State<Plays> {
  DateTime curDate = DateTime.now();
  String displayTime = "00:00:00";
  String timeStopped = "00:00:00";
  var stopW = Stopwatch();
  bool start = true;
  bool stop = true;
  bool reset = true;
  bool finish = false;
  final dur =
      const Duration(seconds: 1); //variable to increment watch by 1 second

  void timer() {
    Timer(dur, timeRunning);
  }

  //update the time displayed
  void timeRunning() {
    if (stopW.isRunning) {
      timer();
    }
    setState(() {
      displayTime = stopW.elapsed.inHours.toString().padLeft(2, "0") +
          ":" +
          (stopW.elapsed.inMinutes % 60).toString().padLeft(2, "0") +
          ":" +
          (stopW.elapsed.inSeconds % 60).toString().padLeft(2, "0");
    });
  }

  //starting the stopwatch
  void startSW() {
    setState(() {
      stop = false;
      start = false;
      finish = false;
    });
    stopW.start();
    timer();
  }

  //stopping the stopwatch
  void stopSW() {
    setState(() {
      stop = true;
      reset = false;
      start = true;
      finish = true;
    });
    stopW.stop();
    timeStopped = displayTime;
  }

  void resetSW() {
    setState(() {
      start = true;
      reset = true;
    });
    stopW.reset();
    displayTime = "00:00:00";
  }

  @override
  Widget build(BuildContext context) {
    String realDate = DateFormat.yMMMd().format(curDate);
    return Scaffold(
      appBar: AppBar(
        title: Text('Play'),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    displayTime,
                    style: TextStyle(fontSize: 50.0),
                  ),
                ),
              ),
              Text(
                widget.dogName,
                style: TextStyle(
                  fontSize: 25.0,
                ),
              ),
              Text(
                'Most recent play: $timeStopped',
                style: TextStyle(
                  fontSize: 25.0,
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            width: 80.0,
                            height: 80.0,
                            child: FloatingActionButton(
                              heroTag: "button1",
                              onPressed: start ? startSW : null,
                              backgroundColor: Colors.green,
                              child: Text("Start"),
                            ),
                          ),
                          Container(
                            width: 80.0,
                            height: 80.0,
                            child: FloatingActionButton(
                              heroTag: "button2",
                              onPressed: stop ? null : stopSW,
                              backgroundColor: Colors.red,
                              child: Text("Stop"),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            width: 80.0,
                            height: 80.0,
                            child: FloatingActionButton(
                              heroTag: "button3",
                              onPressed: reset ? null : resetSW,
                              backgroundColor: Colors.cyan,
                              child: Text("reset"),
                            ),
                          ),
                          Container(
                            width: 80.0,
                            height: 80.0,
                            child: FloatingActionButton(
                              heroTag: "button4",
                              onPressed:finish ? () => finishSW(realDate, widget.uid, timeStopped,widget.dogName):null,                               
                              backgroundColor: Colors.pink,
                              child: Text("Finish"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void finishSW(String date, String dogid, String finishTime, String dogName) async {
    final db = Firestore.instance;
    stopW.stop();
    timeStopped = displayTime;
    DocumentReference ref = await db.collection('log').add({
      'name': '$dogName',
      'dogId': widget.uid,
      'date': '$date',
      'time': '$timeStopped'
    });
    print(ref.documentID);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Summary:'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(widget.dogName),
                  Text('Time:$timeStopped'),
                  Text('Date:$date'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ],
          );
        });
  }
}
