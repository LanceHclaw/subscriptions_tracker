import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/cupertino.dart';

class Subscription {
  int key;
  String title;
  String description;
  String amount;
  Currency currency;
  DateTime startDate;
  Renewal renewalPeriod;

  Subscription({
    required this.key,
    required this.title,
    required this.description,
    required this.amount,
    required this.currency,
    required this.startDate,
    required this.renewalPeriod,
  });

  Subscription.newEmpty()
  : key = UniqueKey().hashCode,
    title = '',
    description = '',
    amount = "0.0",
    currency = CurrencyService().findByCode("EUR")!,
    startDate = DateTime.now(),
    renewalPeriod = Renewal(every: 1, timePeriod: TimePeriod.months);

  Subscription.fromJson(Map<String, dynamic> json)
      : key = json['key'],
        title = json['title'],
        description = json['description'],
        amount = json['amount'],
        currency = Currency.from(json: json['currency']),
        startDate = DateTime.parse(json['startDate']),
        renewalPeriod = Renewal.fromJson(json['renewalPeriod']);

  Map<String, dynamic> toJson() => {
        'key': key,
        'title': title,
        'description': description,
        'amount': amount,
        'currency': currency.toJson(),
        'startDate': startDate.toIso8601String(),
        'renewalPeriod': renewalPeriod.toJson(),
      };
}

class Renewal {
  int every;
  TimePeriod timePeriod;

  Renewal({
    required this.every,
    required this.timePeriod,
  });

  Renewal.fromJson(Map<String, dynamic> json)
    : every = json['every'],
      timePeriod = json['timePeriod'];
  
  Map<String, dynamic> toJson() => {
    'every': every,
    'timePeriod': timePeriod.toString(),
  };
}

enum TimePeriod {
  days,
  weeks,
  months,
  years,
}
