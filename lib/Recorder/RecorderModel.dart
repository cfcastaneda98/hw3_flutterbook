import '../BaseModel.dart';

class Recorder
{
  int id = 0;
  String title = '';
  String content = '';
  String color = 'ffffff';
  String toString() {
    return "{id=$id, title=$title, "
        "content=$content, color=$color}";
  }
}

class RecorderModel extends BaseModel
{
  String color = 'ffffff';

  void setColor(String inColor)
  {
    if (inColor != null) {
      color = inColor;
      notifyListeners();
    }
  }
}

RecorderModel recorderModel = RecorderModel();