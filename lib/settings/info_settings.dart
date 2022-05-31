import 'package:AllMinerMonitor/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class InfoSettings extends GetView<SettingsController> {
  const InfoSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: ScrollController(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(width: 20.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
              const SizedBox(
                  width: 100,
                  height: 100,
                  child: Image(image: AssetImage('lib/assets/logo.png'), fit: BoxFit.contain,)),
              const SizedBox(width: 20.0,),
              Text('All Miner Monitor', style: Get.textTheme.bodyText2,),
            ],
          ),
          Text(
              'info_content'.tr,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Row(
            children: [
              Text('tg_channel'.tr, style:  Get.textTheme.bodyText1,),
              const SizedBox(width: 10.0,),
              InkWell(
                  onTap: (){},
                  child: SelectableText('https://t.me/+ABaUPFp6VtNiZTky', style: Get.textTheme.bodyText1?.copyWith(decoration: TextDecoration.underline),onTap: (){controller.openLink('https://t.me/+ABaUPFp6VtNiZTky');},))
            ],
          ),
          Row(
            children: [
              Row(
                children: [
                  Text('tg_chat_ru'.tr, style:  Get.textTheme.bodyText1,),
                  const SizedBox(width: 10.0,),
                  InkWell(
                    onTap: (){controller.openLink('https://t.me/+Z8njJcc--cszNzli');},
                    child: SelectableText('https://t.me/+Z8njJcc--cszNzli', style: Get.textTheme.bodyText1?.copyWith(decoration: TextDecoration.underline),onTap: (){controller.openLink('https://t.me/+Z8njJcc--cszNzli');},),
                  )
                ],
              ),
            ],
          ),
          Row(
            children: [
              Row(
                children: [
                  Text('tg_chat'.tr, style:  Get.textTheme.bodyText1,),
                  const SizedBox(width: 10.0,),
                  InkWell(
                    onTap: (){controller.openLink('https://t.me/+iQVlXi7R6f1iOWQy');},
                    child: SelectableText('https://t.me/+iQVlXi7R6f1iOWQy', style: Get.textTheme.bodyText1?.copyWith(decoration: TextDecoration.underline),onTap: (){controller.openLink('https://t.me/+iQVlXi7R6f1iOWQy');},),
                  )
                ],
              ),
            ],
          ),
          Text('donations'.tr, style: Get.textTheme.bodyText2, textAlign: TextAlign.center,),
          Text('USDT trc20', style: Get.textTheme.bodyText2),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SelectableText('TRWQkERZSGNH1QZkM8LNqRP8R7pLHC1edh', style: Get.textTheme.bodyText1,),
              IconButton(onPressed: () async {await Clipboard.setData(const ClipboardData(text: 'TRWQkERZSGNH1QZkM8LNqRP8R7pLHC1edh'));}, icon: const Icon(Icons.copy_outlined))
            ],
          ),
          Text('BTC', style: Get.textTheme.bodyText2),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SelectableText('bc1qmfvhxxmjcs4w4ys5uz8lux4f4zaeq626936zze', style: Get.textTheme.bodyText1),
              IconButton(onPressed: () async {await Clipboard.setData(const ClipboardData(text: 'bc1qmfvhxxmjcs4w4ys5uz8lux4f4zaeq626936zze'));}, icon: const Icon(Icons.copy_outlined))
            ],
          ),
          Text('BNB', style: Get.textTheme.bodyText2),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SelectableText('bnb19vqxy2afazyr3t2npr3yv4q2gnhxaf5f3f6p89', style: Get.textTheme.bodyText1),
              IconButton(onPressed: () async {await Clipboard.setData(const ClipboardData(text: 'bnb19vqxy2afazyr3t2npr3yv4q2gnhxaf5f3f6p89'));}, icon: const Icon(Icons.copy_outlined))
            ],
          ),
        ],
      ),
    );
  }
}
