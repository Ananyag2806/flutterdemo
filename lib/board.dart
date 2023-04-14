import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'AddCard.dart';

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

    List<String> headers = ['Stories', 'Tasks', 'Today', 'In Progress', 'Done'];
    List<List<String>> data = [
      ['plan something with krish', 'message Manvi', 'what about itr'],
      ['call krish', 'message Manvi', 'call daddy about itr'],
      ['wash clothes', 'clean room'],
      ['fill form', 'code'],
      ['nothing', 'nothing', 'nothing']
    ];

    _lists = List.generate(headers.length, (outerIndex) {
      return InnerList(
        name: headers[outerIndex],
        children: List.generate(data[outerIndex].length,
            (innerIndex) => data[outerIndex][innerIndex]),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Scrum4Everyday'),
      ),
      body: DragAndDropLists(
        children: List.generate(_lists.length, (index) => _buildList(index)),
        onItemReorder: _onItemReorder,
        onListReorder: _onListReorder,
        axis: Axis.horizontal,
        listWidth: 330,
        listDraggingWidth: 330,
        listDecoration: const BoxDecoration(
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
        listPadding: const EdgeInsets.all(8.0),
      ),
    ));
  }

  _buildList(int outerIndex) {
    var innerList = _lists[outerIndex];
    TextEditingController textController = TextEditingController();

    return DragAndDropList(
        header: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(7.0)),
                  color: Colors.pink,
                ),
                padding: const EdgeInsets.all(10),
                child: Text(
                  innerList.name,
                  style: Theme.of(context).primaryTextTheme.titleLarge,
                ),
              ),
            ),
          ],
        ),
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
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: textController,
                  decoration: const InputDecoration(
                    hintText: 'Add a card',
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  if (textController.text.isNotEmpty) {
                    setState(() {
                      _lists[outerIndex].children.add(textController.text);
                    });
                    textController.clear();
                  }
                },
                icon: const Icon(Icons.add),
              )
            ],
          ),
        ));
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


// black list color : 0xFF483838
// text color : 
// green background color:
// green app bar color
