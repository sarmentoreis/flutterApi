import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:convert';


class QrCodePage extends StatefulWidget {
  const QrCodePage({Key? key}) : super(key: key);

  @override
  State<QrCodePage> createState() => _QrCodePageState();
}
final LocalStorage storage = LocalStorage('localstorage_app');

void addItemsToLocalStorage(item) {
  // storage.setItem('name', 'Abolfazl');
  // storage.setItem('family', 'Roshanzamir');

  final info = json.encode({'apiUrl': item});
  storage.setItem('info', info);
  getitemFromLocalStorage();
}

void getitemFromLocalStorage() {

  Map<String, dynamic> info = json.decode(storage.getItem('info'));

 
}

class _QrCodePageState extends State<QrCodePage> {
  String ticket = '';
  List<String> tickets = [];

  readQRCode() async {
    String code = await FlutterBarcodeScanner.scanBarcode(
      "#FFFFFF",
      "Cancelar",
      false,
      ScanMode.QR,
    );
    setState(() => ticket = code != '-1' ? code : 'Não validado');

    addItemsToLocalStorage(ticket);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (ticket != '')
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Text(
                  'Ticket: $ticket',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ElevatedButton.icon(
              onPressed: readQRCode,
              icon: const Icon(Icons.qr_code),
              label: const Text('Validar'),
            ),
          ],
        ),
      ),
    );
  }
}
