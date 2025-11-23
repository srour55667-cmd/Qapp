import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qapp/services/notificationservices/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DhikrState {
  final bool enabled;

  DhikrState({required this.enabled});

  DhikrState copyWith({bool? enabled}) {
    return DhikrState(enabled: enabled ?? this.enabled);
  }
}

class DhikrCubit extends Cubit<DhikrState> {
  DhikrCubit() : super(DhikrState(enabled: true)) {
    loadSetting();
  }

  // تحميل حالة السويتش عند بداية التطبيق
  Future<void> loadSetting() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool('dhikr_enabled') ?? true;
    emit(state.copyWith(enabled: value));
  }

  // تشغيل / ايقاف الذكر
  Future<void> toggleDhikr(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dhikr_enabled', value);

    emit(state.copyWith(enabled: value));

    if (value) {
      NotificationService.scheduleDhikrAfterTwoHours();
    } else {
      NotificationService.cancelDhikr();
    }
  }
}
