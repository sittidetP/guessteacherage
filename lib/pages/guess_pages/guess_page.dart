import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:guessteacherage/services/api.dart';
import 'package:http/http.dart' as http;

class GuessTeacherAge extends StatefulWidget {
  static const String routeName = "/login";

  const GuessTeacherAge({Key? key}) : super(key: key);

  @override
  _GuessTeacherAgeState createState() => _GuessTeacherAgeState();
}

class _GuessTeacherAgeState extends State<GuessTeacherAge> {
  double _years = 0.0;
  double _month = 0.0;
  bool _isLooding = false;
  bool _isCorrect = false;

  _changeYears(double value) {
    setState(() {
      _years = value;
    });
  }

  _changeMonth(double value) {
    setState(() {
      _month = value;
    });
  }

  Future<void> _sendData() async {
    try {
      setState(() {
        _isLooding = true;
      });
      var sendData = (await Api().submit('guess_teacher_age', {
        'year': _years.toInt(),
        'month': _month.toInt()
      })) as Map<String, dynamic>;
      if (sendData['value'] == false) {
        _showMaterialDialog("ผลการทาย", sendData['text']);
      } else if (sendData['value'] == true) {
        setState(() {
          _isCorrect = true;
        });
      }

      //_showMaterialDialog("ผลการทาย", sendData['text']);
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLooding = false;
      });
    }
  }

  void _showMaterialDialog(String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(msg, style: Theme.of(context).textTheme.bodyText2),
          actions: [
            // ปุ่ม OK ใน dialog
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                // ปิด dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GUESS TEACHER'S AGE"),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Colors.lightBlueAccent.shade100,
              Colors.pinkAccent.shade100,
            ])),
        child: Container(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          "อายุอาจารย์",
                          style: TextStyle(fontSize: 45.0, color: Colors.white),
                          textAlign: TextAlign.center,

                        ),
                      ),
                    ],
                  ),
                  if (!_isCorrect)
                    Card(
                      margin: EdgeInsets.all(16.0),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            SpinBox(
                              decoration: InputDecoration(labelText: "ปี"),
                              textStyle: TextStyle(fontSize: 35.0),
                              min: 0,
                              max: 100,
                              value: 0.0,
                              onChanged: (value) => _changeYears(value),
                            ),
                            SpinBox(
                              decoration: InputDecoration(labelText: "เดือน"),
                              textStyle: TextStyle(fontSize: 35.0),
                              min: 0,
                              max: 11,
                              value: 0.0,
                              onChanged: (value) => _changeMonth(value),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: ElevatedButton(
                                  onPressed: _sendData,
                                  child: Text(
                                    "ทาย",
                                    style: TextStyle(fontSize: 30.0),
                                  )),
                            )
                          ],
                        ),
                      ),
                    )
                  else
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Text(
                                  "${_years.toInt()} ปี ${_month.toInt()} เดือน",
                                  style: TextStyle(fontSize: 35.0)),
                              Icon(Icons.check, size: 100.0, color: Colors.lightGreenAccent,)
                            ],
                          ),
                        ),
                      ],
                    )
                ],
              ),
              if (_isLooding)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
