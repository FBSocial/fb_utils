import 'package:flutter/material.dart';
import 'package:fb_utils/fb_utils.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      readClipContent(false);
    } else if (state == AppLifecycleState.paused) {
    } else if (state == AppLifecycleState.inactive) {}
    super.didChangeAppLifecycleState(state);
  }

  void readClipContent(bool forceRead) async {
    final text = await FbUtils.getPasteboardText(forceRead: forceRead);
    debugPrint("粘贴板内容:$text");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: Column(
            children: [
              Text('fb utils'),
              ElevatedButton(
                onPressed: () {
                  FbUtils.getMD5WithSring("fb").then((value) => print(value));
                },
                child: Text('md5 string'),
              ),
              ElevatedButton(
                onPressed: () {
                  FbUtils.hideKeyboard();
                },
                child: Text('hide keyboard'),
              ),
              ElevatedButton(
                onPressed: () async {
                  readClipContent(true);
                },
                child: Text('读取粘贴板'),
              ),
            ],
          )),
    );
  }
}
