import 'package:AllMinerMonitor/graphic_section/total_stats_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphic/graphic.dart';

class TotalStats extends StatelessWidget {
  final String layoutTag;
  const TotalStats(this.layoutTag, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   final TotalStatsController controller = Get.put(TotalStatsController(layoutTag), tag: layoutTag);
   final ScrollController scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        title: Text('$layoutTag stats'),
      ),
      backgroundColor: Get.theme.appBarTheme.backgroundColor,
      body: Scrollbar(
        controller: scrollController,
        isAlwaysShown: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(right: 10.0),
          controller: scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 50,
                width: Get.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('total_speed'.tr, style: Get.textTheme.bodyText2,),
                    IconButton(
                        onPressed: (){controller.toggleViewMode();},
                        icon: const Icon(Icons.speed_outlined),
                        splashRadius: 2.0,
                      tooltip: 'toggle_view'.tr,
                    ),
                  ],
                ),
              ),
              Obx(()=>IndexedStack(
                  index: controller.viewMode.value,
                  children: [
                    SizedBox(
                      height: 500,
                      width: Get.width,
                      child: Card(
                        color: Get.theme.cardTheme.color?.withOpacity(0.8),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Obx(()=>
                              Visibility(
                                replacement: Container(),
                                visible: controller.totalSpeedSHA256.isNotEmpty,
                                child:
                                    Chart(
                                      data: controller.totalSpeedSHA256,
                                      rebuild: true,
                                      variables: {
                                        'date': Variable(
                                          accessor: (Map map) => map['date'] as String,
                                          scale: OrdinalScale(tickCount: 5),
                                        ),
                                        'value': Variable(
                                          accessor: (Map map) => map['value'] as num,
                                        ),
                                        'name': Variable(
                                          accessor: (Map map) => map['name'] as String,
                                        ),
                                      },
                                      elements: [
                                        LineElement(
                                          position:
                                          Varset('date') * Varset('value') / Varset('name'),
                                          shape: ShapeAttr(value: BasicLineShape(smooth: true)),
                                          size: SizeAttr(value: 0.5),
                                          color: ColorAttr(
                                            variable: 'name',
                                            values: Defaults.colors10,
                                            updaters: {
                                              'groupMouse': {
                                                false: (color) => color.withAlpha(100)
                                              },
                                              'groupTouch': {
                                                false: (color) => color.withAlpha(100)
                                              },
                                            },
                                          ),
                                        ),
                                        PointElement(
                                          color: ColorAttr(
                                            variable: 'name',
                                            values: Defaults.colors10,
                                            updaters: {
                                              'groupMouse': {
                                                false: (color) => color.withAlpha(100)
                                              },
                                              'groupTouch': {
                                                false: (color) => color.withAlpha(100)
                                              },
                                            },
                                          ),
                                        ),
                                      ],
                                      axes: [
                                        Defaults.horizontalAxis,
                                        Defaults.verticalAxis,
                                      ],
                                      selections: {
                                        'tooltipMouse': PointSelection(on: {
                                          GestureType.hover,
                                        }, devices: {
                                          PointerDeviceKind.mouse
                                        }),
                                        'groupMouse': PointSelection(
                                            on: {
                                              GestureType.hover,
                                            },
                                            variable: 'name',
                                            devices: {PointerDeviceKind.mouse}),
                                        'tooltipTouch': PointSelection(on: {
                                          GestureType.scaleUpdate,
                                          GestureType.tapDown,
                                          GestureType.longPressMoveUpdate
                                        }, devices: {
                                          PointerDeviceKind.touch
                                        }),
                                        'groupTouch': PointSelection(
                                            on: {
                                              GestureType.scaleUpdate,
                                              GestureType.tapDown,
                                              GestureType.longPressMoveUpdate
                                            },
                                            variable: 'name',
                                            devices: {PointerDeviceKind.touch}),
                                      },
                                      tooltip: TooltipGuide(
                                        selections: {'tooltipTouch', 'tooltipMouse'},
                                        followPointer: [true, true],
                                        align: Alignment.topLeft,
                                        element: 0,
                                        variables: [
                                          'date',
                                          'name',
                                          'value',
                                        ],
                                      ),
                                      crosshair: CrosshairGuide(
                                        selections: {'tooltipTouch', 'tooltipMouse'},
                                        styles: [
                                          StrokeStyle(color: const Color(0xffbfbfbf)),
                                          StrokeStyle(color: const Color(0x00bfbfbf)),
                                        ],
                                        followPointer: [true, false],
                                      ),
                                    )
                                )

                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 500,
                      width: Get.width,
                      child: Card(
                        color: Get.theme.cardTheme.color?.withOpacity(0.8),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Obx(()=>
                              Visibility(
                                  replacement: Container(),
                                  visible: controller.totalSpeedSCRYPT.isNotEmpty,
                                  child:
                                  Chart(
                                    data: controller.totalSpeedSCRYPT,
                                    rebuild: true,
                                    variables: {
                                      'date': Variable(
                                        accessor: (Map map) => map['date'] as String,
                                        scale: OrdinalScale(tickCount: 5),
                                      ),
                                      'value': Variable(
                                        accessor: (Map map) => map['value'] as num,
                                      ),
                                      'name': Variable(
                                        accessor: (Map map) => map['name'] as String,
                                      ),
                                    },
                                    elements: [
                                      LineElement(
                                        position:
                                        Varset('date') * Varset('value') / Varset('name'),
                                        shape: ShapeAttr(value: BasicLineShape(smooth: true)),
                                        size: SizeAttr(value: 0.5),
                                        color: ColorAttr(
                                          variable: 'name',
                                          values: Defaults.colors10,
                                          updaters: {
                                            'groupMouse': {
                                              false: (color) => color.withAlpha(100)
                                            },
                                            'groupTouch': {
                                              false: (color) => color.withAlpha(100)
                                            },
                                          },
                                        ),
                                      ),
                                      PointElement(
                                        color: ColorAttr(
                                          variable: 'name',
                                          values: Defaults.colors10,
                                          updaters: {
                                            'groupMouse': {
                                              false: (color) => color.withAlpha(100)
                                            },
                                            'groupTouch': {
                                              false: (color) => color.withAlpha(100)
                                            },
                                          },
                                        ),
                                      ),
                                    ],
                                    axes: [
                                      Defaults.horizontalAxis,
                                      Defaults.verticalAxis,
                                    ],
                                    selections: {
                                      'tooltipMouse': PointSelection(on: {
                                        GestureType.hover,
                                      }, devices: {
                                        PointerDeviceKind.mouse
                                      }),
                                      'groupMouse': PointSelection(
                                          on: {
                                            GestureType.hover,
                                          },
                                          variable: 'name',
                                          devices: {PointerDeviceKind.mouse}),
                                      'tooltipTouch': PointSelection(on: {
                                        GestureType.scaleUpdate,
                                        GestureType.tapDown,
                                        GestureType.longPressMoveUpdate
                                      }, devices: {
                                        PointerDeviceKind.touch
                                      }),
                                      'groupTouch': PointSelection(
                                          on: {
                                            GestureType.scaleUpdate,
                                            GestureType.tapDown,
                                            GestureType.longPressMoveUpdate
                                          },
                                          variable: 'name',
                                          devices: {PointerDeviceKind.touch}),
                                    },
                                    tooltip: TooltipGuide(
                                      selections: {'tooltipTouch', 'tooltipMouse'},
                                      followPointer: [true, true],
                                      align: Alignment.topLeft,
                                      element: 0,
                                      variables: [
                                        'date',
                                        'name',
                                        'value',
                                      ],
                                    ),
                                    crosshair: CrosshairGuide(
                                      selections: {'tooltipTouch', 'tooltipMouse'},
                                      styles: [
                                        StrokeStyle(color: const Color(0xffbfbfbf)),
                                        StrokeStyle(color: const Color(0x00bfbfbf)),
                                      ],
                                      followPointer: [true, false],
                                    ),
                                  )
                              )

                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                width: Get.width,
                child: Center(child: Text('total_devices'.tr, style: Get.textTheme.bodyText2,)),
              ),
              SizedBox(
                height: 500,
                width:  Get.width,
                child: Card(
                  color: Get.theme.cardTheme.color?.withOpacity(0.8),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Obx(()=>
                        Visibility(
                          replacement: Container(),
                          visible: controller.totalDevices.isNotEmpty,
                          child:
                              Chart(
                                data: controller.totalDevices,
                                rebuild: true,
                                variables: {
                                  'date': Variable(
                                    accessor: (Map map) => map['date'] as String,
                                    scale: OrdinalScale(tickCount: 5),
                                  ),
                                  'value': Variable(
                                    accessor: (Map map) => map['value'] as num,
                                  ),
                                  'name': Variable(
                                    accessor: (Map map) => map['name'] as String,
                                  ),
                                },
                                elements: [
                                  LineElement(
                                    position:
                                    Varset('date') * Varset('value') / Varset('name'),
                                    shape: ShapeAttr(value: BasicLineShape(smooth: true)),
                                    size: SizeAttr(value: 0.5),
                                    color: ColorAttr(
                                      variable: 'name',
                                      values: Defaults.colors10,
                                      updaters: {
                                        'groupMouse': {
                                          false: (color) => color.withAlpha(100)
                                        },
                                        'groupTouch': {
                                          false: (color) => color.withAlpha(100)
                                        },
                                      },
                                    ),
                                  ),
                                  PointElement(
                                    color: ColorAttr(
                                      variable: 'name',
                                      values: Defaults.colors10,
                                      updaters: {
                                        'groupMouse': {
                                          false: (color) => color.withAlpha(100)
                                        },
                                        'groupTouch': {
                                          false: (color) => color.withAlpha(100)
                                        },
                                      },
                                    ),
                                  ),
                                ],
                                axes: [
                                  Defaults.horizontalAxis,
                                  Defaults.verticalAxis,
                                ],
                                selections: {
                                  'tooltipMouse': PointSelection(on: {
                                    GestureType.hover,
                                  }, devices: {
                                    PointerDeviceKind.mouse
                                  }),
                                  'groupMouse': PointSelection(
                                      on: {
                                        GestureType.hover,
                                      },
                                      variable: 'name',
                                      devices: {PointerDeviceKind.mouse}),
                                  'tooltipTouch': PointSelection(on: {
                                    GestureType.scaleUpdate,
                                    GestureType.tapDown,
                                    GestureType.longPressMoveUpdate
                                  }, devices: {
                                    PointerDeviceKind.touch
                                  }),
                                  'groupTouch': PointSelection(
                                      on: {
                                        GestureType.scaleUpdate,
                                        GestureType.tapDown,
                                        GestureType.longPressMoveUpdate
                                      },
                                      variable: 'name',
                                      devices: {PointerDeviceKind.touch}),
                                },
                                tooltip: TooltipGuide(
                                  selections: {'tooltipTouch', 'tooltipMouse'},
                                  followPointer: [true, true],
                                  align: Alignment.topLeft,
                                  element: 0,
                                  variables: [
                                    'date',
                                    'name',
                                    'value',
                                  ],
                                ),
                                crosshair: CrosshairGuide(
                                  selections: {'tooltipTouch', 'tooltipMouse'},
                                  styles: [
                                    StrokeStyle(color: const Color(0xffbfbfbf)),
                                    StrokeStyle(color: const Color(0x00bfbfbf)),
                                  ],
                                  followPointer: [true, false],
                                ),
                              )

                        )
                    )
                  ),
                ),
              ),
              SizedBox(
                height: 50,
                width: Get.width,
                child: Center(child: Text('total_errors'.tr, style: Get.textTheme.bodyText2,)),
              ),
              SizedBox(
                height: 500,
                width:  Get.width,
                child: Card(
                  color: Get.theme.cardTheme.color?.withOpacity(0.8),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child:Obx(()=>
                        Visibility(
                          replacement: Container(),
                          visible: controller.totalErrors.isNotEmpty,
                          child:
                              Chart(
                                data: controller.totalErrors,
                                rebuild: true,
                                variables: {
                                  'date': Variable(
                                    accessor: (Map map) => map['date'] as String,
                                    scale: OrdinalScale(tickCount: 5),
                                  ),
                                  'value': Variable(
                                    accessor: (Map map) => map['value'] as num,
                                  ),
                                  'name': Variable(
                                    accessor: (Map map) => map['name'] as String,
                                  ),
                                },
                                elements: [
                                  LineElement(
                                    position:
                                    Varset('date') * Varset('value') / Varset('name'),
                                    shape: ShapeAttr(value: BasicLineShape(smooth: true)),
                                    size: SizeAttr(value: 0.5),
                                    color: ColorAttr(
                                      variable: 'name',
                                      values: Defaults.colors10,
                                      updaters: {
                                        'groupMouse': {
                                          false: (color) => color.withAlpha(100)
                                        },
                                        'groupTouch': {
                                          false: (color) => color.withAlpha(100)
                                        },
                                      },
                                    ),
                                  ),
                                  PointElement(
                                    color: ColorAttr(
                                      variable: 'name',
                                      values: Defaults.colors10,
                                      updaters: {
                                        'groupMouse': {
                                          false: (color) => color.withAlpha(100)
                                        },
                                        'groupTouch': {
                                          false: (color) => color.withAlpha(100)
                                        },
                                      },
                                    ),
                                  ),
                                ],
                                axes: [
                                  Defaults.horizontalAxis,
                                  Defaults.verticalAxis,
                                ],
                                selections: {
                                  'tooltipMouse': PointSelection(on: {
                                    GestureType.hover,
                                  }, devices: {
                                    PointerDeviceKind.mouse
                                  }),
                                  'groupMouse': PointSelection(
                                      on: {
                                        GestureType.hover,
                                      },
                                      variable: 'name',
                                      devices: {PointerDeviceKind.mouse}),
                                  'tooltipTouch': PointSelection(on: {
                                    GestureType.scaleUpdate,
                                    GestureType.tapDown,
                                    GestureType.longPressMoveUpdate
                                  }, devices: {
                                    PointerDeviceKind.touch
                                  }),
                                  'groupTouch': PointSelection(
                                      on: {
                                        GestureType.scaleUpdate,
                                        GestureType.tapDown,
                                        GestureType.longPressMoveUpdate
                                      },
                                      variable: 'name',
                                      devices: {PointerDeviceKind.touch}),
                                },
                                tooltip: TooltipGuide(
                                  selections: {'tooltipTouch', 'tooltipMouse'},
                                  followPointer: [true, true],
                                  align: Alignment.topLeft,
                                  element: 0,
                                  variables: [
                                    'date',
                                    'name',
                                    'value',
                                  ],
                                ),
                                crosshair: CrosshairGuide(
                                  selections: {'tooltipTouch', 'tooltipMouse'},
                                  styles: [
                                    StrokeStyle(color: const Color(0xffbfbfbf)),
                                    StrokeStyle(color: const Color(0x00bfbfbf)),
                                  ],
                                  followPointer: [true, false],
                                ),
                              )

                        )
                    )
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
