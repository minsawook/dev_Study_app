// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? uid;
  String? name;
  String? email;
  String? creationTime;
  String? lastSignInTime;
  String? profileUrl;
  String? desc;
  String? updatedTime;
  List<ChatUser>? chats;

  UserModel({
    this.uid,
    this.name,
    this.email,
    this.creationTime,
    this.lastSignInTime,
    this.profileUrl,
    this.desc,
    this.updatedTime,
    this.chats,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    uid: json["uid"],
    name: json["name"],
    email: json["email"],
    creationTime: json["creationTime"],
    lastSignInTime: json["lastSignInTime"],
    profileUrl: json["profileUrl"],
    desc: json["desc"],
    updatedTime: json["updatedTime"],
    // chats: List<ChatUser>.from(json["chats"].map((x) => ChatUser.fromJson
    //  (x))),
  );

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "name": name,
    "email": email,
    "creationTime": creationTime,
    "lastSignInTime": lastSignInTime,
    "profileUrl": profileUrl,
    "desc": desc,
    "updatedTime": updatedTime,
   // "chats": List<dynamic>.from(chats!.map((x) => x.toJson())),
  };
}

class ChatUser {
  String? connection;
  String? chatId;
  String? lastTime;
  int? totalUnread;
  String? lastChat;

  ChatUser({
    this.connection,
    this.chatId,
    this.lastTime,
    this.totalUnread,
    this.lastChat
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) => ChatUser(
    connection: json["connection"],
    chatId: json["chatId"],
    lastTime: json["lastTime"],
    totalUnread: json["totalUnread"],
      lastChat : json["lastChat"]
  );

  Map<String, dynamic> toJson() => {
    "connection": connection,
    "chatId": chatId,
    "lastTime": lastTime,
    "totalUnread" : totalUnread,
    "lastChat" : lastChat
  };
}
