part of '../../../../model.dart';

/// Flanker Test.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class RPFlankerActivity extends RPActivityStep {
  RPFlankerActivity({
    required super.identifier,
    super.includeInstructions,
    super.includeResults,
    this.lengthOfTest = 90,
    this.numberOfCards = 25,
  });

  /// Test duration in seconds. Default is 90 seconds.
  int lengthOfTest;

  /// Number of cards to be presented. Default is 25.
  int numberOfCards;

  @override
  Widget stepBody(
    dynamic Function(dynamic) onResultChange,
    RPActivityEventLogger eventLogger,
  ) => RPUIFlankerActivity(this, eventLogger, onResultChange);

  /// The score is the number of mistakes made during the test.
  /// If the number of mistakes > 2, the test is failed and a score of 0 is
  /// returned. Otherwise, a score of 1 is returned.
  @override
  int calculateScore(dynamic result) => (result['mistakes'] as int > 2) ? 0 : 1;

  /// Calculate scores - sum, mean congruent, mean incongruent
  List<dynamic> calculateScoreFlanker(dynamic result) {
    var accuracy = result['correct'] / (result['correct'] + result['mistakes']);

    // An empty list (no card of that kind swiped) gives 0, not NaN - NaN can't be JSON encoded.
    double mean(dynamic times) => (times as List).isEmpty
        ? 0.0
        : times.fold<num>(0, (p, c) => p + (c as num)) / times.length;
    var meanCongruent = mean(result['congruentTimes']);
    var meanIncongruent = mean(result['incongruentTimes']);

    int sum = 0;
    try {
      final both =
          (result['congruentTimes'] as List).isNotEmpty &&
          (result['incongruentTimes'] as List).isNotEmpty;
      if (both && meanIncongruent - meanCongruent < 500) sum = 1;
      if (accuracy as double < 0.73) sum = 0;
    } catch (error) {
      print('$runtimeType - Error calculating score: $error');
    }

    return [sum, meanCongruent, meanIncongruent];
  }

  @override
  Function get fromJsonFunction => _$RPFlankerActivityFromJson;
  factory RPFlankerActivity.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson<RPFlankerActivity>(json);
  @override
  Map<String, dynamic> toJson() => _$RPFlankerActivityToJson(this);
}
