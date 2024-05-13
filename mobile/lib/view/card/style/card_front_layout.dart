import 'package:client/model/application.dart';
import 'package:client/model/booking.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:client/model/offer.dart';

class CardFrontLayout {
  final Offer? offer;
  final Application? application;
  final Booking? booking;
  int index;
  String name;
  Color textColor;

  CardFrontLayout({
    this.offer,
    this.application,
    this.booking,
    required this.index,
    required this.name,
    required this.textColor,
  });

  Widget layout1() {
    return StreamBuilder<int>(
      stream: Stream.periodic(const Duration(seconds: 1), (i) => i),
      builder: (context, snapshot) {
        DateTime now = DateTime.now();
        DateTime offerExpires = offer!.offerExpires;

        Duration remainingTime = offerExpires.difference(now);
        Duration endedTime = now.difference(offerExpires);

        int reDays = remainingTime.inDays;
        int reHours = remainingTime.inHours % 24;
        int reMinutes = remainingTime.inMinutes % 60;
        int reSeconds = remainingTime.inSeconds % 60;

        int enDays = endedTime.inDays;
        int enHours = endedTime.inHours % 24;
        int enMinutes = endedTime.inMinutes % 60;
        int enSeconds = endedTime.inSeconds % 60;

        String offerON() {
          if (reDays == 0) {
            return '${reHours.toString().padLeft(2, '0')}:${reMinutes.toString().padLeft(2, '0')}:${reSeconds.toString().padLeft(2, '0')}';
          } else {
            return '$reDays day${reDays > 1 ? 's' : ''}  ${reHours.toString().padLeft(2, '0')}:${reMinutes.toString().padLeft(2, '0')}:${reSeconds.toString().padLeft(2, '0')}';
          }
        }

        String offerOFF() {
          if (reDays == -1) {
            return 'The offer ended ${enHours.toString().padLeft(2, '0')}:${enMinutes.toString().padLeft(2, '0')}:${enSeconds.toString().padLeft(2, '0')} ago';
          } else {
            return 'The offer ended $enDays day${enDays > 1 ? 's' : ''} ago';
          }
        }

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 106, 85, 207),
                Color.fromARGB(255, 122, 104, 214),
                Color.fromARGB(255, 131, 120, 191),
                Color.fromARGB(255, 219, 194, 122),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      FontAwesomeIcons.chessKing,
                      size: 25,
                      color: Colors.white,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 50),
                      child: Text(
                        "Offer ${index + 1}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      (DateTime.now().year == offer!.offerDate.year)
                          ? DateFormat('MM-dd').format(offer!.offerDate)
                          : DateFormat('yyyy-MM-dd').format(offer!.offerDate),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            (offer!.description.length <= 60)
                                ? offer!.description
                                : '${offer!.description.substring(0, 60)}...',
                            style: TextStyle(
                              package: 'awesome_card',
                              color: textColor,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'MavenPro',
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(height: 15),
                          // here i want count down the days, hours, minutes, and seconds
                          Text(
                            reDays >= 0 ? offerON() : offerOFF(),
                            style: TextStyle(
                              package: 'awesome_card',
                              color: textColor,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'MavenPro',
                              fontSize: 17,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                name,
                                style: TextStyle(
                                  package: 'awesome_card',
                                  color: textColor,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'MavenPro',
                                  fontSize: 17,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                offer!.offerStatus,
                                style: TextStyle(
                                  package: 'awesome_card',
                                  color: textColor,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'MavenPro',
                                  fontSize: 17,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ]),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget layout2() {
    String applicationType() {
      if (application!.property.listingType == "For daily rent") {
        return "Application to book";
      } else if (application!.property.listingType == "For sell") {
        return "Application to buy";
      } else {
        return "Application to rent";
      }
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black,
            Colors.blue[800]!,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  FontAwesomeIcons.fileCode,
                  size: 25,
                  color: Colors.white,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 50),
                  child: Text(
                    "Application ${index + 1}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  (DateTime.now().year == application!.applicationDate.year)
                      ? DateFormat('MM-dd').format(application!.applicationDate)
                      : DateFormat('yyyy-MM-dd')
                          .format(application!.applicationDate),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        (application!.message.length <= 60)
                            ? application!.message
                            : '${application!.message.substring(0, 60)}...',
                        style: TextStyle(
                          package: 'awesome_card',
                          color: textColor,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'MavenPro',
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        applicationType(),
                        style: TextStyle(
                          package: 'awesome_card',
                          color: textColor,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'MavenPro',
                          fontSize: 17,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            name,
                            style: TextStyle(
                              package: 'awesome_card',
                              color: textColor,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'MavenPro',
                              fontSize: 17,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            application!.applicationStatus,
                            style: TextStyle(
                              package: 'awesome_card',
                              color: textColor,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'MavenPro',
                              fontSize: 17,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget layout3() {
    String divideCodeIntoGroups(String code) {
      final RegExp pattern = RegExp(r".{1,3}");
      Iterable<Match> matches = pattern.allMatches(code);
      List<String> groups = matches.map((match) => match.group(0)!).toList();
      return groups.join(" ");
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 73, 71, 71),
            Color.fromARGB(255, 61, 59, 59),
            Colors.white10,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  FontAwesomeIcons.penToSquare,
                  size: 25,
                  color: Colors.white,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 50),
                  child: Text(
                    "Booking ${index + 1}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  (DateTime.now().year == booking!.bookingDate.year)
                      ? DateFormat('MM-dd').format(booking!.bookingDate)
                      : DateFormat('yyyy-MM-dd').format(booking!.bookingDate),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Property Code",
                        style: TextStyle(
                          package: 'awesome_card',
                          color: textColor,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'MavenPro',
                          fontSize: 17,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        divideCodeIntoGroups(booking!.property!.propertyCode),
                        style: TextStyle(
                          package: 'awesome_card',
                          color: textColor,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'MavenPro',
                          fontSize: 17.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            name,
                            style: TextStyle(
                              package: 'awesome_card',
                              color: textColor,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'MavenPro',
                              fontSize: 17,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            booking!.bookingStatus,
                            style: TextStyle(
                              package: 'awesome_card',
                              color: textColor,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'MavenPro',
                              fontSize: 17,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
