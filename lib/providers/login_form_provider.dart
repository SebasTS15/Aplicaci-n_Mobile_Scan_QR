//import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;

class LoginFormProvider extends ChangeNotifier {
 
  // ignore: unnecessary_new
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  String correo = '';
  String password = '';

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  //set nombre(String nombre) {}

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm() {
    print(formKey.currentState?.validate());

    print('$correo - $password');

    return formKey.currentState?.validate() ?? false;
  }
}
