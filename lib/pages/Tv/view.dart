import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';
import 'widgets/widgets.dart';

class TvPage extends GetView<TvController> {
  const TvPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return const HelloWidget();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TvController>(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("tv")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
