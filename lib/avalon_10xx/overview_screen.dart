import 'package:avalon_tool/ui/controls.dart';
import 'package:avalon_tool/ui/hashboard_display.dart';
import 'package:avalon_tool/ui/miner_info.dart';
import 'package:flutter/material.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              flex: 2,
              child: Controls(),
          ),
          Expanded(
            flex: 8,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                    child: MinerInfo()
                ),
                Expanded(
                  flex: 7,
                    child: HashboardDisplay(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
