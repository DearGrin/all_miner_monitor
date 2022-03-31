
import 'package:avalon_tool/ip_section/ip_range_model.dart';
import 'package:avalon_tool/locales/messages.dart';
import 'package:avalon_tool/pools_editor/pool_model.dart';
import 'package:avalon_tool/scan_list/header_defaults.dart';
import 'package:avalon_tool/scan_list/table_header_model.dart';
import 'package:avalon_tool/settings/header_list_model.dart';
import 'package:avalon_tool/styles/d_l_theme.dart';
import 'package:avalon_tool/ui/desktop_scan_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(IpRangeModelAdapter());
  Hive.registerAdapter(PoolAdapter());
  Hive.registerAdapter(TableHeaderModelAdapter());
  Hive.registerAdapter(HeadersListModelAdapter());
  checkSettings();
  //TODO check all adapters
  runApp(const MyApp());
}
checkSettings() async {
  var box = await Hive.openBox('Settings');
  List<dynamic>? _headers =  box.get('headers');
  if(_headers == null)
    {
      debugPrint('headers are null');
      box.put('headers', headersDefault);
    }
 // box.close();
  //TODO add warnings params
  bool _isDarkMode = box.get('dark_mode')??true;
  String? _language = box.get('language');
  Locale _l;
  if(_language!=null){
    switch(_language){
      case 'english':
        _l = const Locale('en','US');
        break;
      case 'русский':
        _l = const Locale('ru','RU');
        break;
      default:
          _l = Get.deviceLocale?? const Locale('en','US');
          break;
    }
    Get.updateLocale(_l);
  }
  Get.changeThemeMode(_isDarkMode? ThemeMode.dark:ThemeMode.light);

}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Avalon tool',
      theme: lightTheme,
      darkTheme: darkTheme,
      translations: Messages(),
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('en','US'),
      home: const DesktopScanScreen(),
    );
  }
}