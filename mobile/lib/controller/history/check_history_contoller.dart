import 'package:client/model/user_history.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckHistoryController extends GetxController {
  double averageRating = 0;
  double sumRating = 0;
  int oneCount = 0;
  int twoCount = 0;
  int threeCount = 0;
  int fourCount = 0;
  int fiveCount = 0;

  void calHistoryBars(List<UserHistory> listHistories) {
    oneCount = 0;
    twoCount = 0;
    threeCount = 0;
    fourCount = 0;
    fiveCount = 0;

    for (UserHistory history in listHistories) {
      if (history.landlordRating == 1 || history.customerRating == 1) {
        if (history.landlordRating == 1 && history.customerRating == 1) {
          oneCount += 2;
        } else {
          oneCount++;
        }
      }
      if (history.landlordRating == 2 || history.customerRating == 2) {
        if (history.landlordRating == 2 && history.customerRating == 2) {
          twoCount += 2;
        } else {
          twoCount++;
        }
      }
      if (history.landlordRating == 3 || history.customerRating == 3) {
        if (history.landlordRating == 3 && history.customerRating == 3) {
          threeCount += 2;
        } else {
          threeCount++;
        }
      }
      if (history.landlordRating == 4 || history.customerRating == 4) {
        if (history.landlordRating == 4 && history.customerRating == 4) {
          fourCount += 2;
        } else {
          fourCount++;
        }
      }
      if (history.landlordRating == 5 || history.customerRating == 5) {
        if (history.landlordRating == 5 && history.customerRating == 5) {
          fiveCount += 2;
        } else {
          fiveCount++;
        }
      }
    }

    print(oneCount);
    print(twoCount);
    print(threeCount);
    print(fourCount);
    print(fiveCount);
  }

  void calAverageRating(List<UserHistory> listHistories) {
    sumRating = 0;

    for (UserHistory history in listHistories) {
      sumRating += (history.landlordRating! + history.customerRating!) / 2;
      print(
          "================================================================================================================");
      print(sumRating);
    }

    averageRating = sumRating / listHistories.length;
    print(averageRating);
  }
}

class LineWithIconText extends StatelessWidget {
  final IconData icon;
  final String text;

  LineWithIconText(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            text,
            softWrap: true,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13.5),
          ),
        ),
      ],
    );
  }
}

Widget buildRatingRow(int rating, int count, int totalCount) {
  double percentage = (count / totalCount);

  return SizedBox(
    child: Row(
      children: [
        SizedBox(
          width: 20,
          child: Text('$rating   ',
              style: const TextStyle(fontWeight: FontWeight.w500)),
        ),
        Container(
          width: 180,
          height: 10,
          child: LinearProgressIndicator(
            borderRadius: BorderRadius.circular(100),
            value: percentage,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.black87),
            backgroundColor: Colors.grey,
          ),
        ),
        // Text(' $percentage%'),
      ],
    ),
  );
}
