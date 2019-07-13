import 'package:flutter/material.dart';

class CompletedLsit extends StatefulWidget {

   List<String> _completedList = [];
  CompletedLsit(this._completedList);

  @override
  _CompletedLsitState createState() => _CompletedLsitState();
}

class _CompletedLsitState extends State<CompletedLsit> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView.builder(
          itemCount: widget._completedList.length,
          itemBuilder: (BuildContext context, int index) {
              return ListView.builder(
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(widget._completedList[index]),
                  );
               },
              ); 
          }
        )
    );
  }

}
