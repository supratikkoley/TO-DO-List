import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'item.dart';

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  final taskNameController = TextEditingController();
  final priorityController = TextEditingController();

  List<Item> taskList = [];

  List<Item> completedList = [];

  var jsonTaskList;
  var jsonCompletedList;

  bool _visible = false;

  @override
  void initState() {
    super.initState();

    _loadData();

    ///when the app launcehs, this method loads all the data of this app.
  }

  /////////////////////////////////# HELPER METHODS #/////////////////////////////////////////////////////

  _saveValues() async {
    // this method create jsonArray of two list and by using sharedpreferance saves
    // all the data of two lists into the local storage.
    jsonTaskList = jsonEncode(taskList.map((e) => e.toJsonItem()).toList());
    jsonCompletedList =
        jsonEncode(completedList.map((e) => e.toJsonItem()).toList());

    print(jsonTaskList.runtimeType); //for debug pupose
    print(jsonCompletedList.runtimeType); //for debug pupose

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('taskList', jsonTaskList);
    prefs.setString('completedList',
        jsonCompletedList); //save key-value pairs in local storage.
  } // End of _saveValues()

  _loadData() async {
    // this method loads all the data from the local stoarge.

    SharedPreferences prefs = await SharedPreferences.getInstance();
    jsonTaskList = prefs.getString('taskList') ??
        null; // if there is no data, jsonTaskList will be
    jsonCompletedList =
        prefs.getString('completedList') ?? null; // assigned to null.

    print(jsonTaskList); // for debug purpose
    print(jsonTaskList.runtimeType);

    if (jsonTaskList == null)
      taskList = [];
    else {
      Iterable jsonbody = json.decode(jsonTaskList);

      print(jsonbody);
      print(jsonbody.runtimeType); //debug purpose

      setState(() {
        taskList = jsonbody
            .map((e) => Item.fromJson(e))
            .toList(); // this line creates the list of Item(object) from
        print(taskList); // the Json which was fetched from local storage.
      });
    }

    if (jsonCompletedList == null)
      completedList = [];
    else {
      Iterable jsonbody = json.decode(jsonCompletedList);
      setState(() {
        completedList = jsonbody.map((e) => Item.fromJson(e)).toList();
      });
    }
  } //End of _loadData()

  _appendItem(Item item) {
    // It helps the _addTask() method to add the item at the end of the list.
    print(taskList.length);
    setState(() {
      taskList.add(item);

      print(taskList.length);
    });
  }

  _insertItem(int index, Item item) {
    // It helps the _addTask() method to insert the item at the desired index
    // of the list.
    setState(() {
      taskList.insert(index, item);
      print(taskList.length);
    });
  }

  _removeTask(Item item) {
    // remove task from the taskList and add that task into the compltedTaskList.
    setState(() {
      completedList.insert(0, item);
      taskList.remove(item);
      print(taskList.length);
    });
    if (taskList.length == 0 && _visible == true) {
      setState(() {
        _visible = false;
      });
    }
    _saveValues();

    print("completed list length: ${completedList.length}");
    print(jsonTaskList.toString());
    print(jsonCompletedList.toString());
  }

  Future _deleteTask(Item item) async {
    //This method delete task permanently from the taskList.
    Navigator.of(context).pop();
    print(completedList.length);
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext builder) {
          print(completedList.length);
          return Container(
            child: AlertDialog(
              title: Text("Delete this tasks?"),
              content: Text(
                "This task will be permanently removed.",
                style: TextStyle(
                  color: Colors.grey,
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
                    if (item.isChecked == true) {
                      setState(() {
                        completedList.remove(item);
                      });
                    } else {
                      setState(() {
                        taskList.remove(item);
                      });
                    }

                    _saveValues();
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
    // In this function I applied the task inserting algorithm, So this funtion
    // will add the task into the task list in the right order.
    int flag =
        0; // and also when this function is called, it store the data of two lists into the
    if (item == null) {
      // local storage.
      flag = 1;
      String taskName = taskNameController.text;
      int priority = int.parse(priorityController.text);
      bool isChecked = false;
      item = Item(taskName: taskName, priority: priority, isChecked: isChecked);
    } else {
      print(item);
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
      //if the flag is 1, it will clear the form and pop out from the form.
      taskNameController.clear();
      priorityController.clear();
      Navigator.of(context).pop();
    }

    debugPrint(taskList.toString());

    _saveValues();

    print(jsonTaskList.toString());
  }

  void _showForm(BuildContext context) {
    //this function show a form in which user have to
    //give the task name and priority of that task, when,
    //user hit the save button this function add the task into the taskList.
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
                    taskNameController.clear();
                    priorityController.clear();
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

  void _showBottomSheet(int flag, Item item) {
    // it will show a bottom sheet where user can delete all completed task.
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
                  child: flag == 0
                      ? FlatButton(
                          onPressed: completedList.length == 0
                              ? null
                              : _deleteAllCompletedTask,
                          child: Text("Delete all Completed Tasks"),
                        )
                      : FlatButton(
                          onPressed: () {
                            if (item.isChecked == false) {
                              if (taskList.length != 0) _deleteTask(item);
                            } else {
                              _deleteTask(item);
                            }
                          },
                          child: Text("Delete this Tasks"),
                        ),
                )
              ],
            ),
          );
        });
  }

  Future _deleteAllCompletedTask() async {
    //This method helps to delete all the completed tasks
    print(
        "completed length ${completedList.length}"); // after getting permission from user.
    Navigator.of(context).pop();
    print(completedList.length);
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext builder) {
          print(completedList.length);
          return Container(
            child: AlertDialog(
              title: Text("Delete all completed tasks?"),
              content: Text(
                "There is ${completedList.length} completed task that will be permanently removed.",
                style: TextStyle(
                  color: Colors.grey,
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
                    setState(() {
                      completedList.clear();
                    });
                    if (_visible == true) {
                      setState(() {
                        _visible = false;
                      });
                    }
                    _saveValues();
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

////////////////////////////////////////////# End of  HELPER METHODS #/////////////////////////////////////////

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
      body:
          _cardListView(), //this widget will decide what to show on body in different states of the app
      backgroundColor: Colors.white,
      floatingActionButton: _customFloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: customBottomAppBar(),
    );
  } //End of main widget builder.

//////////////////////////////////////// # HELPER WIDGETS #///////////////////////////////////////////////////////////////

  Widget _customFloatingButton() {
    // custom floating button, if users press this button, it will open a form[by _showForm() method]
    return FloatingActionButton(
      // where user will enter taskname and its priority and can save the task into the list.
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
    //it has a menu button which can open a bottomSheet where user can delete all the completed task.
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
                  _showBottomSheet(0,
                      null); //when menu icon will be clicked, a bottosheet will appear where user can find
                }, // the all completed task delete option.
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
    // this is the widget for one list Item, How one item will look
    return ListTile(
      dense: true,
      onLongPress: () => _showBottomSheet(1, item),
      leading: Checkbox(
        // by ticking this checkbox, user can can convert a task to a complted task
        tristate: true, //and add the task to the completedTaskList.
        activeColor: Colors.blue[500],
        value: item.isChecked,
        onChanged: (value) {
          if (item.isChecked == false) {
            // if chekbox is not ticked,
            setState(() {
              // here, it will be ticked and removed from the task list
              item.isChecked = true;
              Future.delayed(Duration(milliseconds: 350), () {
                _removeTask(item);
              });
            });
          } else {
            setState(() {
              item.isChecked = false;

              Future.delayed(Duration(milliseconds: 350), () {
                // if the task is in completedTaskList,
                _addTask(
                    item); // by ticking the checkbox the task will be added to the taskList.
                setState(() {
                  completedList.remove(item);
                });
              });

              print(completedList); //for debug purposes
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
  } //End of listItemTile()

  Widget _cardListView() {
    // this is the main widget, this widget can decide what is needed to show.
    List<Widget> completedListWidgets =
        completedList.map((item) => listItemTile(context, item)).toList();

    if (taskList.length == 0 && completedList.length == 0) {
      // if this condition is true then 'emptyStateView' widget will be shown.
      return emptyStateView();
    } else if (completedList.length == 0 && taskList.length > 0) {
      // if this condition is true then, only listview will be shown.
      return Column(
        mainAxisSize: MainAxisSize.min,
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
        ],
      );
    } else if (completedList.length > 0 && taskList.length == 0) {
      // if this condition is true, only expansiontile(completedList) & taskList will be shown.
      return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ExpansionTile(
              title: Text(
                "Completed (${completedList.length})",
                style: TextStyle(fontSize: 22.0),
              ),
              onExpansionChanged: (val) {
                setState(() {
                  _visible = val;
                });
                print(_visible);
              },
              initiallyExpanded: false,
              children: completedListWidgets,
            ),
            completedTaskStateView(_visible),
          ],
        ),
      );
    } else {
      // if none of the above is true, then it will show the completedList tile(ExpansionTile)
      // and the listview of the taskList.
      return Container(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate([
                ExpansionTile(
                  title: Text(
                    "Completed (${completedList.length})",
                    style: TextStyle(fontSize: 22.0),
                  ),
                  onExpansionChanged: null,
                  initiallyExpanded: false,
                  children: completedListWidgets,
                ),
                ListView.builder(
                  shrinkWrap: true,
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
              ]),
            )
          ],
        ),
      );
    }
  } //End of _cardListView()

  Widget emptyStateView() {
    // this widget return a emptystate view(a fancy image and some text).
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
              height: 60.0,
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
  } //End of emptyStateView()

  Widget completedTaskStateView(bool visible) {
    // when all tasks get completed, this widget will be shown.
    print(visible);
    return AnimatedOpacity(
      opacity: visible ? 0.0 : 1.0,
      duration: Duration(milliseconds: 450),
      child: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 68.0,
            ),
            Image.asset(
              "images/relax.png",
              height: 180.0,
              fit: BoxFit.fitWidth,
            ),
            SizedBox(
              height: 35.0,
            ),
            Center(
              child: Column(
                children: <Widget>[
                  Text(
                    "Nicely done !!!",
                    style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w300,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 14.0,
                  ),
                  Text(
                    "want to add more task ?",
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.grey,
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  } // End of completedTaskStateView()
}
