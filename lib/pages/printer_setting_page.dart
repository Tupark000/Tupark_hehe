// import 'package:flutter/material.dart';
// import 'package:blue_thermal_printer/blue_thermal_printer.dart';
// import '../services/printer_service.dart';

// class PrinterSettingPage extends StatefulWidget {
//   @override
//   _PrinterSettingPageState createState() => _PrinterSettingPageState();
// }

// class _PrinterSettingPageState extends State<PrinterSettingPage> {
//   final PrinterService _printerService = PrinterService();
//   List<BluetoothDevice> _devices = [];
//   BluetoothDevice? _selectedDevice;
//   bool _isScanning = false;

//   @override
//   void initState() {
//     super.initState();
//     _scanDevices();
//   }

//   Future<void> _scanDevices() async {
//     setState(() {
//       _isScanning = true;
//     });

//     try {
//       final devices = await _printerService.scanForPrinters();
//       setState(() {
//         _devices = devices;
//         _isScanning = false;
//       });
//     } catch (e) {
//       print("❌ Error scanning for printers: $e");
//       setState(() {
//         _isScanning = false;
//       });
//     }
//   }

//   void _connectPrinter(BluetoothDevice device) async {
//     await _printerService.connectToPrinter(device);
//     setState(() {
//       _selectedDevice = device;
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("✅ Connected to ${device.name}")),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Select Bluetooth Printer")),
//       body: _isScanning
//           ? Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: _devices.length,
//               itemBuilder: (context, index) {
//                 final device = _devices[index];
//                 return ListTile(
//                   title: Text(device.name ?? "Unknown"),
//                   subtitle: Text(device.address ?? "No Address"),
//                   trailing: _selectedDevice?.address == device.address
//                       ? Icon(Icons.check, color: Colors.green)
//                       : null,
//                   onTap: () => _connectPrinter(device),
//                 );
//               },
//             ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _scanDevices,
//         child: Icon(Icons.refresh),
//         tooltip: "Scan Again",
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:blue_thermal_printer/blue_thermal_printer.dart';
// import '../services/printer_service.dart';

// class PrinterSettingPage extends StatefulWidget {
//   @override
//   _PrinterSettingPageState createState() => _PrinterSettingPageState();
// }

// class _PrinterSettingPageState extends State<PrinterSettingPage> {
//   final PrinterService _printerService = PrinterService();
//   List<BluetoothDevice> devices = [];
//   BluetoothDevice? selectedDevice;
//   bool isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadBondedPrinters();
//   }

//   Future<void> _loadBondedPrinters() async {
//     setState(() => isLoading = true);
//     try {
//       final result = await _printerService.scanForPrinters();
//       setState(() {
//         devices = result;
//         isLoading = false;
//       });
//     } catch (e) {
//       print("❌ Failed to scan: $e");
//       setState(() => isLoading = false);
//     }
//   }

//   void _connectToDevice(BluetoothDevice device) async {
//     try {
//       await _printerService.connectToPrinter(device);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("✅ Connected to ${device.name}")),
//       );
//       setState(() => selectedDevice = device);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("❌ Connection failed: $e")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Printer Settings'),
//         centerTitle: true,
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : devices.isEmpty
//               ? Center(child: Text("No bonded printers found."))
//               : ListView.builder(
//                   itemCount: devices.length,
//                   itemBuilder: (context, index) {
//                     final device = devices[index];
//                     return ListTile(
//                       title: Text(device.name ?? "Unknown Device"),
//                       subtitle: Text(device.address ?? ""),
//                       trailing: selectedDevice?.address == device.address
//                           ? Icon(Icons.check_circle, color: Colors.green)
//                           : null,
//                       onTap: () => _connectToDevice(device),
//                     );
//                   },
//                 ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import '../services/printer_service.dart';

class PrinterSettingPage extends StatefulWidget {
  @override
  _PrinterSettingPageState createState() => _PrinterSettingPageState();
}

class _PrinterSettingPageState extends State<PrinterSettingPage> {
  final PrinterService _printerService = PrinterService();
  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadBondedPrinters();
  }

  Future<void> _loadBondedPrinters() async {
    setState(() => isLoading = true);
    try {
      final result = await _printerService.scanForPrinters();
      setState(() {
        devices = result;
        isLoading = false;
      });
    } catch (e) {
      print("❌ Failed to scan: $e");
      setState(() => isLoading = false);
    }
  }

  void _connectToDevice(BluetoothDevice device) async {
    try {
      await _printerService.connectToPrinter(device);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ Connected to ${device.name}")),
      );
      setState(() => selectedDevice = device);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Connection failed: $e")),
      );
    }
  }

  void _disconnectPrinter() {
    _printerService.disconnect();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("🔌 Printer disconnected")),
    );
    setState(() {
      selectedDevice = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Printer Settings'),
        backgroundColor: Colors.red[400],
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Available Bonded Printers",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.red[700],
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: devices.isEmpty
                        ? Center(
                            child: Text(
                              "No bonded printers found.",
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.separated(
                            itemCount: devices.length,
                            separatorBuilder: (_, __) => SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final device = devices[index];
                              final isSelected = selectedDevice?.address == device.address;

                              return ListTile(
                                tileColor: isSelected
                                    ? Colors.red[100]
                                    : Colors.grey[100],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                leading: Icon(Icons.print, color: Colors.red[300]),
                                title: Text(device.name ?? "Unknown Device"),
                                subtitle: Text(device.address ?? ""),
                                trailing: isSelected
                                    ? Icon(Icons.check_circle, color: Colors.green)
                                    : null,
                                onTap: () => _connectToDevice(device),
                              );
                            },
                          ),
                  ),
                  if (selectedDevice != null) ...[
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _disconnectPrinter,
                      icon: Icon(Icons.cancel),
                      label: Text("Disconnect Printer"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[400],
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ]
                ],
              ),
      ),
    );
  }
}
