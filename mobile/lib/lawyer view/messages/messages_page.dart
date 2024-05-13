import 'dart:convert';
import 'package:client/controller/application/applications_controller.dart';
import 'package:client/controller/history/history_controller.dart';
import 'package:client/controller/users_auth/login_controller.dart';
import 'package:client/controller/users_auth/signup_controller.dart';
import 'package:client/main.dart';
import 'package:client/model/application.dart';
import 'package:client/model/firebase/chats_model.dart';
import 'package:client/view/messages/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class LawyerMessges extends StatefulWidget {
  const LawyerMessges({super.key});

  @override
  State<LawyerMessges> createState() => _MessagesState();
}

class _MessagesState extends State<LawyerMessges> {
  bool isLoading = true;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  LoginControllerImp loginController = Get.put(LoginControllerImp());
  SignUpControllerImp signUpController =
      Get.put(SignUpControllerImp(), permanent: true);
  Map<String, dynamic> userDto = json.decode(sharepref.getString("user")!);

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Map<String, String> lastMessageTextMap = {};
  Map<String, Timestamp> lastMessageTimeMap = {};
  Map<String, bool> isUnreadMap = {};
  Map<String, Application> approvedApplications = {};

  String currentUserId = "";
  String currentUserEmail = "";

  @override
  void initState() {
    super.initState();
    currentUserId = loginController.userDto!["id"].toString();
    var email = loginController.userDto!["email"];
    if (email == null) return;
    currentUserEmail = email;
    loadData();
    setState(() {});
  }

  Future<void> loadData() async {
    if (!isLoading) {
      return;
    }

    await signUpController.getlawyerContacts(loginController.userDto?["id"]);

    if (mounted) {
      setState(() {
        isLoading = false;
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
    // Within the same week
    else if (difference.inDays < 7 && now.weekday != messageTime.weekday) {
      return DateFormat('EEEE', 'en_US').format(messageTime);
    }
    // Format: ShortMonthName Day
    else {
      return DateFormat('MMM dd', 'en_US').format(messageTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center();
    }

    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: FloatingActionButton(
        heroTag: "messagebtn",
        backgroundColor: Colors.orange[700],
        foregroundColor: Colors.white,
        onPressed: () {},
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        child: const Icon(
          FontAwesomeIcons.phone,
          size: 23,
        ),
      ),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Messages",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        elevation: 0,
        shape: null,
        child: Container(
          padding: const EdgeInsets.all(15),
          child: ListView(
            children: [
              Row(
                children: [
                  Container(
                    width: 55,
                    height: 55,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(0, 153, 115, 1),
                    ),
                    child: Center(
                      child: Text(
                        loginController.getShortenedName(userDto["name"] ?? ""),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: ListTile(
                    title: Text(userDto["name"]),
                    subtitle: Text(
                      userDto["email"],
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ))
                ],
              ),
              const SizedBox(height: 5),
              const Divider(),
              const SizedBox(height: 8),
              const ListTile(
                title: Text(
                  "Home page",
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
                leading: Icon(
                  FontAwesomeIcons.home,
                  size: 20,
                ),
              ),
              const ListTile(
                title: Text(
                  "Upload shot",
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
                leading: Icon(
                  FontAwesomeIcons.upload,
                  size: 20,
                ),
              ),
              const ListTile(
                title: Text(
                  "Favourites",
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
                leading: Icon(
                  FontAwesomeIcons.solidHeart,
                  size: 20,
                ),
              ),
              const ListTile(
                title: Text(
                  "Calls",
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
                leading: Icon(
                  FontAwesomeIcons.phone,
                  size: 20,
                ),
              ),
              const ListTile(
                title: Text(
                  "Saved Messages",
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
                leading: Icon(
                  FontAwesomeIcons.solidBookmark,
                  size: 20,
                ),
              ),
              const ListTile(
                title: Text(
                  "Settings",
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
                leading: Icon(
                  FontAwesomeIcons.gear,
                  size: 20,
                ),
              ),
              const ListTile(
                title: Text(
                  "Back",
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
                leading: Icon(
                  FontAwesomeIcons.chevronLeft,
                  size: 21,
                ),
              ),
            ],
          ),
        ),
      ),
      body: signUpController.lawyerContacts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/chat.svg',
                    width: 200,
                    height: 200,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Oops! No chat found",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          : _buildUserList(onMessageSent: () {
              if (mounted) {
                setState(() {});
              }
            }),
    );
  }

  Widget _buildUserList({required Function onMessageSent}) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("error");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center();
        }

        // Filter users based on the condition
        List<DocumentSnapshot> filteredUsers = snapshot.data!.docs.where((doc) {
          Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
          return data['email'] != currentUserEmail &&
              signUpController.lawyerContacts
                  .any((user) => user.email == data['email']);
        }).toList();

        return ListView.builder(
          itemCount: filteredUsers.length,
          itemBuilder: (context, index) {
            return _buildUserItem(filteredUsers[index], onMessageSent);
          },
        );
      },
    );
  }

  Widget _buildUserItem(DocumentSnapshot document, Function onMessageSent) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    String receiverUserId = data['uid'];
    List<String> ids = [currentUserId, receiverUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return FutureBuilder(
      future: _createChatRoomDocument(
          chatRoomId, currentUserId, currentUserEmail, receiverUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return _buildUserListItem(chatRoomId, data, onMessageSent);
        } else {
          return shimmer(data);
        }
      },
    );
  }

  Widget _buildUserListItem(
      String chatRoomId, Map<String, dynamic> data, Function onMessageSent) {
    String lastMessageText = lastMessageTextMap[chatRoomId] ?? "";
    Timestamp lastMessageTime =
        lastMessageTimeMap[chatRoomId] ?? Timestamp.now();

    bool isUnread = isUnreadMap[chatRoomId] ?? false;

    return Container(
      height: 85,
      child: ListTile(
        title: Row(
          children: [
            const SizedBox(width: 10),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.orange[700],
              ),
              child: Center(
                child: Text(
                  loginController.getShortenedName(data['name']),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                title: Text(
                  data['name'],
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.5,
                    color: Colors.orange[700],
                  ),
                ),
                subtitle: Row(
                  children: [
                    Text(
                      lastMessageText.length > 18
                          ? "${lastMessageText.substring(0, 18)}..."
                          : lastMessageText,
                      style: TextStyle(
                        fontSize: isUnread ? 13 : 14.5,
                        fontWeight:
                            isUnread ? FontWeight.w500 : FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Text(
              formatMessageTimestamp(lastMessageTime),
              style: TextStyle(
                fontSize: isUnread ? 13 : 14.5,
                fontWeight: isUnread ? FontWeight.w500 : FontWeight.bold,
              ),
            ),
          ],
        ),
        onTap: () {
          Get.to(() => ChatPage(
                receiverUserEmail: data['name'],
                receiverUserID: data['uid'],
                onMessageSent: onMessageSent,
              ));
        },
      ),
    );
  }

  Future<void> _createChatRoomDocument(String chatRoomId, String currentUserId,
      String currentUserEmail, String receiverUserId) async {
    try {
      QuerySnapshot messagesSnapshot = await _fireStore
          .collection("chat_rooms")
          .doc(chatRoomId)
          .collection("messages")
          .get();

      if (messagesSnapshot.docs.isEmpty) {
        // No message between them, send welcome message
        Message newMessage = Message(
          senderId: currentUserId,
          senderEmail: currentUserEmail,
          receiverId: receiverUserId,
          message: "Now you can communicate with each other.",
          timestamp: Timestamp.now(),
        );

        await _fireStore
            .collection("chat_rooms")
            .doc(chatRoomId)
            .collection("messages")
            .add(newMessage.toMap());

        await _fireStore.collection("chat_rooms").doc(chatRoomId).set({
          "$currentUserId SeeMessage": false,
          "$receiverUserId SeeMessage": false,
        });
      }

      messagesSnapshot = await _fireStore
          .collection("chat_rooms")
          .doc(chatRoomId)
          .collection("messages")
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (messagesSnapshot.docs.isNotEmpty) {
        // Check read message for each user separately
        isUnreadMap[chatRoomId] = await _fireStore
            .collection("chat_rooms")
            .doc(chatRoomId)
            .get()
            .then(
              (doc) => doc.data()?["$currentUserId SeeMessage"],
            );

        // Update the maps for each user separately
        DocumentSnapshot lastMessage = messagesSnapshot.docs.first;
        lastMessageTextMap[chatRoomId] = lastMessage.get("message");
        lastMessageTimeMap[chatRoomId] = lastMessage.get("timestamp");
      } else {
      }
    } catch (error) {
    }
  }

  Widget shimmer(Map<String, dynamic> data) {
    return Center(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 75,
          child: ListTile(
            title: Row(
              children: [
                const SizedBox(width: 10),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.yellow[900],
                  ),
                  child: Center(
                    child: Text(
                      loginController.getShortenedName(data['name']),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text(
                      data['email'],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.yellow[900],
                      ),
                    ),
                    subtitle: const Row(
                      children: [
                        Text(
                          "Now you can communicate",
                          style: TextStyle(
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "11:55 PM",
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
