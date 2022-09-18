// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'dart:convert';

Post postFromJson(String str) {
    final jsonData = json.decode(str);
    return Post.fromJson(jsonData);
}

String postToJson(Post data) {
    final dyn = data.toJson();
    return json.encode(dyn);
}

class Post {
    // final int userId;
    final int id;
    final String name;
    final String username;

    const Post({required this.id, required this.name, required this.username});

    factory Post.fromJson(Map<String, dynamic> json) {
        return Post(
          // userId: json["userId"],
          id: json["id"],
          name: json["name"],
          username: json["username"],
    );
    }

    Map<String, dynamic> toJson() => {
        // "userId": userId,
        "id": id,
        "name": name,
        "username": username,
    };
}