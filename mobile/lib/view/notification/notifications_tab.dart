import 'package:flutter/material.dart';

class NotificationsTab extends StatefulWidget {
  const NotificationsTab({Key? key}) : super(key: key);

  @override
  State<NotificationsTab> createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<NotificationsTab> {
  bool newListingChecked = true;
  bool priceChangeChecked = true;
  bool openHousesChecked = true;
  bool statusChangeChecked = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Notifications tab",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 30),
            const Text(
              "      Property updates",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: RichText(
                text: const TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text:
                          "You can change which homes you get alerted about in your ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    TextSpan(
                      text: "saved homes",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    TextSpan(
                      text: " and ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    TextSpan(
                      text: "saved searches",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            CheckboxListTile(
              title: const Text(
                "New listings",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                ),
              ),
              value: newListingChecked,
              onChanged: (value) {
                setState(() {
                  newListingChecked = value!;
                });
              },
              activeColor: Colors.green, // Color when selected
            ),
            CheckboxListTile(
              title: const Text(
                "Price changes",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                ),
              ),
              value: priceChangeChecked,
              onChanged: (value) {
                setState(() {
                  priceChangeChecked = value!;
                });
              },
              activeColor: Colors.green,
            ),
            CheckboxListTile(
              title: const Text(
                "Open houses",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                ),
              ),
              value: openHousesChecked,
              onChanged: (value) {
                setState(() {
                  openHousesChecked = value!;
                });
              },
              activeColor: Colors.green,
            ),
            CheckboxListTile(
              title: const Text(
                "Status changes",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                ),
              ),
              value: statusChangeChecked,
              onChanged: (value) {
                setState(() {
                  statusChangeChecked = value!;
                });
              },
              activeColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
