
import 'package:get/get.dart';
import 'package:money_expanse/model/history.dart';
import 'package:money_expanse/source/source_history.dart';

class CListSpend extends GetxController {
  final _loading = false.obs;
  bool get loading => _loading.value;

  final _list = <History>[].obs;
  List<History> get list => _list.value;

  getList(idUser) async{
    _loading.value = true;
    update();

    _list.value = await SourceHistory.listSpend(idUser);
    update();

    _loading.value = false;
    update();
  }
}