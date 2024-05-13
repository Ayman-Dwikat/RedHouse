import 'package:client/controller/users_auth/login_controller.dart';
import 'package:client/model/application.dart';
import 'package:client/view/messages/chat_service.dart';
import 'package:client/view/more/complaint.dart';
import 'package:client/view/manage_properties/offers/create_offer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final Function onMessageSent;
  final String receiverUserEmail;
  final String receiverUserID;
  final Application? application;

  const ChatPage(
      {super.key,
      required this.receiverUserEmail,
      required this.receiverUserID,
      required this.onMessageSent,
      this.application});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  LoginControllerImp loginController =
      Get.put(LoginControllerImp(), permanent: true);
  String initialMessage = "Now you can communicate with each other.";

  // instance of fireStore
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  String currentUserId = "";
  String receiverUserId = "";
  List<String> ids = [];
  String chatRoomId = "";

  @override
  void initState() {
    super.initState();
    currentUserId = loginController.userDto!["id"].toString();
    receiverUserId = widget.receiverUserID;
    ids = [currentUserId, receiverUserId];
    ids.sort();
    chatRoomId = ids.join("_");
    print(widget.application);

    // Add the following line to update the 'SeeMessage' value to true
    _trueSeeMessageValue();
  }

  Future<void> _trueSeeMessageValue() async {
    // Check if the document exists before updating
    bool documentExists = await _fireStore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .get()
        .then((doc) => doc.exists);

    if (documentExists) {
      // Update the 'SeeMessage' value to true in the Firestore database
      await _fireStore.collection("chat_rooms").doc(chatRoomId).update({
        "$currentUserId SeeMessage": true,
      });

      // Call the callback function to notify the parent widget
      widget.onMessageSent();
    }
  }

  Future<void> _falseSeeMessageValue() async {
    // Check if the document exists before updating
    bool documentExists = await _fireStore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .get()
        .then((doc) => doc.exists);

    if (documentExists) {
      // Update the 'SeeMessage' value to false in the Firestore database
      await _fireStore.collection("chat_rooms").doc(chatRoomId).update({
        "$receiverUserId SeeMessage": false,
      });
    }
  }

  String formatMessageTimestamp(Timestamp timestamp) {
    DateTime now = DateTime.now();
    DateTime messageTime = timestamp.toDate();
    Duration difference = now.difference(messageTime);

    // Format: Hour:Minute AM/PM
    if (difference.inHours < 24) {
      return DateFormat.jm().format(messageTime);
    }
    // Yesterday
    else if (difference.inHours < 48) {
      return 'Yesterday';
    }
    // Format: FullMonthName Day
    else {
      return DateFormat('MMM dd', 'en_US').format(messageTime);
    }
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(receiverUserId, _messageController.text);

      // Add the following line to update the 'SeeMessage' value to false
      _falseSeeMessageValue();

      // Call the callback function to notify the parent widget
      widget.onMessageSent();

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.receiverUserEmail,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (widget.application != null)
            PopupMenuButton(
              onSelected: (value) {
                print(value);
                switch (value) {
                  case "Send complaint":
                    Get.to(const Complaint());
                    break;
                  case "Create offer":
                    Get.to(
                      () => CreateOffer(
                        landlordId: widget.application!.property.userId,
                        customerId: widget.application!.userId,
                        property: widget.application!.property,
                      ),
                    );
                    break;
                  case "Send complaint":
                    Get.to(const Complaint());
                    break;
                }
              },
              itemBuilder: (context) => [
                // If the landlord and this application does not have a offer, show "Create offer"
                // if (currentUserId ==
                //     widget.application.property.userId.toString())
                const PopupMenuItem(
                  value: "Create offer",
                  child: Text("Create offer"),
                ),

                // If this appliaction has offer, show "See offer"
                // if (true)
                const PopupMenuItem(
                  value: "See offer",
                  child: Text("See offer"),
                ),

                const PopupMenuItem(
                  value: "See offer",
                  child: Text("See contract"),
                ),

                const PopupMenuItem(
                  value: "Send complaint",
                  child: Text("Send complaint"),
                ),
              ],
            ),
        ],
      ),
      body: Column(
        children: [
          // Display messages
          Expanded(
            child: _bulidMessageList(),
          ),

          // Display user input
          _bulidMessageInput(),
        ],
      ),
    );
  }

// build message list
  Widget _bulidMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(currentUserId, receiverUserId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Reverse the order of items in the list
        List<DocumentSnapshot> reversedList =
            List.from(snapshot.data!.docs.reversed);

        return ListView(
          reverse: true, // Reverse the order of items in the list
          children: reversedList
              .map((document) => _bulidMessageItem(document))
              .toList(),
        );
      },
    );
  }

  // build message item
  Widget _bulidMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    bool isMe = data['senderId'] == currentUserId.toString();

    // The message is the initial message
    if (data['message'] == initialMessage) {
      return Container(
        padding:
            const EdgeInsets.only(bottom: 40, top: 40, right: 50, left: 50),
        child: Column(
          children: [
            Text(
              formatMessageTimestamp(data['timestamp']),
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[500],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              data['message'],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }
    // The message is from a user
    else {
      return Container(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Padding(
          padding: isMe
              ? const EdgeInsets.only(top: 8, bottom: 10, right: 10, left: 60)
              : const EdgeInsets.only(top: 8, bottom: 10, left: 10, right: 60),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Material(
                elevation: 5,
                borderRadius: isMe
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      )
                    : const BorderRadius.only(
                        topRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                color: isMe ? Colors.blue[900] : Colors.white,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text(
                    data['message'],
                    style: TextStyle(
                      fontSize: 15,
                      color: isMe ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              isMe
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(Icons.done_all,
                            color: Colors.blue, size: 21),
                        const SizedBox(width: 5),
                        Text(
                          formatMessageTimestamp(data['timestamp']),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.orange[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      formatMessageTimestamp(data['timestamp']),
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ],
          ),
        ),
      );
    }
  }

  // build message input
  Widget _bulidMessageInput() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
              color: Colors.orange[700]!,
              width: 2,
            )),
          ),
        ),
        Row(
          children: [
            // textfiled
            Expanded(
                child: TextField(
              controller: _messageController,
              obscureText: false,
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12),
                ),
                hintText: "Write your message here...",
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 5, horizontal: 13),
              ),
            )),

            // send button
            IconButton(
                onPressed: sendMessage,
                icon: Icon(
                  Icons.send,
                  size: 25,
                  color: Colors.orange[700],
                ))
          ],
        ),
      ],
    );
  }
}
