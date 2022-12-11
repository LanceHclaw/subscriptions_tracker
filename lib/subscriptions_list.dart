import 'package:flutter/material.dart';

class SubscriptionsList extends StatefulWidget {
  const SubscriptionsList({super.key});

  @override
  State<SubscriptionsList> createState() => SubscriptionsListState();
}

class SubscriptionsListState extends State<SubscriptionsList> {
  static int _counter = 0;
  static final List<ListTile> _rows = <ListTile>[];

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
      return ReorderableListView(
        onReorder: reorder,
        children: _rows,
      );
    }
  }

  void reorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final ListTile item = _rows.removeAt(oldIndex);
      _rows.insert(newIndex, item);
    });
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
        onPressed: (() => confirmationPrompt(_key.hashCode)),
        child: const Icon(
          Icons.delete,
        ),
      ),
    );
  }
}
