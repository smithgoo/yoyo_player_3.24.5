import 'package:get/get.dart';

class HomeState {
  // title
  final _title = "".obs;
  set title(value) => _title.value = value;
  get title => _title.value;

  final _videosList = [].obs;
  set videosList(value) => _videosList.value = value;
  get videosList => _videosList.value;

  final _currentPage = 1.obs;
  set currentPage(value) => _currentPage.value = value;
  get currentPage => _currentPage.value;
}
