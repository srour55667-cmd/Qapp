import 'package:flutter/material.dart';
import 'package:qapp/widget/TimeAndHijri.dart';

class Timeandtext extends StatefulWidget {
  const Timeandtext({super.key, required this.text});

  final String text;
  @override
  State<Timeandtext> createState() => _TimeandtextState();
}

class _TimeandtextState extends State<Timeandtext> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "ايات من الذكر ",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color(0xFF9543FF),
            ),
          ),
        ),
        Text(
          "${widget.text}",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFFA8A8A8),
          ),
        ),

        Timeandhijri(),
      ],
    );
  }
}
