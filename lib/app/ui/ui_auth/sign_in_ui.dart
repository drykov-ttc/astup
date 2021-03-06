// ignore_for_file: avoid_returning_null_for_void

import 'package:astup/app/controllers/controllers.dart';
import 'package:astup/app/helpers/helpers.dart';
import 'package:astup/app/ui/components/components.dart';
import 'package:astup/app/ui/ui_auth/ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:core';
import 'package:get/get.dart';

class SignInUI extends StatelessWidget {
  final AuthController authController = AuthController.to;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SignInUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  LogoGraphicHeader(
                    avatar: '',
                  ),
                  const SizedBox(height: 48.0),
                  FormInputFieldWithIcon(
                    controller: authController.emailController,
                    iconPrefix: Icons.email,
                    labelText: 'auth.emailFormField'.tr,
                    validator: Validator().email,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => null,
                    onSaved: (value) =>
                        authController.emailController.text = value!,
                  ),
                  const FormVerticalSpace(),
                  FormInputFieldWithIcon(
                    controller: authController.passwordController,
                    iconPrefix: Icons.lock,
                    labelText: 'auth.passwordFormField'.tr,
                    validator: Validator().password,
                    obscureText: true,
                    onChanged: (value) => null,
                    onSaved: (value) =>
                        authController.passwordController.text = value!,
                    maxLines: 1,
                  ),
                  const FormVerticalSpace(),
                  PrimaryButton(
                      labelText: 'auth.signInButton'.tr,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          authController.signInWithEmailAndPassword(context);
                        }
                      }),
                  const FormVerticalSpace(),
                  LabelButton(
                    labelText: 'auth.resetPasswordLabelButton'.tr,
                    onPressed: () => Get.to(ResetPasswordUI()),
                  ),
                  // LabelButton(
                  //   labelText: 'auth.signUpLabelButton'.tr,
                  //   onPressed: () => Get.to(SignUpUI()),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
