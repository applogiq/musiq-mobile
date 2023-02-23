// To parse this JSON data, do
//
//     final paymentSuccessModel = paymentSuccessModelFromMap(jsonString);

import 'dart:convert';

PaymentSuccessModel paymentSuccessModelFromMap(String str) =>
    PaymentSuccessModel.fromMap(json.decode(str));

String paymentSuccessModelToMap(PaymentSuccessModel data) =>
    json.encode(data.toMap());

class PaymentSuccessModel {
  PaymentSuccessModel({
    required this.success,
    required this.message,
    required this.records,
  });

  final bool success;
  final String message;
  final Records records;

  factory PaymentSuccessModel.fromMap(Map<String, dynamic> json) =>
      PaymentSuccessModel(
        success: json["success"],
        message: json["message"],
        records: Records.fromMap(json["records"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "records": records.toMap(),
      };
}

class Records {
  Records({
    required this.razorpayOrderId,
    required this.paymentInfo,
    required this.premierStatus,
    required this.paymentPrice,
    required this.createdAt,
  });

  final String razorpayOrderId;
  final PaymentInfo paymentInfo;
  final String premierStatus;
  final int paymentPrice;
  final DateTime createdAt;

  factory Records.fromMap(Map<String, dynamic> json) => Records(
        razorpayOrderId: json["razorpay_order_id"],
        paymentInfo: PaymentInfo.fromMap(json["payment_info"]),
        premierStatus: json["premier_status"],
        paymentPrice: json["payment_price"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toMap() => {
        "razorpay_order_id": razorpayOrderId,
        "payment_info": paymentInfo.toMap(),
        "premier_status": premierStatus,
        "payment_price": paymentPrice,
        "created_at": createdAt.toIso8601String(),
      };
}

class PaymentInfo {
  PaymentInfo({
    required this.id,
    required this.entity,
    required this.amount,
    required this.amountPaid,
    required this.amountDue,
    required this.currency,
    required this.receipt,
    required this.offerId,
    required this.status,
    required this.attempts,
    required this.notes,
    required this.createdAt,
  });

  final String id;
  final String entity;
  final int amount;
  final int amountPaid;
  final int amountDue;
  final String currency;
  final String receipt;
  final dynamic offerId;
  final String status;
  final int attempts;
  final List<dynamic> notes;
  final int createdAt;

  factory PaymentInfo.fromMap(Map<String, dynamic> json) => PaymentInfo(
        id: json["id"],
        entity: json["entity"],
        amount: json["amount"],
        amountPaid: json["amount_paid"],
        amountDue: json["amount_due"],
        currency: json["currency"],
        receipt: json["receipt"],
        offerId: json["offer_id"],
        status: json["status"],
        attempts: json["attempts"],
        notes: List<dynamic>.from(json["notes"].map((x) => x)),
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "entity": entity,
        "amount": amount,
        "amount_paid": amountPaid,
        "amount_due": amountDue,
        "currency": currency,
        "receipt": receipt,
        "offer_id": offerId,
        "status": status,
        "attempts": attempts,
        "notes": List<dynamic>.from(notes.map((x) => x)),
        "created_at": createdAt,
      };
}
