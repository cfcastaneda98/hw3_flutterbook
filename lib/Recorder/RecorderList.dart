import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'RecorderDBWorker.dart';
import 'RecorderModel.dart' show Recorder, RecorderModel, recorderModel;

class RecorderList extends StatelessWidget
{
  Widget build(BuildContext inContext)
  {
    return ScopedModel<RecorderModel>(
        model: recorderModel,
        child: ScopedModelDescendant<RecorderModel>(
            builder: (BuildContext inContext, Widget inChild, RecorderModel inModel)
            {
              return Scaffold(
                  floatingActionButton: FloatingActionButton(
                    child: Icon(Icons.add, color: Colors.white),
                    onPressed: (){
                      recorderModel.entityBeingEdited = Recorder();
                      recorderModel.setColor(null);
                      recorderModel.setStackIndex(1);
                    },
                  ),
                  body: ListView.builder(
                      itemCount: recorderModel.entityList.length,
                      itemBuilder: (BuildContext inBuildContext, int inIndex) {
                        Recorder recorder = recorderModel.entityList[inIndex];
                        Color color = Colors.white;

                        switch (recorder.color) {
                          case "red" : color = Colors.red; break;
                          case "green" : color = Colors.green; break;
                          case "blue" : color = Colors.blue; break;
                          case "yellow" : color = Colors.yellow; break;
                          case "grey" : color = Colors.grey; break;
                          case "purple" : color = Colors.purple; break;
                        }

                        return Container(
                            padding : const EdgeInsets.fromLTRB(20, 20, 20, 0),
                            child : Slidable(
                              endActionPane: ActionPane(
                                motion: const DrawerMotion(),
                                extentRatio: 0.25,
                                children: [
                                  SlidableAction(
                                    label: 'Delete',
                                    backgroundColor: Colors.red,
                                    icon: Icons.delete,
                                    onPressed: (inContext) => _deleteNote(inContext, recorder),
                                  ),
                                ],
                              ),
                              child: Card (
                                elevation: 8,
                                color: color,
                                child: ListTile(
                                  title: Text("${recorder.title}"),
                                  subtitle: Text("${recorder.content}"),
                                  onTap: () async {
                                    recorderModel.entityBeingEdited =
                                    await RecorderDBWorker.db.get(recorder.id);
                                    recorderModel.setColor(recorderModel.entityBeingEdited.color);
                                    recorderModel.setStackIndex(1);
                                  },
                                ),
                              ),
                            )
                        );
                      }
                  )
              );
            }
        )
    );
  }

  Future _deleteNote (BuildContext inContext, Recorder inRecorder)
  {
    return showDialog(
        context: inContext,
        barrierDismissible: false,
        builder: (BuildContext inAlertContext) {
          return AlertDialog(
            title: Text('Delete Note'),
            content: Text(
                "Are you sure you want to delete ${inRecorder.title}?"
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(inAlertContext).pop();
                  },
                  child: Text("Cancel")
              ),
              TextButton(
                  onPressed: () async {
                    await RecorderDBWorker.db.delete(inRecorder.id);
                    Navigator.of(inAlertContext).pop();
                    recorderModel.loadData("notes", RecorderDBWorker.db);
                  },
                  child: Text("Delete")
              )
            ],
          );
        }
    );
  }
}