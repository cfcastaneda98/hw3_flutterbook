import '../BaseModel.dart';

class Appointment
{
  int id = 0;
  String title = '';
  String description = '';
  String date = '';
  String time = '';

  bool hasTime() => time != null;

  String toString() {
    return "{id=$id, title=$title, description=$description, "
        "apptDate=$date, apptTime=$time}";
  }
}

class AppointmentsModel extends BaseModel {
  String time = '';

  void setApptTime(String inApptTime)
  {
    time = inApptTime;
    notifyListeners();
  }
}

AppointmentsModel appointmentsModel = AppointmentsModel();