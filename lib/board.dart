import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'SQLHealper.dart';

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

List archiveTb = [];
List storiesTb = [];
List tasksTb = [];
List todayTb = [];
List inProgTb = [];
List doneTb = [];
bool isLoading = true;

List<List> tables = [archiveTb, storiesTb, tasksTb, todayTb, inProgTb, doneTb];

class _ScrumBoard extends State<ScrumBoard> {
  late List<InnerList> _lists;

  void refreshJournals() async {
    print('refreshing');
    final archive = await SQLHelper.getArchive();
    final stories = await SQLHelper.getStories();
    final tasks = await SQLHelper.getTasks();
    final today = await SQLHelper.getToday();
    final inProg = await SQLHelper.getInProg();
    final done = await SQLHelper.getDone();

    final tempArchive = archive.map((item) => item.values.toList()).toList();
    final tempStories = stories.map((item) => item.values.toList()).toList();
    final tempTasks = tasks.map((item) => item.values.toList()).toList();
    final tempToday = today.map((item) => item.values.toList()).toList();
    final tempInProg = inProg.map((item) => item.values.toList()).toList();
    final tempDone = done.map((item) => item.values.toList()).toList();

    setState(() {
      archiveTb = tempArchive;
      storiesTb = tempStories;
      tasksTb = tempTasks;
      todayTb = tempToday;
      inProgTb = tempInProg;
      doneTb = tempDone;
      tables[0] = archiveTb;
      tables[1] = storiesTb;
      tables[2] = tasksTb;
      tables[3] = todayTb;
      tables[4] = inProgTb;
      tables[5] = doneTb;
      isLoading = false;
    });
    print(storiesTb); // prints the first title
    // print(tasksTb);
    print(tables[0]);
    // print(storiesTb.length);

    List<String> headers = [
      'Archive',
      'Stories',
      'Tasks',
      'Today',
      'In Progress',
      'Done'
    ];

    _lists = List.generate(headers.length, (outerIndex) {
      return InnerList(
        name: headers[outerIndex],
        children: List.generate(tables[outerIndex].length,
            (innerIndex) => tables[outerIndex][innerIndex][1]),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    refreshJournals();
  }

  @override
  void dispose() {
    addAllItems(); // Call your function here when the page is disposed
    isLoading = true;
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    isLoading = true;
    addAllItems(); // Call your function here when the user tries to leave the page
    return true;
  }

  void addAllItems() async {
    print(_lists[0].children);

    List<String> temp;

    temp = _lists[0].children;
    print(temp);
    await SQLHelper.emptyTable('archive');
    print(await SQLHelper.addItems('archive', temp));

    temp = _lists[1].children;
    print(temp);
    await SQLHelper.emptyTable('stories');
    print(await SQLHelper.addItems('stories', temp));

    temp = _lists[2].children;
    print(temp);
    await SQLHelper.emptyTable('tasks');
    print(await SQLHelper.addItems('tasks', temp));

    temp = _lists[3].children;
    print(temp);
    await SQLHelper.emptyTable('today');
    print(await SQLHelper.addItems('today', temp));

    temp = _lists[4].children;
    print(temp);
    await SQLHelper.emptyTable('inProg');
    print(await SQLHelper.addItems('inProg', temp));

    temp = _lists[5].children;
    print(temp);
    await SQLHelper.emptyTable('done');
    print(await SQLHelper.addItems('done', temp));
  }

  // data format
  // [[1, fo tasks, 2023-04-14 18:35:54], [2, tasks, 2023-04-14 18:39:34]]

  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // print(_lists[0].children);
    return WillPopScope(
        onWillPop: _onWillPop,
        child: MaterialApp(
            home: Scaffold(
          backgroundColor: const Color(0xFF083906),
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Color(0xFF135f05),
            title: Row(
              children: [
                const Text(
                  'Scrum Board',
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(width: 8.0),
                Container(
                    alignment: Alignment.centerRight,
                    child: const Icon(
                      Icons.show_chart,
                      color: Color(0xFFFFFFFF),
                    ))
              ],
            ),
          ),
          body: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 255, 255, 255)),
                )
              : DragAndDropLists(
                  children: List.generate(
                      _lists.length, (index) => _buildList(index)),
                  onItemReorder: _onItemReorder,
                  onListReorder: _onListReorder,
                  axis: Axis.horizontal,
                  listWidth: 330,
                  listDraggingWidth: 330,
                  listDecoration: const BoxDecoration(
                    color: Color(0xFF212121),
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
        )));
  }

  _buildList(int outerIndex) {
    var innerList = _lists[outerIndex];

    return DragAndDropList(
        header: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(7.0)),
                  color: Color(0xFF212121),
                ),
                padding: const EdgeInsets.all(10),
                child: Text(innerList.name,
                    style: const TextStyle(
                        color: Color(0xFF00A82D),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Montserrat')),
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
              color: Color(0xFF212121),
              borderRadius: BorderRadius.all(Radius.circular(6.0))),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: textController,
                  decoration: const InputDecoration(
                    hintText: 'Add a card',
                    hintStyle: TextStyle(
                        color: Color(0xFF00A82D),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Montserrat'),
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
                iconSize: 24,
                color: const Color(0xFF00A82D),
              )
            ],
          ),
        ));
  }

  // Insert a new journal to the database
  Future<void> addItem(index) async {
    const tables = ['stories', 'tasks', 'today', 'inProg', 'done'];
    await SQLHelper.createItem(tables[index], textController.text);
    refreshJournals();
  }

  _buildItem(String item) {
    return DragAndDropItem(
      child: Container(
        height: 50,
        margin: const EdgeInsets.all(6.0),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 45, 45, 45),
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
            textAlign: TextAlign.left,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.w400,
              fontFamily: 'Montserrat',
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
