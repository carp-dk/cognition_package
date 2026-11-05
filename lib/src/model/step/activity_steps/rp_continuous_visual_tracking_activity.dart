part of '../../../../model.dart';

/// A Multiple Object Tracking Test
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class RPContinuousVisualTrackingActivity extends RPActivityStep {
  RPContinuousVisualTrackingActivity({
    required super.identifier,
    super.includeInstructions,
    super.includeResults,
    this.lengthOfTest = 90,
    this.numberOfTests = 3,
    this.amountOfDots = 5,
    this.amountOfTargets = 2,
    this.dotSize = 100,
    this.trackingSpeed = const Duration(seconds: 5),
  });

  /// Test duration in seconds. Default is 90 seconds.
  int lengthOfTest;

  /// Amount of test repetitions. Default is 3.
  int numberOfTests;

  /// Amount of dots to be displayed. Default is 5.
  int amountOfDots;

  /// Amount of targets to be displayed. Default is 2.
  int amountOfTargets;

  /// Size of the dots in pixels. Default is 100.
  int dotSize;

  /// The speed of the dots in seconds. Default is 5 seconds per move.
  Duration trackingSpeed;

  @override
  Widget stepBody(
    dynamic Function(dynamic) onResultChange,
    RPActivityEventLogger eventLogger,
  ) => RPUIContinuousVisualTrackingActivityBody(
    this,
    eventLogger,
    onResultChange,
  );

  /// The result of this activity is a list of mistakes for each test repetition.
  /// The list is empty if no mistakes were made.
  /// For every repetition with 0 mistakes a score of 1 is added.
  /// The final score is the sum of repetitions with 0 mistakes.
  @override
  int calculateScore(dynamic result) {
    var sum = -1;
    try {
      List<int> mistakes = result['mistakes'] as List<int>;
      for (var round in mistakes) {
        if (round < amountOfTargets) {
          sum += 1;
        }
      }
    } catch (error) {
      print('$runtimeType - Error calculating score: $error');
    }
    return sum;
  }

  @override
  Function get fromJsonFunction => _$RPContinuousVisualTrackingActivityFromJson;
  factory RPContinuousVisualTrackingActivity.fromJson(
    Map<String, dynamic> json,
  ) => FromJsonFactory().fromJson<RPContinuousVisualTrackingActivity>(json);
  @override
  Map<String, dynamic> toJson() =>
      _$RPContinuousVisualTrackingActivityToJson(this);
}
