// ignore_for_file: invalid_use_of_protected_member

import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_expanse/model/history.dart';
import 'package:money_expanse/source/source_history.dart';

class CDetailSpend extends GetxController {
  final _data = History().obs;
  History get data => _data.value;


  getData(id) async {
    History? history = await SourceHistory.getSpend(id);
    _data.value = history ?? History();
    update();
  }
}
