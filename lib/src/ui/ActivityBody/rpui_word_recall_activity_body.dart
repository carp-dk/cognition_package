part of '../../../../ui.dart';

/// The [RPUIWordRecallActivityBody] class defines the UI for the
/// instructions and test phase of the continuous visual tracking task.
class RPUIWordRecallActivityBody extends StatefulWidget {
  /// The [RPUIWordRecallActivityBody] activity.
  final RPWordRecallActivity activity;

  /// The results function for the [RPUIWordRecallActivityBody].
  final void Function(dynamic) onResultChange;

  /// the [RPActivityEventLogger] for the [RPUIWordRecallActivityBody].
  final RPActivityEventLogger eventLogger;

  /// The [RPUIWordRecallActivityBody] constructor.
  const RPUIWordRecallActivityBody(
    this.activity,
    this.eventLogger,
    this.onResultChange, {
    super.key,
  });

  @override
  RPUIWordRecallActivityBodyState createState() =>
      RPUIWordRecallActivityBodyState();
}

class RPUIWordRecallActivityBodyState
    extends State<RPUIWordRecallActivityBody> {
  ActivityStatus? activityStatus;

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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                      text:
                          locale?.translate('word_recall.turn_on_sound') ??
                          "Turn on sound for this task.",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 10,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                      text:
                          locale?.translate('word_recall.list_of_words') ??
                          "A list of words will be read aloud. Try to memorize the list of words.",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 10,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                      text:
                          locale?.translate('word_recall.asked_to_recall') ??
                          "After the words have been read aloud you will be asked to recall them.",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 10,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                      text:
                          locale?.translate('word_recall.write_words') ??
                          "Write the words you recall in the boxes in any order and click",
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
            Container(height: 0),
            Padding(
              padding: const EdgeInsets.all(25),
              child: Container(
                height: 100,
                width: 200,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(
                      'packages/cognition_package/assets/images/wordlist_recall.png',
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
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
            child: WordRecall(
              widget: widget,
              numberOfTests: widget.activity.numberOfTests,
            ),
          ),
        );
      case ActivityStatus.Result:
        return Center(
          child: Text(
            '${locale?.translate('results') ?? 'Results'}: $wordRecallScore',
            style: const TextStyle(fontSize: 22),
            textAlign: TextAlign.center,
          ),
        );
      default:
        return Container();
    }
  }
}

/// score counter for the word recall task used in [RPUIWordRecallActivityBody]
int wordRecallScore = 0;

class WordRecall extends StatefulWidget {
  final RPUIWordRecallActivityBody widget;
  final int numberOfTests;

  const WordRecall({
    super.key,
    required this.widget,
    required this.numberOfTests,
  });

  @override
  WordRecallState createState() => WordRecallState(widget, numberOfTests);
}

class WordRecallState extends State<WordRecall> {
  final RPUIWordRecallActivityBody sWidget;
  final int numberOfTests;
  var currentNum = 1;
  List<int> timesTaken = [];
  List<String> resultsList1 = [];
  List<String> resultsList2 = [];

  List<String> words = ['banana', 'icecream', 'violin', 'desk', 'green'];
  List<String> wordBuffer = ['', '', '', '', ''];
  bool waiting = false;
  bool guess = false;
  bool finished = false;
  int time = 0;

  final player = AudioPlayer();

  WordRecallState(this.sWidget, this.numberOfTests);

  Future<void> resetTest() async {
    setState(() {
      seconds = 0;
      waiting = false;
      guess = false;
    });
    startTest();
  }

  Future<void> startTest() async {
    setState(() {
      currentNum += 1;
      waiting = true;
    });

    for (var word in words) {
      await Future<dynamic>.delayed(const Duration(milliseconds: 1200));
      await player.setAsset(
        '../packages/cognition_package/assets/sounds/${word.toUpperCase()}.mp3',
      );
      await player.play();
    }

    await Future<dynamic>.delayed(const Duration(seconds: 1));
    setState(() {
      waiting = false;
      guess = true;
    });
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
    if (currentNum > 2) {
      resultsList2 = wordBuffer;
      sWidget.eventLogger.testEnded();
      timesTaken.add(seconds);
      timer?.cancel();
      wordRecallScore = sWidget.activity.calculateScore({
        'wordsList': words,
        'resultsList': resultsList2,
      });
      var result = RPWordRecallResult.fromResults(
        words,
        resultsList1,
        resultsList2,
        timesTaken,
        wordRecallScore,
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
    } else {
      resultsList1 = wordBuffer;
      wordBuffer = ['', '', '', '', ''];
      timesTaken.add(seconds);
      timer?.cancel();
      resetTest();
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
              child: !guess
                  ? !waiting
                        ? Text(locale?.translate('ready') ?? 'Ready')
                        : Center(
                            child: Text(
                              locale?.translate('word_recall.listen') ??
                                  'Listen',
                              style: const TextStyle(fontSize: 25),
                            ),
                          )
                  : !waiting
                  ? Scaffold(
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
                                  locale?.translate(
                                        'delayed_recall.enter_words',
                                      ) ??
                                      "Enter the words you recall.",
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
                    )
                  : Center(
                      child: Text(
                        locale?.translate('wait') ?? 'Wait',
                        style: const TextStyle(fontSize: 25),
                      ),
                    ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: !guess
                  ? waiting
                        ? Container()
                        : Column(
                            children: [
                              OutlinedButton(
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
                                  startTest();
                                },
                                child: Text(
                                  locale?.translate('ready') ?? 'Ready',
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          )
                  : finished
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
