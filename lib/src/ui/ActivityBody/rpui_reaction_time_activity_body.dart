part of '../../../../ui.dart';

/// The [RPUIReactionTimeActivityBody] class defines the UI for the
/// instructions and test phase of the continuous visual tracking task.
class RPUIReactionTimeActivityBody extends StatefulWidget {
  /// The [RPUIReactionTimeActivityBody] activity.
  final RPReactionTimeActivity activity;

  /// The results function for the [RPUIReactionTimeActivityBody].
  final void Function(dynamic) onResultChange;

  /// the [RPActivityEventLogger] for the [RPUIReactionTimeActivityBody].
  final RPActivityEventLogger eventLogger;

  /// The [RPUIReactionTimeActivityBody] constructor.
  const RPUIReactionTimeActivityBody(
    this.activity,
    this.eventLogger,
    this.onResultChange, {
    super.key,
  });

  @override
  RPUIReactionTimeActivityBodyState createState() =>
      RPUIReactionTimeActivityBodyState();
}

class RPUIReactionTimeActivityBodyState
    extends State<RPUIReactionTimeActivityBody> {
  ActivityStatus activityStatus = ActivityStatus.Instruction;
  String alert = '';
  int wrongTaps = 0;
  int correctTaps = 0;
  int timer = 0;
  final _random = Random();
  bool lightOn = false; //If light is on, screen is green and should be tapped.
  bool allowGreen = true;
  bool first = true;
  final _sw = Stopwatch();
  List<int> rtList = []; //delay times list
  int result = 0;
  Timer? lightTimer;

  //wrong taps currently do nothing.

  @override
  initState() {
    super.initState();
    if (widget.activity.includeInstructions) {
      activityStatus = ActivityStatus.Instruction;
      widget.eventLogger.instructionStarted();
    } else {
      activityStatus = ActivityStatus.Test;
      widget.eventLogger.testStarted();
      testTimer();
      lightRegulator();
    }
  }

  void lightRegulator() {
    if (!first) {
      lightTimer?.cancel();
    }
    //determines when light is changed, and starts timer when screen turns green. only called when light is red.
    timer = _random.nextInt(widget.activity.switchInterval) + 1;
    lightTimer = Timer(Duration(seconds: timer), () {
      if (mounted && allowGreen) {
        setState(() {
          alert = ''; //"too quick alert set to nothing when light is green"
          lightOn = true; //turn on green light
          _sw.start(); //start stopwatch to track delay from green screen till tap.
        });
      }
    });
    first = false;
  }

  void testTimer() {
    //times the test and calculates result when done.
    Timer(Duration(seconds: widget.activity.lengthOfTest), () {
      widget.eventLogger.testEnded();
      widget.eventLogger.resultsShown();
      if (mounted) {
        if (rtList.isEmpty) {
          //if nothing was pressed during the whole test, add 0.
          rtList.add(0);
        }
        for (int i = 0; i < rtList.length; i++) {
          result += (rtList[i]);
        }
        result = (result / rtList.length)
            .round(); //calculate average delay from test.
        widget.onResultChange({
          'avg. reaction time': result,
          'Wrong taps': wrongTaps,
          'Correct taps': correctTaps,
        });
        if (widget.activity.includeResults) {
          widget.eventLogger.resultsShown();
        }
        setState(() {
          activityStatus = ActivityStatus.Result;
        });
      }
    });
  }

  @override
  void dispose() {
    lightTimer?.cancel();
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
                locale?.translate('reaction_time.tap_screen_green') ??
                    "Tap the screen as fast as possible when it turns from blue to yellow.",
                style: const TextStyle(fontSize: 20),
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
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
                      'packages/cognition_package/assets/images/Reactionintro.png',
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
                  setState(() {
                    activityStatus = ActivityStatus.Test;
                  });
                  testTimer();
                  lightRegulator();
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
        return Flex(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          verticalDirection: VerticalDirection.down,
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: () async {
                  //on tap depends on if light is on. If so, record time, turn light off, and call lightRegulator.
                  if (lightOn) {
                    setState(() {
                      lightOn = false;
                      correctTaps++;
                      widget.eventLogger.addCorrectGesture(
                        'Correct Screen Tap',
                        'Tapped the screen after ${_sw.elapsedMilliseconds} ms',
                      );
                      _sw.stop();
                      rtList.add(
                        _sw.elapsedMilliseconds,
                      ); //add delay for current tap.
                      _sw.reset();
                    });
                    lightRegulator();
                  } else {
                    allowGreen = false;
                    wrongTaps++;
                    widget.eventLogger.addWrongGesture(
                      'Wrong Screen Tap',
                      'Tapped the screen before the screen was yellow',
                    );
                    setState(() {
                      alert =
                          locale?.translate('reaction_time.too_quick') ??
                          "Not so quick.";
                    });
                    await Future<dynamic>.delayed(
                      const Duration(seconds: 1),
                    ); //display feedback
                    if (mounted) {
                      allowGreen = true;
                      setState(() {
                        alert = '';
                      });
                      lightRegulator();
                    } //no actual penalty for wrong taps (would give a wrong picture). WrongTaps are not actually used
                  }
                },
                child: Container(
                  color: lightOn ? Colors.yellow : Colors.blue,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        alert,
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      case ActivityStatus.Result:
        if (widget.activity.includeResults) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '${locale?.translate('reaction_time.time_up') ?? "Time is up."} $result ${locale?.translate('reaction_time.final_score') ?? "is your average reaction time (in milliseconds)."}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 22),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                ),
              ],
            ),
          );
        } else {
          return Container(
            alignment: Alignment.center,
            child: Text(
              locale?.translate('test_done') ?? "The test is done.",
              style: const TextStyle(fontSize: 22),
              textAlign: TextAlign.center,
            ),
          );
        }
    }
  }
}
