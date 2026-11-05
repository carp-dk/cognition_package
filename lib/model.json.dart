// Auto generate json code (.g files) with:
//   dart run build_runner build --delete-conflicting-outputs
part of 'model.dart';

bool _fromJsonFunctionsRegistered = false;

/// Register all the fromJson functions for the deployment domain classes.
void _registerFromJsonFunctions() {
  if (_fromJsonFunctionsRegistered) return;
  _fromJsonFunctionsRegistered = true;

  // activity step classes
  FromJsonFactory().registerAll([
    RPContinuousVisualTrackingActivity(identifier: ''),
    RPCorsiBlockTappingActivity(identifier: ''),
    RPDelayedRecallActivity(identifier: ''),
    RPFlankerActivity(identifier: ''),
    RPLetterTappingActivity(identifier: ''),
    RPPairedAssociatesLearningActivity(identifier: ''),
    RPPictureSequenceMemoryActivity(identifier: ''),
    RPRapidVisualInfoProcessingActivity(identifier: ''),
    RPReactionTimeActivity(identifier: ''),
    RPStroopEffectActivity(identifier: ''),
    RPTappingActivity(identifier: ''),
    RPTrailMakingActivity(identifier: ''),
    RPVisualArrayChangeActivity(identifier: ''),
    RPWordRecallActivity(identifier: ''),
  ]);

  // result classes
  FromJsonFactory().registerAll([
    RPDelayedRecallResult(identifier: ''),
    RPFlankerResult(identifier: ''),
    RPPictureSequenceResult(identifier: ''),
    RPVisualArrayChangeResult(identifier: ''),
    RPVisualTrackingResult(identifier: ''),
    RPWordRecallResult(identifier: ''),
  ]);
}
