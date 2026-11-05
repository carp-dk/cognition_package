import 'package:test/test.dart';
import 'package:cognition_package/model.dart';
import 'package:research_package/model.dart';
import 'dart:convert';

void main() {
  String encode(Object object) =>
      const JsonEncoder.withIndent(' ').convert(object);
  group('TrailMaking', () {
    test('TrailMaking -> JSON', () {
      RPActivityStep activityStepTrail = RPTrailMakingActivity(
        identifier: 'Trail Making step ID',
        trailType: TrailType.B,
        includeResults: false,
      );
      print(encode(activityStepTrail));
    });
    test('TrailMaking score should be calculated correctly : 3', () {
      RPActivityStep activityStepTrail = RPTrailMakingActivity(
        identifier: 'Trail Making step ID',
        trailType: TrailType.B,
        includeResults: false,
      );
      var score = activityStepTrail.calculateScore({'mistakeCount': 3});
      expect(score, 2);
    });

    test('TrailMaking score should be calculated correctly : 5', () {
      RPActivityStep activityStepTrail = RPTrailMakingActivity(
        identifier: 'Trail Making step ID',
        trailType: TrailType.B,
        includeResults: false,
      );
      var score = activityStepTrail.calculateScore({'mistakeCount': 5});
      expect(score, 0);
    });
  });
  group('Continuous Visual tracking', () {
    test('Continuous Visual tracking -> JSON', () {
      RPActivityStep continuousVisualTracking =
          RPContinuousVisualTrackingActivity(
            identifier: 'ContinuousVisualTracking step ID',
            numberOfTests: 3,
            amountOfDots: 15,
            dotSize: 40,
            lengthOfTest: 180,
            trackingSpeed: const Duration(seconds: 5),
            includeResults: false,
          );
      print(encode(continuousVisualTracking));
    });
    test(
      'Continuous Visual tracking score should be calculated correctly : [1, 2, 3]',
      () {
        RPActivityStep continuousVisualTracking =
            RPContinuousVisualTrackingActivity(
              identifier: 'ContinuousVisualTracking step ID',
              numberOfTests: 3,
              amountOfDots: 15,
              dotSize: 40,
              lengthOfTest: 180,
              trackingSpeed: const Duration(seconds: 5),
              includeResults: false,
            );
        var score = continuousVisualTracking.calculateScore({
          'mistakes': [1, 2, 3],
        });
        expect(score, 0);
      },
    );

    test(
      'Continuous Visual tracking score should be calculated correctly : [1, 0, 0]',
      () {
        RPActivityStep continuousVisualTracking =
            RPContinuousVisualTrackingActivity(
              identifier: 'ContinuousVisualTracking step ID',
              numberOfTests: 3,
              amountOfDots: 15,
              dotSize: 40,
              lengthOfTest: 180,
              trackingSpeed: const Duration(seconds: 5),
              includeResults: false,
            );
        var score = continuousVisualTracking.calculateScore({
          'mistakes': [1, 0, 0],
        });
        expect(score, 2);
      },
    );
  });
  group('wordRecall', () {
    test('wordRecall -> JSON', () {
      RPActivityStep wordRecall = RPWordRecallActivity(
        identifier: 'WordRecall step ID',
        lengthOfTest: 180,
        numberOfTests: 3,
        includeResults: false,
      );
      print(encode(wordRecall));
    });
    test('wordRecall score should be calculated correctly : 3', () {
      RPActivityStep wordRecall = RPWordRecallActivity(
        identifier: 'WordRecall step ID',
        lengthOfTest: 180,
        numberOfTests: 3,
        includeResults: false,
      );

      List<String> wordlist = ['banana', 'icecream', 'violin', 'desk', 'green'];
      List<String> resultList = [
        'banana',
        'icecream',
        'violin',
        'desk',
        'green',
      ];
      var score = wordRecall.calculateScore({
        'wordsList': wordlist,
        'resultsList': resultList,
      });
      expect(score, 5);
    });

    test('wordRecall score should be calculated correctly : 5', () {
      RPActivityStep wordRecall = RPWordRecallActivity(
        identifier: 'WordRecall step ID',
        lengthOfTest: 180,
        numberOfTests: 3,
        includeResults: false,
      );
      List<String> wordlist = ['banana', 'icecream', 'violin', 'desk', 'green'];
      List<String> resultList = ['wrong', 'wrong', 'wrong', 'wrong', 'wrong'];
      var score = wordRecall.calculateScore({
        'wordsList': wordlist,
        'resultsList': resultList,
      });
      expect(score, 0);
    });
  });
  group('PictureSequenceMemory', () {
    test('PictureSequenceMemory -> JSON', () {
      RPActivityStep pictureSequenceMemory = RPPictureSequenceMemoryActivity(
        identifier: 'PictureSequenceMemory step ID',
        lengthOfTest: 180,
        numberOfTests: 1,
        numberOfPics: 6,
        includeResults: false,
      );
      print(encode(pictureSequenceMemory));
    });
    test(
      'PictureSequenceMemory score should be calculated correctly : [5, 4, 2]',
      () {
        RPActivityStep pictureSequenceMemory = RPPictureSequenceMemoryActivity(
          identifier: 'PictureSequenceMemory step ID',
          lengthOfTest: 180,
          numberOfTests: 1,
          numberOfPics: 6,
          includeResults: false,
        );
        var score = pictureSequenceMemory.calculateScore({
          'pairs': [5, 4, 2],
        });
        expect(score, 11);
      },
    );

    test(
      'PictureSequenceMemory score should be calculated correctly : [3]',
      () {
        RPActivityStep pictureSequenceMemory = RPPictureSequenceMemoryActivity(
          identifier: 'PictureSequenceMemory step ID',
          lengthOfTest: 180,
          numberOfTests: 1,
          numberOfPics: 6,
          includeResults: false,
        );
        var score = pictureSequenceMemory.calculateScore({
          'pairs': [3],
        });
        expect(score, 3);
      },
    );
  });
  group('Letter Tapping', () {
    test('Letter Tapping -> JSON', () {
      RPActivityStep activityStepLetterTapping = RPLetterTappingActivity(
        identifier: 'Letter Tapping step ID',
        includeResults: false,
      );
      print(encode(activityStepLetterTapping));
    });
    test('Letter Tapping score should be calculated correctly : 3', () {
      RPActivityStep activityStepLetterTapping = RPLetterTappingActivity(
        identifier: 'Letter Tapping step ID',
        includeResults: false,
      );
      var score = activityStepLetterTapping.calculateScore({'errors': 3});
      expect(score, 0);
    });

    test('Letter Tapping score should be calculated correctly : 1', () {
      RPActivityStep activityStepLetterTapping = RPLetterTappingActivity(
        identifier: 'Letter Tapping step ID',
        includeResults: false,
      );
      var score = activityStepLetterTapping.calculateScore({'errors': 1});
      expect(score, 1);
    });
  });
  group('Flanker', () {
    test('Flanker -> JSON', () {
      RPActivityStep flanker = RPFlankerActivity(
        identifier: 'Flanker step ID',
        lengthOfTest: 30,
        numberOfCards: 25,
        includeResults: false,
      );
      print(encode(flanker));
    });
    test('Flanker score should be calculated correctly : 0', () {
      RPActivityStep flanker = RPFlankerActivity(
        identifier: 'Flanker step ID',
        lengthOfTest: 30,
        numberOfCards: 25,
        includeResults: false,
      );
      var score = flanker.calculateScore({
        'mistakes': 6,
        'correct': 14,
        'congruentTimes': [1, 2, 3, 4, 5],
        'incongruentTimes': [10, 12, 13, 14, 15],
      });
      expect(score, 0);
    });

    test('Flanker score should be calculated correctly : 1', () {
      RPActivityStep flanker = RPFlankerActivity(
        identifier: 'Flanker step ID',
        lengthOfTest: 30,
        numberOfCards: 25,
        includeResults: false,
      );
      var score = flanker.calculateScore({
        'mistakes': 1,
        'correct': 24,
        'congruentTimes': [1, 2, 3, 4, 5],
        'incongruentTimes': [1, 3, 3, 2, 1],
      });
      expect(score, 1);
    });
  });
  group('Visual Array Change', () {
    test('Visual Array Change -> JSON', () {
      RPActivityStep visualArrayChange = RPVisualArrayChangeActivity(
        identifier: 'VisualArrayChange step ID',
        lengthOfTest: 180,
        numberOfTests: 3,
        waitTime: 3,
        includeResults: false,
      );
      print(encode(visualArrayChange));
    });
    test('Visual Array Change score should be calculated correctly : 3', () {
      RPActivityStep visualArrayChange = RPVisualArrayChangeActivity(
        identifier: 'VisualArrayChange step ID',
        lengthOfTest: 180,
        numberOfTests: 3,
        waitTime: 3,
        includeResults: false,
      );
      var score = visualArrayChange.calculateScore({'correct': 3});
      expect(score, 3);
    });

    test('Visual Array Change score should be calculated correctly : 1', () {
      RPActivityStep visualArrayChange = RPVisualArrayChangeActivity(
        identifier: 'VisualArrayChange step ID',
        lengthOfTest: 180,
        numberOfTests: 3,
        waitTime: 3,
        includeResults: false,
      );
      var score = visualArrayChange.calculateScore({'correct': 1});
      expect(score, 1);
    });
  });
  group('delayedRecall', () {
    test('delayedRecall -> JSON', () {
      RPActivityStep delayedRecall = RPDelayedRecallActivity(
        identifier: 'DelayedRecall step ID',
        lengthOfTest: 180,
        numberOfTests: 3,
        includeResults: false,
      );
      print(encode(delayedRecall));
    });
    test('delayedRecall score should be calculated correctly : 5', () {
      RPActivityStep delayedRecall = RPDelayedRecallActivity(
        identifier: 'DelayedRecall step ID',
        lengthOfTest: 180,
        numberOfTests: 3,
        includeResults: false,
      );

      List<String> wordlist = ['banana', 'icecream', 'violin', 'desk', 'green'];
      List<String> resultList = [
        'banana',
        'icecream',
        'violin',
        'desk',
        'green',
      ];
      var score = delayedRecall.calculateScore({
        'wordsList': wordlist,
        'resultsList': resultList,
      });
      expect(score, 5);
    });

    test('delayedRecall score should be calculated correctly : 1', () {
      RPActivityStep delayedRecall = RPDelayedRecallActivity(
        identifier: 'DelayedRecall step ID',
        lengthOfTest: 180,
        numberOfTests: 3,
        includeResults: false,
      );
      List<String> wordlist = ['banana', 'icecream', 'violin', 'desk', 'green'];
      List<String> resultList = ['wrong', 'wrong', 'banana', 'wrong', 'wrong'];
      var score = delayedRecall.calculateScore({
        'wordsList': wordlist,
        'resultsList': resultList,
      });
      expect(score, 1);
    });
  });
}
