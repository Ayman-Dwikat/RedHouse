import 'package:client/controller/map_list/map_list_controller.dart';
import 'package:client/controller/static_api/static_controller.dart';
import 'package:client/model/property.dart';
import 'package:client/view/home_information/home_information.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PropertyListTile extends StatefulWidget {
  final Property property;

  const PropertyListTile({Key? key, required this.property}) : super(key: key);

  @override
  State<PropertyListTile> createState() => _PropertyListTileState();
}

class _PropertyListTileState extends State<PropertyListTile> {
  MapListController mapListController = Get.put(MapListController());
  StaticController staticController = Get.put(StaticController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            setState(() {
              Get.to(() => HomeInformation(property: widget.property));
            });
          },
          horizontalTitleGap: 10,
          leading: const Icon(Icons.home),
          title: Text(
            '${widget.property.location!.country}, ${widget.property.location!.city}, ${widget.property.location!.streetAddress}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Divider(height: 2, thickness: 1, color: Colors.grey[300]),
      ],
    );
  }
}
