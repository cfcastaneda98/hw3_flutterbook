import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'RecorderDBWorker.dart';
import 'RecorderModel.dart' show RecorderModel, recorderModel;

class RecorderEntry extends StatelessWidget
{
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
                      ListTile(
                        leading: Icon(Icons.content_paste),
                        title: TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 8,
                          decoration: const InputDecoration(hintText: "Content"),
                          controller: _contentEditingController,
                          validator: (String inValue) {
                            if (inValue == null || inValue.isEmpty) {
                              return "Please enter content";
                            }

                            return null;
                          },
                        ),
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
}