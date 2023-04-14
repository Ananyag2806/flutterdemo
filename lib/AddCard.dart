import 'package:flutter/material.dart';

class AddCardWidget extends StatefulWidget {
  const AddCardWidget({Key? key}) : super(key: key);

  @override
  _AddCardWidgetState createState() => _AddCardWidgetState();
}

class _AddCardWidgetState extends State<AddCardWidget> {
  bool _isAddingCard = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: _isAddingCard
          ? const TextField()
          : TextButton(
              onPressed: () {
                setState(() {
                  _isAddingCard = true;
                });
              },
              child: const Text('Add Card'),
            ),
    );
  }
}
