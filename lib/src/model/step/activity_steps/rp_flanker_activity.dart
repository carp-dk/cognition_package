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

    var conSum = result['congruentTimes'].fold(
      0,
      (dynamic p, dynamic c) => p + c,
    );
    var meanCongruent = conSum / result['congruentTimes'].length;

    var inconSum = result['incongruentTimes'].fold(
      0,
      (dynamic p, dynamic c) => p + c,
    );
    var meanIncongruent = inconSum / result['incongruentTimes'].length;

    int sum = 0;
    try {
      if ((meanIncongruent - meanCongruent) as double < 500) sum = 1;
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
