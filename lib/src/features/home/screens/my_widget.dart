import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final ScrollController _scrollController = ScrollController();
  int _currentMaxIndex = 2;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: 5,
      itemBuilder: (BuildContext context, int index) {
        if (index > _currentMaxIndex) {
          return const SizedBox.shrink();
        } else {
          return Container(
            height: 300,
            color: Colors.blueGrey,
            child: Text('Widget $index'),
          );
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _currentMaxIndex = 4;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
