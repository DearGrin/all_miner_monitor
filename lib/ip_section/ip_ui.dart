import 'package:avalon_tool/ip_section/ip_management_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IpUI extends StatelessWidget{
  const IpUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final IpManagementController controller = Get.put(IpManagementController());
    final ScrollController scrollController = ScrollController();
    return Card(
      color: Theme.of(context).cardTheme.color,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            SizedBox(
              height: 25,
              child: Row(
                children: [
                  IconButton(
                      onPressed: (){controller.onAddNewIp(context);},
                      icon: const Icon(Icons.add),
                  ),
                  IconButton(
                      onPressed: (){controller.onDeleteSelectedIps();},
                      icon: const Icon(Icons.remove),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                const Expanded(child: Text('ip', textAlign: TextAlign.center,)),
                Expanded(child: Text('comment'.tr, textAlign: TextAlign.center,)),
              ],
            ),
            const SizedBox(height: 10,),
            Expanded(
              child: Obx(()=>Scrollbar(
                isAlwaysShown: true,
                controller: scrollController,
                child: ListView.separated(
                  controller: scrollController,
                  itemBuilder: (context, index){
                    return Container(
                      margin: const EdgeInsets.only(right: 16.0),
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                      ),
                      child: InkWell(
                        onDoubleTap: (){controller.onEditIp(index, context);},
                        onTap: (){controller.onTap(index);},
                        child: Row(
                          children: [
                            GetBuilder<IpManagementController>(
                              id: '$index',
                              builder: (context){
                                return Checkbox(
                                //value: controller.selection,
                                  value: controller.selectedIps.contains(index),
                                onChanged: (value){controller.onSelectIp(index, value!);},
                                );
                              },

                            ),
                            Expanded(
                                flex: 1,
                                child: Text(controller.ips[index].rawIpRange??'')),
                            Expanded(
                                flex: 1,
                                child: Text(controller.ips[index].comment??'')),
                          ],
                        ),
                      ),
                      /*
                      child: InkWell(
                        onDoubleTap: (){controller.onEditIp(index);},

                      ),

                       */
                    );
                  },
                  separatorBuilder: (context, index)=> const Divider(),
                  itemCount: controller.ips.length,
                ),
              ),),
            ),
          ],
        ),
      ),
    );
  }
}
