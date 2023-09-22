// To parse this JSON data, do
//
//     final chats = chatsFromJson(jsonString);

import 'dart:convert';

ChatsModel chatsFromJson(String str) => ChatsModel.fromJson(json.decode(str));

String chatsToJson(ChatsModel data) => json.encode(data.toJson());

class ChatsModel {
  List<String>?connection;
  //List<Chat>? chat;

  ChatsModel({
    this.connection,
    //this.chat,
  });

  factory ChatsModel.fromJson(Map<String, dynamic> json) => ChatsModel(
    connection: List<String>.from(json["connection:"].map((x) => x)),
    //chat: List<Chat>.from(json["chat"].map((x) => Chat.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "connection:": List<dynamic>.from(connection!.map((x) => x)),
    //"chat": List<dynamic>.from(chat!.map((x) => x.toJson())),
  };
}

class Chat {
  String? send;
  List<String>? receive;
  String ?message;
  String? time;
  bool? isRead;

  Chat({
    this.send,
    this.receive,
    this.message,
    this.time,
    this.isRead,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
    send: json["send"],
    receive: List<String>.from(json["receive"].map((x) => x)),
    message: json["message"],
    time: json["time"],
    isRead: json["isRead: "],
  );

  Map<String, dynamic> toJson() => {
    "send": send,
    "receive": List<dynamic>.from(receive!.map((x) => x)),
    "message": message,
    "time": time,
    "isRead: ": isRead,
  };
}
