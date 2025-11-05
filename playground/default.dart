import 'dart:io';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';

void main(){
  final track = File("playground/test_material.flac");
  print("Current File: ${track.path} with ${track.lengthSync()} bytes long. ");
  final metadata = readMetadata(track, getImage: true);
  final picture = File("playground/test_material.jpg");
  picture.writeAsBytes(metadata.pictures[0].bytes, mode: FileMode.write, flush: true);
  print("Title: ${metadata.title}\nAlbum: ${metadata.album}");
}