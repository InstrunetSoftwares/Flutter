import 'dart:convert';

import 'package:darq/darq.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'api_fetch.g.dart';
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
  /// Huge side-effect. Sets session_string in shared_preference.
  static Future<void> login({required String api, required String username, required String password})async {
    final res = await http.post("$api/login".toUri(), body: json.encode({"username": username, "password": password }), headers: {"Content-Type": "application/json"});
    if(res.statusCode == 200){
      final cookies = res.headers['set-cookie'];
      if(cookies != null){
        final sessionCookie = cookies.split(';').firstWhereOrDefault((i)=>i.startsWith(".AspNetCore.Session="));
        final sessionValue = sessionCookie?.split('=').last;
        if(sessionValue == null){
          throw Exception("Login failed: No session cookie received. ");
        }
        final pref = await SharedPreferences.getInstance();
        await pref.setString(".AspNetCore.Session=", sessionValue);
      }else{
        throw Exception("Login failed: No session cookie received. ");
      }
    }else{
      throw Exception("Login failed: ${res.statusCode} ");
    }
  }
  static Future<User> fetchUser({required String api}) async {
    final shared = (await SharedPreferences.getInstance()).getString(".AspNetCore.Session=");
    if(shared == null || shared.isEmpty){
      throw Exception("Failed to fetch userapi: No session cookie stored. ");
    }
    final res = await http.get("$api/userapi".toUri(), headers: {"Cookie": ".AspNetCore.Session=$shared"});
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


extension on String {
  Uri toUri() {
    return Uri.parse(this);
  }
}