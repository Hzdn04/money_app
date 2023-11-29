import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:money_expanse/config/session.dart';
import 'package:money_expanse/config/theme.dart';
import 'package:money_expanse/pages/home_page.dart';
import 'package:money_expanse/pages/login_page.dart';

import 'model/user.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting().then((value) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
          primaryColor: kPrimaryColor,
          colorScheme: ColorScheme.light(
            primary: kPrimaryColor,
            secondary: kSecondaryColor,
          )),
      home: FutureBuilder(
        future: Session.getUser(),
        builder: (context, AsyncSnapshot<User> snapshot) {
          if (snapshot.data != null && snapshot.data!.id != null) {
            return const HomePage();
          }
          return LoginPage();
        },
      ),
    );
  }
}
