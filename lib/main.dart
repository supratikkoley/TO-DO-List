import 'package:flutter/material.dart';
import './tasklist.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TODO List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        canvasColor: Colors.transparent,
      ),
      home: TaskList(),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   List<Item> _todoList = [];
//   // List<String> _completedList = [];

//   Item item;

//   String taskName;
//   int priority;

//   final taskNameController = TextEditingController();
//   final priorityController = TextEditingController();

//   void _showForm(BuildContext context) {
//     showDialog(
//         context: context,
//         builder: (context) {
//           return Container(
//             child: AlertDialog(
//               title: Text("Add a task"),
//               content: Container(
//                 height: 100.0,
//                 child: Column(
//                   children: <Widget>[
//                     TextFormField(
//                       autofocus: true,
//                       controller: taskNameController,
//                       decoration: InputDecoration(
//                         hintText: "Enter a task name",
//                       ),
//                     ),
//                     SizedBox(
//                       height: 15.0,
//                     ),
//                     TextFormField(
//                       autofocus: true,
//                       controller: priorityController,
//                       decoration: InputDecoration(
//                         hintText: "Enter priority of the task",
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               actions: <Widget>[
//                 FlatButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: Text(
//                     "Cancel",
//                     style: TextStyle(fontSize: 16.0),
//                   ),
//                 ),
//                 FlatButton(
//                   onPressed: addTask(),
//                   child: Text(
//                     "Save",
//                     style: TextStyle(fontSize: 16.0),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         });
//   }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       leading: Icon(Icons.event_note, color: Colors.blue[700]),
  //       titleSpacing: 4.0,
  //       backgroundColor: Colors.transparent,
  //       elevation: 0.0,
  //       title: Text(
  //         "TO-DO List",
  //         style: TextStyle(
  //           color: Colors.blue[700],
  //           fontSize: 24.0,
  //           fontWeight: FontWeight.w400,
  //         ),
  //       ),
  //     ),
  //     body: TaskList(list:null,),
  //     backgroundColor: Colors.white,
  //     floatingActionButton: _customFloatingButton(),
  //     floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
  //     bottomNavigationBar: BottomAppBar(
  //       shape: CircularNotchedRectangle(),
  //       notchMargin: 5.0,
  //       elevation: 10.0,
  //       color: Colors.white,
  //       child: Container(
  //         height: 58.0,
  //         child: Row(
  //           mainAxisSize: MainAxisSize.max,
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: <Widget>[
  //             IconButton(
  //                 onPressed: null,
  //                 icon: Icon(
  //                   Icons.menu,
  //                   color: Colors.blue[500],
  //                 )),
  //             IconButton(
  //                 onPressed: null,
  //                 icon: Icon(
  //                   Icons.more_vert,
  //                   color: Colors.blue[500],
  //                 )),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // custom widgets needed for the project

  // Widget _customFloatingButton() {
  //   return FloatingActionButton(
  //     focusElevation: 10.0,
  //     foregroundColor: Colors.white,
  //     backgroundColor: Colors.blue[500],
  //     elevation: 12.0,
  //     onPressed: () {
  //       return _showForm(context);
  //     },
  //     child: Icon(Icons.add),
  //     tooltip: "Add a new task",
  //   );
  // }

  // Widget _cardListView() {
  //   return _todoList.length == 0
  //       ? emptyStateView()
  //       : ListView.builder(
  //           itemCount: _todoList.length,
  //           itemBuilder: (BuildContext context, int index) {
  //             return Padding(
  //               padding: const EdgeInsets.all(4.0),
  //               child: Column(
  //                 children: <Widget>[
  //                   listItemTile(
  //                       _todoList[index][0], _todoList[index][1], index),
  //                   Divider(color: Colors.grey,height: 16.0)
  //                 ],
  //               ),
  //             );
  //           },
  //         );
  // }

  // Widget listItemTile(String task, int priority, int index) {
  //   return 
  //     ListTile(
  //       dense: true,
  //       leading: Checkbox(
  //           activeColor: Colors.blue[500],
  //           value: _todoList[index][2],
  //           onChanged: (value) {
  //             setState(() {
  //               if (_todoList[index][2] == false)
  //                 _todoList[index][2] = true;
  //               else
  //                 _todoList[index][2] = false;

                // Future.delayed(Duration(milliseconds: 400), () {
                //   setState(() {
                //     _todoList.removeAt(index);
                //   });
  //               });
  //             });
  //           }),
  //       title: Text(
  //         task,
  //         style: TextStyle(fontSize: 22.0),
  //       ),
  //       trailing: Text(
  //         priority.toString(),
  //         style: TextStyle(fontSize: 22.0),
  //       ),
    
  //   );
  // }

  // Widget emptyStateView() {
  //   return Align(
  //     alignment: Alignment.topCenter,
  //     child: SingleChildScrollView(
  //       child: Column(
  //         children: <Widget>[
  //           Image.asset(
  //             "images/to-do-empty.jpg",
  //             height: 270.0,
  //             fit: BoxFit.fitWidth,
  //           ),
  //           SizedBox(
  //             height: 50.0,
  //           ),
  //           Center(
  //             child: Text(
  //               "Add a new task !!!",
  //               style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w300),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
// }
