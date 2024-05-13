import 'package:client/controller/contract/contracts_controller.dart';
import 'package:client/controller/static_api/static_controller.dart';
import 'package:client/controller/users_auth/login_controller.dart';
import 'package:client/model/user.dart';
import 'package:client/view/more/profile/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

class LawyerSearchProfile extends StatefulWidget {
  final User lawyer;
  const LawyerSearchProfile({super.key, required this.lawyer});

  @override
  State<LawyerSearchProfile> createState() => _LawyerSearchProfileState();
}

class _LawyerSearchProfileState extends State<LawyerSearchProfile>
    with AutomaticKeepAliveClientMixin {
  LoginControllerImp loginController = Get.put(LoginControllerImp());
  ContractsController controller =
      Get.put(ContractsController(), permanent: true);
  StaticController staticController = Get.put(StaticController());
  bool isFollowed = false;

  @override
  bool get wantKeepAlive => true; // Keep the state alive

  @override
  void initState() {
    super.initState();
    print(widget.lawyer);
    print(controller.currentContract);
    if (controller.currentContract != null) {
      if (controller.currentContract!.lawyer != null) {
        if (controller.currentContract!.lawyer!.id == widget.lawyer.id) {
          isFollowed = true;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return VisibilityDetector(
      key: const Key('LawyerSearchProfile'),
      onVisibilityChanged: (info) {
        if (controller.currentContract != null) {
          if (controller.currentContract!.lawyer != null) {
            if (controller.currentContract!.lawyer!.id == widget.lawyer.id) {
              isFollowed = true;
            }
          }
        }

        if (mounted) {
          setState(() {});
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              FontAwesomeIcons.angleLeft,
            ),
          ),
          title: const Text(
            "Profile",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF001BFF).withOpacity(0.65),
                  ),
                  child: Center(
                    child: Text(
                      loginController.getShortenedName(widget.lawyer.name),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 38,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.lawyer.name!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  widget.lawyer.email!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 20),
                if (controller.visitLawyerFromContract &&
                    controller.currentContract != null)
                  GestureDetector(
                    onTap: () async {
                      print(controller.currentContract!.id);
                      print(widget.lawyer);

                      bool lawyerExists = staticController.recentlySelectLawyers
                          .any((lawyer) => lawyer.id == widget.lawyer.id);

                      if (!lawyerExists) {
                        staticController.recentlySelectLawyers
                            .add(widget.lawyer);
                      }

                      setState(() {
                        isFollowed = !isFollowed;
                      });
                      if (isFollowed) {
                        await controller.addLawyerToContract(
                            controller.currentContract!.id, widget.lawyer.id!);
                        controller.currentContract!.lawyerId =
                            widget.lawyer.id!;
                        controller.currentContract!.lawyer = widget.lawyer;
                      } else {
                        await controller.addLawyerToContract(
                            controller.currentContract!.id, 0);
                        controller.currentContract!.lawyerId = null;
                        controller.currentContract!.lawyer = null;
                      }
                    },
                    child: Container(
                      width: 140,
                      height: 38,
                      decoration: BoxDecoration(
                        color: isFollowed ? Colors.grey[300] : Colors.blue,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isFollowed) const SizedBox(width: 10),
                          Text(
                            isFollowed ? "Added" : "Add",
                            style: TextStyle(
                              fontSize: 16,
                              color: isFollowed ? Colors.black : Colors.white,
                            ),
                          ),
                          if (isFollowed)
                            const Icon(
                              Icons.keyboard_arrow_down_sharp,
                              color: Colors.black,
                            ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 30),
                Divider(color: Colors.grey[300]),
                const SizedBox(height: 10),

                // MENU
                ProfileMenuWidget(
                  title: 'Setting',
                  icon: FontAwesomeIcons.cog,
                  onPress: () {},
                ),
                ProfileMenuWidget(
                    title: 'Report',
                    icon: FontAwesomeIcons.share,
                    sizeIcon: 22,
                    onPress: () {}),
                ProfileMenuWidget(
                    title: 'Information',
                    icon: FontAwesomeIcons.info,
                    sizeIcon: 22,
                    onPress: () {}),
                Divider(color: Colors.grey[300]),
                const SizedBox(height: 10),
                ProfileMenuWidget(
                    title: 'Feedback',
                    icon: Icons.feedback,
                    textColor: Colors.red[700],
                    sizeIcon: 24,
                    onPress: () {
                      // Get.to(() => const MyFeedback());
                    }),
                ProfileMenuWidget(
                    title: 'Contracts',
                    icon: FontAwesomeIcons.handshake,
                    textColor: Colors.red[700],
                    sizeIcon: 21,
                    onPress: () {
                      // Get.to(() => const MyFeedback());
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (controller.currentContract != null) {
      if (controller.currentContract!.lawyer != null) {
        if (controller.currentContract!.lawyer!.id == widget.lawyer.id) {
          isFollowed = true;
        }
      }
    }
    super.dispose();
  }
}

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
    this.sizeIcon = 23,
  });

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;
  final double sizeIcon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: const Color(0xFF001BFF).withOpacity(0.1),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF001BFF).withOpacity(0.6),
          size: sizeIcon,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 17.5,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      trailing: endIcon
          ? Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: const Icon(
                FontAwesomeIcons.angleRight,
                size: 18,
                color: Colors.grey,
              ),
            )
          : null,
    );
  }
}
