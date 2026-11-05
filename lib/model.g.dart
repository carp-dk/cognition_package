// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RPCorsiBlockTappingActivity _$RPCorsiBlockTappingActivityFromJson(
  Map<String, dynamic> json,
) =>
    RPCorsiBlockTappingActivity(
        identifier: json['identifier'] as String,
        includeInstructions: json['includeInstructions'] as bool? ?? true,
        includeResults: json['includeResults'] as bool? ?? true,
      )
      ..$type = json['__type'] as String?
      ..title = json['title'] as String
      ..text = json['text'] as String?
      ..optional = json['optional'] as bool
      ..footnote = json['footnote'] as String?;

Map<String, dynamic> _$RPCorsiBlockTappingActivityToJson(
  RPCorsiBlockTappingActivity instance,
) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['identifier'] = instance.identifier;
  val['title'] = instance.title;
  writeNotNull('text', instance.text);
  val['optional'] = instance.optional;
  writeNotNull('footnote', instance.footnote);
  val['includeInstructions'] = instance.includeInstructions;
  val['includeResults'] = instance.includeResults;
  return val;
}

RPLetterTappingActivity _$RPLetterTappingActivityFromJson(
  Map<String, dynamic> json,
) =>
    RPLetterTappingActivity(
        identifier: json['identifier'] as String,
        includeInstructions: json['includeInstructions'] as bool? ?? true,
        includeResults: json['includeResults'] as bool? ?? true,
      )
      ..$type = json['__type'] as String?
      ..title = json['title'] as String
      ..text = json['text'] as String?
      ..optional = json['optional'] as bool
      ..footnote = json['footnote'] as String?;

Map<String, dynamic> _$RPLetterTappingActivityToJson(
  RPLetterTappingActivity instance,
) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['identifier'] = instance.identifier;
  val['title'] = instance.title;
  writeNotNull('text', instance.text);
  val['optional'] = instance.optional;
  writeNotNull('footnote', instance.footnote);
  val['includeInstructions'] = instance.includeInstructions;
  val['includeResults'] = instance.includeResults;
  return val;
}

RPPairedAssociatesLearningActivity _$RPPairedAssociatesLearningActivityFromJson(
  Map<String, dynamic> json,
) =>
    RPPairedAssociatesLearningActivity(
        identifier: json['identifier'] as String,
        includeInstructions: json['includeInstructions'] as bool? ?? true,
        includeResults: json['includeResults'] as bool? ?? true,
        maxTestDuration: (json['maxTestDuration'] as num?)?.toInt() ?? 100,
      )
      ..$type = json['__type'] as String?
      ..title = json['title'] as String
      ..text = json['text'] as String?
      ..optional = json['optional'] as bool
      ..footnote = json['footnote'] as String?;

Map<String, dynamic> _$RPPairedAssociatesLearningActivityToJson(
  RPPairedAssociatesLearningActivity instance,
) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['identifier'] = instance.identifier;
  val['title'] = instance.title;
  writeNotNull('text', instance.text);
  val['optional'] = instance.optional;
  writeNotNull('footnote', instance.footnote);
  val['includeInstructions'] = instance.includeInstructions;
  val['includeResults'] = instance.includeResults;
  val['maxTestDuration'] = instance.maxTestDuration;
  return val;
}

RPRapidVisualInfoProcessingActivity
_$RPRapidVisualInfoProcessingActivityFromJson(Map<String, dynamic> json) =>
    RPRapidVisualInfoProcessingActivity(
        identifier: json['identifier'] as String,
        includeInstructions: json['includeInstructions'] as bool? ?? true,
        includeResults: json['includeResults'] as bool? ?? true,
        interval: (json['interval'] as num?)?.toInt() ?? 9,
        lengthOfTest: (json['lengthOfTest'] as num?)?.toInt() ?? 90,
        sequence:
            (json['sequence'] as List<dynamic>?)
                ?.map((e) => (e as num).toInt())
                .toList() ??
            const [3, 6, 9],
      )
      ..$type = json['__type'] as String?
      ..title = json['title'] as String
      ..text = json['text'] as String?
      ..optional = json['optional'] as bool
      ..footnote = json['footnote'] as String?;

Map<String, dynamic> _$RPRapidVisualInfoProcessingActivityToJson(
  RPRapidVisualInfoProcessingActivity instance,
) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['identifier'] = instance.identifier;
  val['title'] = instance.title;
  writeNotNull('text', instance.text);
  val['optional'] = instance.optional;
  writeNotNull('footnote', instance.footnote);
  val['includeInstructions'] = instance.includeInstructions;
  val['includeResults'] = instance.includeResults;
  val['interval'] = instance.interval;
  val['lengthOfTest'] = instance.lengthOfTest;
  val['sequence'] = instance.sequence;
  return val;
}

RPReactionTimeActivity _$RPReactionTimeActivityFromJson(
  Map<String, dynamic> json,
) =>
    RPReactionTimeActivity(
        identifier: json['identifier'] as String,
        includeInstructions: json['includeInstructions'] as bool? ?? true,
        includeResults: json['includeResults'] as bool? ?? true,
        lengthOfTest: (json['lengthOfTest'] as num?)?.toInt() ?? 30,
        switchInterval: (json['switchInterval'] as num?)?.toInt() ?? 4,
      )
      ..$type = json['__type'] as String?
      ..title = json['title'] as String
      ..text = json['text'] as String?
      ..optional = json['optional'] as bool
      ..footnote = json['footnote'] as String?;

Map<String, dynamic> _$RPReactionTimeActivityToJson(
  RPReactionTimeActivity instance,
) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['identifier'] = instance.identifier;
  val['title'] = instance.title;
  writeNotNull('text', instance.text);
  val['optional'] = instance.optional;
  writeNotNull('footnote', instance.footnote);
  val['includeInstructions'] = instance.includeInstructions;
  val['includeResults'] = instance.includeResults;
  val['lengthOfTest'] = instance.lengthOfTest;
  val['switchInterval'] = instance.switchInterval;
  return val;
}

RPStroopEffectActivity _$RPStroopEffectActivityFromJson(
  Map<String, dynamic> json,
) =>
    RPStroopEffectActivity(
        identifier: json['identifier'] as String,
        includeInstructions: json['includeInstructions'] as bool? ?? true,
        includeResults: json['includeResults'] as bool? ?? true,
        lengthOfTest: (json['lengthOfTest'] as num?)?.toInt() ?? 40,
        displayTime: (json['displayTime'] as num?)?.toInt() ?? 1000,
        delayTime: (json['delayTime'] as num?)?.toInt() ?? 750,
      )
      ..$type = json['__type'] as String?
      ..title = json['title'] as String
      ..text = json['text'] as String?
      ..optional = json['optional'] as bool
      ..footnote = json['footnote'] as String?;

Map<String, dynamic> _$RPStroopEffectActivityToJson(
  RPStroopEffectActivity instance,
) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['identifier'] = instance.identifier;
  val['title'] = instance.title;
  writeNotNull('text', instance.text);
  val['optional'] = instance.optional;
  writeNotNull('footnote', instance.footnote);
  val['includeInstructions'] = instance.includeInstructions;
  val['includeResults'] = instance.includeResults;
  val['lengthOfTest'] = instance.lengthOfTest;
  val['displayTime'] = instance.displayTime;
  val['delayTime'] = instance.delayTime;
  return val;
}

RPTappingActivity _$RPTappingActivityFromJson(Map<String, dynamic> json) =>
    RPTappingActivity(
        identifier: json['identifier'] as String,
        includeInstructions: json['includeInstructions'] as bool? ?? true,
        includeResults: json['includeResults'] as bool? ?? true,
        lengthOfTest: (json['lengthOfTest'] as num?)?.toInt() ?? 30,
      )
      ..$type = json['__type'] as String?
      ..title = json['title'] as String
      ..text = json['text'] as String?
      ..optional = json['optional'] as bool
      ..footnote = json['footnote'] as String?;

Map<String, dynamic> _$RPTappingActivityToJson(RPTappingActivity instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['identifier'] = instance.identifier;
  val['title'] = instance.title;
  writeNotNull('text', instance.text);
  val['optional'] = instance.optional;
  writeNotNull('footnote', instance.footnote);
  val['includeInstructions'] = instance.includeInstructions;
  val['includeResults'] = instance.includeResults;
  val['lengthOfTest'] = instance.lengthOfTest;
  return val;
}

RPTrailMakingActivity _$RPTrailMakingActivityFromJson(
  Map<String, dynamic> json,
) =>
    RPTrailMakingActivity(
        identifier: json['identifier'] as String,
        includeInstructions: json['includeInstructions'] as bool? ?? true,
        includeResults: json['includeResults'] as bool? ?? true,
        trailType:
            $enumDecodeNullable(_$TrailTypeEnumMap, json['trailType']) ??
            TrailType.A,
      )
      ..$type = json['__type'] as String?
      ..title = json['title'] as String
      ..text = json['text'] as String?
      ..optional = json['optional'] as bool
      ..footnote = json['footnote'] as String?;

Map<String, dynamic> _$RPTrailMakingActivityToJson(
  RPTrailMakingActivity instance,
) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['identifier'] = instance.identifier;
  val['title'] = instance.title;
  writeNotNull('text', instance.text);
  val['optional'] = instance.optional;
  writeNotNull('footnote', instance.footnote);
  val['includeInstructions'] = instance.includeInstructions;
  val['includeResults'] = instance.includeResults;
  val['trailType'] = _$TrailTypeEnumMap[instance.trailType]!;
  return val;
}

const _$TrailTypeEnumMap = {TrailType.A: 'A', TrailType.B: 'B'};

RPFlankerActivity _$RPFlankerActivityFromJson(Map<String, dynamic> json) =>
    RPFlankerActivity(
        identifier: json['identifier'] as String,
        includeInstructions: json['includeInstructions'] as bool? ?? true,
        includeResults: json['includeResults'] as bool? ?? true,
        lengthOfTest: (json['lengthOfTest'] as num?)?.toInt() ?? 90,
        numberOfCards: (json['numberOfCards'] as num?)?.toInt() ?? 25,
      )
      ..$type = json['__type'] as String?
      ..title = json['title'] as String
      ..text = json['text'] as String?
      ..optional = json['optional'] as bool
      ..footnote = json['footnote'] as String?;

Map<String, dynamic> _$RPFlankerActivityToJson(RPFlankerActivity instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['identifier'] = instance.identifier;
  val['title'] = instance.title;
  writeNotNull('text', instance.text);
  val['optional'] = instance.optional;
  writeNotNull('footnote', instance.footnote);
  val['includeInstructions'] = instance.includeInstructions;
  val['includeResults'] = instance.includeResults;
  val['lengthOfTest'] = instance.lengthOfTest;
  val['numberOfCards'] = instance.numberOfCards;
  return val;
}

RPPictureSequenceMemoryActivity _$RPPictureSequenceMemoryActivityFromJson(
  Map<String, dynamic> json,
) =>
    RPPictureSequenceMemoryActivity(
        identifier: json['identifier'] as String,
        includeInstructions: json['includeInstructions'] as bool? ?? true,
        includeResults: json['includeResults'] as bool? ?? true,
        lengthOfTest: (json['lengthOfTest'] as num?)?.toInt() ?? 90,
        numberOfTests: (json['numberOfTests'] as num?)?.toInt() ?? 3,
        numberOfPics: (json['numberOfPics'] as num?)?.toInt() ?? 3,
      )
      ..$type = json['__type'] as String?
      ..title = json['title'] as String
      ..text = json['text'] as String?
      ..optional = json['optional'] as bool
      ..footnote = json['footnote'] as String?;

Map<String, dynamic> _$RPPictureSequenceMemoryActivityToJson(
  RPPictureSequenceMemoryActivity instance,
) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['identifier'] = instance.identifier;
  val['title'] = instance.title;
  writeNotNull('text', instance.text);
  val['optional'] = instance.optional;
  writeNotNull('footnote', instance.footnote);
  val['includeInstructions'] = instance.includeInstructions;
  val['includeResults'] = instance.includeResults;
  val['lengthOfTest'] = instance.lengthOfTest;
  val['numberOfTests'] = instance.numberOfTests;
  val['numberOfPics'] = instance.numberOfPics;
  return val;
}

RPWordRecallActivity _$RPWordRecallActivityFromJson(
  Map<String, dynamic> json,
) =>
    RPWordRecallActivity(
        identifier: json['identifier'] as String,
        includeInstructions: json['includeInstructions'] as bool? ?? true,
        includeResults: json['includeResults'] as bool? ?? true,
        lengthOfTest: (json['lengthOfTest'] as num?)?.toInt() ?? 90,
        numberOfTests: (json['numberOfTests'] as num?)?.toInt() ?? 3,
      )
      ..$type = json['__type'] as String?
      ..title = json['title'] as String
      ..text = json['text'] as String?
      ..optional = json['optional'] as bool
      ..footnote = json['footnote'] as String?;

Map<String, dynamic> _$RPWordRecallActivityToJson(
  RPWordRecallActivity instance,
) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['identifier'] = instance.identifier;
  val['title'] = instance.title;
  writeNotNull('text', instance.text);
  val['optional'] = instance.optional;
  writeNotNull('footnote', instance.footnote);
  val['includeInstructions'] = instance.includeInstructions;
  val['includeResults'] = instance.includeResults;
  val['lengthOfTest'] = instance.lengthOfTest;
  val['numberOfTests'] = instance.numberOfTests;
  return val;
}

RPDelayedRecallActivity _$RPDelayedRecallActivityFromJson(
  Map<String, dynamic> json,
) =>
    RPDelayedRecallActivity(
        identifier: json['identifier'] as String,
        includeInstructions: json['includeInstructions'] as bool? ?? true,
        includeResults: json['includeResults'] as bool? ?? true,
        lengthOfTest: (json['lengthOfTest'] as num?)?.toInt() ?? 90,
        numberOfTests: (json['numberOfTests'] as num?)?.toInt() ?? 3,
      )
      ..$type = json['__type'] as String?
      ..title = json['title'] as String
      ..text = json['text'] as String?
      ..optional = json['optional'] as bool
      ..footnote = json['footnote'] as String?;

Map<String, dynamic> _$RPDelayedRecallActivityToJson(
  RPDelayedRecallActivity instance,
) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['identifier'] = instance.identifier;
  val['title'] = instance.title;
  writeNotNull('text', instance.text);
  val['optional'] = instance.optional;
  writeNotNull('footnote', instance.footnote);
  val['includeInstructions'] = instance.includeInstructions;
  val['includeResults'] = instance.includeResults;
  val['lengthOfTest'] = instance.lengthOfTest;
  val['numberOfTests'] = instance.numberOfTests;
  return val;
}

RPVisualArrayChangeActivity _$RPVisualArrayChangeActivityFromJson(
  Map<String, dynamic> json,
) =>
    RPVisualArrayChangeActivity(
        identifier: json['identifier'] as String,
        includeInstructions: json['includeInstructions'] as bool? ?? true,
        includeResults: json['includeResults'] as bool? ?? true,
        numberOfShapes: (json['numberOfShapes'] as num?)?.toInt() ?? 3,
        lengthOfTest: (json['lengthOfTest'] as num?)?.toInt() ?? 90,
        waitTime: (json['waitTime'] as num?)?.toInt() ?? 2,
        numberOfTests: (json['numberOfTests'] as num?)?.toInt() ?? 3,
      )
      ..$type = json['__type'] as String?
      ..title = json['title'] as String
      ..text = json['text'] as String?
      ..optional = json['optional'] as bool
      ..footnote = json['footnote'] as String?;

Map<String, dynamic> _$RPVisualArrayChangeActivityToJson(
  RPVisualArrayChangeActivity instance,
) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['identifier'] = instance.identifier;
  val['title'] = instance.title;
  writeNotNull('text', instance.text);
  val['optional'] = instance.optional;
  writeNotNull('footnote', instance.footnote);
  val['includeInstructions'] = instance.includeInstructions;
  val['includeResults'] = instance.includeResults;
  val['lengthOfTest'] = instance.lengthOfTest;
  val['numberOfTests'] = instance.numberOfTests;
  val['numberOfShapes'] = instance.numberOfShapes;
  val['waitTime'] = instance.waitTime;
  return val;
}

RPContinuousVisualTrackingActivity _$RPContinuousVisualTrackingActivityFromJson(
  Map<String, dynamic> json,
) =>
    RPContinuousVisualTrackingActivity(
        identifier: json['identifier'] as String,
        includeInstructions: json['includeInstructions'] as bool? ?? true,
        includeResults: json['includeResults'] as bool? ?? true,
        lengthOfTest: (json['lengthOfTest'] as num?)?.toInt() ?? 90,
        numberOfTests: (json['numberOfTests'] as num?)?.toInt() ?? 3,
        amountOfDots: (json['amountOfDots'] as num?)?.toInt() ?? 5,
        amountOfTargets: (json['amountOfTargets'] as num?)?.toInt() ?? 2,
        dotSize: (json['dotSize'] as num?)?.toInt() ?? 100,
        trackingSpeed: json['trackingSpeed'] == null
            ? const Duration(seconds: 5)
            : Duration(microseconds: (json['trackingSpeed'] as num).toInt()),
      )
      ..$type = json['__type'] as String?
      ..title = json['title'] as String
      ..text = json['text'] as String?
      ..optional = json['optional'] as bool
      ..footnote = json['footnote'] as String?;

Map<String, dynamic> _$RPContinuousVisualTrackingActivityToJson(
  RPContinuousVisualTrackingActivity instance,
) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['identifier'] = instance.identifier;
  val['title'] = instance.title;
  writeNotNull('text', instance.text);
  val['optional'] = instance.optional;
  writeNotNull('footnote', instance.footnote);
  val['includeInstructions'] = instance.includeInstructions;
  val['includeResults'] = instance.includeResults;
  val['lengthOfTest'] = instance.lengthOfTest;
  val['numberOfTests'] = instance.numberOfTests;
  val['amountOfDots'] = instance.amountOfDots;
  val['amountOfTargets'] = instance.amountOfTargets;
  val['dotSize'] = instance.dotSize;
  val['trackingSpeed'] = instance.trackingSpeed.inMicroseconds;
  return val;
}

RPVisualTrackingResult _$RPVisualTrackingResultFromJson(
  Map<String, dynamic> json,
) => RPVisualTrackingResult(identifier: json['identifier'] as String)
  ..$type = json['__type'] as String?
  ..startDate = json['startDate'] == null
      ? null
      : DateTime.parse(json['startDate'] as String)
  ..endDate = json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String)
  ..results = json['results'] as Map<String, dynamic>
  ..stepTimes = StepTimes.fromJson(json['stepTimes'] as Map<String, dynamic>)
  ..interactions = (json['interactions'] as List<dynamic>)
      .map((e) => Interaction.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$RPVisualTrackingResultToJson(
  RPVisualTrackingResult instance,
) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['identifier'] = instance.identifier;
  writeNotNull('startDate', instance.startDate?.toIso8601String());
  writeNotNull('endDate', instance.endDate?.toIso8601String());
  val['results'] = instance.results;
  val['stepTimes'] = instance.stepTimes.toJson();
  val['interactions'] = instance.interactions.map((e) => e.toJson()).toList();
  return val;
}

RPFlankerResult _$RPFlankerResultFromJson(Map<String, dynamic> json) =>
    RPFlankerResult(identifier: json['identifier'] as String)
      ..$type = json['__type'] as String?
      ..startDate = json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String)
      ..endDate = json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String)
      ..results = json['results'] as Map<String, dynamic>
      ..stepTimes = StepTimes.fromJson(
        json['stepTimes'] as Map<String, dynamic>,
      )
      ..interactions = (json['interactions'] as List<dynamic>)
          .map((e) => Interaction.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$RPFlankerResultToJson(RPFlankerResult instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['identifier'] = instance.identifier;
  writeNotNull('startDate', instance.startDate?.toIso8601String());
  writeNotNull('endDate', instance.endDate?.toIso8601String());
  val['results'] = instance.results;
  val['stepTimes'] = instance.stepTimes.toJson();
  val['interactions'] = instance.interactions.map((e) => e.toJson()).toList();
  return val;
}

RPPictureSequenceResult _$RPPictureSequenceResultFromJson(
  Map<String, dynamic> json,
) => RPPictureSequenceResult(identifier: json['identifier'] as String)
  ..$type = json['__type'] as String?
  ..startDate = json['startDate'] == null
      ? null
      : DateTime.parse(json['startDate'] as String)
  ..endDate = json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String)
  ..results = json['results'] as Map<String, dynamic>
  ..stepTimes = StepTimes.fromJson(json['stepTimes'] as Map<String, dynamic>)
  ..interactions = (json['interactions'] as List<dynamic>)
      .map((e) => Interaction.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$RPPictureSequenceResultToJson(
  RPPictureSequenceResult instance,
) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['identifier'] = instance.identifier;
  writeNotNull('startDate', instance.startDate?.toIso8601String());
  writeNotNull('endDate', instance.endDate?.toIso8601String());
  val['results'] = instance.results;
  val['stepTimes'] = instance.stepTimes.toJson();
  val['interactions'] = instance.interactions.map((e) => e.toJson()).toList();
  return val;
}

RPVisualArrayChangeResult _$RPVisualArrayChangeResultFromJson(
  Map<String, dynamic> json,
) => RPVisualArrayChangeResult(identifier: json['identifier'] as String)
  ..$type = json['__type'] as String?
  ..startDate = json['startDate'] == null
      ? null
      : DateTime.parse(json['startDate'] as String)
  ..endDate = json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String)
  ..results = json['results'] as Map<String, dynamic>
  ..stepTimes = StepTimes.fromJson(json['stepTimes'] as Map<String, dynamic>)
  ..interactions = (json['interactions'] as List<dynamic>)
      .map((e) => Interaction.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$RPVisualArrayChangeResultToJson(
  RPVisualArrayChangeResult instance,
) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['identifier'] = instance.identifier;
  writeNotNull('startDate', instance.startDate?.toIso8601String());
  writeNotNull('endDate', instance.endDate?.toIso8601String());
  val['results'] = instance.results;
  val['stepTimes'] = instance.stepTimes.toJson();
  val['interactions'] = instance.interactions.map((e) => e.toJson()).toList();
  return val;
}

RPWordRecallResult _$RPWordRecallResultFromJson(Map<String, dynamic> json) =>
    RPWordRecallResult(identifier: json['identifier'] as String)
      ..$type = json['__type'] as String?
      ..startDate = json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String)
      ..endDate = json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String)
      ..results = json['results'] as Map<String, dynamic>
      ..stepTimes = StepTimes.fromJson(
        json['stepTimes'] as Map<String, dynamic>,
      )
      ..interactions = (json['interactions'] as List<dynamic>)
          .map((e) => Interaction.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$RPWordRecallResultToJson(RPWordRecallResult instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['identifier'] = instance.identifier;
  writeNotNull('startDate', instance.startDate?.toIso8601String());
  writeNotNull('endDate', instance.endDate?.toIso8601String());
  val['results'] = instance.results;
  val['stepTimes'] = instance.stepTimes.toJson();
  val['interactions'] = instance.interactions.map((e) => e.toJson()).toList();
  return val;
}

RPDelayedRecallResult _$RPDelayedRecallResultFromJson(
  Map<String, dynamic> json,
) => RPDelayedRecallResult(identifier: json['identifier'] as String)
  ..$type = json['__type'] as String?
  ..startDate = json['startDate'] == null
      ? null
      : DateTime.parse(json['startDate'] as String)
  ..endDate = json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String)
  ..results = json['results'] as Map<String, dynamic>
  ..stepTimes = StepTimes.fromJson(json['stepTimes'] as Map<String, dynamic>)
  ..interactions = (json['interactions'] as List<dynamic>)
      .map((e) => Interaction.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$RPDelayedRecallResultToJson(
  RPDelayedRecallResult instance,
) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['identifier'] = instance.identifier;
  writeNotNull('startDate', instance.startDate?.toIso8601String());
  writeNotNull('endDate', instance.endDate?.toIso8601String());
  val['results'] = instance.results;
  val['stepTimes'] = instance.stepTimes.toJson();
  val['interactions'] = instance.interactions.map((e) => e.toJson()).toList();
  return val;
}
