import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

class EmptyHeader extends Header {
  EmptyHeader({required super.triggerOffset, required super.clamping});

  @override
  Widget build(BuildContext context, IndicatorState state) {
    return SizedBox(); // 不显示任何内容
  }
}

class EmptyFooter extends Footer {
  EmptyFooter({required super.triggerOffset, required super.clamping});

  @override
  Widget build(BuildContext context, IndicatorState state) {
    return SizedBox(); // 不显示任何内容
  }
}
