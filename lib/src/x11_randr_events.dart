import 'x11_events.dart';
import 'x11_read_buffer.dart';
import 'x11_types.dart';
import 'x11_write_buffer.dart';

Set<X11RandrRotation> _decodeX11RandrRotation(int flags) {
  var rotation = <X11RandrRotation>{};
  for (var value in X11RandrRotation.values) {
    if ((flags & (1 << value.index)) != 0) {
      rotation.add(value);
    }
  }
  return rotation;
}

int _encodeX11RandrRotation(Set<X11RandrRotation> rotation) {
  var flags = 0;
  for (var value in rotation) {
    flags |= 1 << value.index;
  }
  return flags;
}

class X11RandrScreenChangeNotifyEvent extends X11Event {
  final int firstEventCode;
  final int root;
  final int requestWindow;
  final X11Size sizeInPixels;
  final X11Size sizeInMillimeters;
  final Set<X11RandrRotation> rotation;
  final int sizeId;
  final X11SubPixelOrder subPixelOrder;
  final int timestamp;
  final int configTimestamp;

  X11RandrScreenChangeNotifyEvent(this.firstEventCode,
      {this.root = 0,
      this.requestWindow = 0,
      this.sizeInPixels = const X11Size(0, 0),
      this.sizeInMillimeters = const X11Size(0, 0),
      this.rotation = const {X11RandrRotation.rotate0},
      this.sizeId = 0,
      this.subPixelOrder = X11SubPixelOrder.unknown,
      this.timestamp = 0,
      this.configTimestamp = 0});

  factory X11RandrScreenChangeNotifyEvent.fromBuffer(
      int firstEventCode, X11ReadBuffer buffer) {
    var rotation = _decodeX11RandrRotation(buffer.readUint8());
    var timestamp = buffer.readUint32();
    var configTimestamp = buffer.readUint32();
    var root = buffer.readUint32();
    var requestWindow = buffer.readUint32();
    var sizeId = buffer.readUint16();
    var subPixelOrder = X11SubPixelOrder.values[buffer.readUint16()];
    var widthInPixels = buffer.readUint16();
    var heightInPixels = buffer.readUint16();
    var widthInMillimeters = buffer.readUint16();
    var heightInMillimeters = buffer.readUint16();
    return X11RandrScreenChangeNotifyEvent(firstEventCode,
        root: root,
        requestWindow: requestWindow,
        rotation: rotation,
        timestamp: timestamp,
        configTimestamp: configTimestamp,
        sizeId: sizeId,
        subPixelOrder: subPixelOrder,
        sizeInPixels: X11Size(widthInPixels, heightInPixels),
        sizeInMillimeters: X11Size(widthInMillimeters, heightInMillimeters));
  }

  @override
  int encode(X11WriteBuffer buffer) {
    buffer.writeUint8(_encodeX11RandrRotation(rotation));
    buffer.writeUint32(timestamp);
    buffer.writeUint32(configTimestamp);
    buffer.writeUint32(root);
    buffer.writeUint32(requestWindow);
    buffer.writeUint16(sizeId);
    buffer.writeUint16(subPixelOrder.index);
    buffer.writeUint16(sizeInPixels.width);
    buffer.writeUint16(sizeInPixels.height);
    buffer.writeUint16(sizeInMillimeters.width);
    buffer.writeUint16(sizeInMillimeters.height);
    return firstEventCode;
  }

  @override
  String toString() =>
      'X11RandrScreenChangeNotifyEvent(root: ${root}, requestWindow: ${requestWindow}, sizeInPixels: ${sizeInPixels}, sizeInMillimeters: ${sizeInMillimeters}, rotation: ${rotation}, sizeId: ${sizeId}, subPixelOrder: ${subPixelOrder}, timestamp: ${timestamp}, configTimestamp: ${configTimestamp})';
}

class X11RandrCrtcChangeNotifyEvent extends X11Event {
  final int firstEventCode;
  final int requestWindow;
  final int crtc;
  final int mode;
  final Set<X11RandrRotation> rotation;
  final X11Rectangle area;
  final int timestamp;

  X11RandrCrtcChangeNotifyEvent(this.firstEventCode,
      {this.requestWindow = 0,
      this.crtc = 0,
      this.mode = 0,
      this.rotation = const {X11RandrRotation.rotate0},
      this.area = const X11Rectangle(0, 0, 0, 0),
      this.timestamp = 0});

  factory X11RandrCrtcChangeNotifyEvent.fromBuffer(
      int firstEventCode, X11ReadBuffer buffer) {
    var timestamp = buffer.readUint32();
    var requestWindow = buffer.readUint32();
    var crtc = buffer.readUint32();
    var mode = buffer.readUint32();
    var rotation = _decodeX11RandrRotation(buffer.readUint16());
    buffer.skip(2);
    var x = buffer.readInt16();
    var y = buffer.readInt16();
    var width = buffer.readUint16();
    var height = buffer.readUint16();
    return X11RandrCrtcChangeNotifyEvent(firstEventCode,
        requestWindow: requestWindow,
        crtc: crtc,
        mode: mode,
        rotation: rotation,
        area: X11Rectangle(x, y, width, height),
        timestamp: timestamp);
  }

  @override
  int encode(X11WriteBuffer buffer) {
    buffer.writeUint8(0);
    buffer.writeUint32(timestamp);
    buffer.writeUint32(requestWindow);
    buffer.writeUint32(crtc);
    buffer.writeUint32(mode);
    buffer.writeUint16(_encodeX11RandrRotation(rotation));
    buffer.skip(2);
    buffer.writeInt16(area.x);
    buffer.writeInt16(area.y);
    buffer.writeUint16(area.width);
    buffer.writeUint16(area.height);
    return firstEventCode + 1;
  }

  @override
  String toString() =>
      'X11RandrCrtcChangeNotifyEvent(requestWindow: ${requestWindow}, crtc: ${crtc}, mode: ${mode}, rotation: ${rotation}, area: ${area}, timestamp: ${timestamp})';
}

class X11RandrOutputChangeNotifyEvent extends X11Event {
  final int firstEventCode;
  final int requestWindow;
  final int output;
  final int crtc;
  final int mode;
  final Set<X11RandrRotation> rotation;
  final int connection;
  final X11SubPixelOrder subPixelOrder;
  final int timestamp;
  final int configTimestamp;

  X11RandrOutputChangeNotifyEvent(this.firstEventCode,
      {this.requestWindow = 0,
      this.output = 0,
      this.crtc = 0,
      this.mode = 0,
      this.rotation = const {X11RandrRotation.rotate0},
      this.connection = 0,
      this.subPixelOrder = X11SubPixelOrder.unknown,
      this.timestamp = 0,
      this.configTimestamp = 0});

  factory X11RandrOutputChangeNotifyEvent.fromBuffer(
      int firstEventCode, X11ReadBuffer buffer) {
    var timestamp = buffer.readUint32();
    var configTimestamp = buffer.readUint32();
    var requestWindow = buffer.readUint32();
    var output = buffer.readUint32();
    var crtc = buffer.readUint32();
    var mode = buffer.readUint32();
    var rotation = _decodeX11RandrRotation(buffer.readUint16());
    var connection = buffer.readUint8();
    var subPixelOrder = X11SubPixelOrder.values[buffer.readUint8()];
    return X11RandrOutputChangeNotifyEvent(firstEventCode,
        requestWindow: requestWindow,
        output: output,
        crtc: crtc,
        mode: mode,
        rotation: rotation,
        connection: connection,
        subPixelOrder: subPixelOrder,
        timestamp: timestamp,
        configTimestamp: configTimestamp);
  }

  @override
  int encode(X11WriteBuffer buffer) {
    buffer.writeUint8(1);
    buffer.writeUint32(timestamp);
    buffer.writeUint32(configTimestamp);
    buffer.writeUint32(requestWindow);
    buffer.writeUint32(output);
    buffer.writeUint32(crtc);
    buffer.writeUint32(mode);
    buffer.writeUint16(_encodeX11RandrRotation(rotation));
    buffer.writeUint8(connection);
    buffer.writeUint8(subPixelOrder.index);
    return firstEventCode + 1;
  }

  @override
  String toString() =>
      'X11RandrOutputChangeNotifyEvent(requestWindow: ${requestWindow}, output: {$output}, crtc: ${crtc}, mode: ${mode}, rotation: ${rotation}, connection: ${connection}, subPixelOrder: ${subPixelOrder}, timestamp: ${timestamp}, configTimestamp: ${configTimestamp})';
}

class X11RandrOutputPropertyNotifyEvent extends X11Event {
  final int firstEventCode;
  final int window;
  final int output;
  final int atom;
  final int state; // FIXME: enum
  final int timestamp;

  X11RandrOutputPropertyNotifyEvent(this.firstEventCode,
      {this.window = 0,
      this.output = 0,
      this.atom = 0,
      this.state = 0,
      this.timestamp = 0});

  factory X11RandrOutputPropertyNotifyEvent.fromBuffer(
      int firstEventCode, X11ReadBuffer buffer) {
    var window = buffer.readUint32();
    var output = buffer.readUint32();
    var atom = buffer.readUint32();
    var timestamp = buffer.readUint32();
    var state = buffer.readUint8();
    buffer.skip(11);
    return X11RandrOutputPropertyNotifyEvent(firstEventCode,
        window: window,
        output: output,
        atom: atom,
        state: state,
        timestamp: timestamp);
  }

  @override
  int encode(X11WriteBuffer buffer) {
    buffer.writeUint8(2);
    buffer.writeUint32(window);
    buffer.writeUint32(output);
    buffer.writeUint32(atom);
    buffer.writeUint32(timestamp);
    buffer.writeUint8(state);
    buffer.skip(11);
    return firstEventCode + 1;
  }

  @override
  String toString() =>
      'X11RandrOutputPropertyNotifyEvent(window: ${window}, output: {$output}, atom: ${atom}, state: ${state}, timestamp: ${timestamp})';
}

class X11RandrProviderChangeNotifyEvent extends X11Event {
  final int firstEventCode;
  final int requestWindow;
  final int provider;
  final int timestamp;

  X11RandrProviderChangeNotifyEvent(
    this.firstEventCode, {
    this.requestWindow = 0,
    this.provider = 0,
    this.timestamp = 0,
  });

  factory X11RandrProviderChangeNotifyEvent.fromBuffer(
      int firstEventCode, X11ReadBuffer buffer) {
    var timestamp = buffer.readUint32();
    var requestWindow = buffer.readUint32();
    var provider = buffer.readUint32();
    buffer.skip(16);
    return X11RandrProviderChangeNotifyEvent(
      firstEventCode,
      requestWindow: requestWindow,
      provider: provider,
      timestamp: timestamp,
    );
  }

  @override
  int encode(X11WriteBuffer buffer) {
    buffer.writeUint8(3);
    buffer.writeUint32(timestamp);
    buffer.writeUint32(requestWindow);
    buffer.writeUint32(provider);
    buffer.skip(16);
    return firstEventCode + 1;
  }

  @override
  String toString() =>
      'X11RandrProviderChangeNotifyEvent(requestWindow: ${requestWindow}, provider: {$provider}, timestamp: ${timestamp})';
}

class X11RandrProviderPropertyNotifyEvent extends X11Event {
  final int firstEventCode;
  final int window;
  final int provider;
  final int atom;
  final int state; // FIXME: enum
  final int timestamp;

  X11RandrProviderPropertyNotifyEvent(this.firstEventCode,
      {this.window = 0,
      this.provider = 0,
      this.atom = 0,
      this.state = 0,
      this.timestamp = 0});

  factory X11RandrProviderPropertyNotifyEvent.fromBuffer(
      int firstEventCode, X11ReadBuffer buffer) {
    var window = buffer.readUint32();
    var provider = buffer.readUint32();
    var atom = buffer.readUint32();
    var timestamp = buffer.readUint32();
    var state = buffer.readUint8();
    buffer.skip(11);
    return X11RandrProviderPropertyNotifyEvent(firstEventCode,
        window: window,
        provider: provider,
        atom: atom,
        state: state,
        timestamp: timestamp);
  }

  @override
  int encode(X11WriteBuffer buffer) {
    buffer.writeUint8(4);
    buffer.writeUint32(window);
    buffer.writeUint32(provider);
    buffer.writeUint32(atom);
    buffer.writeUint32(timestamp);
    buffer.writeUint8(state);
    buffer.skip(11);
    return firstEventCode + 1;
  }

  @override
  String toString() =>
      'X11RandrProviderPropertyNotifyEvent(window: ${window}, provider: {$provider}, atom: ${atom}, state: ${state}, timestamp: ${timestamp})';
}

class X11RandrResourceChangeNotifyEvent extends X11Event {
  final int firstEventCode;
  final int window;
  final int timestamp;

  X11RandrResourceChangeNotifyEvent(
    this.firstEventCode, {
    this.window = 0,
    this.timestamp = 0,
  });

  factory X11RandrResourceChangeNotifyEvent.fromBuffer(
      int firstEventCode, X11ReadBuffer buffer) {
    var timestamp = buffer.readUint32();
    var window = buffer.readUint32();
    buffer.skip(20);
    return X11RandrResourceChangeNotifyEvent(
      firstEventCode,
      window: window,
      timestamp: timestamp,
    );
  }

  @override
  int encode(X11WriteBuffer buffer) {
    buffer.writeUint8(5);
    buffer.writeUint32(timestamp);
    buffer.writeUint32(window);
    buffer.skip(20);
    return firstEventCode + 1;
  }

  @override
  String toString() =>
      'X11RandrResourceChangeNotifyEvent(window: ${window}, timestamp: ${timestamp})';
}

class X11RandrUnknownEvent extends X11Event {
  final int firstEventCode;
  final int subCode;
  final List<int> data;

  const X11RandrUnknownEvent(this.firstEventCode, this.subCode, this.data);

  factory X11RandrUnknownEvent.fromBuffer(
      int firstEventCode, int subCode, X11ReadBuffer buffer) {
    var data = buffer.readListOfUint8(27);
    return X11RandrUnknownEvent(firstEventCode, subCode, data);
  }

  @override
  int encode(X11WriteBuffer buffer) {
    buffer.writeUint8(subCode);
    buffer.writeListOfUint8(data);
    return firstEventCode + 1;
  }

  @override
  String toString() => 'X11RandrUnknownEvent(subCode: ${subCode})';
}
