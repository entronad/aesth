void _mix(Map<String, Object> dist, Map<String, Object> src) {
  for (final key in src.keys) {
    if(src[key] != null) {
      dist[key] = src[key];
    }
  }
}

Map<String, Object> mix(List<Map<String, Object>> maps) {
  final rst = maps[0];
  for (var i = 1; i < maps.length; i++) {
    _mix(rst, maps[i]);
  }
  return rst;
}

void _deepMix(Map<String, Object> dist, Map<String, Object> src, [int level = 0]) {
  const maxLevel = 5;
  for (final key in src.keys) {
    final value = src[key];
    if (value is Map<String, Object>) {
      if (!(dist[key] is Map<String, Object>)) {
        dist[key] = <String, Object>{};
      }
      if (level < maxLevel) {
        _deepMix(dist[key], value, level + 1);
      } else {
        dist[key] = src[key];
      }
    } else if(value is List) {
      dist[key] = [...value];
    } else if(value != null) {
      dist[key] = value;
    }
  }
}

Map<String, Object> deepMix(List<Map<String, Object>> maps) {
  final rst = maps[0];
  for (var i = 1; i < maps.length; i++) {
    _deepMix(rst, maps[i]);
  }
  return rst;
}
