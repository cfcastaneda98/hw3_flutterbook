import '../BaseModel.dart';

class Contact
{
  int id = 0;
  String name = '';
  String phone = '';
  String email = '';
  String birthday = '';
  String toString(){
    return "id=$id, name=$name, phone=$phone, email=$email, birthday=$birthday";
  }
}

class ContactsModel extends BaseModel {
  String apptTime = '';
  void setBirthday(String date){
    super.setChosenDate(date);
  }
  void triggerRebuild() {
    notifyListeners();
  }
}

ContactsModel contactsModel = ContactsModel();