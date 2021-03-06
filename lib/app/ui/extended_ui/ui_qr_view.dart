import 'dart:developer';
import 'dart:io';

import 'package:astup/app/res/index.dart';
import 'package:astup/app/ui/tutorial_ui/index_tutorial.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class UIQRView extends StatefulWidget {
  const UIQRView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewState();
}

class _QRViewState extends State<UIQRView> {
  Barcode? barcode;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  void _onPress() {
    if (barcode != null) {
      var data = {"result": '${barcode!.code}'};
      Get.toNamed('/object', parameters: data);
    }
  }

  void _showOverlay(BuildContext context) {
    Navigator.push(context, TutorialOverlay());
    // Get.to(TutorialOverlay());
    // navigator.push(TutorialOverlay());
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          body: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              _buildQrView(context),
              Positioned(bottom: 128, child: buildResult()),
              Positioned(top: 10, left: 16, child: buildControlButtons()),
              Positioned(top: 10, right: 16, child: buildUserButtons()),
            ],
          ),
        ),
      );

  Widget buildResult() {
    if (barcode != null) {
      return
          // padding: const EdgeInsets.all(12),
          // decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(8), color: Colors.white24),
          OutlinedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white24),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
        ),
        onPressed: _onPress,
        child: Text(
          '${barcode!.code}',
          maxLines: 3,
          style: const TextStyle(color: AppThemesColors.whiteLilac),
        ),
        // )
        // Text(
        //   '${barcode!.code}',
        //   maxLines: 3,
        //   style: const TextStyle(color: AppThemesColors.whiteLilac),
        // ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18), color: Colors.white24),
        child: const Text(
          'Scan a code',
          maxLines: 3,
          style: TextStyle(color: AppThemesColors.whiteLilac),
        ),
      );
    }
  }

  Widget buildControlButtons() => Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppThemesColors.white24),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
              onPressed: () async {
                await controller?.toggleFlash();
                setState(() {});
              },
              icon: FutureBuilder<bool?>(
                future: controller?.getFlashStatus(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return Icon(
                      snapshot.data!
                          ? Icons.flash_on_outlined
                          : Icons.flash_off_outlined,
                      color: AppThemesColors.whiteLilac,
                    );
                  } else {
                    return Container();
                  }
                },
              )),
          IconButton(
              onPressed: () async {
                await controller?.flipCamera();
                setState(() {});
              },
              icon: const Icon(
                Icons.flip_camera_android_outlined,
                color: AppThemesColors.whiteLilac,
              )),
        ],
      ));

  Widget buildUserButtons() => Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppThemesColors.white24),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
              onPressed: () async {
                Get.toNamed("/home");
              },
              icon: const Icon(
                Icons.engineering_outlined,
                color: AppThemesColors.whiteLilac,
              )),
          // IconButton(
          //     onPressed: () async {
          //       _showOverlay(context);
          //       // Get.toNamed("/profile");
          //     },
          //     icon: const Icon(
          //       // Icons.perm_identity_outlined,
          //       Icons.help_outline_outlined,
          //       color: AppThemesColors.whiteLilac,
          //     )),
          IconButton(
              onPressed: () async {
                Get.toNamed("/settings");
              },
              icon: const Icon(
                Icons.settings_outlined,
                color: AppThemesColors.whiteLilac,
              )),
        ],
      ));

  Widget _buildQrView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
            borderColor: Theme.of(context).errorColor,
            borderRadius: 10,
            borderLength: 40,
            borderWidth: 5,
            cutOutSize: MediaQuery.of(context).size.width * 0.8),
        onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
      );

  void _onQRViewCreated(QRViewController controller) {
    setState(() => this.controller = controller);
    controller.scannedDataStream.listen((barcode) {
      setState(() {
        this.barcode = barcode;
        // openDetail();
      });
    });
    // controller.scannedDataStream
    //     .listen((barcode) => setState(() => this.barcode = barcode));
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void reassamble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }
}
