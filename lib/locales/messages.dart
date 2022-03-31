import 'package:avalon_tool/locales/eng.dart';
import 'package:avalon_tool/locales/ru.dart';
import 'package:get/get.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': en_US,
    'ru_ru': ru_RU,
  };
}
