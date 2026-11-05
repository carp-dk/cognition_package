part of '../../../../model.dart';

/// Visual Array Change Test
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class RPVisualArrayChangeActivity extends RPActivityStep {
  RPVisualArrayChangeActivity({
    required super.identifier,
    super.includeInstructions,
    super.includeResults,
    this.numberOfShapes = 3,
    this.lengthOfTest = 90,
    this.waitTime = 2,
    this.numberOfTests = 3,
  });

  /// Test duration in seconds. Default is 90 seconds.
  int lengthOfTest;

  /// number of tests to run. Default is 3.
  int numberOfTests;

  int numberOfShapes;

  /// wait time between tests in seconds. Default is 2 seconds.
  int waitTime;

  @override
  Widget stepBody(
    dynamic Function(dynamic) onResultChange,
    RPActivityEventLogger eventLogger,
  ) => RPUIVisualArrayChangeActivityBody(this, eventLogger, onResultChange);

  /// Score is the number of correct answers in the test.
  @override
  int calculateScore(dynamic result) => result['correct'] as int;

  @override
  Function get fromJsonFunction => _$RPVisualArrayChangeActivityFromJson;
  factory RPVisualArrayChangeActivity.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson<RPVisualArrayChangeActivity>(json);
  @override
  Map<String, dynamic> toJson() => _$RPVisualArrayChangeActivityToJson(this);
}
