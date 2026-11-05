part of '../../../../ui.dart';

/// The [RPUIRapidVisualInfoProcessingActivityBody] class defines the UI for the
/// instructions and test phase of the continuous visual tracking task.
class RPUIRapidVisualInfoProcessingActivityBody extends StatefulWidget {
  /// The [RPUIRapidVisualInfoProcessingActivityBody] activity.
  final RPRapidVisualInfoProcessingActivity activity;

  /// The results function for the [RPUIRapidVisualInfoProcessingActivityBody].
  final void Function(dynamic) onResultChange;

  /// the [RPActivityEventLogger] for the [RPUIRapidVisualInfoProcessingActivityBody].
  final RPActivityEventLogger eventLogger;

  /// The [RPUIRapidVisualInfoProcessingActivityBody] constructor.
  const RPUIRapidVisualInfoProcessingActivityBody(
    this.activity,
    this.eventLogger,
    this.onResultChange, {
    super.key,
  });

  @override
  RPUIRapidVisualInfoProcessingActivityBodyState createState() =>
      RPUIRapidVisualInfoProcessingActivityBodyState();
}

class RPUIRapidVisualInfoProcessingActivityBodyState
    extends State<RPUIRapidVisualInfoProcessingActivityBody> {
  final _random = Random();
  String texthint = 'rapid_visual_info.tap_button';
  int newNum = 0; //int for next random generated number on screen
  int goodTaps = 0; //number of taps that were correct
  int badTaps = 0; //number of taps that were wrong
  int seqsPassed =
      0; //number of times the given sequence passed: cap for good taps
  Duration displayTime = const Duration(
    seconds: 1,
  ); //amount of time each number is displayed
  ActivityStatus activityStatus = ActivityStatus.Instruction;
  bool seqPassed =
      false; //if a sequence has passed or not, meaning a tap would be a correct tap if true
  List<bool> listIndexes = [
    true,
  ]; //booleans for keeping track of lowest index - for registering a sequence has passed
  String seq1s = ''; //string for display of sequence
  List<int> curSeq = []; //numbers that have appeared on screen in a list
  List<int> delaysList =
      []; //list of delay from seqPassed is set true, to button is pressed
  final _sw = Stopwatch();

  Timer? timer;

  //Todo: determine how test results are evaluated: Hit sequences, delay in doing so, and false taps are recorded
  //seqsPassed can be different that good and bad taps total! Meaning tap should have occured but didnt, before next full sequence.

  @override
  initState() {
    super.initState();
    for (int i = 0; i < widget.activity.sequence.length; i++) {
      seq1s = '$seq1s${widget.activity.sequence[i]}  ';
    }
    for (int i = 0; i < widget.activity.sequence.length; i++) {
      //adds bools according to sequence lengths
      listIndexes.add(false);
    }
    if (widget.activity.includeInstructions) {
      activityStatus = ActivityStatus.Instruction;
      widget.eventLogger.instructionStarted();
    } else {
      activityStatus = ActivityStatus.Test;
      widget.eventLogger.testStarted();
      startTest();
    }
  }

  void startTest() async {
    await Future<dynamic>.delayed(const Duration(seconds: 1));

    //periodic timer to update number on screen - starts in init currently.
    timer = Timer.periodic(displayTime, (Timer t) {
      //make sure window is mounted and that test is live before setting state.
      if (activityStatus == ActivityStatus.Test && mounted) {
        setState(() {
          numGenerator();
          sequenceChecker(
            widget.activity.sequence,
          ); //check for sequence - could be for looped through multiple sequences if wanted, displayng current one.
        });
      } else {
        t.cancel();
      }
    });
    Timer(Duration(seconds: widget.activity.lengthOfTest), () {
      //when time is up, change window and set result
      if (mounted) {
        widget.eventLogger.testEnded();
        widget.onResultChange({
          'Correct taps': goodTaps,
          'incorrect taps': badTaps,
          'passed sequences': seqPassed,
          'Delay on correct taps': delaysList,
        });
        if (widget.activity.includeResults) {
          widget.eventLogger.resultsShown();
          setState(() {
            activityStatus = ActivityStatus.Result;
          });
        }
      }
    });
  }

  void numGenerator() {
    //generates the numbers to display on screen
    int nextNum =
        _random.nextInt(widget.activity.interval) + 1; //plus one to not get 0.
    while (newNum == nextNum) {
      //currently code enforces no repetition of numbers - for graphical sakes.
      nextNum = _random.nextInt(widget.activity.interval) + 1;
    }
    newNum = nextNum;
    curSeq.add(newNum);
  }

  /// Check if sequence have appeared through setting an array of bools for
  /// each number. Keeping it dynamic, so size of sequence can vary freely.
  void sequenceChecker(List<int> seq) {
    for (int i = 0; i < widget.activity.sequence.length; i++) {
      if (newNum == seq[i] && listIndexes[i] == true) {
        listIndexes[i + 1] = true;
      }
    }
    if (listIndexes[listIndexes.length - 1] == true) {
      //set all bool flags to false except first one, to restart sequencing
      seqPassed =
          true; //set flag so next press on button gives a positive result
      seqsPassed++;
      _sw.reset(); //if a new sequence passes, reset stopwatch
      _sw.start(); //timer to note delay on presssing button after seeing sequence
      for (int i = 0; i < listIndexes.length - 1; i++) {
        //reset list of bools for tracking if sequence passed
        listIndexes[i + 1] = false;
      }
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
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
                locale?.translate(texthint) ?? 'Hint',
                style: const TextStyle(fontSize: 20),
                overflow: TextOverflow.ellipsis,
                maxLines: 20,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Container(
                height: MediaQuery.of(context).size.height / 2.5,
                width: MediaQuery.of(context).size.width / 1.1,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(
                      'packages/cognition_package/assets/images/RVIPintro.png',
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
                  widget.eventLogger.instructionEnded();
                  widget.eventLogger.testStarted();
                  if (mounted) {
                    setState(() {
                      activityStatus = ActivityStatus.Test;
                    });
                  }
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
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '${locale?.translate('sequence') ?? 'Sequence'}:',
                    style: const TextStyle(fontSize: 24),
                  ),
                  Text(seq1s, style: const TextStyle(fontSize: 32)),
                  Container(height: 40),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '${locale?.translate('number') ?? 'Number'}:',
                        style: const TextStyle(fontSize: 24),
                      ),
                      Text('$newNum', style: const TextStyle(fontSize: 40)),
                    ],
                  ),
                  Container(height: 40),
                  SizedBox(
                    height: 80,
                    width: 160,
                    child: OutlinedButton(
                      child: Text(
                        locale?.translate('guess') ?? 'Guess',
                        style: const TextStyle(fontSize: 18),
                      ),
                      onPressed: () {
                        // time is tracked if sequence has actually passed, otherwise no
                        if (seqPassed) {
                          seqPassed = false;
                          goodTaps++;
                          _sw.stop();
                          delaysList.add(_sw.elapsedMilliseconds);
                          int tapDelay = _sw.elapsedMilliseconds;
                          widget.eventLogger.addCorrectGesture(
                            'Button tap',
                            'Correct tap. Number of sequences passed: $seqsPassed. Delay on tap: $tapDelay. Shown sequence: $curSeq',
                          );
                          _sw.reset();
                        } else {
                          widget.eventLogger.addWrongGesture(
                            'Button tap',
                            'Incorrect tap. Number of sequences passed: $seqsPassed. Shown sequence: $curSeq',
                          );
                          badTaps++;
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      case ActivityStatus.Result:
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                locale?.translate('test_done') ?? "The test is done.",
                style: const TextStyle(fontSize: 22),
              ),
              Text(
                '${locale?.translate('you_had') ?? "You had"} $goodTaps ${locale?.translate('rapid_visual_info.correct_taps') ?? "correct guesses"} ${locale?.translate('and') ?? 'and'} $badTaps ${locale?.translate('rapid_visual_info.wrong_ones') ?? "wrong ones"}.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22),
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
              ),
            ],
          ),
        );
    }
  }
}
