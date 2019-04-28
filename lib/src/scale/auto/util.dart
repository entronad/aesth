double _getFactor(num v) {
  var factor = 1.0;
  if (v == double.infinity || v == double.negativeInfinity) {
    throw Exception('Not support Infinity!');
  }
  if (v < 1) {
    while (v < 1) {
      factor = factor / 10;
      v = v * 10;
    }
  } else {
    while (v > 10) {
      factor = factor * 10;
      v = v / 10;
    }
  }

  return factor;
}

// Less then current value.
num _arrayFloor(List<num> values, num value) {
  final length = values.length;
  if(length == 0) {
    return double.nan;
  }

  var pre = values[0];

  if (value < values[0]) {
    return double.nan;
  }

  if (value >= values.last) {
    return values.last;
  }
  for (var v in values) {
    if (value < v) {
      break;
    }
    pre = v;
  }

  return pre;
}

// First greater then current value.
num _arrayCeiling(List<num> values, num value) {
  final length = values.length;
  if(length == 0) {
    return double.nan;
  }

  var rst;

  if (value > values.last) {
    return double.nan;
  }

  if (value < values[0]) {
    return values[0];
  }
  for (var v in values) {
    if (value <= v) {
      rst = v;
      break;
    }
  }

  return rst;
}

enum SnapType {
  floor,
  ceil,
}

num snapTo(List<num> values, num value) {
  final floorVal = _arrayFloor(values, value);
  final ceilingVal = _arrayCeiling(values, value);
  if (floorVal.isNaN || ceilingVal.isNaN) {
    if (values[0] >= value) {
      return values[0];
    }
    final last = values.last;
    if (last <= value) {
      return last;
    }
  }
  if ((value - floorVal).abs() < (ceilingVal - value).abs()) {
    return floorVal;
  }
  return ceilingVal;
}

num snapFloor(List<num> values, num value) =>
  _arrayFloor(values, value);

num snapCeiling(List<num> values, num value) =>
  _arrayCeiling(values, value);

num snapFactorTo(num v, List<num> arr, SnapType snapType) {
  if (v.isNaN) {
    return double.nan;
  }
  var factor = 1.0;
  if (v != 0) {
    if (v < 0) {
      factor = -1;
    }
    v = v * factor;
    final tmpFactor = _getFactor(v);
    factor = factor * tmpFactor;

    v = v / tmpFactor;
  }
  if (snapType == SnapType.floor) {
    v = snapFloor(arr, v);
  } else if (snapType == SnapType.ceil) {
    v = snapCeiling(arr, v);
  } else {
    v = snapTo(arr, v);
  }

  final rst = v * factor;

  return rst;
}

num snapMultiple(num v, num base, SnapType snapType) {
  var div;
  if (snapType == SnapType.ceil) {
    div = (v / base).ceil();
  } else if (snapType == SnapType.floor) {
    div = (v / base).floor();
  } else {
    div = (v / base).round();
  }
  return div * base;
}

num fixedBase(num v, num base) {
  final str = base.toString();
  if (base is int) {
    return v.round();
  }
  var length = str.split('.').last.length;
  if (length > 20) {
    length = 20;
  }
  return num.parse(v.toStringAsFixed(length));
}