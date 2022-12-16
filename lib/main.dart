import 'package:flutter/material.dart';
import 'subscriptions_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final _key = GlobalKey<SubscriptionsListState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Subscriptions Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("My Subscriptions"),
        ),
        body: SubscriptionsList(key: _key),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _key.currentState!.addRow(),
          tooltip: 'Add a Subscription',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
