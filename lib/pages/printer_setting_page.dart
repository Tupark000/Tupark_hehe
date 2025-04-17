import 'package:flutter/material.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import '../services/printer_service.dart';

class PrinterSettingPage extends StatefulWidget {
  @override
  _PrinterSettingPageState createState() => _PrinterSettingPageState();
}

class _PrinterSettingPageState extends State<PrinterSettingPage> {
  final PrinterService _printerService = PrinterService();
  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _selectedDevice;
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _scanDevices();
  }

  Future<void> _scanDevices() async {
    setState(() {
      _isScanning = true;
    });

    try {
      final devices = await _printerService.scanForPrinters();
      setState(() {
        _devices = devices;
        _isScanning = false;
      });
    } catch (e) {
      print("❌ Error scanning for printers: $e");
      setState(() {
        _isScanning = false;
      });
    }
  }

  void _connectPrinter(BluetoothDevice device) async {
    await _printerService.connectToPrinter(device);
    setState(() {
      _selectedDevice = device;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ Connected to ${device.name}")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Bluetooth Printer")),
      body: _isScanning
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _devices.length,
              itemBuilder: (context, index) {
                final device = _devices[index];
                return ListTile(
                  title: Text(device.name ?? "Unknown"),
                  subtitle: Text(device.address ?? "No Address"),
                  trailing: _selectedDevice?.address == device.address
                      ? Icon(Icons.check, color: Colors.green)
                      : null,
                  onTap: () => _connectPrinter(device),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scanDevices,
        child: Icon(Icons.refresh),
        tooltip: "Scan Again",
      ),
    );
  }
}
