import 'package:client/model/contract.dart';
import 'package:json_annotation/json_annotation.dart';

part "user_history.g.dart";

@JsonSerializable()
class UserHistory {
  int id;

  int contractId;
  Contract contract;

  String? feedbackToLandlord;
  String? feedbackToCustomer;

  int? customerRating;
  int? landlordRating;

  String helpful = "";

  UserHistory({
    required this.id,
    required this.contractId,
    required this.feedbackToLandlord,
    required this.feedbackToCustomer,
    required this.customerRating,
    required this.landlordRating,
    required this.contract,
    // required this.user,
  });

  factory UserHistory.fromJson(Map<String, dynamic> json) =>
      _$UserHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$UserHistoryToJson(this);
}
