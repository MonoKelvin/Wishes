import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/api_config.dart';

class SettingsState {
  final String appkey;
  final bool isSaving;

  const SettingsState({
    required this.appkey,
    this.isSaving = false,
  });

  SettingsState copyWith({
    String? appkey,
    bool? isSaving,
  }) {
    return SettingsState(
      appkey: appkey ?? this.appkey,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

final settingsProvider =
    NotifierProvider<SettingsNotifier, SettingsState>(() {
  return SettingsNotifier();
});

class SettingsNotifier extends Notifier<SettingsState> {
  @override
  SettingsState build() {
    _loadConfig();
    return SettingsState(
      appkey: ApiConfig.zhetaokeAppkey,
    );
  }

  Future<void> _loadConfig() async {
    await ApiConfig.loadFromStorage();
    state = SettingsState(
      appkey: ApiConfig.zhetaokeAppkey,
    );
  }

  void updateAppkey(String value) {
    state = state.copyWith(appkey: value);
  }

  Future<bool> save() async {
    state = state.copyWith(isSaving: true);
    try {
      ApiConfig.setConfig(appkey: state.appkey);
      await ApiConfig.saveToStorage();
      state = state.copyWith(isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(isSaving: false);
      return false;
    }
  }
}
