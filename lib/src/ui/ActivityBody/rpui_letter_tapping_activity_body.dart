part of '../../../../ui.dart';

/// The [RPUILetterTappingActivityBody] class defines the UI for the
/// instructions and test phase of the continuous visual tracking task.
class RPUILetterTappingActivityBody extends StatefulWidget {
  /// The [RPUILetterTappingActivityBody] activity.
  final RPLetterTappingActivity activity;

  /// The results function for the [RPUILetterTappingActivityBody].
  final void Function(dynamic) onResultChange;

  /// the [RPActivityEventLogger] for the [RPUILetterTappingActivityBody].
  final RPActivityEventLogger eventLogger;

  /// The [RPUILetterTappingActivityBody] constructor.
  const RPUILetterTappingActivityBody(
    this.activity,
    this.eventLogger,
    this.onResultChange, {
    super.key,
  });

  @override
  RPUILetterTappingActivityBodyState createState() =>
      RPUILetterTappingActivityBodyState();
}

class RPUILetterTappingActivityBodyState
    extends State<RPUILetterTappingActivityBody> {
  final player = AudioPlayer();

  late String currentLetter;
  late String lastLetter;
  int errors = 0;
  late bool shouldTap;
  late bool lastWasTapped;
  bool wasTapped = false;
  int letterIndex = 0;
  ActivityStatus activityStatus = ActivityStatus.Instruction;

  /// The list of letters in the MOCA test.
  List<String> mocaLetterList = [
    'F',
    'B',
    'A',
    'C',
    'M',
    'N',
    'A',
    'A',
    'J',
    'K',
    'L',
    'B',
    'A',
    'F',
    'A',
    'K',
    'D',
    'E',
    'A',
    'A',
    'A',
    'J',
    'A',
    'M',
    'O',
    'F',
    'A',
    'A',
    'B',
  ];

  @override
  initState() {
    super.initState();
    // soundService = SoundService(alphabet
    //     .map(
    //         (item) => ('../packages/cognition_package/assets/sounds/$item.mp3'))
    //     .toList());
    currentLetter = mocaLetterList.first;
    lastLetter = '';
    if (widget.activity.includeInstructions) {
      activityStatus = ActivityStatus.Instruction;
      widget.eventLogger.instructionStarted();
    } else {
      activityStatus = ActivityStatus.Test;
      widget.eventLogger.testStarted();
      startTest();
    }
  }

  Future<void> startTest() async {
    widget.eventLogger.instructionEnded();
    widget.eventLogger.testStarted();
    setState(() {
      activityStatus = ActivityStatus.Test;
    });
    await Future<dynamic>.delayed(const Duration(seconds: 2));
    for (String letter in mocaLetterList) {
      if (!mounted) break;
      await player.setAsset(
        '../packages/cognition_package/assets/sounds/$letter.mp3',
      );
      await player.play();

      updateLetter(letter);
      await Future<dynamic>.delayed(const Duration(milliseconds: 1000));
      if (letterIndex < 29) letterIndex += 1;
    }
    updateLetter('');
    if (mounted) {
      int score = errors < 2 ? 1 : 0;
      widget.onResultChange({'amount of errors': errors, 'score': score});
      widget.eventLogger.testEnded();
      if (widget.activity.includeResults) {
        widget.eventLogger.resultsShown();
        setState(() {
          activityStatus = ActivityStatus.Result;
        });
      }
    }
  }

  void updateLetter(String newLetter) {
    if (lastLetter == 'A' && !lastWasTapped) {
      errors += 1;
      String s;
      if (letterIndex == mocaLetterList.length) {
        s = '${mocaLetterList.getRange(0, letterIndex - 2)} >A< ${mocaLetterList.getRange(letterIndex - 1, mocaLetterList.length)}';
      } else {
        s = '${mocaLetterList.getRange(0, letterIndex - 2)} >A< ${mocaLetterList.getRange(letterIndex - 1, mocaLetterList.length)}';
      }
      widget.eventLogger.addWrongGesture(
        'Missed button tap',
        'Did not press button on: $s',
      );
    }
    lastWasTapped = wasTapped;
    wasTapped = false;
    lastLetter = currentLetter;
    currentLetter = newLetter;
  }

  @override
  Widget build(BuildContext context) {
    var locale = CPLocalizations.of(context);
    switch (activityStatus) {
      case ActivityStatus.Instruction:
        return Column(
          //entry screen with rules and start button
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                locale?.translate('letter_tapping.turn_on_sound') ??
                    "Turn your sound on.",
                style: const TextStyle(fontSize: 20),
                overflow: TextOverflow.ellipsis,
                maxLines: 20,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                locale?.translate('letter_tapping.tap_A_button') ??
                    "Then, tap the button on the next screen, whenever you hear the letter 'A' being said.",
                style: const TextStyle(fontSize: 20),
                overflow: TextOverflow.ellipsis,
                maxLines: 20,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Container(
                height: 250,
                width: 250,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(
                      'packages/cognition_package/assets/images/letter_tapping.png',
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: OutlinedButton(
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                onPressed: () {
                  startTest();
                },
                child: Text(
                  locale?.translate('ready') ?? 'Ready',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        );
      case ActivityStatus.Test:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 100,
              height: 60,
              child: OutlinedButton(
                child: const Text('A'),
                onPressed: () {
                  // X - X
                  if (currentLetter != 'A' && lastLetter != 'A') {
                    errors += 1;
                    String s =
                        '${(letterIndex > 0) ? mocaLetterList.getRange(0, letterIndex) : ''}'
                        '>$currentLetter<'
                        '${mocaLetterList.getRange(letterIndex + 1, mocaLetterList.length)}';
                    widget.eventLogger.addWrongGesture(
                      'Button tap',
                      'Pressed button on wrong letter: $s',
                    );
                  }
                  // A - A
                  if (lastLetter == 'A' && currentLetter == 'A') {
                    if (!lastWasTapped) {
                      widget.eventLogger.addCorrectGesture(
                        'Button tap',
                        'Tapped letter with a delay: ${mocaLetterList.getRange(0, letterIndex - 1)} >A< ${mocaLetterList.getRange(letterIndex, mocaLetterList.length)}',
                      );
                      lastWasTapped = true;
                    } else if (lastWasTapped && !wasTapped) {
                      widget.eventLogger.addCorrectGesture(
                        'Button tap',
                        'Tapped letter without delay: ${mocaLetterList.getRange(0, letterIndex)} >A< ${mocaLetterList.getRange(letterIndex + 1, mocaLetterList.length)}',
                      );
                      wasTapped = true;
                    } else {
                      errors += 1;
                      widget.eventLogger.addWrongGesture(
                        'Button tap',
                        'Tapped letter too many times: ${mocaLetterList.getRange(0, letterIndex)} >A< ${mocaLetterList.getRange(letterIndex + 1, mocaLetterList.length)}',
                      );
                    }
                  }
                  // A - X
                  if (lastLetter == 'A' && currentLetter != 'A') {
                    if (lastWasTapped) {
                      errors += 1;
                      widget.eventLogger.addWrongGesture(
                        'Button tap',
                        'Tapped letter too many times: ${mocaLetterList.getRange(0, letterIndex - 1)} >A< ${mocaLetterList.getRange(letterIndex, mocaLetterList.length)}',
                      );
                    } else {
                      lastWasTapped = true;
                      widget.eventLogger.addCorrectGesture(
                        'Button tap',
                        'Tapped letter with a delay: ${mocaLetterList.getRange(0, letterIndex - 1)} >A< ${mocaLetterList.getRange(letterIndex, mocaLetterList.length)}',
                      );
                    }
                  }
                  // X - A
                  if (lastLetter != 'A' && currentLetter == 'A') {
                    if (wasTapped) {
                      errors += 1;
                      widget.eventLogger.addWrongGesture(
                        'Button tap',
                        'Tapped letter too many times: ${mocaLetterList.getRange(0, letterIndex - 1)} >A< ${mocaLetterList.getRange(letterIndex + 1, mocaLetterList.length)}',
                      );
                    } else {
                      wasTapped = true;
                      widget.eventLogger.addCorrectGesture(
                        'Button tap',
                        'Tapped letter without delay: ${mocaLetterList.getRange(0, letterIndex)} >A< ${mocaLetterList.getRange(letterIndex + 1, mocaLetterList.length)}',
                      );
                    }
                  }
                },
              ),
            ),
          ],
        );
      case ActivityStatus.Result:
        return Center(
          child: Text(
            '${locale?.translate('you_had') ?? 'You had'} $errors ${locale?.translate('mistakes') ?? 'mistakes'}',
            style: const TextStyle(fontSize: 22),
            textAlign: TextAlign.center,
          ),
        );
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}
