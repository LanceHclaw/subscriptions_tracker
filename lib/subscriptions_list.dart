import 'package:flutter/material.dart';

class SubscriptionsList extends StatefulWidget {
  const SubscriptionsList({super.key});

  @override
  State<SubscriptionsList> createState() => SubscriptionsListState();
}

class SubscriptionsListState extends State<SubscriptionsList> {
  static int _counter = 0;
  static final _rows = <ListTile>[];

  @override
  Widget build(BuildContext context) {
    final list = createList();
    return list;
  }

  Widget createList() {
    if (_rows.isEmpty) {
      return Container(
        alignment: const Alignment(0, 0),
        child: const Text(
          "You haven't added any subscriptions yet. Press the Add button to create one!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: _rows.length,
        itemBuilder: (context, index) => _rows[index],
      );
    }
  }

  void addRow() {
    setState(() {
      _counter++;
      _rows.add(createRow());
    });
  }

  void removeRow(int hashCode) {
    setState(() {
      _rows.removeWhere(
        (element) {
          if (element.key.hashCode == hashCode) {
            return true;
          }
          return false;
        },
      );
    });
  }

  ListTile createRow() {
    // ignore: no_leading_underscores_for_local_identifiers
    final _key = Key(_counter.toString());

    return ListTile(
        key: _key,
        leading: Text(
          "This is row $_counter",
          style: TextStyle(
            background: Paint()..color = Colors.lightGreen,
            fontSize: 16,
          ),
        ),
        trailing: ElevatedButton(
          onPressed: (() => removeRow(_key.hashCode)),
          child: const Icon(
            Icons.delete,
          ),
        ));
  }
}
