import 'package:flutter/material.dart';
import 'StartingOptionComponent.dart';

class ContentCardComponent extends StatelessWidget {
  const ContentCardComponent(
      {Key? key, required this.contentName, this.location})
      : super(key: key);
  final String contentName;
  final String? location;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Card(
        child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              print(location);
              if (location == null) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: new Text('Warning'),
                        content: new Text('위치를 먼저 설정해주세요'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'))
                        ],
                      );
                    });
              } else {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const StartingOptionComponent();
                }));
              }
            },
            child: SizedBox(
              width: 300,
              height: 150,
              child: Text(contentName),
            )),
      ),
    );
  }
}
