part of '../../../../ui.dart';

/// The [RPUIPictureSequenceMemoryActivityBody] class defines the UI for the
/// instructions and test phase of the continuous visual tracking task.
class RPUIPictureSequenceMemoryActivityBody extends StatefulWidget {
  /// The [RPUIPictureSequenceMemoryActivityBody] activity.
  final RPPictureSequenceMemoryActivity activity;

  /// The results function for the [RPUIPictureSequenceMemoryActivityBody].
  final void Function(dynamic) onResultChange;

  /// the [RPActivityEventLogger] for the [RPUIPictureSequenceMemoryActivityBody].
  final RPActivityEventLogger eventLogger;

  /// The [RPUIPictureSequenceMemoryActivityBody] constructor.
  const RPUIPictureSequenceMemoryActivityBody(
    this.activity,
    this.eventLogger,
    this.onResultChange, {
    super.key,
  });

  @override
  RPUIPictureSequenceMemoryActivityBodyState createState() =>
      RPUIPictureSequenceMemoryActivityBodyState();
}

/// Score counter for the picture sequence memory task used in [RPUIPictureSequenceMemoryActivityBody]
int pictureSequenceScore = 0;

class RPUIPictureSequenceMemoryActivityBodyState
    extends State<RPUIPictureSequenceMemoryActivityBody> {
  ActivityStatus activityStatus = ActivityStatus.Instruction;

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
      if (mounted) {
        widget.eventLogger.testEnded();
        widget.onResultChange({'Correct swipes': pictureSequenceScore});
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
  Widget build(BuildContext context) {
    var locale = CPLocalizations.of(context);
    switch (activityStatus) {
      case ActivityStatus.Instruction:
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  locale?.translate('picture_sequence.memorize_order') ??
                      "In this test you should memorize the original position of six images.",
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
                            locale?.translate(
                              'picture_sequence.once_memorized',
                            ) ??
                            "Once memorized click the",
                        style: const TextStyle(fontSize: 16),
                      ),
                      TextSpan(
                        text: " '${locale?.translate('start') ?? 'Start'}' ",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text:
                            locale?.translate(
                              'picture_sequence.images_change_positions',
                            ) ??
                            "button and the images will change positions.",
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
                padding: const EdgeInsets.all(20),
                child: RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            locale?.translate(
                              'picture_sequence.drag_and_drop',
                            ) ??
                            "Drag and drop the images to their original positions and press",
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
                  height: 200,
                  width: 200,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(
                        'packages/cognition_package/assets/images/picture_sequence.png',
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffC32C39),
                    fixedSize: const Size(300, 60),
                  ),
                  child: Text(
                    locale?.translate('ready') ?? 'Ready',
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  onPressed: () {
                    widget.eventLogger.instructionEnded();
                    widget.eventLogger.testStarted();
                    setState(() {
                      activityStatus = ActivityStatus.Test;
                    });
                    startTest();
                  },
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        );
      case ActivityStatus.Test:
        return Scaffold(
          body: Center(
            child: PictureSequenceMemory(
              sWidget: widget,
              numberOfTests: widget.activity.numberOfTests,
              numberOfPics: widget.activity.numberOfPics,
            ),
          ),
        );
      case ActivityStatus.Result:
        if (widget.activity.includeResults) {
          return Center(
            child: Text(
              '${locale?.translate('results') ?? 'results'}: $pictureSequenceScore',
              style: const TextStyle(fontSize: 22),
              textAlign: TextAlign.center,
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

class PictureSequenceMemory extends StatefulWidget {
  final RPUIPictureSequenceMemoryActivityBody sWidget;
  final int numberOfTests;
  final int numberOfPics;
  const PictureSequenceMemory({
    super.key,
    required this.sWidget,
    required this.numberOfTests,
    required this.numberOfPics,
  });

  @override
  PictureSequenceMemoryState createState() =>
      PictureSequenceMemoryState(sWidget, numberOfTests, numberOfPics);
}

class PictureSequenceMemoryState extends State<PictureSequenceMemory> {
  final RPUIPictureSequenceMemoryActivityBody sWidget;
  final int numberOfTestsPIC;
  final int numberOfPics;
  List<Picture> original = [];
  List<Picture> pictures = [];
  bool waiting = false;
  bool guess = false;
  bool finished = false;
  int time = 0;

  List<int> pictureScoreList = [];
  List<int> pictureTimesList = [];
  List<int> pictureMovesList = [];
  List<int> memorySecondList = [];
  var picCurrentNum = 1;
  var pictureScore = 0;
  var moves = 0;

  final urlImages = [
    'packages/cognition_package/assets/images/picturesequencememory-1.jpeg',
    'packages/cognition_package/assets/images/picturesequencememory-2.jpeg',
    'packages/cognition_package/assets/images/picturesequencememory-3.jpeg',
    'packages/cognition_package/assets/images/picturesequencememory-4.jpeg',
    'packages/cognition_package/assets/images/picturesequencememory-5.jpeg',
    'packages/cognition_package/assets/images/picturesequencememory-6.jpeg',
    'packages/cognition_package/assets/images/picturesequencememory-7.jpeg',
    'packages/cognition_package/assets/images/picturesequencememory-8.jpeg',
    'packages/cognition_package/assets/images/picturesequencememory-9.jpeg',
    'packages/cognition_package/assets/images/picturesequencememory-10.jpeg',
    'packages/cognition_package/assets/images/picturesequencememory-11.jpeg',
    'packages/cognition_package/assets/images/picturesequencememory-12.jpeg',
    'packages/cognition_package/assets/images/picturesequencememory-13.jpeg',
  ];

  PictureSequenceMemoryState(
    this.sWidget,
    this.numberOfTestsPIC,
    this.numberOfPics,
  );

  ScrollController scrollController = ScrollController();

  List<Picture> getPictures(int start, int end, int num) => List.generate(
    num,
    (index) =>
        Picture(name: index.toString(), urlImage: urlImages[index + start]),
  );

  void resetTest() async {
    memorySeconds = 0;
    startMemoryTimer();
    setState(() {
      seconds = 0;
      waiting = false;
      guess = false;
      var start = numberOfPics * (picCurrentNum - 1);
      var end = start + numberOfPics;
      pictures = [];
      pictures = getPictures(start, end, numberOfPics);
      pictures.shuffle();
      _tiles = [];
      for (int i = 0; i < numberOfPics; i++) {
        _tiles.add(buildPicture(i, pictures[i]));
      }
      original = [];
      moves = 0;
      for (Picture picl in pictures) {
        original.add(picl);
      }
      for (int i = 0; i < pictures.length; i++) {
        if (i > 0 && i < pictures.length - 1) {
          pictures[i - 1].left = pictures[i].name;
          pictures[i].right = pictures[i + 1].name;
        } else if (i == 0) {
          pictures[i].right = pictures[i + 1].name;
        } else if (i == pictures.length - 1) {
          pictures[i - 1].left = pictures[i].name;
        }
      }
    });
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

  void startTest() async {
    memoryTimer?.cancel();
    memorySecondList.add(memorySeconds);
    setState(() {
      picCurrentNum += 1;
      waiting = true;
      pictures.shuffle();
      _tiles = [];
      for (int i = 0; i < numberOfPics; i++) {
        _tiles.add(buildPicture(i, pictures[i]));
      }
    });
    await Future<dynamic>.delayed(const Duration(seconds: 2));
    setState(() {
      waiting = false;
      guess = true;
    });
    startTimer();
  }

  Timer? picTimer;
  int seconds = 0;
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    picTimer = Timer.periodic(
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
    var newScore = 0;
    for (var i = 0; i < pictures.length; i++) {
      if (i > 0 && i < pictures.length - 1) {
        if (pictures[i].left == pictures[i - 1].name) {
          newScore += 1;
        }
        if (pictures[i].right == pictures[i + 1].name) {
          newScore += 1;
        }
      } else if (i == 0) {
        if (pictures[i].right == pictures[i + 1].name) {
          newScore += 1;
        }
      } else if (i == pictures.length - 1) {
        if (pictures[i].left == pictures[i - 1].name) {
          newScore += 1;
        }
      }
    }

    if (picCurrentNum > numberOfTestsPIC) {
      pictureTimesList.add(seconds);
      pictureScoreList.add(newScore);
      pictureMovesList.add(moves);
      sWidget.eventLogger.testEnded();

      pictureSequenceScore = sWidget.activity.calculateScore({
        'pairs': pictureScoreList,
      });
      var pictureSequenceResult = RPPictureSequenceResult.fromResults(
        pictureMovesList,
        pictureScoreList,
        pictureTimesList,
        memorySecondList,
        pictureSequenceScore,
        original,
        pictures,
      );

      sWidget.onResultChange(pictureSequenceResult.results);

      if (sWidget.activity.includeResults) {
        picTimer?.cancel();
        sWidget.eventLogger.resultsShown();
        setState(() {
          finished = true;
        });
      } else {
        picTimer?.cancel();
        sWidget.eventLogger.resultsShown();
        setState(() {
          finished = true;
        });
      }
    } else {
      pictureScoreList.add(seconds);
      pictureMovesList.add(moves);
      picTimer?.cancel();
      resetTest();
    }
  }

  List<Widget> _tiles = [];

  @override
  initState() {
    super.initState();
    pictures = getPictures(0, numberOfPics, numberOfPics);

    pictures.shuffle();
    for (Picture picl in pictures) {
      original.add(picl);
    }
    for (int i = 0; i < pictures.length; i++) {
      if (i > 0 && i < pictures.length - 1) {
        pictures[i - 1].left = pictures[i].name;
        pictures[i].right = pictures[i + 1].name;
      } else if (i == 0) {
        pictures[i].right = pictures[i + 1].name;
      } else if (i == pictures.length - 1) {
        pictures[i - 1].left = pictures[i].name;
      }
    }
    _tiles = [];
    memorySeconds = 0;
    for (int i = 0; i < numberOfPics; i++) {
      _tiles.add(buildPicture(i, pictures[i]));
    }
    startMemoryTimer();
  }

  @override
  void dispose() {
    picTimer?.cancel();
    memoryTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var locale = CPLocalizations.of(context);

    void onReorder(int oldIndex, int newIndex) {
      setState(() {
        moves = moves + 1;
        final oldPicture = _tiles.removeAt(oldIndex);
        _tiles.insert(newIndex, oldPicture);
        final newPicture = pictures.removeAt(oldIndex);
        pictures.insert(newIndex, newPicture);
      });
    }

    var wrap = ReorderableWrap(
      controller: scrollController,
      needsLongPressDraggable: false,
      spacing: 8.0,
      runSpacing: 4.0,
      padding: const EdgeInsets.all(8),
      onReorder: onReorder,
      children: _tiles,
    );

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 1.5,
              width: MediaQuery.of(context).size.width,
              child: !guess
                  ? !waiting
                        ? Center(child: wrap)
                        : Center(
                            child: Text(
                              locale?.translate('wait') ?? 'Wait',
                              style: const TextStyle(fontSize: 25),
                            ),
                          )
                  : !waiting
                  ? Center(child: wrap)
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
                                  locale?.translate('start') ?? 'Start',
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

  Widget buildPicture(int index, Picture picture) => SizedBox(
    height: 100,
    width: 100,
    key: ValueKey(picture),
    child: ReorderableDragStartListener(
      index: index,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          image: DecorationImage(
            image: AssetImage(picture.urlImage),
            fit: BoxFit.cover,
          ),
        ),
      ),
    ),
  );
}

class Picture {
  String name;
  String urlImage;
  String left = "";
  String right = "";

  Picture({required this.name, required this.urlImage});
}
