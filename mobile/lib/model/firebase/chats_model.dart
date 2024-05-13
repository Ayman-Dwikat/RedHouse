import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class Message {
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });

  // convert to a map
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
    };
  }
}

// To parse this JSON data, do
// final chats = chatsFromJson(jsonString);

Chats chatsFromJson(String str) => Chats.fromJson(json.decode(str));

String chatsToJson(Chats data) => json.encode(data.toJson());

class Chats {
  Chats({
    this.connections,
    this.chat,
  });

  List<String>? connections;
  List<Chat>? chat;

  factory Chats.fromJson(Map<String, dynamic> json) => Chats(
        connections: List<String>.from(json["connections"].map((x) => x)),
        chat: List<Chat>.from(json["chat"].map((x) => Chat.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "connections": List<dynamic>.from(connections!.map((x) => x)),
        "chat": List<dynamic>.from(chat!.map((x) => x.toJson())),
      };
}

class Chat {
  Chat({
    this.pengirim,
    this.penerima,
    this.pesan,
    this.time,
    this.isRead,
  });

  String? pengirim;
  String? penerima;
  String? pesan;
  String? time;
  bool? isRead;

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        pengirim: json["pengirim"],
        penerima: json["penerima"],
        pesan: json["pesan"],
        time: json["time"],
        isRead: json["isRead"],
      );

  Map<String, dynamic> toJson() => {
        "pengirim": pengirim,
        "penerima": penerima,
        "pesan": pesan,
        "time": time,
        "isRead": isRead,
      };
}
