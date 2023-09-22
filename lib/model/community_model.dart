// To parse this JSON data, do
//
//     final communityModel = communityModelFromJson(jsonString);

import 'dart:convert';

CommunityModel communityModelFromJson(String str) => CommunityModel.fromJson(json.decode(str));

String communityModelToJson(CommunityModel data) => json.encode(data.toJson());

class CommunityModel {
    String title;
    String writer;
    String time;
    String text;
    List<dynamic> photoList;
    int like;
    int viewCount;
    String category;
    List<Comment> comment;

    CommunityModel({
        required this.title,
        required this.writer,
        required this.time,
        required this.text,
        required this.photoList,
        required this.like,
        required this.viewCount,
        required this.category,
        required this.comment,
    });

    factory CommunityModel.fromJson(Map<String, dynamic> json) => CommunityModel(
        title: json["title"],
        writer: json["writer"],
        time: json["time"],
        text: json["text"],
        photoList: List<dynamic>.from(json["photoList"].map((x) => x)),
        like: json["like"],
        viewCount: json["viewCount"],
        category: json["category"],
        comment: List<Comment>.from(json["comment"].map((x) => Comment.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "writer": writer,
        "time": time,
        "text": text,
        "photoList": List<dynamic>.from(photoList.map((x) => x)),
        "like": like,
        "viewCount": viewCount,
        "category": category,
        "comment": List<dynamic>.from(comment.map((x) => x.toJson())),
    };
}

class Comment {
    String writer;
    String text;
    String tile;

    Comment({
        required this.writer,
        required this.text,
        required this.tile,
    });

    factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        writer: json["writer"],
        text: json["text"],
        tile: json["tile"],
    );

    Map<String, dynamic> toJson() => {
        "writer": writer,
        "text": text,
        "tile": tile,
    };
}
