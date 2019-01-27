import 'dart:async';

import 'package:angular/core.dart';

/// Mock service emulating access to a dashboard data from server.
@Injectable()
class DashboardService {
  // List<String> mockItemList = loadItems().toList();
  List<String> mockItemList = <String>[];

  Future<List<String>> getItemList() async => mockItemList;
}


Iterable<String> loadItems() sync* {
  var actions = ['Walk', 'Wash', 'Feed'];
  var pets = ['cats', 'dogs'];

  for (var action in actions) {
    for (var pet in pets) {
      if (pet == 'cats' && action != 'Feed') continue;
      yield '$action the $pet';
    }
  }
}