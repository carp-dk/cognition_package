part of '../../../../model.dart';

/// A Paired Associates Learning Test
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class RPPairedAssociatesLearningActivity extends RPActivityStep {
  /// Contructor for creating a Paired Associates Learning Test.
  RPPairedAssociatesLearningActivity({
    required super.identifier,
    super.includeInstructions,
    super.includeResults,
    this.maxTestDuration = 100,
  });

  /// The maximum length of the test. Default is 100 seconds.
  int maxTestDuration;

  @override
  Widget stepBody(
    dynamic Function(dynamic) onResultChange,
    RPActivityEventLogger eventLogger,
  ) => RPUIPairedAssociatesLearningActivityBody(
    this,
    eventLogger,
    onResultChange,
  );

  @override
  Function get fromJsonFunction => _$RPPairedAssociatesLearningActivityFromJson;
  factory RPPairedAssociatesLearningActivity.fromJson(
    Map<String, dynamic> json,
  ) => FromJsonFactory().fromJson<RPPairedAssociatesLearningActivity>(json);
  @override
  Map<String, dynamic> toJson() =>
      _$RPPairedAssociatesLearningActivityToJson(this);
}
