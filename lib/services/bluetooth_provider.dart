import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BluetoothProvider with ChangeNotifier {
  final FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
  bool _bluetoothState = false;
  bool _isConnecting = false;
  BluetoothConnection? _connection;
  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _deviceConnected;
  String? _temperature;
  String? _humedad;
  int times = 0;

  bool get isBluetoothOn => _bluetoothState;
  bool get isConnecting => _isConnecting;
  BluetoothConnection? get connection => _connection;
  BluetoothDevice? get deviceConnected => _deviceConnected;
  List<BluetoothDevice> get devices => _devices;
  String? get temperature => _temperature;
  String? get humedad => _humedad;

  BluetoothProvider() {
    _init();
  }

  void _init() {
    _requestPermission();
    _restoreConnectedDevice();

    bluetooth.state.then((state) {
      _bluetoothState = state.isEnabled;
      notifyListeners();
    });

    bluetooth.onStateChanged().listen((state) {
      _bluetoothState = state.isEnabled;
      notifyListeners();
    });
  }

  Future<void> _requestPermission() async {
    await Permission.location.request();
    await Permission.bluetooth.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
  }

  Future<void> _saveConnectedDevice() async {
    final prefs = await SharedPreferences.getInstance();
    if (_deviceConnected != null) {
      await prefs.setString('connected_device', jsonEncode(_deviceConnected!.toMap()));
    } else {
      await prefs.remove('connected_device');
    }
  }

  Future<void> _restoreConnectedDevice() async {
    final prefs = await SharedPreferences.getInstance();
    final String? deviceJson = prefs.getString('connected_device');
    if (deviceJson != null) {
      _deviceConnected = BluetoothDevice.fromMap(jsonDecode(deviceJson));
      notifyListeners();
      _reconnectDevice(_deviceConnected!);
    }
  }

  Future<void> _reconnectDevice(BluetoothDevice device) async {
    _isConnecting = true;
    notifyListeners();
    try {
      _connection = await BluetoothConnection.toAddress(device.address);
      _deviceConnected = device;
      _receiveData();
      _recibe();
    } catch (e) {
      print('Could not reconnect: $e');
    } finally {
      _isConnecting = false;
      notifyListeners();
    }
  }

  void getDevices() async {
    var res = await bluetooth.getBondedDevices();
    _devices = res;
    notifyListeners();
  }

  void _receiveData() {
    _connection?.input?.listen((event) {
      String data = String.fromCharCodes(event);
      print('Received data: $data');
      //Formato "T:XX.XX"
      if (data.startsWith('T:')) {
        _temperature = data.substring(2).trim();
        notifyListeners();
      }
    });
  }

  void _recibe() {
    _connection?.input?.listen((event) {
      String data = String.fromCharCodes(event);
      print('Received data: $data');
      //Formato "T:XX.XX"
      if (data.startsWith('H:')) {
        _humedad = data.substring(2).trim();
        notifyListeners();
      }
    });
  }

  void ledStatus(bool status, int led) async {
    if (_connection?.isConnected ?? false) {
      String data = status ? '1,$led\n' : '0,$led\n';
      _connection?.output.add(ascii.encode(data));
      await _connection?.output.allSent;
      print("Data sent LED: $data");
    } else {
      print("Connection is not established.");
    }
  }

  void servoStatus(int furniture) async {
    if (_connection?.isConnected ?? false) {
      String data = '0,$furniture\n';
      _connection?.output.add(ascii.encode(data));
      await _connection?.output.allSent;
      print("Data sent SERVO: $data");
    } else {
      print("Connection is not established.");
    }
  }

  void connectToDevice(BluetoothDevice device) async {
    _isConnecting = true;
    notifyListeners();
    try {
      _connection = await BluetoothConnection.toAddress(device.address);
      print(_connection);
      _deviceConnected = device;
      _devices = [];
      _receiveData();
      _recibe();
      await _saveConnectedDevice();
    } finally {
      _isConnecting = false;
      notifyListeners();
    }
  }

  void disconnect() async {
    await _connection?.finish();
    _deviceConnected = null;
    await _saveConnectedDevice();
    notifyListeners();
  }
}
