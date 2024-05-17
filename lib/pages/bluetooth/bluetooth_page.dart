import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:mall_community/components/button/button.dart';
import 'package:mall_community/pages/bluetooth/bluetooth_pop.dart';
import 'package:mall_community/pages/bluetooth/characteristic_tile.dart';
import 'package:mall_community/pages/bluetooth/descriptor_tile.dart';
import 'package:mall_community/pages/bluetooth/server_title.dart';
import 'package:mall_community/utils/log/log.dart';

class BluetoothPage extends StatefulWidget {
  const BluetoothPage({super.key});

  @override
  State<BluetoothPage> createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  late StreamSubscription<BluetoothConnectionState>
      _connectionStateSubscription;
  late StreamSubscription<bool> _isConnectingSubscription;
  late StreamSubscription<bool> _isDisconnectingSubscription;
  late StreamSubscription<int> _mtuSubscription;
  bool _isDiscoveringServices = false;
  bool _isConnecting = false;
  bool _isDisconnecting = false;

  int? _rssi;
  int? _mtuSize;
  BluetoothDevice? _device;

  BluetoothConnectionState _connectionState =
      BluetoothConnectionState.disconnected;
  List<BluetoothService> _services = [];

  List list = [];

  getDevices(BuildContext context) async {
    var result = await showModalBottomSheet(
      context: context,
      constraints: const BoxConstraints.expand(),
      builder: (ctx) => const BluetoohPop(),
    );
    if (result != null && result.runtimeType == BluetoothDevice) {
      try {
        _device = result;
        setState(() {
          _isConnecting = true;
        });
        await result.connect();
        init(result);
      } catch (e) {
        Log.error(e);
        setState(() {
          _isConnecting = false;
        });
      }
    }
  }

  /// 获取蓝牙传递过来的数据
  Future onDiscoverServicesPressed() async {
    if (mounted) {
      setState(() {
        _isDiscoveringServices = true;
      });
    }
    try {
      _services = await _device!.discoverServices();
    } catch (e) {}
    if (mounted) {
      setState(() {
        _isDiscoveringServices = false;
      });
    }
  }

  init(BluetoothDevice device) {
    _connectionStateSubscription = device.connectionState.listen((state) async {
      _connectionState = state;
      if (state == BluetoothConnectionState.connected) {
        _services = []; // must rediscover services
      }
      if (state == BluetoothConnectionState.connected && _rssi == null) {
        _rssi = await device.readRssi();
      }
      if (mounted) {
        setState(() {});
      }
    });
    _mtuSubscription = device.mtu.listen((value) {
      _mtuSize = value;
      if (mounted) {
        setState(() {});
      }
    });
  }

  stop() {
    FlutterBluePlus.stopScan();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _isConnectingSubscription.cancel();
    _isDisconnectingSubscription.cancel();
    _mtuSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("蓝牙测试"),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Button(
            onPressed: () {
              getDevices(context);
            },
            text: "开始扫描",
          ),
          const SizedBox(height: 10),
          Button(
            onPressed: stop,
            text: "停止扫描",
          ),
          if (_isConnecting) Text("当前设备：${getDeviceName()}"),
          ListTile(
            leading: buildRssiTile(context),
            title: Text('设备连接状态 ${_connectionState.toString().split('.')[1]}.'),
            trailing: buildGetServices(context),
          ),
          if (_device != null) ..._buildServiceTiles(context, _device!),
        ]),
      ),
    );
  }

  String getDeviceName() {
    return _device!.remoteId.str;
  }

  Widget buildRssiTile(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _isConnecting
            ? const Icon(Icons.bluetooth_connected)
            : const Icon(Icons.bluetooth_disabled),
        Text(((_isConnecting && _rssi != null) ? '${_rssi!} dBm' : ''),
            style: Theme.of(context).textTheme.bodySmall)
      ],
    );
  }

  Widget buildGetServices(BuildContext context) {
    return IndexedStack(
      index: (_isDiscoveringServices) ? 1 : 0,
      children: <Widget>[
        TextButton(
          onPressed: onDiscoverServicesPressed,
          child: const Text("获取设备服务通道"),
        ),
        const IconButton(
          icon: SizedBox(
            width: 18.0,
            height: 18.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.grey),
            ),
          ),
          onPressed: null,
        )
      ],
    );
  }

  List<Widget> _buildServiceTiles(BuildContext context, BluetoothDevice d) {
    return _services
        .map(
          (s) => ServiceTile(
            service: s,
            characteristicTiles: s.characteristics
                .map((c) => _buildCharacteristicTile(c))
                .toList(),
          ),
        )
        .toList();
  }

  CharacteristicTile _buildCharacteristicTile(BluetoothCharacteristic c) {
    return CharacteristicTile(
      characteristic: c,
      descriptorTiles:
          c.descriptors.map((d) => DescriptorTile(descriptor: d)).toList(),
    );
  }
}

class ScanResultTile extends StatefulWidget {
  const ScanResultTile({Key? key, required this.result, this.onTap})
      : super(key: key);

  final ScanResult result;
  final VoidCallback? onTap;

  @override
  State<ScanResultTile> createState() => _ScanResultTileState();
}

class _ScanResultTileState extends State<ScanResultTile> {
  BluetoothConnectionState _connectionState =
      BluetoothConnectionState.disconnected;

  late StreamSubscription<BluetoothConnectionState>
      _connectionStateSubscription;

  @override
  void initState() {
    super.initState();

    _connectionStateSubscription =
        widget.result.device.connectionState.listen((state) {
      _connectionState = state;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _connectionStateSubscription.cancel();
    super.dispose();
  }

  String getNiceHexArray(List<int> bytes) {
    return '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}]';
  }

  String getNiceManufacturerData(List<List<int>> data) {
    return data
        .map((val) => '${getNiceHexArray(val)}')
        .join(', ')
        .toUpperCase();
  }

  String getNiceServiceData(Map<Guid, List<int>> data) {
    return data.entries
        .map((v) => '${v.key}: ${getNiceHexArray(v.value)}')
        .join(', ')
        .toUpperCase();
  }

  String getNiceServiceUuids(List<Guid> serviceUuids) {
    return serviceUuids.join(', ').toUpperCase();
  }

  bool get isConnected {
    return _connectionState == BluetoothConnectionState.connected;
  }

  Widget _buildTitle(BuildContext context) {
    if (widget.result.device.platformName.isNotEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.result.device.platformName,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            widget.result.device.remoteId.str,
            style: Theme.of(context).textTheme.bodySmall,
          )
        ],
      );
    } else {
      return Text(widget.result.device.remoteId.str);
    }
  }

  Widget _buildConnectButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      onPressed:
          (widget.result.advertisementData.connectable) ? widget.onTap : null,
      child: isConnected ? const Text('停止链接') : const Text('链接'),
    );
  }

  Widget _buildAdvRow(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.apply(color: Colors.black),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var adv = widget.result.advertisementData;
    return SingleChildScrollView(
      child: ExpansionTile(
        title: _buildTitle(context),
        leading: Text(widget.result.rssi.toString()),
        trailing: _buildConnectButton(context),
        children: <Widget>[
          if (adv.advName.isNotEmpty)
            _buildAdvRow(context, 'Name', adv.advName),
          if (adv.txPowerLevel != null)
            _buildAdvRow(context, '发送功率等级', '${adv.txPowerLevel}'),
          if ((adv.appearance ?? 0) > 0)
            _buildAdvRow(
                context, '广播外观', '0x${adv.appearance!.toRadixString(16)}'),
          if (adv.msd.isNotEmpty)
            _buildAdvRow(context, '制造商', getNiceManufacturerData(adv.msd)),
          if (adv.serviceUuids.isNotEmpty)
            _buildAdvRow(
                context, '服务 UUIDs', getNiceServiceUuids(adv.serviceUuids)),
          if (adv.serviceData.isNotEmpty)
            _buildAdvRow(context, '服务 数据', getNiceServiceData(adv.serviceData)),
        ],
      ),
    );
  }
}
