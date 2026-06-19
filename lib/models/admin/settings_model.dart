class SettingsModel {
  final Map<String, dynamic> settings;

  SettingsModel({required this.settings});

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(settings: Map<String, dynamic>.from(json));
  }

  String getValue(String key) {
    return settings[key]?.toString() ?? '';
  }
}