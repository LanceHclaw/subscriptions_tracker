import 'package:flutter/material.dart';
import 'package:subscription_tracker/data_persistence.dart';
import 'package:subscription_tracker/subscription.dart';

class SubscriptionsList extends StatefulWidget {
  const SubscriptionsList({super.key});

  @override
  State<SubscriptionsList> createState() => SubscriptionsListState();
}

class SubscriptionsListState extends State<SubscriptionsList> {
  static int _counter = 0;
  static final List<ListTile> _rows = <ListTile>[];
  static final List<Subscription> _subscriptions = <Subscription>[];

  @override
  Widget build(BuildContext context) {
    final list = createList();
    return list;
  }

  Widget createList() {
    if (_subscriptions.isEmpty) {
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
      return ReorderableListView(
        onReorder: reorder,
        children: _subscriptions.map((e) => createTile(e)).toList(),
      );
    }
  }

  void reorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final Subscription item = _subscriptions.removeAt(oldIndex);
      _subscriptions.insert(newIndex, item);

      DataPersistence.instance.saveList(_subscriptions);
    });
  }

  void updateIndices() {

  }

  void addRow() {
    setState(() {
      _counter++;
      _subscriptions.add(createSubscription());
      DataPersistence.instance.saveList(_subscriptions);
    });
  }

  void removeRow(int hashCode) {
    setState(() {
      _subscriptions.removeWhere(
        (element) {
          if (element.key.hashCode == hashCode) {
            return true;
          }
          return false;
        },
      );
      DataPersistence.instance.saveList(_subscriptions);
      // the new list is stored in the first length-1 cells, so we get rid of the unused last one
      DataPersistence.instance.deleteSubscription(_subscriptions.length);
    });
  }

  confirmationPrompt(int rowHashcode) {
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget confirmButton = TextButton(
      child: const Text("Delete"),
      onPressed: () => {
        removeRow(rowHashcode),
        Navigator.pop(context)
      }
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Delete Subscription"),
      content: const Text(
          "Are you sure you want to delete this subscription record?"),
      actions: [
        cancelButton,
        confirmButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Subscription createSubscription(){
    final subscription = Subscription(
      key: _counter, 
      title: "This is row $_counter",
      description: "Dummy description"
    );

    return subscription;
  }

  ListTile createTile(Subscription subscription) {
    final key = Key(subscription.key.toString());

    return ListTile(
      key: key,
      leading: Text(
        subscription.title,
        style: TextStyle(
          background: Paint()..color = Colors.lightGreen,
          fontSize: 16,
        ),
      ),
      trailing: ElevatedButton(
        onPressed: (() => confirmationPrompt(subscription.key)),
        child: const Icon(
          Icons.delete,
        ),
      ),
    );
  }
}
