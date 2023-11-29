// import 'dart:html';

// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_expanse/model/history.dart';
import 'package:money_expanse/pages/list_spend_page.dart';
import 'package:quickalert/quickalert.dart';

import '../config/api.dart';
import '../config/app_request.dart';
import '../config/session.dart';
import '../pages/home_page.dart';

class SourceHistory {
  static Future<Map> analysis(String idUser) async {
    String url = '${Api.history}analysis.php';
    Map? responseBody = await AppRequest.post(url, {
      'id_user': idUser,
      'today': DateFormat('yyyy-MM-dd').format(DateTime.now())
    });

    // print(responseBody!['data']);

    if (responseBody == null) {
      return {
        'today': 0.0,
        'yesterday': 0.0,
        'week': [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
        'month': {
          'income': 0.0,
          'outcome': 0.0,
        },
      };
    }

    return responseBody;
  }

  static Future<List<History>> listSpend(String idUser) async {
    String url = '${Api.history}list_spend.php';
    Map? responseBody = await AppRequest.post(url, {
      'id_user': idUser,
    });

    if (responseBody == null) return [];

    if (responseBody['success']) {
      List list = responseBody['data'];
      return list.map((e) => History.fromJson(e)).toList();
    }

    return [];
  }

  static Future<bool> addSpend(String idUser, String date, String type,
      String details, String total, BuildContext context) async {
    String url = '${Api.history}add.php';

    Map? responseBody = await AppRequest.post(url, {
      'id_user': idUser,
      'date': date,
      'type': type,
      'details': details,
      'total': total,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    });

    // print(responseBody!['data']);
    if (responseBody == null) return false;

    if (responseBody['success']) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: '${type}mu Berhasil Ditambahkan!',
        autoCloseDuration: const Duration(seconds: 3),
      );

      Timer(const Duration(seconds: 3), () {
        Get.off(() => HomePage());
      });
    } else {
      if (responseBody['message'] == 'date') {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: '$type dengan tanggal tersebut sudah ada!',
          autoCloseDuration: const Duration(seconds: 3),
        );
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: '$type Gagal Ditambahkan!',
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
    }

    return responseBody['success'];
  }

  static Future<History?> getSpend(String id) async {
    String url = '${Api.history}where_date.php';
    Map? responseBody = await AppRequest.post(url, {
      'id': id,
    });

    if (responseBody == null) return null;

    if (responseBody['success']) {
      var e = responseBody['data'];
      return History.fromJson(e);
    }

    return null;
  }

  static Future<bool> editSpend(String id, String idUser, String date, String type,
      String details, String total, BuildContext context) async {
    String url = '${Api.history}update.php';

    Map? responseBody = await AppRequest.post(url, {
      'id': id,
      'id_user': idUser,
      'date': date,
      'type': type,
      'details': details,
      'total': total,
      'updatedAt': DateTime.now().toIso8601String(),
    });

    // print(responseBody!['data']);
    if (responseBody == null) return false;

    if (responseBody['success']) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: '${type}mu Berhasil DiUpdate!',
        autoCloseDuration: const Duration(seconds: 3),
      );

      Timer(const Duration(seconds: 3), () {
        Get.off(() => const ListSpend());
      });
    } else {
      if (responseBody['message'] == 'date') {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: '$type dengan tanggal tersebut sudah terpakai!',
          autoCloseDuration: const Duration(seconds: 3),
        );
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: '$type Gagal DiUpdate!',
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
    }

    return responseBody['success'];
  }

  static Future<bool> deleteSpend(String id) async {
    String url = '${Api.history}delete.php';
    Map? responseBody = await AppRequest.post(url, {
      'id': id,
    });

    if (responseBody == null) return false;

    return responseBody['success'];
  }
}
