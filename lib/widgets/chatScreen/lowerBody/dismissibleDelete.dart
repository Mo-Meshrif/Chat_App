import 'package:flutter/material.dart';

class DismissibleDelete extends StatelessWidget {
  final DismissDirection dir;
  final Widget child;

  final String spacifickey;
  final Function onDismissed;

  DismissibleDelete({ this.spacifickey, this.child, this.dir, this.onDismissed});
  @override
  Widget build(BuildContext context) {
    return Dismissible(
        background: Container(
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.symmetric(horizontal: 10),
            color: Colors.red,
            child: Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.delete),
            )),
        direction: dir,
        key: ValueKey(spacifickey),
        onDismissed:onDismissed,
        child: child);
  }
}
