import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_expanse/config/app_format.dart';
import 'package:money_expanse/config/theme.dart';
import 'package:money_expanse/controller/c_user.dart';
import 'package:money_expanse/pages/add_spend_page.dart';
import 'package:money_expanse/widgets/card_spending_custom.dart';
import 'package:money_expanse/widgets/drawer_cutom.dart';
import 'package:money_expanse/widgets/icon_custom.dart';

import '../controller/c_home.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final cUser = Get.put(CUser());
  final cHome = Get.put(CHome());

  @override
  void initState() {
    cHome.getAnalysis(cUser.data.id!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const Drawer(
        child: 
          DrawerCustom()
         ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              cHome.getAnalysis(cUser.data.id!);
            },
            child: ListView(children: [
              const SizedBox(
                height: 30,
              ),
              Obx(() {
                return header(cUser.data.name ?? 'User');
              }),
              const SizedBox(
                height: 20,
              ),
              outcome(),
              const SizedBox(
                height: 20,
              ),
              spendingCategory(),
              const SizedBox(
                height: 20,
              ),
              spendingByWeek(),
              const SizedBox(
                height: 20,
              ),
              spendingByMonth(context),
              const SizedBox(
                height: 25,
              ),
            ]),
          ),
          addSpending(context)
        ],
      ),
    );
  }

  Padding spendingByMonth(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bulan ini',
            style: blackTextStyle.copyWith(
                fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.width * 0.5,
                child: Stack(
                  children: [
                    Obx(() {
                      return DChartPie(
                        data: [
                          {'domain': 'income', 'measure': cHome.monthIncome},
                          {'domain': 'outcome', 'measure': cHome.monthOutcome},
                          if (cHome.monthIncome == 0 && cHome.monthOutcome == 0)
                            {'domain': 'nol', 'measure': 1},
                        ],
                        fillColor: (pieData, index) {
                          switch (pieData['domain']) {
                            case 'income':
                              return kSecondaryColor;
                            case 'outcome':
                              return Colors.yellow[700];
                            default:
                              return kPrimaryColor.withOpacity(0.7);
                          }
                        },
                        donutWidth: 30,
                        labelColor: Colors.transparent,
                        showLabelLine: false,
                      );
                    }),
                    Center(
                      child: Obx(() {
                        return Text('${cHome.percentIncome}%');
                      }),
                    )
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 15,
                        width: 15,
                        color: kSecondaryColor,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text('Pemasukan')
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Container(
                        height: 15,
                        width: 15,
                        color: Colors.yellow[700],
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text('Pengeluaran')
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Obx(() {
                    return Text(cHome.monthPercent);
                  }),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text('Atau setara:'),
                  Obx(() {
                    return Text(
                      AppFormat.currency(cHome.differentMonth.toString()),
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Padding outcome() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              width: 158,
              height: 97,
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      return Text(
                        'Pengeluaran ${cHome.todayPercent}',
                        maxLines: 2,
                        style: whiteTextStyle.copyWith(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      );
                    }),
                    const SizedBox(
                      height: 14,
                    ),
                    Obx(() {
                      return Text(
                        AppFormat.currency(cHome.today.toString()),
                        style: whiteTextStyle.copyWith(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 19,
          ),
          Expanded(
            child: Container(
              width: 158,
              height: 97,
              decoration: BoxDecoration(
                color: kSecondaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pengeluaranmu Bulan ini',
                      maxLines: 2,
                      style: whiteTextStyle.copyWith(
                          fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Text(
                      'Rp. 90.000',
                      style: whiteTextStyle.copyWith(
                          fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding spendingByWeek() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Minggu ini',
            style: blackTextStyle.copyWith(
                fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 20,
          ),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Obx(() {
              return DChartBar(
                data: [
                  {
                    'id': 'Bar',
                    'data': List.generate(7, (index) {
                      return {
                        'domain': cHome.weekText()[index],
                        'measure': cHome.week[index]
                      };
                    }),
                  },
                ],
                domainLabelPaddingToAxisLine: 16,
                axisLineTick: 2,
                axisLinePointTick: 2,
                axisLinePointWidth: 10,
                axisLineColor: kSecondaryColor,
                measureLabelPaddingToAxisLine: 16,
                barColor: (barData, index, id) => kPrimaryColor,
                showBarValue: true,
              );
            }),
          ),
          const SizedBox(
            height: 20,
          ),
          // SpendingCardCustom(
          //     category: 'Makanan',
          //     asset: 'assets/food.png',
          //     bg: kYellowColor,
          //     color: Colors.white,
          //     spend: 18000),
        ],
      ),
    );
  }

  Container addSpending(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 30, bottom: 30),
      alignment: Alignment.bottomRight,
      child: FloatingActionButton(
          backgroundColor: kPrimaryColor,
          child: const Icon(
            Icons.edit_note_outlined,
            color: Colors.white,
          ),
          onPressed: () {
            Get.to(() => AddSpendPage())?.then((value) {
              if (value ?? false) {
                cHome.getAnalysis(cUser.data.id!);
              }
            });
          }),
    );
  }

  Padding spendingCategory() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pengeluaran berdasarkan kategori',
            style: blackTextStyle.copyWith(
                fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    margin: const EdgeInsets.only(right: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 0,
                          blurRadius: 2.5,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const IconCustom(
                            asset: 'assets/food.png',
                            color: Colors.white,
                            bg: Color(0xffF2C94C),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Makanan',
                            style: greyTextStyle.copyWith(
                                fontSize: 12, fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Rp. 70.000',
                            style: blackTextStyle.copyWith(
                                fontSize: 12, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 120,
                    height: 120,
                    margin: const EdgeInsets.only(right: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 0,
                          blurRadius: 2.5,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const IconCustom(
                            asset: 'assets/food.png',
                            color: Colors.white,
                            bg: Color(0xffF2C94C),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Makanan',
                            style: greyTextStyle.copyWith(
                                fontSize: 12, fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Rp. 70.000',
                            style: blackTextStyle.copyWith(
                                fontSize: 12, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 120,
                    height: 120,
                    margin: const EdgeInsets.only(right: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 0,
                          blurRadius: 2.5,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const IconCustom(
                            asset: 'assets/food.png',
                            color: Colors.white,
                            bg: Color(0xffF2C94C),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Makanan',
                            style: greyTextStyle.copyWith(
                                fontSize: 12, fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Rp. 70.000',
                            style: blackTextStyle.copyWith(
                                fontSize: 12, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 120,
                    height: 120,
                    margin: const EdgeInsets.only(right: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 0,
                          blurRadius: 2.5,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const IconCustom(
                            asset: 'assets/food.png',
                            color: Colors.white,
                            bg: Color(0xffF2C94C),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Makanan',
                            style: greyTextStyle.copyWith(
                                fontSize: 12, fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Rp. 70.000',
                            style: blackTextStyle.copyWith(
                                fontSize: 12, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Padding header(user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo, $user',
                  style: blackTextStyle.copyWith(
                      fontSize: 18, fontWeight: FontWeight.w700),
                  overflow: TextOverflow.fade,
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  'Jangan lupa catat keuanganmu setiap hari',
                  style: greyTextStyle.copyWith(
                      fontSize: 14, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          Builder(builder: (ctx) {
            return Material(
              borderRadius: BorderRadius.circular(15),
              color: kPrimaryColor.withOpacity(0.5),
              child: InkWell(
                  onTap: () {
                    Scaffold.of(ctx).openEndDrawer();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.menu_outlined,
                      color: Colors.white,
                    ),
                  )),
            );
          })
        ],
      ),
    );
  }
}
