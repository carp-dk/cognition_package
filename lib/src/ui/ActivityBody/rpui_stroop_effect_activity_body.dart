part of '../../../../ui.dart';

/// The [RPUIStroopEffectActivityBody] class defines the UI for the
/// instructions and test phase of the continuous visual tracking task.
class RPUIStroopEffectActivityBody extends StatefulWidget {
  /// The [RPUIStroopEffectActivityBody] activity.
  final RPStroopEffectActivity activity;

  /// The results function for the [RPUIStroopEffectActivityBody].
  final void Function(dynamic) onResultChange;

  /// the [RPActivityEventLogger] for the [RPUIStroopEffectActivityBody].
  final RPActivityEventLogger eventLogger;

  /// The [RPUIStroopEffectActivityBody] constructor.
  const RPUIStroopEffectActivityBody(
    this.activity,
    this.eventLogger,
    this.onResultChange, {
    super.key,
  });

  @override
  RPUIStroopEffectActivityBodyState createState() =>
      RPUIStroopEffectActivityBodyState();
}

class RPUIStroopEffectActivityBodyState
    extends State<RPUIStroopEffectActivityBody> {
  late ActivityStatus activityStatus;
  int mistakes = 0;
  int correctTaps = 0;
  int totalWords = 0;
  int cWordIndex = 0;
  int wColorIndex = 0;
  final _random = Random();

  Timer pulseTimer = Timer(const Duration(seconds: 0), () {});

  //bool testLive = false; //test going on, screen flag
  //bool testBegin = true; //pre test screen flag
  bool disableButton = false; //makes sure spamming doesn't disturb the test
  bool clicked = false; //boolean to track if the user taps an answer in time
  late List<String> possColorsString = [
    'BLUE',
    'GREEN',
    'RED',
    'YELLOW',
  ]; //the two lists are ordered, like in a map.
  //map is not used due to unwanted complexity
  List<Color> possColors = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.yellow,
  ];
  List<Color> backgroundButtons = [
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
  ];
  String cWord = '';
  Color wColor = Colors.white;

  @override
  initState() {
    super.initState();
    cWordIndex = _random.nextInt(possColorsString.length);
    wColorIndex = _random.nextInt(possColors.length);
    cWord = possColorsString[cWordIndex];
    wColor = possColors[wColorIndex];
    if (widget.activity.includeInstructions) {
      activityStatus = ActivityStatus.Instruction;
      widget.eventLogger.instructionStarted();
    } else {
      activityStatus = ActivityStatus.Test;
      widget.eventLogger.testStarted();
      startTest();
    }
  }

  void startTest() {
    if (mounted) {
      widget.eventLogger.instructionEnded();
      widget.eventLogger.testStarted();
      setState(() {
        //change screen
        activityStatus = ActivityStatus.Test;
      });
    }
    Timer(Duration(seconds: widget.activity.lengthOfTest), () {
      //when time is up, change window and set result
      widget.eventLogger.testEnded();
      if (mounted) {
        setState(() {});
        widget.onResultChange({
          'mistakes': mistakes,
          'correct taps': correctTaps,
        });
        if (widget.activity.includeResults) {
          widget.eventLogger.resultsShown();
          setState(() {
            activityStatus = ActivityStatus.Result;
          });
        }
      }
    });
    wordPulse();
  }

  void wordPulse() async {
    //control pulsation of words and pause between them
    disableButton = true;
    pulseTimer.cancel();
    //make sure window is mounted and that test is live before setting state.
    if (mounted && activityStatus == ActivityStatus.Test) {
      setState(() {
        cWord = '----';
        wColor = Colors.black;
        backgroundButtons = [
          Colors.white,
          Colors.white,
          Colors.white,
          Colors.white,
        ]; //reset feedback
      });
      await Future<dynamic>.delayed(
        Duration(milliseconds: widget.activity.delayTime),
      ); //delay before showing next word
      if (mounted && activityStatus == ActivityStatus.Test) {
        setState(() {
          cWordIndex = _random.nextInt(possColorsString.length);
          wColorIndex = _random.nextInt(possColors.length);
          cWord = possColorsString[cWordIndex];
          wColor = possColors[wColorIndex]; //pick word and color for display
        });
      }
      disableButton = false; //make buttons tap-able
    }

    pulseTimer = Timer(Duration(milliseconds: widget.activity.displayTime), () {
      if (activityStatus == ActivityStatus.Test) {
        if (!clicked) {
          //if tap doesnt happen in time, count is a mistake.
          mistakes++;
          totalWords++;
          // totalWords = totalWords + mistakes + correctTaps;
          // totalWords = mistakes + correctTaps;
          String widgetNoTapColor = possColorsString[wColorIndex];
          widget.eventLogger.addWrongGesture(
            'Button tap',
            'No color tapped. The color was $widgetNoTapColor. The word spelled $cWord. Total words passed: $totalWords',
          );
        } else {
          clicked = false;
        }
        wordPulse();
      }
    }); //call wordPulse recursively for periodic timer effect
  }

  @override
  void dispose() {
    pulseTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var locale = CPLocalizations.of(context);
    possColorsString = [
      locale?.translate('BLUE') ?? 'BLUE',
      locale?.translate('GREEN') ?? 'GREEN',
      locale?.translate('RED') ?? 'RED',
      locale?.translate('YELLOW') ?? 'YELLOW',
    ];

    switch (activityStatus) {
      case ActivityStatus.Instruction:
        return Column(
          //entry screen with rules and start button
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                locale?.translate('stroop.tap_color') ??
                    "Tap the color of the word you see on screen. For example, tap the box that says 'GREEN' when a green word appears.",
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
                      'packages/cognition_package/assets/images/Stroopintro.png',
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
        //main screen for test - contains word and buttons to push
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox(
                  height: 100,
                  width: 200,
                  child: Text(
                    cWord,
                    style: TextStyle(fontSize: 45, color: wColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _makeButton(0),
                _makeButton(1),
                _makeButton(2),
                _makeButton(3),
              ],
            ),
          ],
        );
      case ActivityStatus.Result:
        return Container(
          //result screen
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    locale?.translate('test_done') ?? "The test is done.",
                    style: const TextStyle(fontSize: 22),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '${locale?.translate('stroop.correct_answers') ?? "Correct"}: $correctTaps',
                    style: const TextStyle(fontSize: 22),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '${locale?.translate('stroop.mistakes_made') ?? "Wrong"}: $mistakes',
                    style: const TextStyle(fontSize: 22),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 20,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        );
    }
  }

  Widget _makeButton(int buttonNum) {
    String buttonCode = possColorsString[buttonNum];
    return (SizedBox(
      height: 75,
      width: MediaQuery.of(context).size.width / 5,
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: const BorderSide(color: Colors.black, width: 3),
        ),
        textColor: Colors.black,
        color:
            backgroundButtons[buttonNum], //set background on buttons for feedback
        onPressed: () {
          String widgetTapColor = possColorsString[wColorIndex];
          if (!disableButton) {
            clicked = true;
            if (wColor == possColors[buttonNum]) {
              //if a button was pressed, produce new word
              correctTaps++;
              totalWords++;
              if (mounted && activityStatus == ActivityStatus.Test) {
                setState(() {
                  backgroundButtons[buttonNum] =
                      Colors.green; //set feedback color
                });
                widget.eventLogger.addCorrectGesture(
                  'Button tap',
                  'Correct color tapped. The color was $widgetTapColor and the word spelled $cWord. Total words passed: $totalWords',
                );
              }
            } else {
              mistakes++;
              totalWords++;
              if (mounted && activityStatus == ActivityStatus.Test) {
                setState(() {
                  backgroundButtons[buttonNum] = Colors.red;
                });
                widget.eventLogger.addWrongGesture(
                  'Button tap',
                  'Incorrect color tapped. The color tapped was $buttonCode but should have been $widgetTapColor. The word spelled $cWord. Total words passed: $totalWords',
                );
              }
            }
            //wordPulse(); //this one instantly give new word if something is clicked.
          }
        },
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(buttonCode, style: const TextStyle(fontSize: 19)),
        ),
      ),
    ));
  }
}
