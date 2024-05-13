import 'package:client/model/milestone.dart';
import 'package:client/model/offer.dart';
import 'package:client/model/user.dart';
import 'package:json_annotation/json_annotation.dart';
part "contract.g.dart";

@JsonSerializable()
class Contract {
  int id;
  int offerId;
  DateTime startDate;
  DateTime? endDate;
  String contractType;
  String contractStatus;
  double earnings;
  int isShouldPay;
  Offer? offer;
  List<Milestone>? milestones;
  int? lawyerId;
  User? lawyer;

  Contract({
    required this.id,
    required this.offerId,
    required this.startDate,
    this.endDate,
    required this.contractType,
    required this.contractStatus,
    required this.earnings,
    required this.isShouldPay,
    this.offer,
    this.milestones,
    this.lawyerId,
    this.lawyer,
  });

  factory Contract.fromJson(Map<String, dynamic> json) =>
      _$ContractFromJson(json);
  Map<String, dynamic> toJson() => _$ContractToJson(this);
}
