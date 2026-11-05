part of '../../../../ui.dart';

/// The [RPUIVisualArrayChangeActivityBody] class defines the UI for the
/// instructions and test phase of the continuous visual tracking task.
class RPUIVisualArrayChangeActivityBody extends StatefulWidget {
  /// The [RPUIVisualArrayChangeActivityBody] activity.
  final RPVisualArrayChangeActivity activity;

  /// The results function for the [RPUIVisualArrayChangeActivityBody].
  final void Function(dynamic) onResultChange;

  /// the [RPActivityEventLogger] for the [RPUIVisualArrayChangeActivityBody].
  final RPActivityEventLogger eventLogger;

  /// The [RPUIVisualArrayChangeActivityBody] constructor.
  const RPUIVisualArrayChangeActivityBody(
    this.activity,
    this.eventLogger,
    this.onResultChange, {
    super.key,
  });

  @override
  RPUIVisualArrayChangeActivityBodyState createState() =>
      RPUIVisualArrayChangeActivityBodyState();
}

/// score counter for the visual array change task used in [RPUIVisualArrayChangeActivityBody]
int visualArrayChangeScore = 0;

class RPUIVisualArrayChangeActivityBodyState
    extends State<RPUIVisualArrayChangeActivityBody> {
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
      startTest();
    }
  }

  void startTest() async {
    Timer(Duration(seconds: widget.activity.lengthOfTest), () {
      //when time is up, change window and set result
      if (mounted) {
        widget.eventLogger.testEnded();
        widget.onResultChange({'Correct swipes': visualArrayChangeScore});
        if (widget.activity.includeResults) {
          widget.eventLogger.resultsShown();
          setState(() {
            activityStatus = ActivityStatus.Result;
          });
        }
      }
    });
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
                locale?.translate('visual_array.memorize_colors') ??
                    "On the next screen, you should memorize the colors of the shapes.",
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
                maxLines: 10,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                locale?.translate(
                      'visual_array.shapes_will_change_positions',
                    ) ??
                    "Once you are ready, press 'Start' and the shapes will change positions.",
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
                maxLines: 10,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                locale?.translate('visual_array.indicate_changed') ??
                    "Indicate if any of the shapes changed color ('Different') or if all shapes remained the same ('Same').",
                style: const TextStyle(fontSize: 16),
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
                      'packages/cognition_package/assets/images/shape_recall.png',
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
        return Scaffold(
          body: Center(
            child: _VisualArrayChange(
              sWidget: widget,
              numberOfTests: widget.activity.numberOfTests,
              numberOfShapes: widget.activity.numberOfShapes,
              waitTime: widget.activity.waitTime,
            ),
          ),
        );
      case ActivityStatus.Result:
        return Center(
          child: Text(
            '${locale?.translate('results') ?? 'results'}: $visualArrayChangeScore',
            style: const TextStyle(fontSize: 22),
            textAlign: TextAlign.center,
          ),
        );
      default:
        return Container();
    }
  }
}

class _VisualArrayChange extends StatefulWidget {
  final RPUIVisualArrayChangeActivityBody sWidget;
  final int numberOfTests;
  final int numberOfShapes;
  final int waitTime;

  const _VisualArrayChange({
    required this.sWidget,
    required this.numberOfTests,
    required this.numberOfShapes,
    required this.waitTime,
  });

  @override
  _VisualArrayChangeState createState() =>
      _VisualArrayChangeState(sWidget, numberOfTests, numberOfShapes, waitTime);
}

class _VisualArrayChangeState extends State<_VisualArrayChange> {
  final RPUIVisualArrayChangeActivityBody sWidget;
  final int numberOfTests;
  final int numberOfShapes;
  final int waitTime;
  List<Shape> original = [];
  List<Shape> pictures = [];
  List<Shape> top = [];
  List<Shape> arrow = [];
  List<Shape> hourglass = [];
  List<Shape> bowl = [];
  List<Shape> bean = [];
  List<EdgeInsets> padding = [];
  List<int> rotation = [];
  List<int> color = [];
  bool waiting = false;
  bool guess = false;
  bool finished = false;
  int time = 0;
  bool changed = false;
  int visualScore = 0;
  int viscurrentNum = 1;

  int right = 0;
  int wrong = 0;
  List<int> memoryTimes = [];
  List<int> times = [];

  List<String> arrows = [
    'packages/cognition_package/assets/images/arrow_1.png',
    'packages/cognition_package/assets/images/arrow_2.png',
    'packages/cognition_package/assets/images/arrow_3.png',
    'packages/cognition_package/assets/images/arrow_4.png',
    'packages/cognition_package/assets/images/arrow_5.png',
  ];

  List<String> tops = [
    'packages/cognition_package/assets/images/boomerang_1.png',
    'packages/cognition_package/assets/images/boomerang_2.png',
    'packages/cognition_package/assets/images/boomerang_3.png',
    'packages/cognition_package/assets/images/boomerang_4.png',
    'packages/cognition_package/assets/images/boomerang_5.png',
  ];

  List<String> hourglasses = [
    'packages/cognition_package/assets/images/hourglass_1.png',
    'packages/cognition_package/assets/images/hourglass_2.png',
    'packages/cognition_package/assets/images/hourglass_3.png',
    'packages/cognition_package/assets/images/hourglass_4.png',
    'packages/cognition_package/assets/images/hourglass_5.png',
  ];

  List<String> beans = [
    'packages/cognition_package/assets/images/bean_1.png',
    'packages/cognition_package/assets/images/bean_2.png',
    'packages/cognition_package/assets/images/bean_3.png',
    'packages/cognition_package/assets/images/bean_4.png',
    'packages/cognition_package/assets/images/bean_5.png',
  ];

  List<String> bowls = [
    'packages/cognition_package/assets/images/bowl_1.png',
    'packages/cognition_package/assets/images/bowl_2.png',
    'packages/cognition_package/assets/images/bowl_3.png',
    'packages/cognition_package/assets/images/bowl_4.png',
    'packages/cognition_package/assets/images/bowl_5.png',
  ];

  List<Positioned> makeShapes(
    int numberOfShapes,
    BoxConstraints constraints,
    int avatarSize,
  ) {
    List<Positioned> shapes = [];
    top = getPictures(tops);
    hourglass = getPictures(hourglasses);
    arrow = getPictures(arrows);
    bowl = getPictures(bowls);
    bean = getPictures(beans);
    var shape = [arrow, top, hourglass, bowl, bean];

    for (int i = 0; i < numberOfShapes; i++) {
      shapes.add(
        Positioned(
          left:
              avatarSize +
              (constraints.biggest.width - 2 * avatarSize) /
                  100.0 *
                  rotation[i],
          top:
              avatarSize +
              (constraints.biggest.height - 2 * avatarSize) /
                  100.0 *
                  rotation[i + 1],
          child: CircleAvatar(
            radius: avatarSize / 2,
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                image: DecorationImage(
                  image: AssetImage(shape[i][color[i]].urlImage),
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return shapes;
  }

  _VisualArrayChangeState(
    this.sWidget,
    this.numberOfTests,
    this.numberOfShapes,
    this.waitTime,
  );
  List<Shape> getPictures(List<String> list) => List.generate(
    5,
    (index) =>
        Shape(name: index.toString(), urlImage: list[index], index: index),
  );

  @override
  initState() {
    super.initState();
    top = getPictures(tops);
    hourglass = getPictures(hourglasses);
    arrow = getPictures(arrows);
    padding = getPadding();
    rotation = getRotation();
    color = getColor();
    pictures.shuffle();
    for (Shape picl in pictures) {
      original.add(picl);
    }
    memorySeconds = 0;
    startMemoryTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    memoryTimer?.cancel();
    super.dispose();
  }

  List<Positioned> shapes = [];
  List<int> getRotation() => List.generate(10, (index) => rng.nextInt(100));
  List<int> getColor() => List.generate(5, (index) => rng.nextInt(5));

  List<EdgeInsets> getPadding() => List.generate(
    4,
    (index) => EdgeInsets.fromLTRB(
      rng.nextInt(300).toDouble(),
      rng.nextInt(100).toDouble(),
      rng.nextInt(300).toDouble(),
      rng.nextInt(100).toDouble(),
    ),
  );

  void resetTest() async {
    setState(() {
      changed = false;
      waiting = false;
      guess = false;
      pictures.shuffle();
      padding = getPadding();
      rotation = getRotation();
      color = getColor();
      original = [];
      for (Shape picl in pictures) {
        original.add(picl);
      }
    });
    memorySeconds = 0;
    startMemoryTimer();
  }

  void startTest() async {
    memoryTimer?.cancel();
    memoryTimes.add(memorySeconds);
    memorySeconds = 0;

    if (rng.nextBool()) {
      List<int> og = color;
      color = getColor();
      if (color != og) {
        changed = true;
      }
    }

    setState(() {
      viscurrentNum += 1;
      waiting = true;
      pictures.shuffle();
      padding.shuffle();
      rotation = getRotation();
    });
    await Future<dynamic>.delayed(Duration(seconds: waitTime));
    setState(() {
      waiting = false;
      guess = true;
    });
    startTimer();
  }

  var rng = Random();

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

  Timer? memoryTimer;
  int memorySeconds = 0;
  void startMemoryTimer() {
    const oneSec = Duration(seconds: 1);
    memoryTimer = Timer.periodic(
      oneSec,
      (Timer timer) => setState(() {
        if (seconds < 0) {
          timer.cancel();
        } else {
          memorySeconds = memorySeconds + 1;
        }
      }),
    );
  }

  void same() {
    timer?.cancel();
    times.add(seconds);
    seconds = 0;

    if (!changed) {
      if (viscurrentNum > numberOfTests) {
        visualScore += 1;
        right += 1;
        sWidget.eventLogger.testEnded();

        visualArrayChangeScore = sWidget.activity.calculateScore({
          'correct': right,
          'wrong': wrong,
        });
        var visualArrayChangeResult = RPVisualArrayChangeResult.fromResults(
          wrong,
          right,
          times,
          memoryTimes,
          visualArrayChangeScore,
        );

        sWidget.onResultChange(visualArrayChangeResult.results);
        if (sWidget.activity.includeResults) {
          sWidget.eventLogger.resultsShown();
          setState(() {
            finished = true;
          });
        }
      } else {
        visualScore += 1;
        right += 1;
        resetTest();
      }
    } else {
      wrong += 1;
      if (viscurrentNum > numberOfTests) {
        sWidget.eventLogger.testEnded();
        var visualArrayChangeScore = sWidget.activity.calculateScore({
          'correct': right,
          'wrong': wrong,
        });
        var visualArrayChangeResult = RPVisualArrayChangeResult.fromResults(
          wrong,
          right,
          times,
          memoryTimes,
          visualArrayChangeScore,
        );

        sWidget.onResultChange(visualArrayChangeResult.results);
        if (sWidget.activity.includeResults) {
          sWidget.eventLogger.resultsShown();
          setState(() {
            finished = true;
          });
        }
      } else {
        resetTest();
      }
    }
  }

  void different() {
    timer?.cancel();
    times.add(seconds);
    seconds = 0;
    if (changed) {
      if (viscurrentNum > numberOfTests) {
        visualScore += 1;
        right += 1;
        sWidget.eventLogger.testEnded();
        var visualArrayChangeScore = sWidget.activity.calculateScore({
          'correct': right,
          'wrong': wrong,
        });
        var visualArrayChangeResult = RPVisualArrayChangeResult.fromResults(
          wrong,
          right,
          times,
          memoryTimes,
          visualArrayChangeScore,
        );

        sWidget.onResultChange(visualArrayChangeResult.results);
        if (sWidget.activity.includeResults) {
          sWidget.eventLogger.resultsShown();
          setState(() {
            finished = true;
          });
        }
      } else {
        visualScore += 1;
        right += 1;
        resetTest();
      }
    } else {
      if (viscurrentNum > numberOfTests) {
        sWidget.eventLogger.testEnded();
        var visualArrayChangeScore = sWidget.activity.calculateScore({
          'correct': right,
          'wrong': wrong,
        });
        var visualArrayChangeResult = RPVisualArrayChangeResult.fromResults(
          wrong,
          right,
          times,
          memoryTimes,
          visualArrayChangeScore,
        );

        sWidget.onResultChange(visualArrayChangeResult.results);
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
        resetTest();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var locale = CPLocalizations.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height - 270,
              width: MediaQuery.of(context).size.width - 20,
              child: !waiting
                  ? LayoutBuilder(
                      builder: (context, constraints) {
                        const avatarSize = 100;
                        return Stack(
                          children: makeShapes(
                            numberOfShapes,
                            constraints,
                            avatarSize,
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        locale?.translate('wait') ?? 'Wait',
                        style: const TextStyle(fontSize: 25),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
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
                                        vertical: 8,
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
                                    locale?.translate('start') ?? 'Start',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(
                                    '${locale?.translate('task') ?? 'task'} $viscurrentNum/$numberOfTests',
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
                    : Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: OutlinedButton(
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
                                same();
                              },
                              child: Text(
                                locale?.translate('visual_array.same') ??
                                    "Same",
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
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
                              different();
                            },
                            child: Text(
                              locale?.translate('visual_array.different') ??
                                  "Different",
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildShape(
    int index,
    Shape picture,
    double left,
    double top,
    double right,
    double bottom,
  ) => Padding(
    padding: padding[picture.index],
    child: Transform.rotate(
      angle: 3.14 / rotation[picture.index],
      child: SizedBox(
        height: 150,
        width: 50,
        key: ValueKey(picture),
        child: ReorderableDragStartListener(
          index: index,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              image: DecorationImage(
                image: AssetImage(picture.urlImage),
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class Shape {
  String name;
  String urlImage;
  int index;

  Shape({required this.name, required this.urlImage, required this.index});
}
