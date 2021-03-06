import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wte_today/src/providers/LocationProvider.dart';

import 'SelectRestaurantComponent.dart';

class CheckOptionWidget extends StatefulWidget {
  const CheckOptionWidget({Key? key, required this.optionName})
      : super(key: key);
  final String optionName;

  @override
  State<CheckOptionWidget> createState() => _CheckOptionWidgetState();
}

class _CheckOptionWidgetState extends State<CheckOptionWidget> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      checkColor: Colors.white,
      title: Text(widget.optionName),
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value!;
        });
      },
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}

List<String> optionArr = ['거리 우선', '평점 우선', 'option3'];

class StartingOptionScreen extends StatefulWidget {
  const StartingOptionScreen({Key? key}) : super(key: key);
  @override
  State<StartingOptionScreen> createState() => _StartingOptionScreenState();
}

class _StartingOptionScreenState extends State<StartingOptionScreen> {
  bool _isStart = false;

  @override
  Widget build(BuildContext context) {
    String currentLocation = context.watch<LocationProvider>().currentLocation;
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.all(32),
      child: Column(children: [
        Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back)),
            Text(
              currentLocation,
              // style: TextStyle(fontSize: 24),
            ),
          ],
        ),
        _isStart
            ? const Expanded(
                child: SelectRestaurantScreen(),
              )
            : Column(
                children: [
                  Column(children: _getOptionArr()),
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: GestureDetector(
                      child: Row(children: [
                        const Text('시작하기'),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _isStart = true;
                            });
                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (context) {
                            //   return const SelectRestaurantComponent();
                            // }));
                          },
                          icon: const Icon(Icons.start),
                        )
                      ]),
                      onTap: () {
                        print('start!');
                      },
                    ),
                  ),
                ],
              )
      ]),
    ));
  }

  _getOptionArr() {
    return optionArr
        .map((option) => CheckOptionWidget(
              optionName: option,
            ))
        .toList();
  }
}
