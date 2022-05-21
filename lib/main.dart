
import 'package:AllMinerMonitor/ip_section/ip_range_model.dart';
import 'package:AllMinerMonitor/locales/messages.dart';
import 'package:AllMinerMonitor/pools_editor/pool_model.dart';
import 'package:AllMinerMonitor/scan_list/header_defaults.dart';
import 'package:AllMinerMonitor/scan_list/table_header_model.dart';
import 'package:AllMinerMonitor/service_record/record_model.dart';
import 'package:AllMinerMonitor/settings/header_list_model.dart';
import 'package:AllMinerMonitor/styles/d_l_theme.dart';
import 'package:AllMinerMonitor/ui/desktop_scan_screen.dart';
import 'package:AllMinerMonitor/utils/bindings.dart';
import 'package:AllMinerMonitor/visual_constructor/constructor_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  await Hive.initFlutter('All Miner');
  Hive.registerAdapter(IpRangeModelAdapter());
  Hive.registerAdapter(PoolAdapter());
  Hive.registerAdapter(TableHeaderModelAdapter());
  Hive.registerAdapter(HeadersListModelAdapter());
  Hive.registerAdapter(LayoutAdapter());
  Hive.registerAdapter(RigAdapter());
  Hive.registerAdapter(ShelfAdapter());
  Hive.registerAdapter(PlaceAdapter());
  Hive.registerAdapter(RecordModelAdapter());
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
  int? _octet = box.get('octet_count');
  if(_octet == null){
    box.put('octet_count', 2);
  }
  List<dynamic>? _creds = box.get('ant_passwords');
  if(_creds == null || _creds.isEmpty){
    box.put('ant_passwords', [{'root':'root'},]);
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
      initialBinding: InitBinding(),
      title: 'Avalon tool',
      theme: lightTheme,
      darkTheme: darkTheme,
      translations: Messages(),
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('en','US'),
      home: const DesktopScanScreen(),
      //home: LayoutScreen(),
    );
  }
}