import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoyo_player/network/homePage/homePage.dart';
import 'package:yoyo_player/network/homePage/homeSearchModel.dart';
import 'index.dart';

class SearchviewController extends GetxController {
  SearchviewController();

  final state = SearchviewState();

  var searchText = "".obs; // 绑定输入框的文本
  var searchResults = [].obs; // 搜索结果列表
  var searchHistory = <String>[].obs; // 历史搜索记录
  final TextEditingController textController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    textController.addListener(() {
      searchText.value = textController.text;
    });

    // Load saved search history
    _loadSearchHistory();
  }

  // Load search history from shared preferences
  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('searchHistory') ?? [];
    searchHistory.addAll(history);
  }

  // Save search history to shared preferences
  Future<void> _saveSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('searchHistory', searchHistory);
  }

  // 执行搜索
  Future<void> search() async {
    searchHistory.clear();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    String query = textController.text.trim();
    if (query.isNotEmpty) {
      searchText.value = query;

      // 添加到历史搜索记录（去重）
      if (!searchHistory.contains(query)) {
        searchHistory.insert(0, query);
      }

      // Save the updated search history
      await _saveSearchHistory();

      print("点击了搜索");
      // 模拟获取搜索结果
      HomeSearchInput par = HomeSearchInput(keyword: query);
      HomeSearchResponse res = await HomePageAPI.searchListByKeyWords(params: par);
      print(res.total);

      // 确保 res.data 是 List<Videos> 类型
      searchResults.addAll(res.data!);
    }
  }

  // 清除搜索历史
  void clearHistory() async {
    searchHistory.clear();
    // Clear the history from shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('searchHistory');
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
