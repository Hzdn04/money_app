import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_expanse/config/app_format.dart';
import 'package:money_expanse/config/theme.dart';
import 'package:money_expanse/controller/spend/c_add_spend.dart';
import 'package:money_expanse/source/source_history.dart';
import 'package:money_expanse/widgets/button_custom.dart';

import '../controller/c_user.dart';

class AddSpendPage extends StatelessWidget {
  AddSpendPage({super.key});

  final cAddSpend = Get.put(CAddSpend());
  final cUser = Get.put(CUser());

  final controllerSource = TextEditingController();
  final controllerNominal = TextEditingController();
  final controllerItems = TextEditingController();
  final formKey = GlobalKey<FormState>();

  addSpend(context) async {
    await SourceHistory.addSpend(
        cUser.data.id!,
        cAddSpend.date,
        cAddSpend.type,
        jsonEncode(cAddSpend.items),
        cAddSpend.total.toString(),
        context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: const Text(
          'Tambah Pengeluaran Baru',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView( 
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        Obx(() {
                          return TextFormField(
                            controller: TextEditingController(
                              text: AppFormat.date(cAddSpend.date),
                            ),
                            onTap: () async {
                              DateTime? res = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2023, 01, 01),
                                  lastDate: DateTime(DateTime.now().year + 1));

                              if (res != null) {
                                cAddSpend.setDate(
                                    DateFormat('yyyy-MM-dd').format(res));
                              }
                            },
                            readOnly: true,
                            decoration: InputDecoration(
                              isDense: true,
                              filled: true,
                              fillColor: Colors.white,
                              suffixIcon:
                                  const Icon(Icons.calendar_month_outlined),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              labelText: "Tanggal ",
                              hintText: '12-12-2023',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide:
                                      BorderSide(color: kSecondaryColor)),
                            ),
                          );
                        }),
                        const SizedBox(
                          height: 20,
                        ),
                        Obx(() {
                          return DropdownButtonFormField(
                            value: cAddSpend.type,
                            items: ['Pemasukan', 'Pengeluaran'].map((e) {
                              return DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              );
                            }).toList(),
                            onChanged: (value) {
                              cAddSpend.setType(value);
                            },
                            decoration: InputDecoration(
                              isDense: true,
                              filled: true,
                              fillColor: Colors.white,
                              labelText: "Tipe ",
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide:
                                      BorderSide(color: kSecondaryColor)),
                            ),
                          );
                        }),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: controllerSource,
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            labelText: "Sumber(Objek) pemasukan/pengeluaran  ",
                            hintText: 'Transfer',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide(color: kSecondaryColor)),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: controllerNominal,
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            labelText: "Nominal ",
                            hintText: 'Rp. 9000',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide(color: kSecondaryColor)),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: kSecondaryColor),
                            onPressed: () {
                              cAddSpend.addItem({
                                'source': controllerSource.text,
                                'nominal': controllerNominal.text
                              });
                              controllerSource.clear();
                              controllerNominal.clear();
                            },
                            child: Container(
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                width: double.infinity,
                                child: const Text('Tambah ke Items'))),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                            padding: const EdgeInsets.only(left: 15, bottom: 3),
                            alignment: Alignment.centerLeft,
                            child: const Text('Items')),
                        Container(
                          padding: const EdgeInsets.all(12),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                  style: BorderStyle.solid, width: 0.7)),
                          child: GetBuilder<CAddSpend>(builder: (_) {
                            return Wrap(
                              runSpacing: 10,
                              spacing: 10,
                              children: List.generate(_.items.length, (index) {
                                return Chip(
                                  backgroundColor: Colors.grey[200],
                                  label: Text(_.items[index]['source']),
                                  deleteIcon: const Icon(Icons.clear),
                                  onDeleted: () {
                                    _.deleteItem(index);
                                  },
                                );
                              }),
                            );
                          }),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Text('Total : '),
                            Obx(() {
                              return Text(
                                AppFormat.currency(cAddSpend.total.toString()),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5!
                                    .copyWith(color: kPrimaryColor),
                              );
                            })
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ButtonCustom(
                            label: 'Simpan',
                            onTap: () {
                              addSpend(context);
                            },
                            marginHorizontal: 80,
                          ),
                        )
                      ]),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
