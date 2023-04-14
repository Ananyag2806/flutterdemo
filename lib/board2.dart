import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';

class ScrumBoard extends StatefulWidget {
  const ScrumBoard({Key? key}) : super(key: key);

  @override
  State createState() => _ScrumBoard();
}

class InnerList {
  final String name;
  List<String> children;
  InnerList({required this.name, required this.children});
}

class _ScrumBoard extends State<ScrumBoard> {
  late List<InnerList> _lists;

  @override
  void initState() {
    super.initState();

    _lists = List.generate(9, (outerIndex) {
      return InnerList(
        name: outerIndex.toString(),
        children: List.generate(12, (innerIndex) => '$outerIndex.$innerIndex'),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Scrum4Everyday'),
          backgroundColor: Colors.green,
        ),
        body: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _lists.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildList(index);
          },
        ),
      ),
    );
  }

  _buildList(int outerIndex) {
    var innerList = _lists[outerIndex];
    return DragAndDropList(
      children: List.generate(innerList.children.length,
          (index) => _buildItem(innerList.children[index])),
      footer: Container(
        height: 50,
        margin: const EdgeInsets.all(8.0),
        decoration: const BoxDecoration(
          color: Color(0xFF483838),
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black45,
              spreadRadius: 3.0,
              blurRadius: 6.0,
              offset: Offset(2, 3),
            ),
          ],
        ),
        child: const Center(
          child: TextButton(
            onPressed: null,
            child: Text(
              'Add Task',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildItem(String item) {
    return DragAndDropItem(
      child: Container(
        height: 50,
        margin: const EdgeInsets.all(8.0),
        decoration: const BoxDecoration(
          color: Color(0xFF483838),
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black45,
              spreadRadius: 3.0,
              blurRadius: 6.0,
              offset: Offset(2, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            item,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
    );
  }

  _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      var movedItem = _lists[oldListIndex].children.removeAt(oldItemIndex);
      _lists[newListIndex].children.insert(newItemIndex, movedItem);
    });
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      var movedList = _lists.removeAt(oldListIndex);
      _lists.insert(newListIndex, movedList);
    });
  }
}
