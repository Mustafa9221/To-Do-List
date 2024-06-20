import 'package:shared_preferences/shared_preferences.dart';

class Task {
  String title;
  String description;
  bool status = false;
  bool active;
  String date;
  String priority;
  Task(
    this.title,
    this.description,
    this.priority,
    this.date,
    this.active,
  );

  void setPriorty(value) {
    this.priority = priority;
  }

  void setDate(value) {
    this.date = value;
  }

  void setStatus(value) {
    status = value;
  }

  void setDescription(value) {
    this.description = value;
  }

  void setActive(value) {
    this.active = value;
  }

  void setTitle(value) {
    this.title = value;
  }
}

late SharedPreferences sp;
late List<Task> data = [];
late int check = 1;

Future getTaskData() async {
  List<String>? info = [];
  info = sp.getStringList("Mytasks");
  for (int i = 1; i < info!.length; i++) {
    String tasktitle;
    String taskdescription;
    bool taskstatus;
    bool taskactive;
    String taskdate;
    String taskpriority;
    tasktitle = info[i * 6 - 6];
    taskdescription = info[i * 6 - 5];
    taskstatus = info[i * 6 - 4] == "false" ? false : true;
    taskactive = info[i * 6 - 3] == "false" ? false : true;
    taskdate = info[i * 6 - 2];
    taskpriority = info[i * 6 - 1];
    Task obj =
        Task(tasktitle, taskdescription, taskpriority, taskdate, taskactive);
    obj.setStatus(taskstatus);
    data.insert(0, obj);
  }
}

void setTaskData() async {
  List<String> tasks = [];
  for (int i = 0; i < data.length; i++) {
    tasks.insert(0, data[i].priority.toString());
    tasks.insert(0, data[i].date.toString());
    tasks.insert(0, data[i].active.toString());
    tasks.insert(0, data[i].status.toString());
    tasks.insert(0, data[i].description.toString());
    tasks.insert(0, data[i].title.toString());
  }
  sp.setStringList("Mytasks", tasks);
}

void onboardornot() async {
  check = sp.getInt("onboard")!;
}
