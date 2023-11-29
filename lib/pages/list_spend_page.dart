// ignore_for_file: use_build_context_synchronously

import 'package:d_info/d_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:money_expanse/config/app_format.dart';
import 'package:money_expanse/controller/spend/c_list_spend.dart';
import 'package:money_expanse/model/history.dart';
import 'package:money_expanse/pages/detail_spend_page.dart';
import 'package:money_expanse/pages/edit_spend_page.dart';
import 'package:money_expanse/source/source_history.dart';
import 'package:money_expanse/widgets/card_spending_custom.dart';
import 'package:money_expanse/widgets/drawer_cutom.dart';
import 'package:quickalert/quickalert.dart';

import '../config/theme.dart';
import '../controller/c_user.dart';

class ListSpend extends StatefulWidget {
  const ListSpend({super.key});

  @override
  State<ListSpend> createState() => _ListSpendState();
}

class _ListSpendState extends State<ListSpend> {
  final cListSpend = Get.put(CListSpend());
  final cUser = Get.put(CUser());

  refresh() {
    cListSpend.getList(cUser.data.id!);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      refresh();
    });
    super.initState();
  }

  delete(History history) async {
    bool? yes = await DInfo.dialogConfirmation(
      context,
      'Delete',
      'Are you sure to deleted?',
      textNo: 'Batal',
      textYes: 'Ya',
    );
    if (yes == true) {
      bool? success = await SourceHistory.deleteSpend(history.id!);
      if (success) {
        refresh();
        DInfo.dialogSuccess(context, 'Delete Successfully');
        DInfo.closeDialog(context);
      } else {
        DInfo.dialogError(context, 'Delete Failed');
        DInfo.closeDialog(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const Drawer(
        child: DrawerCustom(),
      ),
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 60,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: const Text(
          'Riwayat',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            searchField(),
            const SizedBox(
              height: 20,
            ),
            GetBuilder<CListSpend>(builder: (_) {
              if (_.loading) return const CircularProgressIndicator();
              if (_.list.isEmpty) return const Text('Kosong');

              return RefreshIndicator(
                onRefresh: () async {
                  refresh();
                },
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: _.list.length,
                    itemBuilder: (context, index) {
                      History history = _.list[index];
                      return Slidable(
                        // The end action pane is the one at the right or the bottom side.
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              flex: 2,
                              onPressed: (context) {
                                delete(history);
                              },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                            SlidableAction(
                              flex: 2,
                              onPressed: (context) {
                                Get.to(() => EditSpendPage(
                                      history: history,
                                    ))?.then((value) {
                                  if (value ?? false) {
                                    refresh();
                                  }
                                });
                              },
                              backgroundColor: Colors.yellow,
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: 'Update',
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: () {
                            Get.to(() => DetailSpend(history: history,));
                          },
                          child: SpendingCardCustom(
                              category: AppFormat.date(history.date!),
                              asset: history.type == 'Pemasukan'
                                  ? 'assets/download.png'
                                  : 'assets/upload.png',
                              bg: history.type == 'Pemasukan'
                                  ? Colors.green
                                  : Colors.red,
                              color: Colors.white,
                              spend: AppFormat.currency(history.total!),
                              type: 'Pengeluaran'),
                        ),
                      );
                    }),
              );
            })
          ],
        ),
      ),
    );
  }

  Container searchField() {
    return Container(
      height: 45,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      child: TextField(
        onChanged: (value) {
          // setState(() {
          //   searchKeyword = value;
          // });
        },
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none),
            hintText: 'Search',
            hintStyle: greyTextStyle.copyWith(
                fontSize: 16, fontWeight: FontWeight.w400),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            prefixIcon: const Icon(Icons.search)),
      ),
    );
  }
}
