import 'package:AllMinerMonitor/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewSettings extends StatelessWidget {
  const ViewSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SettingsController controller = Get.put(SettingsController());
    final ScrollController _scrollController = ScrollController();
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Text(
            'view_descr'.tr,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Expanded(
              flex: 1,

              child: GetBuilder<SettingsController>(
                id: 'headers_settings',
                builder: (_) {
                  return Scrollbar(
                    isAlwaysShown: true,
                    controller: _scrollController,
                    child: ListView.separated(
                      padding: const EdgeInsets.only(right: 10.0),
                      controller: _scrollController,
                      itemCount: _.headers.length,
                        separatorBuilder: (BuildContext context, int index) => const Divider(),
                          itemBuilder: (context, index){
                        String _label = _.headers[index].label.toString().tr;
                        return Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                             Text(
                                 _label,
                               style: Theme.of(context).textTheme.bodyText1,
                             ),

                              Obx(()=> Checkbox(
                                 // value: false,
                                  value: controller.isVisibleHeader[index],
                                  onChanged: (value) {
                                    controller.setVisibility(index, value!);
                                  }
                              ),
                              ),
                            ],
                          ),
                        );
                          },

                        ),
                  );
                }
              ),
              ),

        ],
      ),
    );
  }
}
