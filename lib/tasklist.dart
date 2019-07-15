import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'spalsh_screen.dart';
import 'item.dart';

class TaskList extends StatefulWidget {
  List<Item> tasklist = [];
  List<Item> completedTasklist = [];
  TaskList({this.tasklist,this.completedTasklist});

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
  
  
  @override
  void initState() {    
    super.initState();
    _loadData(); ///when the app launcehs, this method loads all the data of this app.
  }
  
  
  /////////////////////////////////# HELPER METHODS #/////////////////////////////////////////////////////
  
  _saveValues() async {  // this method create jsonArray of two list and by using sharedpreferance saves
                          // all the data of two lists into the local storage.          
    jsonTaskList  = jsonEncode(taskList.map((e)=>e.toJsonItem()).toList());
    jsonCompletedList =  jsonEncode(completedList.map((e)=>e.toJsonItem()).toList());
    
    print(jsonTaskList.runtimeType);   //for debug pupose
    print(jsonCompletedList.runtimeType); //for debug pupose
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('taskList', jsonTaskList);
    prefs.setString('completedList', jsonCompletedList);  //save key-value pairs in local storage.
  
  } // End of _saveValues()

  _loadData() async {  // this method loads all the data from the local stoarge.
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    jsonTaskList = prefs.getString('taskList') ?? null;           // if there is no data, jsonTaskList will be
    jsonCompletedList = prefs.getString('completedList') ?? null; // assigned to null.
    
    print(jsonTaskList);          // for debug purpose
    print(jsonTaskList.runtimeType);
    
    if(jsonTaskList==null)
      taskList = [];
    else{
      Iterable jsonbody = json.decode(jsonTaskList);
      
      print(jsonbody);
      print(jsonbody.runtimeType); //debug purpose
      
      setState(() {
        taskList = jsonbody.map((e)=>Item.fromJson(e)).toList(); // this line creates the list of Item(object) from
        print(taskList);                                         // the Json which was fetched from local storage.
      });
    
    }

    if(jsonCompletedList==null)
      completedList = [];
    else{
      Iterable jsonbody = json.decode(jsonCompletedList);
      setState(() {
        completedList = jsonbody.map((e)=>Item.fromJson(e)).toList();        
      });
    }
  
  } //End of _loadData()

  
  _appendItem(Item item) { // It helps the _addTask() method to add the item at the end of the list.
    print(taskList.length);
    setState(() {

      taskList.add(item);

      print(taskList.length);
    });
  }

  _insertItem(int index, Item item) { // It helps the _addTask() method to insert the item at the desired index 
                                    // of the list.
    setState(() { 
      taskList.insert(index, item);
      print(taskList.length);
    });

  }

  _removeTask(Item item) {  // 
    setState(() {
      completedList.insert(0, item);
      taskList.remove(item);
      print(taskList.length);
      
    });
    
    _saveValues();
    
    print("completed list length: ${completedList.length}");
    print(jsonTaskList.toString());
    print(jsonCompletedList.toString());
    
  }

  
  void _addTask(Item item) {// In this function I applied the task inserting algorithm, So this funtion
                            // will add the task into the task list in the right order.
    int flag = 0;           // and also when this function is called, it store the data of two lists into the
    if (item == null) {     // local storage.
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

    if (flag == 1) {    //if the flag is 1, it will clear the form and pop out from the form.
      taskNameController.clear();
      priorityController.clear();
      Navigator.of(context).pop();
    }

    debugPrint(taskList.toString());
    
    _saveValues();

    print(jsonTaskList.toString());
  }

  void _showForm(BuildContext context) { //this function show a form in which user have to
        showDialog(                      //give the task name and priority of that task, when,
        context: context,                //user hit the save button this function add the task into the taskList.
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

  
  void _showBottomSheet() { // it will show a bottom sheet where user can delete all completed task.
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

  Future _deleteAllCompletedTask() async {              //This method helps to delete all the completed tasks 
    print("completed length ${completedList.length}"); // after getting permission from user.
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
      body: _cardListView(),
      backgroundColor: Colors.white,
      floatingActionButton: _customFloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: customBottomAppBar(),
    );
  
  } //End of main widget builder.

//////////////////////////////////////// # HELPER WIDGETS #///////////////////////////////////////////////////////////////

  Widget _customFloatingButton() { // custom floating button, if users press this button, it will open a form[by _showForm() method]
    return FloatingActionButton(   // where user will enter taskname and its priority and can save the task into the list.
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

  Widget customBottomAppBar() {  //it has a menu button which can open a bottomSheet where user can delete all the completed task.
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

  Widget listItemTile(BuildContext context, Item item) { // this is the widget for one list Item, How one item will look
    return ListTile(
      dense: true,
      leading: Checkbox( // by ticking this checkbox, user can can convert a task to a complted task 
        tristate: true,  //and add the task to the completedTaskList.
        activeColor: Colors.blue[500],
        value: item.isChecked,
        onChanged: (value) {
          if (item.isChecked == false) { // if chekbox is not ticked,
            setState(() {               // here, it will be ticked and removed from the task list
              item.isChecked = true;
              Future.delayed(Duration(milliseconds: 350), () {
                _removeTask(item);
              });
            });
          } else {
            setState(() {
              item.isChecked = false;

              Future.delayed(Duration(milliseconds: 350), () { // if the task is in completedTaskList,
                _addTask(item);         // by ticking the checkbox the task will be added to the taskList.
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
  }

  Widget _cardListView() {                                      // this is the main widget, this widget can decide what is needed to show.
    if (taskList.length == 0 && completedList.length == 0) { // if this condition is true then 'emptyStateView' widget will be shown.
      return emptyStateView();
    } else if (completedList.length == 0 && taskList.length > 0) {// if this condition is true then, only listview will be shown. 
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
    } else {  // if none of the above is true, then it will show the completedList tile(ExpansionTile)
      List<Widget> completedListWidgets =                          // and the listview of the taskList.
          completedList.map((item) => listItemTile(context, item)).toList();
      return Column(
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

  Widget emptyStateView() { // this widget return a emptystate view( a fancy image and some text).
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