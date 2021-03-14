import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_reader_app/bloc/scan_bloc.dart';
import 'package:qr_reader_app/models/scan_model.dart';
import 'package:qr_reader_app/pages/adresses_page.dart';
import 'package:qr_reader_app/pages/maps_page.dart';
import 'package:qr_reader_app/utils/utils.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  final scansBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _callPage(currentIndex),
      bottomNavigationBar: _buildBottomNavigation(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: () {
          _scanQR();
        },
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text('QR Scanner'),
        actions: [
          IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: scansBloc.deleteAllScans),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
        BottomNavigationBarItem(
            icon: Icon(Icons.brightness_5), label: 'Adresses'),
      ],
    );
  }

  Widget _callPage(int currentPage) {
    switch (currentPage) {
      case 0:
        return MapsPage();
      case 1:
        return AdressesPage();
      default:
        return MapsPage();
    }
  }

  void _scanQR() async {
    // https://taxiaki.net
    // https://maps.google.com/local?q=51.049259,13.73836

    String futureString = 'https://taxiaki.net';

    try {
      futureString = await scanner.scan();
    } catch (e) {
      futureString = e.toString();
    }

    print('Future String: $futureString');

    if (futureString != null) {
      final scan = ScanModel(value: futureString);
      scansBloc.addScan(scan);
      openScan(context, scan);
    }
  }
}
