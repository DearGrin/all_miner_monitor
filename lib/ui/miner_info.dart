import 'package:avalon_tool/ui/info_block.dart';
import 'package:flutter/material.dart';

class MinerInfo extends StatelessWidget {
  const MinerInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: const[
          InfoBlock('General', infos: [{'Version':'1u314p'},],),
          InfoBlock('Hashboard status', infos: [{'Hashboard count':'3'}],),
          InfoBlock('Speed', infos: [{'Average speed':'47 Th/s'}],),
          InfoBlock('Power Supply', infos: [{'Output':'13,1 V'}],),
          InfoBlock('Extras', infos: [{'Aging':'complete'}],),
        ],
      ),
    );
  }
}
