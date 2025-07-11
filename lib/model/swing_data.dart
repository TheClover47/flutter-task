import 'dart:convert';
import 'package:flutter/services.dart';

class SwingData {
  final int id;
  final List<double> flexEx;
  final List<double> radUln;
  final List<double> capRot;

  SwingData({
    required this.id,
    required this.flexEx,
    required this.radUln,
    required this.capRot,
  });

  factory SwingData.fromJson(Map<String, dynamic> json) {
    final params = json['parameters'] ?? {};

    List<double> parseValues(String key) {
      final list = params[key]?['values'] ?? [];
      return List<double>.from(list.map((e) => (e as num).toDouble()));
    }

    return SwingData(
      id: json['id'] ?? 0,
      flexEx: parseValues('HFA_crWrFlexEx'),
      radUln: parseValues('HFA_crWrRadUln'),
      capRot: parseValues('HFA_glfCapRot'),
    );
  }
}

Future<List<SwingData>> loadSwingsFromAssets() async {
  final manifestContent = await rootBundle.loadString('AssetManifest.json');
  final Map<String, dynamic> manifestMap = json.decode(manifestContent);

  final swingFiles = manifestMap.keys
      .where((path) => path.contains('assets/') && path.endsWith('.json'))
      .toList();

  List<SwingData> swings = [];

  for (var i = 0; i < swingFiles.length; i++) {
    final path = swingFiles[i];
    final content = await rootBundle.loadString(path);
    final jsonData = json.decode(content);

    if (!jsonData.containsKey('id')) {
      jsonData['id'] = i + 1;
    }

    swings.add(SwingData.fromJson(jsonData));
  }

  return swings;
}
