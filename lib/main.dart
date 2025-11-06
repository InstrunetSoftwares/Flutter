import 'dart:io';
import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:instrunet_mobile/api_fetch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_size/window_size.dart';
import 'package:darq/darq.dart';

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
class _MainAppState extends State<MainApp> {
  int pageIndex = 0;
  late PageController pageController = PageController(initialPage: pageIndex);
  @override
  Widget build(BuildContext context) {
    Scaffold s = Scaffold(
      body:
        PageView(
          controller: pageController,
          children: [
            UploadPage(),
            Center(child: Text("Search")),
            Center(child: Text("Settings")),
            ProfilePage(),
            TestPage()
          ],
        ),

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
          NavigationDestination(icon: Icon(Icons.science), label: "Test page")

        ],
        selectedIndex: pageIndex,
        onDestinationSelected: (i) {
          setState(() {
            pageIndex = i;
            pageController.jumpToPage(i);
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

class UploadPage extends StatefulWidget{
  const UploadPage({super.key});
  @override
  State<UploadPage> createState() => _UploadPageState();
}
class Metadata{
  String? title;
  String? album;
  String? artist;
  List<Picture> image;
  Metadata(this.title, this.album, this.artist, this.image);
}
class _UploadPageState extends State<UploadPage> with AutomaticKeepAliveClientMixin<UploadPage> {
  File? selected;
  Metadata? metaData;
  final Map<String, TextEditingController> _controllers = {"title": TextEditingController(), "artist": TextEditingController(),"album": TextEditingController()};
  bool validation = false;
  @override
  void initState() {
    super.initState();
    _controllers["title"]!.addListener((){
      if(_controllers["title"]!.text.isNotEmpty){
        setState(() {
          validation = true;
        });
      }else{
        setState(() {
          validation = false;
        });
      }
    });
  }
  @override
  void dispose() {
    for (var value in _controllers.values) {
      value.dispose();
    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    if(selected != null || metaData != null){
      return Center(
        child: Card(
          child: Container(
            constraints: BoxConstraints(maxWidth: 700),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Align(alignment: AlignmentGeometry.topRight,child: IconButton(onPressed: (){
                    setState(() {
                      selected = null;
                      metaData = null;
                    });
                  }, icon: Icon(Icons.close))),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      spacing: 10.0,
                      children: [
                        Expanded(
                          child: metaData != null ? Image.memory(metaData!.image[0].bytes) : Text("无封面"),
                        ),
                        Expanded(
                          child: IntrinsicHeight(
                            child: Column(
                              spacing: 10.0,
                              children: [
                                TextField(controller: _controllers["title"]!,decoration: InputDecoration(labelText: "歌名",border: OutlineInputBorder(), errorText: validation ? null :"歌曲名不可为空" ),),
                                TextField(controller: _controllers["artist"]!, decoration: InputDecoration(labelText: "艺术家",border: OutlineInputBorder()),),
                                TextField(controller: _controllers["album"]! , decoration: InputDecoration(labelText: "专辑",border: OutlineInputBorder()),),
                                ElevatedButton(onPressed: (){}, child: IntrinsicWidth(child: Row(children: [Icon(Icons.upload), Text("上传")],)))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }else{
      return Center(child: ElevatedButton(onPressed: (){
        FilePicker.platform.pickFiles(allowMultiple: false, type: FileType.custom, allowedExtensions: ["aac", "midi", "mp3", "ogg", "wav", "m4a", "flac"]).then((result) => {
          if(result != null){
            setState(() {
              final f = File(result.files.single.path!);
              selected = f;
              final metadata = readMetadata(f, getImage: true);
              metaData = Metadata(metadata.title, metadata.album, metadata.artist, metadata.pictures);
              _controllers["title"]!.text = metadata.title ?? "";
              _controllers["album"]!.text = metadata.album ?? "未知专辑";
              _controllers["artist"]!.text = metadata.artist ?? "未知艺术家";
            })
          }
        });
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

  @override
  bool get wantKeepAlive => true;
}

class ProfilePage extends StatefulWidget{
  const ProfilePage({super.key});

  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}
class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [],
    );
  }
}

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  void _runTest() async {
    await WebRequest.login("http://localhost:5298", "xiey0", "moyingren2015");
    final pref = await SharedPreferences.getInstance();

    final s = await WebRequest.fetchUser("http://localhost:5298", pref.getString(".AspNetCore.Session=")!);

    if (kDebugMode) {
      print("$s, ${pref.getKeys().select((s, i){
        return {
          s:
          pref.getString(s)
        };
      })}");
    }
  }
  @override
  void initState() {
    super.initState();
    _runTest();
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("This is a test page."),
    );
  }
}
