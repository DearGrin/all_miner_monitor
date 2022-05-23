import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class InfoSettings extends StatelessWidget {
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
