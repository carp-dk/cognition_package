part of '../../../../model.dart';

/// Picture Sequence Memory Test Result
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class RPPictureSequenceResult extends RPActivityResult {
  RPPictureSequenceResult({required super.identifier});

  /// Create a [RPPictureSequenceResult] from results for Picture Sequence Memory Test
  ///
  ///  * [moves]: list of the number of moves made to complete the test
  ///  * [times]: time taken for each repetition
  ///  * [memoryTime]: time taken to memorize the sequence of images
  ///  * [score]: score of the test calculated in model class
  factory RPPictureSequenceResult.fromResults(
    List<dynamic> moves,
    List<dynamic> scores,
    List<dynamic> times,
    List<dynamic> memoryTimes,
    int score,
    original,
    pictures,
  ) {
    var res = RPPictureSequenceResult(identifier: 'PictureSequenceResult');
    res.results.addAll({'Amount of moves': moves});
    res.results.addAll({'Amount of correct pairs': scores});
    res.results.addAll({'Time taken to memorize': memoryTimes});
    res.results.addAll({'Time taken to move pictures': times});
    // res.results.addAll({'Original list': original});
    // res.results.addAll({'new list': pictures});
    res.results.addAll({'score': score});
    return res;
  }

  @override
  Function get fromJsonFunction => _$RPPictureSequenceResultFromJson;
  factory RPPictureSequenceResult.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson<RPPictureSequenceResult>(json);

  @override
  Map<String, dynamic> toJson() => _$RPPictureSequenceResultToJson(this);
}
