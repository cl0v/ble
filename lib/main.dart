import 'dart:convert';
import 'dart:typed_data';

import 'package:buzzao_ble_protocol/buzzao_ble_protocol.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  BleApi api = BleApi();

  BuzzaoBle? response;
  Uint8List? uint;

  open() async {}

  close() async {
    await api.connect('70:B3:D5:7B:12:1D');
    CloseCashierSend _closingSession = CloseCashierSend(
      operatorId: '02df37bc-ef3e-4c4d-9027-a1efc4cfc102',
    );
    final data = Uint8List.fromList(jsonEncode(_closingSession).codeUnits);
    final params = ProtocolParameters(
      macAddress: '70:B3:D5:7B:12:1D',
      timeout: 3000,
      command: BuzzaoBleCommands.closeSession,
    );
    api.send(params, data);
    await Future.delayed(Duration(seconds: 6));
    print('uint: $uint');
    if (uint == null) return;
    if (uint!.length <= 2) return;
    api.send(
      ProtocolParameters(
          macAddress: '70:B3:D5:7B:12:1D',
          timeout: 3000,
          command: uint![1],
          ack: true),
      null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  const Text('Dados recebidos: '),
                  StreamBuilder<Uint8List>(
                    stream: api.onDataReceive,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Text('Sem dados');
                      }
                      if (snapshot.data != null) {
                        uint = snapshot.data;
                        response = BuzzaoBleProtocol.result(snapshot.data);
                        return Text(
                          response.toString(),
                        );
                      }
                      return const Text('Aguardando...');
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      api.disconnect();
                    },
                    child: Text('Desconectar'),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Abrir'),
                  ),
                  ElevatedButton(
                    onPressed: close,
                    child: Text('Fechar'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
