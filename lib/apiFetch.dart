import 'dart:convert';

import 'package:darq/darq.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
part 'apiFetch.g.dart';
@JsonSerializable()
class User{
  String uuid;
  String username;
  String email;
  User(this.uuid, this.username, this.email);
  @override
  toString(){
    return 'user{uuid: $uuid, username: $username, email: $email}';
  }
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

}
class WebRequest{
  static Future<String> login(String api, String username, String password)async {
    final res = await http.post("$api/login".toUri(), body: json.encode({"username": username, "password": password }), headers: {"Content-Type": "application/json"});
    if(res.statusCode == 200){
      final cookies = res.headers['set-cookie'];
      if(cookies != null){
        final sessionCookie = cookies.split(';').firstWhereOrDefault((i)=>i.startsWith(".AspNetCore.Session="));
        final sessionValue = sessionCookie?.split('=').last;
        if(sessionValue == null){
          throw Exception("Login failed: No session cookie received. ");
        }
        return sessionValue;
      }else{
        throw Exception("Login failed: No session cookie received. ");
      }
    }else{
      throw Exception("Login failed: ${res.statusCode} ");
    }
  }
  static Future<User> fetchUser(String api, String sessionId) async {
    final res = await http.get("$api/userapi".toUri(), headers: {"Cookie": ".AspNetCore.Session=$sessionId"});
    if(res.statusCode == 200){
      return User.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }else{
      switch(res.statusCode){
        case 500:
          throw Exception("Failed to fetch userapi: You're not logged in. ");
        case _:
          throw Exception('Failed to fetch userapi: unknown error. ');
      }
    }
  }
}
void main() async {
  final session = await WebRequest.login("http://localhost:5298", "xiey0", "moyingren2015");
  final s = await WebRequest.fetchUser("http://localhost:5298", session);
  print(s);
}

extension on String {
  Uri toUri() {
    return Uri.parse(this);
  }
}