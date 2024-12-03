import 'package:freezed_annotation/freezed_annotation.dart';
import '../config.dart';

part 'slider.g.dart';
part 'slider.freezed.dart';

List<SliderModel> sliderFromJson(dynamic str) {
  return List<SliderModel>.from((str ?? []).map((x) {
    return SliderModel.fromJson({
      'sliderName': x['sliderName'] ?? '',
      'sliderImage': x['sliderImage'] ?? '',
      'sliderId': x['sliderId'] ?? '',
    });
  }));
}

@freezed
abstract class SliderModel with _$SliderModel {
  factory SliderModel({
    required String sliderName,
    required String sliderImage,
    required String sliderId,
  }) = _Slider;

  factory SliderModel.fromJson(Map<String, dynamic> json) =>
      _$SliderModelFromJson(json);
}

extension SliderModelExt on SliderModel {
  String get fullImagePath => Config.imageURL + sliderImage;
}
