// ignore_for_file: invalid_use_of_protected_member

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_expanse/model/history.dart';

class CAddSpend extends GetxController {
  final _date = DateFormat('yyyy-MM-dd').format(DateTime.now()).obs;
  String get date => _date.value;
  setDate(n) => _date.value = n;

  final _type = 'Pemasukan'.obs;
  String get type => _type.value;
  setType(n) => _type.value = n;

  final _items = [].obs;
  List get items => _items.value;
  addItem(n) {
    _items.value.add(n);
    count();
  }

  deleteItem(i) {
    _items.value.removeAt(i);
    count();
  }

  final _total = 0.0.obs;
  double get total => _total.value;

  count() {
   _total.value = items
        .map((e) => e['nominal'])
        .toList()
        .fold(0.0, (previousValue, element) {
          return double.parse(previousValue.toString()) + double.parse(element);
        });
        update();
  }
}
