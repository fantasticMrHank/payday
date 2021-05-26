import 'package:flutter/material.dart';

class SingleLink extends StatelessWidget {
  final String label;
  final String type;
  final String currentScreen;
  final String thisLink;

  SingleLink(this.label, this.type, this.currentScreen, this.thisLink);
  @override
  Widget build(BuildContext context) {
    Color linkColor =
        ((type == currentScreen) ? Colors.amber[200] : Colors.white)!;
    return InkWell(
      onTap: () {
        if (type == currentScreen) {
          // current screen is active, do nothing
          Navigator.pop(context);
        } else {
          print('dymo link');
          Navigator.popAndPushNamed(context, thisLink);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(5, 10, 0, 10),
            child: Text(
              label,
              style: TextStyle(
                  fontFamily: 'open-regular', color: linkColor, fontSize: 18),
            ),
          ),
          Divider(
            color: Colors.white,
          )
        ],
      ),
    );
  }
}
