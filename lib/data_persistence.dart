import 'package:localstore/localstore.dart';
import 'package:subscription_tracker/subscription.dart';

// in case of multiple files / databases we can make this class abstract and derive from it multiple times for each use case
class DataPersistence {
  static final DataPersistence _instance = DataPersistence._internal();
  factory DataPersistence() => _instance;

  DataPersistence._internal();

  static DataPersistence get instance => _instance;

  static final Localstore _db = Localstore.instance;
  static const String _collection = 'subscriptions';

  Future<List<Subscription>> loadList() async{
    Map<String, dynamic>? data = await _db.collection(_collection).get();
    if (data == null) {
      return [];
    }

    List<Subscription> list = <Subscription>[];
    for (final key in data.keys) {
      list.add(Subscription.fromJson(data[key]));
    }
    return list;
  }

// this kinda works actually
  void saveList(List<Subscription> subscriptions) async {
    for (int i = 0; i < subscriptions.length; i++) {
      await _db.collection(_collection).doc(i.toString()).set(subscriptions[i].toJson());
    }
  }

  void saveSubscription(Subscription subscription) {
    _db.collection(_collection).doc(subscription.key.toString()).set({
      Fields.key.name: subscription.key,
      Fields.title.name: subscription.title,
      Fields.description.name: subscription.description,
    });
  }

  void deleteSubscription(int key) {
    _db.collection(_collection).doc(key.toString()).delete();
  }

  Future<String> getData() async {
    final data = await _db.collection('subscriptions').get();
    //debugPrint(data.toString());
    return data.toString();
  }
}

enum Fields {
  key,
  order,
  title,
  description,
}
