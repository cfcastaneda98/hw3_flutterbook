import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'RecorderDBWorker.dart';
import 'RecorderList.dart';
import 'RecorderEntry.dart';
import 'RecorderModel.dart' show RecorderModel, recorderModel;

class Recorder extends StatelessWidget
{
  Recorder({Key key}) : super(key: key)
  {
    recorderModel.loadData("notes", RecorderDBWorker.db);
  }

  Widget build(BuildContext context) {
    return ScopedModel<RecorderModel>(
        model: recorderModel,
        child:
        ScopedModelDescendant<RecorderModel>(
            builder: (BuildContext inContext, Widget inChild, RecorderModel inModel)
            {
              return IndexedStack(
                index: inModel.stackIndex,
                children: [
                  RecorderList(),
                  RecorderEntry()
                ],
              );
            }
        )
    );
  }
}