import 'dart:io';
import 'package:test/test.dart';
import 'dart:convert';
import 'package:carp_serializable/carp_serializable.dart';
import 'package:research_package/research_package.dart';
import 'package:cognition_package/cognition_package.dart';

/// Tests are focusing mainly on Object -> JSON direction since the current
/// use-case for Research Package doesn't include the other way around,
/// only uploading results to server
void main() {
  RPOrderedTask? surveyTask;
  RPTaskResult? surveyResult;

  setUp(() {
    // initialize the cognition package.
    CognitionPackage.ensureInitialized();

    RPCompletionStep completionStep =
        RPCompletionStep(identifier: 'completionID', title: 'Finished')
          ..title = 'Finished'
          ..text = 'Thank you for taking the tests';

    RPActivityStep tappingStep = RPTappingActivity(
      identifier: 'Tapping step ID',
    );

    RPActivityStep reactionTimeStep = RPReactionTimeActivity(
      identifier: 'Reaction Time step ID',
    );

    RPActivityStep rapidVisualInfoProcessingStep =
        RPRapidVisualInfoProcessingActivity(
          identifier: 'RVIP step ID',
          lengthOfTest: 10,
        );

    RPActivityStep activityStepTrail = RPTrailMakingActivity(
      identifier: 'Trail Making step ID',
      trailType: TrailType.B,
      includeResults: false,
    );

    RPActivityStep activityStepLetterTapping = RPLetterTappingActivity(
      identifier: 'Letter Tapping step ID',
      includeResults: false,
    );

    RPActivityStep pairedAssociatesLearningStep =
        RPPairedAssociatesLearningActivity(identifier: 'PAL step ID');

    RPActivityStep corsiBlockTapping = RPCorsiBlockTappingActivity(
      identifier: 'Corsi Block Tapping step ID',
    );

    RPActivityStep stroopEffect = RPStroopEffectActivity(
      identifier: 'Stroop Effect step ID',
    );

    RPActivityStep flanker = RPFlankerActivity(
      identifier: 'Flanker step ID',
      lengthOfTest: 45 /* 300 */,
      numberOfCards: 10,
      includeResults: true,
    );

    RPActivityStep pictureSequenceMemory = RPPictureSequenceMemoryActivity(
      identifier: 'PictureSequenceMemory step ID',
      lengthOfTest: 180,
      numberOfTests: 1,
      numberOfPics: 6,
      includeResults: false,
    );

    RPActivityStep wordRecall = RPWordRecallActivity(
      identifier: 'WordRecall step ID',
      lengthOfTest: 180,
      numberOfTests: 3,
      includeResults: false,
    );

    RPActivityStep delayedRecall = RPDelayedRecallActivity(
      identifier: 'DelayedRecall step ID',
      lengthOfTest: 180,
      numberOfTests: 3,
      includeResults: false,
    );

    RPActivityStep visualArrayChange = RPVisualArrayChangeActivity(
      identifier: 'VisualArrayChange step ID',
      lengthOfTest: 180,
      numberOfTests: 3,
      waitTime: 3,
      includeResults: false,
    );

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

    surveyTask = RPOrderedTask(
      identifier: 'surveyTaskID',
      steps: [
        reactionTimeStep,
        pairedAssociatesLearningStep,
        tappingStep,
        corsiBlockTapping,
        stroopEffect,
        rapidVisualInfoProcessingStep,
        activityStepTrail,
        continuousVisualTracking,
        wordRecall,
        pictureSequenceMemory,
        activityStepLetterTapping,
        flanker,
        visualArrayChange,
        delayedRecall,
        completionStep,
      ],
    );

    surveyResult = RPTaskResult(identifier: surveyTask!.identifier);
    surveyResult!.results[delayedRecall.identifier] = RPDelayedRecallResult(
      identifier: delayedRecall.identifier,
    );
    surveyResult!.results[flanker.identifier] = RPFlankerResult(
      identifier: flanker.identifier,
    );
    surveyResult!.results[pictureSequenceMemory.identifier] =
        RPPictureSequenceResult(identifier: pictureSequenceMemory.identifier);
    surveyResult!.results[visualArrayChange.identifier] =
        RPVisualArrayChangeResult(identifier: visualArrayChange.identifier);
    surveyResult!.results[wordRecall.identifier] = RPWordRecallResult(
      identifier: wordRecall.identifier,
    );
  });

  group('Cognition Survey', () {
    test('Cognition Survey -> JSON', () {
      print(toJsonString(surveyTask!));
    });

    test(
      'Cognition Survey -> JSON -> Cognition Survey :: deep assert',
      () async {
        final surveyJson = toJsonString(surveyTask!);

        RPOrderedTask survey = RPOrderedTask.fromJson(
          json.decode(surveyJson) as Map<String, dynamic>,
        );
        expect(toJsonString(survey), equals(surveyJson));
      },
    );

    test('JSON file -> Cognition Survey', () async {
      String surveyJson = File(
        'test/json/cognition_survey.json',
      ).readAsStringSync();

      RPOrderedTask survey = RPOrderedTask.fromJson(
        json.decode(surveyJson) as Map<String, dynamic>,
      );

      expect(survey.steps.length, surveyTask!.steps.length);
      expect(survey.steps.first.identifier, surveyTask!.steps.first.identifier);
      print(toJsonString(survey));
    });
  });

  group('Results', () {
    test('RPTaskResult -> JSON', () {
      print(toJsonString(surveyResult!));
      expect(surveyResult?.results.length, 5);
    });

    test('JSON -> Recall RPTaskResult', () async {
      String plainJson = File(
        'test/json/recall_result.json',
      ).readAsStringSync();

      final task = RPTaskResult.fromJson(
        json.decode(plainJson) as Map<String, dynamic>,
      );

      expect(task.$type, task.runtimeType.toString());
      expect(task.results.values.first.$type, 'RPDelayedRecallResult');
      print(toJsonString(task));

      // deep assert
      final taskJson = toJsonString(task);
      final taskFromJson = RPTaskResult.fromJson(
        json.decode(taskJson) as Map<String, dynamic>,
      );
      expect(toJsonString(taskFromJson), equals(taskJson));
    });

    test('JSON -> Flanker RPTaskResult', () async {
      String plainJson = File(
        'test/json/flanker_result.json',
      ).readAsStringSync();

      final task = RPTaskResult.fromJson(
        json.decode(plainJson) as Map<String, dynamic>,
      );

      expect(task.$type, task.runtimeType.toString());
      expect(task.results.values.first.$type, 'RPActivityResult');
      print(toJsonString(task));

      // deep assert
      final taskJson = toJsonString(task);
      final taskFromJson = RPTaskResult.fromJson(
        json.decode(taskJson) as Map<String, dynamic>,
      );
      expect(toJsonString(taskFromJson), equals(taskJson));
    });
  });
}
