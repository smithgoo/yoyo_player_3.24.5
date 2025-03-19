import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';
import 'widgets/widgets.dart';

class TestPage extends GetView<TestController> {
  @override
  final controller = Get.put<TestController>(TestController());

  TestPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return const HelloWidget();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TestController>(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("test")),
          body: SafeArea(
            child: Center(
              child: GestureDetector(
                onTap: () {
                  
                },
                child: Container(
                  width: 300,
                  height: 300,
                  child: Text("Hello World"),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
