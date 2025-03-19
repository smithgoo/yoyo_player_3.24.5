import 'package:get/get.dart';
import 'package:yoyo_player/network/homePage/homePageModel.dart';

class VideoState {
  // title
  final _title = "".obs;
  set title(value) => _title.value = value;
  get title => _title.value;

  final _model = Videos().obs;
  set model(value) => _model.value = value;
  get model => _model.value;

  final _items = [].obs;
  set items(value) => _items.value = value;
  get items => _items.value;

    final _currentIdx = 0.obs;
  set currentIdx(value) => _currentIdx.value = value;
  get currentIdx => _currentIdx.value;
}
