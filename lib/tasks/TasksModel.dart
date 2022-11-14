import '../BaseModel.dart';

TasksModel tasksModel = TasksModel();

class Task
{
  int id = 0;
  String description = '';
  String dueDate = '';
  String completed = 'false';
  String toString() {
    return "{id=$id, description=$description, "
        "dueDate=$dueDate, completed=$completed}";
  }
}

class TasksModel extends BaseModel {
}

