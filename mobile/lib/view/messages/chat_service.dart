import 'package:client/controller/users_auth/login_controller.dart';
import 'package:client/model/firebase/chats_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ChatService extends GetxController {
  LoginControllerImp loginController =
      Get.put(LoginControllerImp(), permanent: true);

  // instance of fireStore
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  // Callback to notify when a new message is sent
  Function()? onMessageSent;

  // SEND MESSAGE
  Future<void> sendMessage(String receiverId, String message) async {
    // get current user info
    final String currentUserId = loginController.userDto!["id"].toString();
    final String currentUserEmail = loginController.userDto!["email"];
    final Timestamp timestamp = Timestamp.now();

    // create a new message
    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
    );

    // construct chat room id from current user id and receiver id (sorted to ensure uniqueness)
    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    // add new message to database
    await _fireStore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .add(newMessage.toMap());

    // Notify the callback that a new message is sent
    if (onMessageSent != null) {
      onMessageSent!();
    }
  }

  // GET MESSAGES
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    // construct chat room id from current user id and receiver id (sorted to ensure uniqueness)
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _fireStore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
