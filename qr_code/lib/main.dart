import 'package:flutter/material.dart';
import 'package:qr_code/qrcode_page.dart';
void main() {
  runApp(MaterialApp(
    title: "Leitor de QrCode",
    debugShowCheckedModeBanner: false,
    home: QRCodePage(),
  ));
}

