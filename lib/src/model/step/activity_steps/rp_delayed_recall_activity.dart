part of '../../../../model.dart';

/// Delayed Recall Test.
/// Must be used after a [RPWordRecallActivity]
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class RPDelayedRecallActivity extends RPWordRecallActivity {
  RPDelayedRecallActivity({
    required super.identifier,
    super.includeInstructions,
    super.includeResults,
    super.lengthOfTest,
    super.numberOfTests,
  });

  @override
  Widget stepBody(
    dynamic Function(dynamic) onResultChange,
    RPActivityEventLogger eventLogger,
  ) => RPUIDelayedRecallActivityBody(this, eventLogger, onResultChange);

  @override
  Function get fromJsonFunction => _$RPDelayedRecallActivityFromJson;
  factory RPDelayedRecallActivity.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson<RPDelayedRecallActivity>(json);
  @override
  Map<String, dynamic> toJson() => _$RPDelayedRecallActivityToJson(this);
}
