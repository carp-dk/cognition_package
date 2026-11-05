part of '../../../../model.dart';

/// Corsi Block Tapping Test.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class RPCorsiBlockTappingActivity extends RPActivityStep {
  /// Create Corsi Block Tapping Test.
  RPCorsiBlockTappingActivity({
    required super.identifier,
    super.includeInstructions,
    super.includeResults,
  });

  @override
  Widget stepBody(
    dynamic Function(dynamic) onResultChange,
    RPActivityEventLogger eventLogger,
  ) => RPUICorsiBlockTappingActivityBody(this, eventLogger, onResultChange);

  @override
  Function get fromJsonFunction => _$RPCorsiBlockTappingActivityFromJson;
  factory RPCorsiBlockTappingActivity.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson<RPCorsiBlockTappingActivity>(json);
  @override
  Map<String, dynamic> toJson() => _$RPCorsiBlockTappingActivityToJson(this);
}
