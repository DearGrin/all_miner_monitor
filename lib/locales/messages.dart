import 'package:AllMinerMonitor/locales/eng.dart';
import 'package:AllMinerMonitor/locales/ru.dart';
import 'package:get/get.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': en_US,
    'ru_ru': ru_RU,
  };
}
