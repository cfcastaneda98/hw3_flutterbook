import 'dart:convert';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:scoped_model/scoped_model.dart';
import 'RecorderDBWorker.dart';
import 'RecorderModel.dart' show RecorderModel, recorderModel;
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:intl/intl.dart' show DateFormat;
class RecorderEntry extends StatelessWidget
{
  FlutterSoundRecorder _recordingSession;
  final recorder = FlutterSoundRecorder();
  final recordingPlayer = AssetsAudioPlayer();

  String pathToAudio;
  bool _playAudio = false;
  String _timerText = '00:00:00';

  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _contentEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  RecorderEntry()
  {
    _titleEditingController.addListener(() {
      recorderModel.entityBeingEdited.title = _titleEditingController.text;
    });
    _contentEditingController.addListener(() {
      recorderModel.entityBeingEdited.content = _contentEditingController.text;
    });
  }

  Widget build(BuildContext inContext) {
    if (recorderModel.entityBeingEdited != null) {
      _titleEditingController.text = recorderModel.entityBeingEdited.title;
      _contentEditingController.text = recorderModel.entityBeingEdited.content;
    }

    return ScopedModel(
        model: recorderModel,
        child: ScopedModelDescendant<RecorderModel>(
            builder: (BuildContext inContext, Widget inChild, RecorderModel inModel)
            {
              return Scaffold(
                bottomNavigationBar: Padding(
                    padding :
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    child: Row(
                      children: [
                        TextButton(
                            onPressed: () {
                              FocusScope.of(inContext).requestFocus(FocusNode());
                              inModel.setStackIndex(0);
                            },
                            child: Text("Cancel")
                        ),
                        Spacer(),
                        TextButton(
                            onPressed: () {_save(inContext, recorderModel);},
                            child: Text("Save")
                        )
                      ],
                    )
                ),
                body: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      ListTile(
                        leading: Icon(Icons.title),
                        title: TextFormField(
                          decoration: const InputDecoration(hintText: "Title"),
                          controller: _titleEditingController,
                          validator: (String inValue) {
                            if (inValue == null || inValue.isEmpty) {
                              return "Please enter a title";
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        child: Center(
                          child: Text(
                            _timerText,
                            style: TextStyle(
                              fontSize: 70,
                              color: Colors.lightBlueAccent,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton.icon(
                            label: Text('Start'),
                            icon: Icon(Icons.mic),
                            onPressed: () async{
                              if(recorder.isRecording){
                                await stop();
                              }else{
                                await record();
                              }
                            },
                          ),
                        ]
                      ),
                      ListTile(
                        leading: Icon(Icons.color_lens),
                        title: Row(
                          children: [
                            GestureDetector(
                              child: Container(
                                decoration: ShapeDecoration(
                                    shape: Border.all(width: 18, color: Colors.red) +
                                        Border.all(width: 6,
                                            color: recorderModel.color == "red" ?
                                            Colors.red : Theme.of(inContext).canvasColor
                                        )
                                ),
                              ),
                              onTap: () {
                                recorderModel.entityBeingEdited.color = "red";
                                recorderModel.setColor("red");
                              },
                            ),
                            Spacer(),
                            GestureDetector(
                              child: Container(
                                decoration: ShapeDecoration(
                                    shape: Border.all(width: 18, color: Colors.blue) +
                                        Border.all(width: 6,
                                            color: recorderModel.color == "blue" ?
                                            Colors.blue : Theme.of(inContext).canvasColor
                                        )
                                ),
                              ),
                              onTap: () {
                                recorderModel.entityBeingEdited.color = "blue";
                                recorderModel.setColor("blue");
                              },
                            ),
                            Spacer(),
                            GestureDetector(
                              child: Container(
                                decoration: ShapeDecoration(
                                    shape: Border.all(width: 18, color: Colors.green) +
                                        Border.all(width: 6,
                                            color: recorderModel.color == "green" ?
                                            Colors.green : Theme.of(inContext).canvasColor
                                        )
                                ),
                              ),
                              onTap: () {
                                recorderModel.entityBeingEdited.color = "green";
                                recorderModel.setColor("green");
                              },
                            ),
                            Spacer(),
                            GestureDetector(
                              child: Container(
                                decoration: ShapeDecoration(
                                    shape: Border.all(width: 18, color: Colors.yellow) +
                                        Border.all(width: 6,
                                            color: recorderModel.color == "yellow" ?
                                            Colors.yellow : Theme.of(inContext).canvasColor
                                        )
                                ),
                              ),
                              onTap: () {
                                recorderModel.entityBeingEdited.color = "yellow";
                                recorderModel.setColor("yellow");
                              },
                            ),
                            Spacer(),
                            GestureDetector(
                              child: Container(
                                decoration: ShapeDecoration(
                                    shape: Border.all(width: 18, color: Colors.grey) +
                                        Border.all(width: 6,
                                            color: recorderModel.color == "grey" ?
                                            Colors.grey : Theme.of(inContext).canvasColor
                                        )
                                ),
                              ),
                              onTap: () {
                                recorderModel.entityBeingEdited.color = "grey";
                                recorderModel.setColor("grey");
                              },
                            ),
                            Spacer(),
                            GestureDetector(
                              child: Container(
                                decoration: ShapeDecoration(
                                    shape: Border.all(width: 18, color: Colors.purple) +
                                        Border.all(width: 6,
                                            color: recorderModel.color == "purple" ?
                                            Colors.purple : Theme.of(inContext).canvasColor
                                        )
                                ),
                              ),
                              onTap: () {
                                recorderModel.entityBeingEdited.color = "purple";
                                recorderModel.setColor("purple");
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
        )
    );
  }

  void _save(BuildContext inContext, RecorderModel inModel) async
  {

    if (_formKey.currentState != null && _formKey.currentState?.validate() == false) {
      return;
    }

    if (inModel.entityBeingEdited.id == 0) {
      await RecorderDBWorker.db.create(recorderModel.entityBeingEdited);
    } else if (inModel.entityBeingEdited != null && inModel.entityBeingEdited.id > 0) {
      await RecorderDBWorker.db.update(recorderModel.entityBeingEdited);
    }

    recorderModel.loadData("notes", RecorderDBWorker.db);
    inModel.setStackIndex(0);
    ScaffoldMessenger.of(inContext).showSnackBar(
        const SnackBar(
            content: Text("Note saved"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2)
        )
    );
  }
  ElevatedButton createElevatedButton(
      {IconData icon, Color iconColor, Function onPressFunc}) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(6.0),
        side: BorderSide(
          color: Colors.red,
          width: 4.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        primary: Colors.white,
        elevation: 9.0,
      ),
      onPressed: onPressFunc,
      icon: Icon(
        icon,
        color: iconColor,
        size: 38.0,
      ),
      label: Text(''),
    );
  }
  Future record() async{
    await recorder.startRecorder(toFile: 'audio');
  }
  Future stop() async{
    final path = await recorder.stopRecorder();
    final audioFile = File(path);
    print('Recorded audio: $audioFile');
  }
  Future<String> stopRecording() async {
    _recordingSession.closeAudioSession();
    return await _recordingSession.stopRecorder();
  }
  Future<void> playFunc() async{
    recordingPlayer.open(
      Audio.file(pathToAudio),
      autoStart: true,
      showNotification: true,
    );
  }
  Future<void> stopPlayFunc() async {
    recordingPlayer.stop();
  }
}