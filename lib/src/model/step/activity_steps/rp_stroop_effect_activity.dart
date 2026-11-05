part of '../../../../model.dart';

/// Stroop Effect Test.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class RPStroopEffectActivity extends RPActivityStep {
  /// Contructor for creating a Stroop effect Test.
  RPStroopEffectActivity({
    required super.identifier,
    super.includeInstructions,
    super.includeResults,
    this.lengthOfTest = 40,
    this.displayTime = 1000,
    this.delayTime = 750,
  });

  /// Test duration in seconds. Default is 40 seconds.
  int lengthOfTest;

  /// Amount of time each word is displayed in milliseconds.
  /// Default is 1000 ms.
  int displayTime;

  /// Amount of time between words in ms. Default is 750 ms.
  int delayTime;

  @override
  Widget stepBody(
    dynamic Function(dynamic) onResultChange,
    RPActivityEventLogger eventLogger,
  ) => RPUIStroopEffectActivityBody(this, eventLogger, onResultChange);

  @override
  Function get fromJsonFunction => _$RPStroopEffectActivityFromJson;
  factory RPStroopEffectActivity.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson<RPStroopEffectActivity>(json);
  @override
  Map<String, dynamic> toJson() => _$RPStroopEffectActivityToJson(this);
}
