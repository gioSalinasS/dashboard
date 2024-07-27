import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dashboard/services/bluetooth_provider.dart';

class Conection extends StatefulWidget {
  const Conection({super.key});

  @override
  State<Conection> createState() => _ConectionState();
}

class _ConectionState extends State<Conection> {
  @override
  Widget build(BuildContext context) {
    final bluetoothProvider = Provider.of<BluetoothProvider>(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _controlBT(bluetoothProvider),
        _infoDevice(bluetoothProvider),
        _listDevices(bluetoothProvider),
      ],
    );
  }

  Widget _controlBT(BluetoothProvider bluetoothProvider) {
    return SwitchListTile(
      value: bluetoothProvider.isBluetoothOn,
      onChanged: (bool value) async {
        if (value) {
          await bluetoothProvider.bluetooth.requestEnable();
        } else {
          await bluetoothProvider.bluetooth.requestDisable();
        }
      },
      tileColor: Colors.white,
      title: Text(
        bluetoothProvider.isBluetoothOn ? "Bluetooth: ON" : "Bluetooth: OFF",
      ),
    );
  }

  Widget _infoDevice(BluetoothProvider bluetoothProvider) {
    return SingleChildScrollView(
      child: ListTile(
        tileColor: Colors.white,
        title:  Text("Conectado a: ${bluetoothProvider.deviceConnected?.name ?? "ninguno"}"),
        trailing: bluetoothProvider.connection?.isConnected ?? false
            ? TextButton(
                onPressed: () async {
                  bluetoothProvider.disconnect();
                },
                child: const Text("Desconectar"),
              )
            : TextButton(
                onPressed: bluetoothProvider.getDevices,
                child: const Text("Ver dispositivos"),
              ),
      ),
    );
  }

  Widget _listDevices(BluetoothProvider bluetoothProvider) {
    return bluetoothProvider.isConnecting
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.5,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...[
                      for (final device in bluetoothProvider.devices)
                        SafeArea(
                          child: ListTile(
                            title: Text(device.name ?? device.address),
                            trailing: TextButton(
                              child: const Text('Conectar'),
                              onPressed: () {
                                print(("conectado"));
                                bluetoothProvider.connectToDevice(device);
                              },
                            ),
                          ),
                        )
                    ]
                  ],
                ),
              ),
            ),
          );
  }
}