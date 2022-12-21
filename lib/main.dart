import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:subscription_tracker/subscription_form.dart';
import 'subscriptions_list.dart';
import 'data_persistence.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Subscriptions Tracker',
      home: Home(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    ),
  );
}

class Home extends StatelessWidget {
  Home({super.key});
  final db = Localstore.instance;
  final _key = GlobalKey<SubscriptionsListState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Subscriptions"),
        leading: ElevatedButton(
          onPressed: (() async =>
              log(await DataPersistence.instance.getData())),
          child: const Icon(Icons.plus_one),
        ),
      ),
      body: SubscriptionsList(key: _key),
      floatingActionButton: FloatingActionButton(
        //onPressed: () => _key.currentState!.addRow(),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubscriptionForm(
              null,
              (subscription) =>
                  _key.currentState!.createSubscription(subscription),
            ),
          ),
        ),
        tooltip: 'Add a Subscription',
        child: const Icon(Icons.add),
      ),
    );
  }
}
