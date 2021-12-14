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

  open() async {
    final params = ProtocolParameters(
      timeout: 3000,
      command: BuzzaoBleCommands.openSession,
    );
    await api.connect('70:B3:D5:7B:12:1D');
    final result = await api.send(params, opendata);
    await api.sendAck(result[1]);
    print('Resultado: $result');
    final r = BuzzaoBleProtocol.result(result);
    print('Tipo: $r');
    api.disconnect();
  }

  close() async {
    final closingSession = CloseCashierSend(
      operatorId: '02df37bc-ef3e-4c4d-9027-a1efc4cfc102',
    );
    final data = Uint8List.fromList(jsonEncode(closingSession).codeUnits);
    final params = ProtocolParameters(
      timeout: 3000,
      command: BuzzaoBleCommands.closeSession,
    );

    await api.connect('70:B3:D5:7B:12:1D');
    final result = await api.send(params, data);
    await api.sendAck(result[1]);
    print('Resultado: $result');
    final r = BuzzaoBleProtocol.result(result);
    print('Tipo: $r');
    api.disconnect();
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

final opendata = Uint8List.fromList([
  1,
  5,
  0,
  206,
  123,
  34,
  116,
  105,
  109,
  101,
  115,
  116,
  97,
  109,
  112,
  34,
  58,
  49,
  54,
  51,
  57,
  52,
  56,
  56,
  56,
  54,
  52,
  44,
  34,
  102,
  97,
  114,
  101,
  67,
  111,
  100,
  101,
  34,
  58,
  49,
  44,
  34,
  114,
  111,
  117,
  116,
  101,
  73,
  100,
  34,
  58,
  34,
  48,
  48,
  100,
  57,
  97,
  100,
  50,
  54,
  45,
  102,
  52,
  49,
  56,
  45,
  52,
  56,
  102,
  53,
  45,
  97,
  98,
  48,
  52,
  45,
  57,
  53,
  100,
  100,
  50,
  57,
  102,
  55,
  50,
  53,
  101,
  99,
  34,
  44,
  34,
  111,
  112,
  101,
  114,
  97,
  116,
  111,
  114,
  73,
  100,
  34,
  58,
  34,
  100,
  56,
  98,
  53,
  48,
  55,
  49,
  101,
  45,
  56,
  53,
  50,
  49,
  45,
  52,
  100,
  97,
  100,
  45,
  56,
  52,
  101,
  51,
  45,
  102,
  98,
  52,
  48,
  99,
  54,
  57,
  54,
  53,
  49,
  97,
  101,
  34,
  44,
  34,
  103,
  97,
  116,
  101,
  67,
  111,
  117,
  110,
  116,
  101,
  114,
  34,
  58,
  51,
  44,
  34,
  114,
  111,
  117,
  116,
  101,
  68,
  105,
  114,
  101,
  99,
  116,
  105,
  111,
  110,
  34,
  58,
  48,
  44,
  34,
  102,
  97,
  114,
  101,
  115,
  34,
  58,
  110,
  117,
  108,
  108,
  44,
  34,
  99,
  108,
  97,
  115,
  115,
  101,
  115,
  82,
  117,
  108,
  101,
  115,
  34,
  58,
  110,
  117,
  108,
  108,
  125,
  160,
  207
]);
