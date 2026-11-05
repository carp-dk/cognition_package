part of 'main.dart';

// Here the list of cognitive test are added to an RP ordered task.
// Uncomment the ones you want to see a demo of.
RPOrderedTask cognitionTask = RPOrderedTask(
  identifier: 'cognition_demo_task',
  steps: [
    // reactionTime,
    // pairedAssociatesLearning,
    // tapping,
    // corsiBlockTapping,
    // stroopEffect,
    // rapidVisualInfoProcessing,
    // trailMaking,
    // continuousVisualTracking,
    // wordRecall,
    pictureSequenceMemory,
    // letterTapping,
    flanker,
    // visualArrayChange,
    // delayedRecall,
    completionStep,
  ],
);

// Note how steps can be localized by using a translation key and adding
// the translation to the locale files in the 'assets/lang' folder.
final completionStep = RPCompletionStep(
  identifier: 'completion_step',
  title: 'completion_title',
  text: 'completion_text',
);

final tapping = RPTappingActivity(identifier: 'tapping_step');

final reactionTime = RPReactionTimeActivity(identifier: 'reaction_time_step');

final rapidVisualInfoProcessing = RPRapidVisualInfoProcessingActivity(
  identifier: 'RVIP_step',
  lengthOfTest: 10,
);

final trailMaking = RPTrailMakingActivity(
  identifier: 'trail_making_step',
  trailType: TrailType.B,
  includeResults: false,
);

final letterTapping = RPLetterTappingActivity(
  identifier: 'letter_tapping_step',
  includeResults: false,
);

final pairedAssociatesLearning = RPPairedAssociatesLearningActivity(
  identifier: 'PAL_step',
);

final corsiBlockTapping = RPCorsiBlockTappingActivity(
  identifier: 'corsi_block_step',
);

final stroopEffect = RPStroopEffectActivity(identifier: 'stroop_ffect_step');

final flanker = RPFlankerActivity(
  identifier: 'flanker_step',
  lengthOfTest: 45,
  numberOfCards: 10,
  includeResults: true,
);

final pictureSequenceMemory = RPPictureSequenceMemoryActivity(
  identifier: 'PSM_step',
  lengthOfTest: 180,
  numberOfTests: 1,
  numberOfPics: 6,
  includeResults: false,
);

final wordRecall = RPWordRecallActivity(
  identifier: 'word_recall_step',
  lengthOfTest: 180,
  numberOfTests: 3,
  includeResults: false,
);

final delayedRecall = RPDelayedRecallActivity(
  identifier: 'delayed_recall_step',
  lengthOfTest: 180,
  numberOfTests: 3,
  includeResults: false,
);

final visualArrayChange = RPVisualArrayChangeActivity(
  identifier: 'VAC_step',
  lengthOfTest: 180,
  numberOfTests: 3,
  waitTime: 3,
  includeResults: false,
);

final continuousVisualTracking = RPContinuousVisualTrackingActivity(
  identifier: 'CVT_step',
  numberOfTests: 3,
  amountOfDots: 15,
  dotSize: 40,
  lengthOfTest: 180,
  trackingSpeed: const Duration(seconds: 5),
  includeResults: false,
);
