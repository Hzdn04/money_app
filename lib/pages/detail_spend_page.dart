import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_expanse/config/app_format.dart';
import 'package:money_expanse/config/theme.dart';
import 'package:money_expanse/controller/spend/c_detail_spend.dart';
import 'package:money_expanse/model/history.dart';

class DetailSpend extends StatefulWidget {
  const DetailSpend({super.key, required this.history,});

  final History history;

  @override
  State<DetailSpend> createState() => _DetailSpendState();
}

class _DetailSpendState extends State<DetailSpend> {

  final cDetailSpend = Get.put(CDetailSpend());

  @override
  void initState() {
    cDetailSpend.getData(widget.history.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 60,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: Text(
          AppFormat.date(widget.history.date ?? '00-00-0000'),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Icon( widget.history.type == 'Pemasukan' ? Icons.south_west : Icons.north_east , color: widget.history.type == 'Pemasukan' ? Colors.green : Colors.red,)
        ],
      ),
      body: GetBuilder<CDetailSpend>(
        builder: (_) {
          if (_.data.id == null) return Text('Not Found');
          List details = jsonDecode(_.data.details!);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
          
                  children: [
                    Text('Total', style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: kPrimaryColor),),
                    const SizedBox(height: 10,),
                    Text(AppFormat.currency(_.data.total ?? '0'), style: Theme.of(context).textTheme.headlineLarge!.copyWith(color: kPrimaryColor),)
                  ],
                ),
                const SizedBox(height: 35,),
                Expanded(
                  child: ListView.separated(
                    itemCount: details.length,
                    separatorBuilder: (context, index) => const Divider(height: 40, indent: 16, endIndent: 16,),
                    itemBuilder: (context, index) {
                      Map item = details[index];
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${index+1}. ${item['source']}'),
                          Text(AppFormat.currency(item['nominal']))
                        ],
                      );
                  }),
                )
              ],
            ),
          );
        }
      ),
    );
  }
}
