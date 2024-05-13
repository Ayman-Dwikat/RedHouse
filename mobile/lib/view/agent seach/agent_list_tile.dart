import 'package:client/controller/static_api/static_controller.dart';
import 'package:client/model/user.dart';
import 'package:client/view/agent%20seach/agent_search_profile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class AgentListTile extends StatefulWidget {
  final User agent;

  const AgentListTile({Key? key, required this.agent}) : super(key: key);

  @override
  State<AgentListTile> createState() => _AgentListTileState();
}

class _AgentListTileState extends State<AgentListTile> {
  StaticController staticController = Get.put(StaticController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            bool agentExists = staticController.recentlySearchAgents
                .any((agent) => agent.id == widget.agent.id);

            if (!agentExists) {
              staticController.recentlySearchAgents.add(widget.agent);
            }

            setState(() {
              Get.to(() => AgentSearchProfile(agent: widget.agent));
            });
          },
          horizontalTitleGap: 15,
          leading: const Icon(FontAwesomeIcons.solidUser),
          title: Text(
            '${widget.agent.name}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            '${widget.agent.email}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Divider(height: 2, thickness: 1, color: Colors.grey[300]),
      ],
    );
  }
}
