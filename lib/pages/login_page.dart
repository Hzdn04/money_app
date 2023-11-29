// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_expanse/config/theme.dart';
import 'package:quickalert/quickalert.dart';

import '../source/source_user.dart';
import '../widgets/button_custom.dart';
import 'home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final controllerEmail = TextEditingController();

  final controllerPassword = TextEditingController();

  final formKey = GlobalKey<FormState>();

  // password visibilty
  bool passwordVisible = false;

  void togglePassword() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  login() async {
    if (formKey.currentState!.validate()) {
      bool? status =
          await SourceUser.login(controllerEmail.text, controllerPassword.text);

      if (status) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Login Successfully!',
          autoCloseDuration: const Duration(seconds: 3),
        );

        Timer(const Duration(seconds: 3), () {
          Get.off(() => const HomePage());
        });
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Oops...',
          text: 'Sorry, something went wrong',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 70),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 50),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Login Here',
                            style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                color: kPrimaryColor),
                          )),
                      TextFormField(
                        controller: controllerEmail,
                        validator: (value) =>
                            value == '' ? "Jangan Kosong" : null,
                        decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            hintText: 'Email Address',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(color: kSecondaryColor)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide.none)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: controllerPassword,
                        validator: (value) =>
                            value == '' ? "Jangan Kosong" : null,
                        obscureText: !passwordVisible,
                        decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: Colors.white,
                            suffixIcon: IconButton(
                              color: Colors.grey,
                              splashRadius: 1,
                              icon: Icon(passwordVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined),
                              onPressed: togglePassword,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            hintText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(color: kSecondaryColor)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide.none)),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ButtonCustom(
                          label: 'Login',
                          onTap: () => login(),
                          marginHorizontal: 80,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                          onTap: () {
                            Get.to(RegisterPage());
                          },
                          child: const Text(
                            'Create New Account',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                                fontWeight: FontWeight.w500),
                          ))
                    ],
                  ),
                ),
                const Text(
                  'Version 0.1',
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
