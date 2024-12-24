import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';

class ContactSharedPreferencesStorage {
  static const String _keyContactIndexes = 'contact_indexes';

  Future<void> save(QueueList<int> indexes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> indexStrings = indexes.map((index) => index.toString()).toList();

    await prefs.setStringList(_keyContactIndexes, indexStrings);
  }

  Future<QueueList<int>> load() async {
    QueueList<int> indexes = QueueList<int>();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? indexStrings = prefs.getStringList(_keyContactIndexes);

    if (indexStrings != null) {
      indexes.addAll(indexStrings.map(int.parse));
    }

    return indexes;
  }
}

