part of '../../../../ui.dart';

/// The [RPUIDelayedRecallActivityBody] class defines the UI for the
/// instructions and test phase of the continuous visual tracking task.
class RPUIDelayedRecallActivityBody extends StatefulWidget {
  /// The [RPUIDelayedRecallActivityBody] activity.
  final RPDelayedRecallActivity activity;

  /// The results function for the [RPUIDelayedRecallActivityBody].
  final void Function(dynamic) onResultChange;

  /// the [RPActivityEventLogger] for the [RPUIDelayedRecallActivityBody].
  final RPActivityEventLogger eventLogger;

  /// The [RPUIDelayedRecallActivityBody] constructor.
  const RPUIDelayedRecallActivityBody(
    this.activity,
    this.eventLogger,
    this.onResultChange, {
    super.key,
  });

  @override
  RPUIDelayedRecallActivityBodyState createState() =>
      RPUIDelayedRecallActivityBodyState();
}

class RPUIDelayedRecallActivityBodyState
    extends State<RPUIDelayedRecallActivityBody> {
  ActivityStatus activityStatus = ActivityStatus.Instruction;

  var score = 0;

  @override
  initState() {
    super.initState();
    if (widget.activity.includeInstructions) {
      activityStatus = ActivityStatus.Instruction;
      widget.eventLogger.instructionStarted();
    } else {
      activityStatus = ActivityStatus.Test;
      widget.eventLogger.testStarted();
    }
  }

  @override
  Widget build(BuildContext context) {
    var locale = CPLocalizations.of(context);
    switch (activityStatus) {
      case ActivityStatus.Instruction:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                locale?.translate('delayed_recall.remember_words') ??
                    'Can you remember the words you recalled from the listening exercise earlier?',
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
                maxLines: 10,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                      text:
                          '${locale?.translate('delayed_recall.remember_write') ?? 'Please write down the words you recall now and click'} ',
                      style: const TextStyle(fontSize: 16),
                    ),
                    TextSpan(
                      text: " '${locale?.translate('guess') ?? 'Guess'}'.",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 10,
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
                      'packages/cognition_package/assets/images/delayed_recall.png',
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              //width: MediaQuery.of(context).size.width / 2,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffC32C39),
                  fixedSize: const Size(300, 60),
                ),
                child: Text(
                  locale?.translate('ready') ?? 'Ready',
                  style: const TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  widget.eventLogger.instructionEnded();
                  widget.eventLogger.testStarted();
                  setState(() {
                    activityStatus = ActivityStatus.Test;
                  });
                },
              ),
            ),
          ],
        );
      case ActivityStatus.Test:
        return Scaffold(
          body: Center(
            child: DelayedRecall(
              sWidget: widget,
              numberOfTests: widget.activity.numberOfTests,
            ),
          ),
        );
      case ActivityStatus.Result:
        return Center(
          child: Text(
            '${locale?.translate('results') ?? 'results'}: $score',
            style: const TextStyle(fontSize: 22),
            textAlign: TextAlign.center,
          ),
        );
    }
  }
}

class DelayedRecall extends StatefulWidget {
  final RPUIDelayedRecallActivityBody sWidget;
  final int numberOfTests;

  const DelayedRecall({
    super.key,
    required this.sWidget,
    required this.numberOfTests,
  });

  @override
  DelayedRecallState createState() =>
      DelayedRecallState(sWidget, numberOfTests);
}

class DelayedRecallState extends State<DelayedRecall> {
  final RPUIDelayedRecallActivityBody sWidget;
  final int numberOfTests;
  final List<int> timesTaken = [];
  final List<int> timesTaken2 = [];
  List<String> resultsList3 = [];
  List<String> words = ['banana', 'icecream', 'violin', 'desk', 'green'];
  List<String> wordBuffer = ['', '', '', '', ''];
  bool waiting = false;
  bool guess = false;
  bool finished = false;
  int time = 0;

  DelayedRecallState(this.sWidget, this.numberOfTests);

  void resetTest() async {
    setState(() {
      seconds = 0;
      waiting = false;
      guess = true;
    });
    startTest();
  }

  void startTest() async {
    startTimer();
  }

  Timer? timer;
  int seconds = 0;
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) => setState(() {
        if (seconds < 0) {
          timer.cancel();
        } else {
          seconds = seconds + 1;
        }
      }),
    );
  }

  void makeGuess() {
    sWidget.eventLogger.testEnded();
    timesTaken.add(seconds);
    timer?.cancel();
    resultsList3 = wordBuffer;
    var delayedRecallScore = sWidget.activity.calculateScore({
      'wordsList': words,
      'resultsList': resultsList3,
    });

    var result = RPDelayedRecallResult.fromResults(
      words,
      resultsList3,
      seconds,
      delayedRecallScore,
    );

    sWidget.onResultChange(result.results);
    if (sWidget.activity.includeResults) {
      sWidget.eventLogger.resultsShown();
      setState(() {
        finished = true;
      });
    } else {
      setState(() {
        finished = true;
      });
    }
  }

  @override
  initState() {
    super.initState();
    startTest();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var locale = CPLocalizations.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 1.5,
              width: MediaQuery.of(context).size.width,
              child: Scaffold(
                body: ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 25,
                        bottom: 10,
                        top: 20,
                      ),
                      child: Row(
                        children: <Widget>[
                          Text(
                            locale?.translate('delayed_recall.enter_words') ??
                                'Enter the words you recall.',
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 0,
                      ),
                      child: TextField(
                        textInputAction: TextInputAction.next,
                        onChanged: (text) {
                          wordBuffer[0] = text;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Container(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 0,
                      ),
                      child: TextField(
                        textInputAction: TextInputAction.next,
                        onChanged: (text) {
                          wordBuffer[1] = text;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Container(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 0,
                      ),
                      child: TextField(
                        textInputAction: TextInputAction.next,
                        onChanged: (text) {
                          wordBuffer[2] = text;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Container(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 0,
                      ),
                      child: TextField(
                        textInputAction: TextInputAction.next,
                        onChanged: (text) {
                          wordBuffer[3] = text;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Container(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 0,
                      ),
                      child: TextField(
                        textInputAction: TextInputAction.done,
                        onChanged: (text) {
                          wordBuffer[4] = text;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 550),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: finished
                  ? Center(
                      child: Text(
                        locale?.translate('continue') ??
                            "Click 'Next' to continue",
                        style: const TextStyle(fontSize: 18),
                      ),
                    )
                  : OutlinedButton(
                      style: ButtonStyle(
                        padding: WidgetStateProperty.all(
                          const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                        ),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                      onPressed: () {
                        makeGuess();
                      },
                      child: Text(
                        locale?.translate('guess') ?? 'Guess',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
