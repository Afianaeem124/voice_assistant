import 'package:flutter/material.dart';
import 'package:voice_assistant/utils/pallete.dart';

class FeaturesBox extends StatelessWidget {
  final Color color;
  final String header;
  final String description;
  const FeaturesBox({super.key, required this.color, required this.header, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 35),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20).copyWith(left: 15),
          child: Column(children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(header, style: const TextStyle(fontFamily: 'Cera Pro', fontSize: 18, color: Pallete.mainFontColor, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(
              height: 3,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Text(description,
                  style: const TextStyle(
                    fontFamily: 'Cera Pro',
                    color: Pallete.mainFontColor,
                  )),
            ),
          ]),
        ));
  }
}
