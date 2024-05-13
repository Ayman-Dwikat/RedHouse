import 'package:client/controller/contract/contracts_controller.dart';
import 'package:client/controller/users_auth/login_controller.dart';
import 'package:client/main.dart';
import 'package:client/view/agent%20seach/agent_search.dart';
import 'package:client/view/auth/register.dart';
import 'package:client/view/contracts/all_contracts.dart';
import 'package:client/view/lawyer%20seach/lawyer_search.dart';
import 'package:client/view/messages/messages_page.dart';
import 'package:client/view/more/my_applications.dart';
import 'package:client/view/more/my_bookings.dart';
import 'package:client/view/more/my_offers.dart';
import 'package:client/view/more/my_properties.dart';
import 'package:client/view/more/profile/edit_profile.dart';
import 'package:client/view/more/profile/profile.dart';
import 'package:client/view/more/upgrade/account_upgrade.dart';
import 'package:client/view/more/user_level.dart';
import 'package:client/view/more/verification/account_verification.dart';
import 'package:client/view/more/complaint.dart';
import 'package:client/view/more/favorite_properties.dart';
import 'package:client/view/more/my_feedback.dart';
import 'package:client/view/more/verification/display_verification_status.dart';
import 'package:client/view/notification/notifications.dart';
import 'package:client/view/notification/notifications_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class More extends StatefulWidget {
  const More({Key? key}) : super(key: key);

  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {
  LoginControllerImp loginController = Get.put(LoginControllerImp());
  ContractsController contractController =
      Get.put(ContractsController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          // Here check visitor or No
          if (sharepref.getString("user") != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: InkWell(
                    onTap: () {
                      if (loginController.userDto != null) {
                        Get.to(() => const AccountInformation());
                      }
                    },
                    child: Text(loginController.userDto?["email"] ?? "",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        )),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    sharepref.remove("user");
                    print(loginController.userDto);
                    print(loginController.userDto);
                    Get.offAllNamed("/login");
                  },
                  child: const Text('Log out',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                      )),
                ),
              ],
            )
          else
            Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const SizedBox(height: 25),
                    const Text(
                      "Welcome",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 34,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: const Text(
                        "Login or sign up to save listings and get updates on your home search.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onPressed: () {
                        Get.toNamed("/login");
                      },
                      minWidth: 300,
                      height: 45,
                      color: Colors.black,
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const Register());
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "sign up",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ],
            ),

          // Line and Space
          const Divider(
            height: 1,
            color: Colors.black,
          ),
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Container(
              alignment: Alignment.centerLeft,
              height: 150,
              width: 150,
              child: Image.asset("assets/images/red-tree.png"),
            ),
          ),

          // Here settings list
          // Here settings list
          // Here settings list
          // Here settings list
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: const Text(
              "Settings",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(() => const EditProfile());
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
              child: const Text(
                "Profile",
                style: TextStyle(
                  color: Color.fromARGB(174, 0, 0, 0),
                  fontSize: 19,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(() => const NotificationsSettings());
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
              child: const Text(
                "Notifications",
                style: TextStyle(
                  color: Color.fromARGB(174, 0, 0, 0),
                  fontSize: 19,
                ),
              ),
            ),
          ),

          const SizedBox(height: 15),
          // Here account list
          // Here account list
          // Here account list
          // Here account list
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: const Text(
              "Account",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(() => const AccountInformation());
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
              child: const Text(
                "My account",
                style: TextStyle(
                  color: Color.fromARGB(174, 0, 0, 0),
                  fontSize: 19,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(() => const UserLevel());
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
              child: const Text(
                "Level",
                style: TextStyle(
                  color: Color.fromARGB(174, 0, 0, 0),
                  fontSize: 19,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(() => const DisplayVerificaionStatus());
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
              child: const Text(
                "Verification",
                style: TextStyle(
                  color: Color.fromARGB(174, 0, 0, 0),
                  fontSize: 19,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(() => const AccountUpgrade());
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
              child: const Text(
                "Upgrade",
                style: TextStyle(
                  color: Color.fromARGB(174, 0, 0, 0),
                  fontSize: 19,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(() => const MyFeedback());
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
              child: const Text(
                "Feedback",
                style: TextStyle(
                  color: Color.fromARGB(174, 0, 0, 0),
                  fontSize: 19,
                ),
              ),
            ),
          ),

          const SizedBox(height: 15),
          // Here Manange Properties list
          // Here Manange Properties list
          // Here Manange Properties list
          // Here Manange Properties list
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: const Text(
              "Manange Properties",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(() => const MyProperties());
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
              child: const Text(
                "Properties",
                style: TextStyle(
                  color: Color.fromARGB(174, 0, 0, 0),
                  fontSize: 19,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(() => const MyApplications());
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
              child: const Text(
                "Applications",
                style: TextStyle(
                  color: Color.fromARGB(174, 0, 0, 0),
                  fontSize: 19,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(() => const MyBookings());
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
              child: const Text(
                "Bookings",
                style: TextStyle(
                  color: Color.fromARGB(174, 0, 0, 0),
                  fontSize: 19,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(() => const MyOffers());
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
              child: const Text(
                "Offers",
                style: TextStyle(
                  color: Color.fromARGB(174, 0, 0, 0),
                  fontSize: 19,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(() => const AllContracts());
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
              child: const Text(
                "Contracts",
                style: TextStyle(
                  color: Color.fromARGB(174, 0, 0, 0),
                  fontSize: 19,
                ),
              ),
            ),
          ),

          const SizedBox(height: 15),
          // Here home list
          // Here home list
          // Here home list
          // Here home list
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: const Text(
              "My home",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(() => const Messages());
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
              child: const Text(
                "Messages",
                style: TextStyle(
                  color: Color.fromARGB(174, 0, 0, 0),
                  fontSize: 19,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(() => const Notifications());
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
              child: const Text(
                "Notifications",
                style: TextStyle(
                  color: Color.fromARGB(174, 0, 0, 0),
                  fontSize: 19,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(() => const FavoriteProperties());
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
              child: const Text(
                "Favorite properties",
                style: TextStyle(
                  color: Color.fromARGB(174, 0, 0, 0),
                  fontSize: 19,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(() => const Complaint());
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
              child: const Text(
                "Send complaint",
                style: TextStyle(
                  color: Color.fromARGB(174, 0, 0, 0),
                  fontSize: 19,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              showSearch(
                context: context,
                delegate: AgentSearch(),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
              child: const Text(
                "Search agent",
                style: TextStyle(
                  color: Color.fromARGB(174, 0, 0, 0),
                  fontSize: 19,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              contractController.visitLawyerFromContract = false;
              contractController.currentContract = null;
              showSearch(
                context: context,
                delegate: LawyerSearch(),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
              child: const Text(
                "ٍSearch lawyer",
                style: TextStyle(
                  color: Color.fromARGB(174, 0, 0, 0),
                  fontSize: 19,
                ),
              ),
            ),
          ),

          const SizedBox(height: 15),

          // here buying a home list
          // here buying a home list
          // here buying a home list
          // here buying a home list
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: const Text(
              "More",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 27,
              ),
            ),
          ),

          InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
              child: const Text(
                "Contact Us",
                style: TextStyle(
                  color: Color.fromARGB(174, 0, 0, 0),
                  fontSize: 19,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
              child: const Text(
                "About Us",
                style: TextStyle(
                  color: Color.fromARGB(174, 0, 0, 0),
                  fontSize: 19,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
              child: const Text(
                "Terms Us",
                style: TextStyle(
                  color: Color.fromARGB(174, 0, 0, 0),
                  fontSize: 19,
                ),
              ),
            ),
          ),

          // here the end
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("RedHouse.com® Version 23.24"),
                Text("all copyright © rights reserved"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
