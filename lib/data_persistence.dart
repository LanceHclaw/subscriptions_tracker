import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';

class DataPersistence extends StatelessWidget {
  const DataPersistence({
    super.key,
    required this.db,
  });

  final Localstore db;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => saveMultiple(),
      onLongPress: (() async => log(await getData())),
      child: const Icon(
        Icons.plus_one,
      ),
    );
  }

  void saveMultiple(){
    for (int i = 0; i < 10; i++){
      saveElement('$i', 'this is my $i -th subscription');
    }
  }

  void saveElement(String key, String data) {
    db
        .collection('subscriptions')
        .doc(key)
        .set({'title': 'data', 'random': 'randomwordsblahblah'});
  }

  Future<String> getData() async {
    final data = await db.collection('subscriptions').get();
    //debugPrint(data.toString());
    return data.toString();
  }
}
