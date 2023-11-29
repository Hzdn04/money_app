// import 'dart:html';

// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_expanse/pages/login_page.dart';
import 'package:quickalert/quickalert.dart';

import '../config/api.dart';
import '../config/app_request.dart';
import '../config/session.dart';
import '../model/user.dart';

class SourceUser {
  static Future<bool> login(String email, String password) async {
    // String url = '${Api.user}login.php';
    String url = '${Api.user}login.php';
    Map? responseBody =
        await AppRequest.post(url, {'email': email, 'password': password});

    // print(responseBody!['data']);

    if (responseBody!['status']) {
      var mapUser = responseBody['data'];
      Session.saveUser(User.fromJson(mapUser));
    }

    return responseBody['status'];
  }

  static Future<bool?> register(
      String name, String email, String password, BuildContext context) async {
    String url = '${Api.user}register.php';

    Map? responseBody = await AppRequest.post(url, {
      'name': name,
      'email': email,
      'password': password,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    });

    // print(responseBody!['data']);

    if (responseBody == null) return false;

    if (responseBody['success']) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: '$email Berhasil Ditambahkan!',
        autoCloseDuration: const Duration(seconds: 2),
      );
      Timer(const Duration(seconds: 2), () {
        Get.off(() => LoginPage());
      });

    } else {
      if (responseBody['message'] == 'email') {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: '$email sudah didaftarkan!',
          autoCloseDuration: const Duration(seconds: 3),
        );
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: 'Gagal didaftarkan!',
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
    }

    return responseBody['success'];
  }

  // static Future<String?> edit(String username, String email, String name,
  //     String age, String address, String phone, String id, token) async {
  //   String url = '${Api.user}edit/$id';

  //   Session.getToken().then((value) {
  //     tokenAccess = value!;
  //   });

  //   Map? responseBody = await AppRequest.update(url, {
  //     'username': username,
  //     'email': email,
  //     'name': name,
  //     'age': age,
  //     'address': address,
  //     'phone': phone,
  //     'updated_at': DateTime.now().toIso8601String(),
  //   }, headers: {
  //     'Accept': 'application/json',
  //     'access_token': tokenAccess
  //   });

  //   if (responseBody == null) return null;

  //   if (responseBody['message'] == 'User has been updated!') {
  //     DInfo.dialogSuccess('Updated SuccessFully');
  //     DInfo.closeDialog(
  //         durationBeforeClose: const Duration(seconds: 5),
  //         actionAfterClose: () {
  //           Session.clearUser();
  //           cHome.indexPage = 0;
  //           Get.offAll(HomePage());
  //         });
  //   } else {
  //     DInfo.dialogError('Updated Failed');
  //     DInfo.closeDialog();
  //   }

  //   return responseBody['message'];
  // }

  // static Future<String?> changePassword(
  //     String password, String id, token) async {
  //   String url = '${Api.user}change/$id';

  //   Session.getToken().then((value) {
  //     tokenAccess = value!;
  //   });

  //   Map? responseBody = await AppRequest.update(url, {
  //     'password': password,
  //     'updated_at': DateTime.now().toIso8601String(),
  //   }, headers: {
  //     'Accept': 'application/json',
  //     'access_token': tokenAccess
  //   });

  //   if (responseBody == null) return null;

  //   if (responseBody['message'] == 'Password has been updated!') {
  //     DInfo.dialogSuccess('Updated SuccessFully');
  //     DInfo.closeDialog(
  //         durationBeforeClose: const Duration(seconds: 5),
  //         actionAfterClose: () {
  //           Session.clearUser();
  //           cHome.indexPage = 0;
  //           Get.offAll(HomePage());
  //         });
  //   } else {
  //     DInfo.dialogError('Change Password Failed');
  //     DInfo.closeDialog();
  //   }

  //   return responseBody['message'];
  // }
}
