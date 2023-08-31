import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../constants/constants.dart';

class NetworkController extends GetxController with WidgetsBindingObserver {
  final Connectivity _connectivity = Connectivity();
  final RxBool isDialogOpen = false.obs;
  static const String googleUrl = 'https://www.google.com';
  static const Duration dialogDelay = Duration(seconds: 15);
  Timer? _dialogTimer;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _checkInitialConnectionStatus();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _checkInitialConnectionStatus() async {
    bool hasInternet = await _checkInternetConnectivity();
    if (!hasInternet) {
      _showSnackbar();
    }
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) async {
    bool hasInternet = await _checkInternetConnectivity();
    if (!hasInternet) {
      _showSnackbar();
      _dialogTimer = Timer(dialogDelay, () {
        if (connectivityResult == ConnectivityResult.none) {
          _handleDialogAndSnackbar(connectivityResult);
        } else {
          _hideDialog();
        }
      });
    } else {
      _hideSnackbarAndDialog();
    }
  }

  Future<bool> _checkInternetConnectivity() async {
    try {
      final response = await http.get(Uri.parse(googleUrl));
      final code = response.statusCode;
      return code >= 200 && code < 300;
    } catch (e) {
      return false;
    }
  }

  void _showSnackbar() {
    if (!Get.isSnackbarOpen) {
      snackBar("Connecting ...", const Duration(days: 1));
    }
  }

  void _handleDialogAndSnackbar(ConnectivityResult connectivityResult) {
    _hideSnackbarAndDialog();
    _showDialogBox(connectivityResult);
  }

  void _hideSnackbarAndDialog() {
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }
    if (isDialogOpen.value) {
      _hideDialog();
    }
    _cancelDialogTimer();
  }

  void _hideDialog() {
    if (isDialogOpen.value) {
      isDialogOpen.value = false;
      Get.back();
    }
  }

  void _cancelDialogTimer() {
    if (_dialogTimer != null && _dialogTimer!.isActive) {
      _dialogTimer!.cancel();
    }
  }

  void _showDialogBox(ConnectivityResult connectivityResult) {
    isDialogOpen.value = true;
    Get.dialog(
      barrierDismissible: false,
      CupertinoAlertDialog(
        title: const Text(
          "NETWORK ERROR",
          style: TextStyle(
            color: Color(0xFFFF0000),
          ),
        ),
        content: const Text(
          "Please check your network connection",
          style: TextStyle(fontSize: 16),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CupertinoButton(
                    onPressed: () {
                      _hideDialog();
                      _updateConnectionStatus(connectivityResult);
                    },
                    color: Colors.white,
                    padding: const EdgeInsets.all(5),
                    child: const Icon(
                      Icons.refresh_rounded,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cancelDialogTimer();
    super.dispose();
  }
}
