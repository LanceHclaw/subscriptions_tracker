import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'subscriptions_list.dart';
import 'data_persistence.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final db = Localstore.instance;
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
          leading: DataPersistence(db: db),
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
