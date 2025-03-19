import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ModalDateTimePickerController extends GetxController {
  var formattedDate = ''.obs; // 观察者，存储格式化后的日期
}

class ModalDateTimePickerExample extends StatelessWidget {
  final ModalDateTimePickerController controller =
      Get.put(ModalDateTimePickerController());
  DateTime selectedDateTime = DateTime.now(); // 默认初始化为当前时间
  final Function(String) onDateSelected; // 回调函数, 传递字符串

  ModalDateTimePickerExample({Key? key, required this.onDateSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min, // 让内容只占用所需的高度
        children: [
          // 顶部的取消和确认按钮
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Get.back(), // 点击取消，关闭弹框
                  child: Text(
                    "取消",
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // 在确认按钮中使用选中的日期时间
                    // 使用 DateFormat 格式化 DateTime
                    String formattedDate = DateFormat('yyyy年MM月dd日 HH:mm')
                        .format(selectedDateTime);

                    // 更新 controller 中的 formattedDate
                    controller.formattedDate.value = formattedDate;
                    print(formattedDate);

                    // 返回格式化后的日期时间字符串
                    onDateSelected(formattedDate); // 调用回调传回格式化的日期字符串
                    Get.back(); // 关闭弹框
                  },
                  child: Text(
                    "确认",
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
          // 滚轮选择器
          Container(
            height: 250, // 设置日期选择器的高度
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.dateAndTime,
              initialDateTime: selectedDateTime, // 设置初始时间为 selectedDateTime
              onDateTimeChanged: (DateTime dateTime) {
                // 当日期时间改变时，更新选中的时间
                selectedDateTime = dateTime;
              },
            ),
          ),
        ],
      ),
    );
  }
}

void showModalDateTimePicker({required Function(String) onDateSelected}) {
  Get.bottomSheet(
    ModalDateTimePickerExample(onDateSelected: onDateSelected),
    isScrollControlled: true, // 控制弹框高度
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
  );
}
