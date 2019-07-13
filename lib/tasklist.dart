import 'package:flutter/material.dart';
// import 'completedList.dart';

class Item {
  String taskName;
  int priority;
  bool isChecked;
  Item({this.taskName, this.priority, this.isChecked});
}

class TaskList extends StatefulWidget {
  TaskList({Key key}) : super(key: key);

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            height: 100.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                    onPressed: completedList.length == 0
                        ? null
                        : _deleteAllCompletedTask,
                          
                    child: Text("Delete all Completed Tasks"),
                  ),
                )
              ],
            ),
          );
        });
  }

  final taskNameController = TextEditingController();
  final priorityController = TextEditingController();

  List<Item> taskList = List();

  List<Item> completedList = [];

  _appendItem(Item item) {
    print(taskList.length);
    setState(() {
      // print(listKey.currentState);

      taskList.add(item);

      print(taskList.length);
    });
  }

  _insertItem(int index, Item item) {
    setState(() {
      taskList.insert(index, item);
      print(taskList.length);
    });
  }

  _removeItem(Item item) {
    setState(() {
      completedList.insert(0, item);
      taskList.remove(item);
      print(taskList.length);
    });

    print("completed list length: ${completedList.length}");
  }

  Future _deleteAllCompletedTask() async {
    print("completed length ${completedList.length}");
    Navigator.of(context).pop();
    print(completedList.length);
    return showDialog(
        context: context,
        barrierDismissible: false      ,
        builder: (BuildContext builder) {
          print(completedList.length);
          return Container(
            child: AlertDialog(
              title: Text("Delete all completed tasks?"),
              content: Text(
                  "There is ${completedList.length} completed task that will be permanently removed."),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel", style: TextStyle(fontSize: 16.0)),
                ),
                FlatButton(
                  onPressed: () {
                    setState(() {
                      completedList.clear();
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Delete",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _addTask(Item item) {
    // print(item);
    int flag = 0;

    if (item == null) {
      flag = 1;
      String taskName = taskNameController.text;
      int priority = int.parse(priorityController.text);
      bool isChecked = false;
      item = Item(taskName: taskName, priority: priority, isChecked: isChecked);
    } else {
      print("compl#######$item");
    }

    int length = taskList.length;

    print(item.taskName);
    if (length == 0) {
      _appendItem(item);
    } else if (length == 1) {
      if (item.priority >= taskList[0].priority) {
        _appendItem(item);
      } else if (item.priority <= taskList[0].priority) {
        _insertItem(0, item);
      }
    } else {
      if (item.priority <= taskList[0].priority) {
        _insertItem(0, item);
      } else {
        for (int i = 0; i < length - 1; i++) {
          if (taskList[i].priority <= item.priority &&
              item.priority < taskList[i + 1].priority) {
            _insertItem(i + 1, item);
            break;
          } else if (i + 1 == length - 1) {
            _appendItem(item);
            break;
          }
        }
      }
    }
    if (flag == 1) {
      taskNameController.clear();
      priorityController.clear();
      Navigator.of(context).pop();
    }
    debugPrint(taskList.toString());
  }

  void _showForm(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Container(
            child: AlertDialog(
              title: Text("Add a task"),
              content: Container(
                height: 100.0,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      autofocus: true,
                      controller: taskNameController,
                      decoration: InputDecoration(
                        hintText: "Enter a task name",
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    TextFormField(
                      autofocus: true,
                      controller: priorityController,
                      decoration: InputDecoration(
                        hintText: "Enter priority of the task",
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel", style: TextStyle(fontSize: 16.0)),
                ),
                FlatButton(
                  onPressed: () {
                    _addTask(null);
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.event_note, color: Colors.blue[700]),
        titleSpacing: 4.0,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          "TO-DO List",
          style: TextStyle(
            color: Colors.blue[700],
            fontSize: 24.0,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: _cardListView(),
      backgroundColor: Colors.white,
      floatingActionButton: _customFloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: customBottomAppBar(),
    );
  }

  Widget _customFloatingButton() {
    return FloatingActionButton(
      focusElevation: 10.0,
      foregroundColor: Colors.white,
      backgroundColor: Colors.blue[500],
      elevation: 12.0,
      onPressed: () {
        return _showForm(context);
      },
      child: Icon(Icons.add),
      tooltip: "Add a new task",
    );
  }

  Widget customBottomAppBar() {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 5.0,
      elevation: 16.0,
      color: Colors.white,
      child: Container(
        height: 58.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
                onPressed: () {
                  _showBottomSheet();
                },
                icon: Icon(
                  Icons.menu,
                  color: Colors.blue[500],
                )),
          ],
        ),
      ),
    );
  }

  Widget listItemTile(BuildContext context, Item item) {
    return ListTile(
      dense: true,
      leading: Checkbox(
        tristate: true,
        activeColor: Colors.blue[500],
        value: item.isChecked,
        onChanged: (value) {
          if (item.isChecked == false) {
            setState(() {
              item.isChecked = true;
              Future.delayed(Duration(milliseconds: 350), () {
                _removeItem(item);
              });
            });
          } else {
            setState(() {
              item.isChecked = false;

              Future.delayed(Duration(milliseconds: 350), () {
                _addTask(item);
                setState(() {
                  completedList.remove(item);
                });
              });
              // completedList.remove(item);
              print(completedList);
              print("completd list length ${completedList.length}");
            });
          }
        },
      ),
      title: Text(
        item.taskName,
        style: TextStyle(fontSize: 20.0),
      ),
      trailing: Text(
        item.priority.toString(),
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }

  Widget _cardListView() {
    if (taskList.length == 0 && completedList.length == 0) {
      return emptyStateView();
    } else if (completedList.length == 0 && taskList.length > 0) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        // mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(0.0),
              itemCount: taskList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    children: <Widget>[
                      listItemTile(context, taskList[index]),
                      Divider(color: Colors.grey, height: 16.0)
                    ],
                  ),
                );
              },
            ),
          ),

          // completedList.length==0?null:
        ],
      );
    } else {
      List<Widget> completedListWidgets =
          completedList.map((item) => listItemTile(context, item)).toList();
      return Column(
        // mainAxisSize: MainAxisSize.min,
        // mainAxisAlignment: MainAxisAlignment.end,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ExpansionTile(
            title: Text(
              "Completed (${completedList.length})",
              style: TextStyle(fontSize: 22.0),
            ),
            onExpansionChanged: null,
            initiallyExpanded: false,
            children: completedListWidgets,
          ),

          SizedBox(height: 5.0),
          // Divider(color: Colors.grey, height: 16.0),
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(0.0),
              itemCount: taskList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    children: <Widget>[
                      index == 0
                          ? Divider(color: Colors.grey, height: 16.0)
                          : Divider(color: Colors.transparent, height: 0.0),
                      listItemTile(context, taskList[index]),
                      Divider(color: Colors.grey, height: 16.0),
                    ],
                  ),
                );
              },
            ),
          ),

          // completedList.length==0?null:
        ],
      );
    }
  }

  Widget emptyStateView() {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.asset(
              "images/to-do-empty.jpg",
              height: 270.0,
              fit: BoxFit.fitWidth,
            ),
            SizedBox(
              height: 50.0,
            ),
            Center(
              child: Text(
                "Add a new task !!!",
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w300),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
