import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/session.dart';
import '../pages/about_page.dart';
import '../pages/account_page.dart';
import '../pages/list_spend_page.dart';
import '../pages/login_page.dart';
import 'button_custom.dart';

class DrawerCustom extends StatelessWidget {
  const DrawerCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
          children: [
            ListView(children: [
              DrawerHeader(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 65),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    'https://via.placeholder.com/100',
                    height: 90,
                    width: 30,
                    fit: BoxFit.cover,
                  ),
                ),
              )),
              ListTile(
                onTap: () {
                  Get.to(AccountPage());
                },
                title: const Text('My Account'),
                leading: const Icon(Icons.person_2_outlined),
                horizontalTitleGap: 0,
              ),
              ListTile(
                onTap: () {
                  Get.to(ListSpend());
                },
                title: const Text('Riwayat'),
                leading: const Icon(Icons.history),
                horizontalTitleGap: 0,
              ),
              ListTile(
                onTap: () {
                  Get.to(const AboutPage());
                },
                title: const Text('About'),
                leading: const Icon(Icons.app_shortcut_rounded),
                horizontalTitleGap: 0,
              )
            ]),
            Container(
                padding: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
                alignment: Alignment.bottomCenter,
                child: ButtonCustom(
                    label: 'Logout',
                    onTap: () {
                      Session.clearUser();
                      Get.offAll(() => LoginPage());
                    },
                    marginHorizontal: 80))
          ],
        );
     
  }
}