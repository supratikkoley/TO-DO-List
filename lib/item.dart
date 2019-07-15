class Item {
  String taskName;
  int priority;
  bool isChecked;
  Item({this.taskName, this.priority, this.isChecked});

  Map<String,dynamic> toJsonItem()=>{
    'taskName':taskName,
    'priority':priority,
    'isChecked':isChecked
  };
  
  factory Item.fromJson(Map<String,dynamic> jsonbody){
    return Item(
      taskName: jsonbody['taskName'],
      priority: jsonbody['priority'],
      isChecked: jsonbody['isChecked']
    );
  }
}
