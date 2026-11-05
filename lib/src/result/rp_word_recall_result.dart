part of '../../../../model.dart';

/// Verbal Recognition Memory Test Result
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class RPWordRecallResult extends RPActivityResult {
  RPWordRecallResult({required super.identifier});

  /// Create a [RPWordRecallResult] based on results for Word Recall Test:
  ///
  ///  * [wordList]: list of words to be recalled
  ///  * [resultList1]: list of recalled words in 1 repetition
  ///  * [resultList1]: list of recalled words in 2 repetition
  ///  * [timeTaken]: time taken to recall
  ///  * [score]: score of the test calculated in model class
  factory RPWordRecallResult.fromResults(
    List<String> wordList,
    List<String> resultList1,
    List<String> resultList2,
    List<dynamic> timesTaken,
    int score,
  ) {
    var res = RPWordRecallResult(identifier: 'WordRecallResult');
    res.results.addAll({'wordlist': wordList});
    res.results.addAll({'resultlist1': resultList1});
    res.results.addAll({'resultlist2': resultList2});
    res.results.addAll({'times taken': timesTaken});
    res.results.addAll({'score': score});
    return res;
  }

  @override
  Function get fromJsonFunction => _$RPWordRecallResultFromJson;
  factory RPWordRecallResult.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson<RPWordRecallResult>(json);

  @override
  Map<String, dynamic> toJson() => _$RPWordRecallResultToJson(this);
}
