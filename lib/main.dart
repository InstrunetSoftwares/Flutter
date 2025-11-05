import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle("Instrunet");
    setWindowMinSize(const Size(300, 600));
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class UploadPage extends StatefulWidget{
  const UploadPage({super.key});
  @override
  State<UploadPage> createState() => _UploadPageState();
}
class _UploadPageState extends State<UploadPage> {
  File? selected;
  @override
  Widget build(BuildContext context) {
    if(selected != null){
      return Center(
        child: Card(
          child: Container(
            constraints: BoxConstraints(maxWidth: 500),
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: Text("data"),
                ),
                Expanded(
                  child: IntrinsicHeight(
                    child: Column(
                      spacing: 4.0,
                      children: [
                        TextField(decoration: InputDecoration(hintText: "歌名",border: OutlineInputBorder()),),
                        TextField(decoration: InputDecoration(hintText: "艺术家",border: OutlineInputBorder()),),
                        TextField(decoration: InputDecoration(hintText: "专辑",border: OutlineInputBorder()),),
                        TextField(decoration: InputDecoration(hintText: "文件",border: OutlineInputBorder()),),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }else{
      return Center(child: ElevatedButton(onPressed: (){

      }, child: IntrinsicWidth(
        child: Row(
          children: [
            Icon(Icons.upload),
            Text("上传"),
          ],
        ),
      ),));
    }
    
  }
}
class _MainAppState extends State<MainApp> {
  int pageIndex = 0;
  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    if (kDebugMode) {
      print(pageIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    Scaffold s = Scaffold(
      body: [
           UploadPage(),

        Center(child: Text("Search")),
        Center(child: Text("Settings")),
        Center(child: Text("Profile"),)
      ][pageIndex],
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(icon: Icon(Icons.upload), label: "上传"),
          NavigationDestination(icon: Icon(Icons.search), label: "搜索"),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: "设置",
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: "个人",
          ),

        ],
        selectedIndex: pageIndex,
        onDestinationSelected: (i) {
          setState(() {
            pageIndex = i;
          });
        },
      ),
      appBar: AppBar(title: Text("伴奏网")),
    );
    return MaterialApp(
      home: s
    );
  }
}
