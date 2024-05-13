import 'package:client/controller/static_api/static_controller.dart';
import 'package:client/model/user.dart';
import 'package:client/view/lawyer%20seach/lawyer_search_profile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class LawyerListTile extends StatefulWidget {
  final User lawyer;

  const LawyerListTile({Key? key, required this.lawyer}) : super(key: key);

  @override
  State<LawyerListTile> createState() => _LawyerListTileState();
}

class _LawyerListTileState extends State<LawyerListTile> {
  StaticController staticController = Get.put(StaticController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            bool lawyerExists = staticController.recentlySearchLawyers
                .any((lawyer) => lawyer.id == widget.lawyer.id);

            if (!lawyerExists) {
              staticController.recentlySearchLawyers.add(widget.lawyer);
            }

            setState(() {
              Get.to(() => LawyerSearchProfile(lawyer: widget.lawyer));
            });
          },
          horizontalTitleGap: 15,
          leading: const Icon(FontAwesomeIcons.userGraduate),
          title: Text(
            '${widget.lawyer.name}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            '${widget.lawyer.email}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Divider(height: 2, thickness: 1, color: Colors.grey[300]),
      ],
    );
  }
}
