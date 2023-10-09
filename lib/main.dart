//
// import 'package:flutter/material.dart';
// import 'package:wifi_iot/wifi_iot.dart';
//
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: WifiListScreen(),
//     );
//   }
// }
//
// class WifiListScreen extends StatefulWidget {
//   @override
//   _WifiListScreenState createState() => _WifiListScreenState();
// }
//
// class _WifiListScreenState extends State<WifiListScreen> {
//   List<WifiNetwork> _wifiList = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _getWifiList();
//   }
//
//   Future<void> _getWifiList() async {
//     try {
//       await WiFiForIoTPlugin.setEnabled(true);
//       List<WifiNetwork> wifiList = await WiFiForIoTPlugin.loadWifiList();
//       setState(() {
//         _wifiList = wifiList;
//       });
//     } catch (e) {
//       print('Error fetching Wi-Fi data: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Wi-Fi Networks'),
//       ),
//       body: ListView.builder(
//         itemCount: _wifiList.length,
//         itemBuilder: (context, index) {
//           final wifi = _wifiList[index];
//           return ListTile(
//             title: Text(
//               'SSID: ${wifi.ssid ?? "N/A"}'
//             ),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('BSSID: ${wifi.bssid}'),
//                 Text('Signal Strength: ${wifi.level} dBm'),
//                 Text('Frequency: ${wifi.frequency} MHz'),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }



import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wifi_iot/wifi_iot.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WifiListScreen(),
    );
  }
}

class WifiListScreen extends StatefulWidget {
  @override
  _WifiListScreenState createState() => _WifiListScreenState();
}

class _WifiListScreenState extends State<WifiListScreen> {
  List<WifiNetwork> _wifiList = [];
  late Timer _timer;
  static const refreshInterval = Duration(seconds: 10); // Adjust as needed

  @override
  void initState() {
    super.initState();
    _startFetchingData();
  }

  void _startFetchingData() {
    _fetchWifiData(); // Initial data fetch
    _timer = Timer.periodic(refreshInterval, (_) {
      _fetchWifiData(); // Periodically fetch data
    });
  }

  Future<void> _fetchWifiData() async {
    try {
      await WiFiForIoTPlugin.setEnabled(true);
      List<WifiNetwork> wifiList = await WiFiForIoTPlugin.loadWifiList();
      setState(() {
        _wifiList = wifiList;
      });
    } catch (e) {
      print('Error fetching Wi-Fi data: $e');
    }
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wi-Fi Networks'),
      ),
      body: ListView.builder(
        itemCount: _wifiList.length,
        itemBuilder: (context, index) {
          final wifi = _wifiList[index];
          return ListTile(
            title: Text(wifi.ssid ?? 'Unknown SSID'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('BSSID: ${wifi.bssid ?? 'Unknown BSSID'}'),
                Text('Signal Strength: ${wifi.level} dBm'),
                Text('Frequency: ${wifi.frequency} MHz'),
              ],
            ),
          );
        },
      ),
    );
  }
}
