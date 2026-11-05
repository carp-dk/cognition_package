part of '../../../../ui.dart';

/// The [RPUICorsiBlockTappingActivityBody] class defines the UI for the
/// instructions and test phase of the continuous visual tracking task.
class RPUICorsiBlockTappingActivityBody extends StatefulWidget {
  /// The [RPUICorsiBlockTappingActivityBody] activity.
  final RPCorsiBlockTappingActivity activity;

  /// The results function for the [RPUICorsiBlockTappingActivityBody].
  final void Function(dynamic) onResultChange;

  /// the [RPActivityEventLogger] for the [RPUICorsiBlockTappingActivityBody].
  final RPActivityEventLogger eventLogger;

  /// The [RPUICorsiBlockTappingActivityBody] constructor.
  const RPUICorsiBlockTappingActivityBody(
    this.activity,
    this.eventLogger,
    this.onResultChange, {
    super.key,
  });

  @override
  RPUICorsiActivityBodyState createState() => RPUICorsiActivityBodyState();
}

/// State class for [ContinuousVisualTrackingActivityBody]
class RPUICorsiActivityBodyState
    extends State<RPUICorsiBlockTappingActivityBody> {
  ActivityStatus activityStatus = ActivityStatus.Instruction;
  int corsiSpan = 0;
  int highlightedBlockID = 500;
  List<int> blocks = [];
  List<int> tapOrder = [];
  bool readyForTap = false;
  bool finishedTask = false;
  bool failedLast = false;
  String taskInfo = '';
  int numberOfBlocks = 2;
  CPLocalizations? locale;

  @override
  initState() {
    super.initState();
    blocks = List.generate(9, (index) => index);
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
    setState(() {
      taskInfo = locale?.translate('corsi_block.wait') ?? "Wait";
      readyForTap = false;
      tapOrder.clear();
      blocks.shuffle();
    });
    await Future<dynamic>.delayed(const Duration(seconds: 1));
    for (int i = 0; i < numberOfBlocks; i++) {
      if (activityStatus == ActivityStatus.Test && mounted) {
        setState(() {
          highlightedBlockID = blocks[i];
        });
      }
      await Future<dynamic>.delayed(const Duration(milliseconds: 1000));
    }
    if (activityStatus == ActivityStatus.Test && mounted) {
      setState(() {
        highlightedBlockID = 500;
        readyForTap = true;
        taskInfo = locale?.translate('corsi_block.go') ?? 'Go';
      });
    }
  }

  void onBlockTap(int index) async {
    setState(() {
      tapOrder.add(index);
    });
    if (tapOrder.length == numberOfBlocks) {
      finishedTask = true;
      bool wasCorrect = true;
      for (int x = 0; x < numberOfBlocks; x++) {
        if (tapOrder[x] != blocks[x]) wasCorrect = false;
      }
      if (!wasCorrect) {
        if (failedLast) {
          widget.eventLogger.addWrongGesture(
            'Button tap',
            'Test Finished after second fail - Tapped the order: $tapOrder. The correct order was: ${blocks.getRange(0, numberOfBlocks)}',
          );
          setState(() {
            taskInfo = locale?.translate('corsi_block.finished') ?? 'Finished';
          });
          await Future<dynamic>.delayed(const Duration(milliseconds: 700));
          widget.onResultChange(corsiSpan);
          widget.eventLogger.testEnded();
          if (widget.activity.includeResults) {
            widget.eventLogger.resultsShown();
            setState(() {
              activityStatus = ActivityStatus.Result;
            });
          }
        } else {
          widget.eventLogger.addWrongGesture(
            'Button tap',
            'Failed first try - Tapped the order: $tapOrder. The correct order was: ${blocks.getRange(0, numberOfBlocks)}',
          );
          failedLast = true;
          setState(() {
            taskInfo =
                locale?.translate('corsi_block.try_again') ?? 'Try again';
          });
          await Future<dynamic>.delayed(const Duration(milliseconds: 700));
          startTest();
        }
      } else {
        widget.eventLogger.addCorrectGesture(
          'Button tap',
          'Succeeded test in ${!failedLast ? 'first' : 'second'} try. Tap order was: $tapOrder',
        );
        setState(() {
          failedLast = false;
          taskInfo = locale?.translate('corsi_block.well_done') ?? 'Well done!';
        });
        corsiSpan = numberOfBlocks;
        numberOfBlocks++;
        await Future<dynamic>.delayed(const Duration(milliseconds: 700));
        startTest();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    locale = CPLocalizations.of(context);

    // try to get language-specific image - EN version as default.
    var image = Image.asset(
      'packages/cognition_package/assets/images/corsi_${locale?.locale.languageCode}.png',
      errorBuilder: (ctx, error, stackTrace) =>
          Image.asset('packages/cognition_package/assets/images/corsi_en.png'),
    );

    switch (activityStatus) {
      case ActivityStatus.Instruction:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                locale?.translate('corsi_block.9_tiles') ??
                    "On the following screen, you will see 9 tiles. Some of the tiles will be highlighted in a specific order. When the light in the top of the screen is green, and reads 'Go', you should press the tiles in the same order as they were highlighted. As the test progress, more and more tiles are highlighted.",
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
                maxLines: 10,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Container(
                height: MediaQuery.of(context).size.height / 2.5,
                width: MediaQuery.of(context).size.width / 1.1,
                decoration: BoxDecoration(
                  image: DecorationImage(fit: BoxFit.fill, image: image.image),
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
        return Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 70,
                width: 400,
                color: readyForTap ? Colors.green : Colors.red,
                child: Center(
                  child: Text(
                    taskInfo,
                    style: const TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [_makeButton(0), _makeButton(1)],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [_makeButton(2), _makeButton(3)],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [_makeButton(4), _makeButton(5), _makeButton(6)],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [_makeButton(7), _makeButton(8)],
              ),
            ],
          ),
        );
      case ActivityStatus.Result:
        return Center(
          child: Text(
            '${locale?.translate('corsi_block.span') ?? "Your Corsi Span was"} $corsiSpan',
            style: const TextStyle(fontSize: 22),
            textAlign: TextAlign.center,
          ),
        );
    }
  }

  Widget _makeButton(int buttonNum) {
    return InkWell(
      onTap: readyForTap
          ? () {
              onBlockTap(buttonNum);
            }
          : null,
      child: Container(
        height: 60,
        width: 60,
        color: highlightedBlockID == buttonNum ? Colors.red : Colors.blue,
        child: Center(
          child: tapOrder.contains(buttonNum) ? const Icon(Icons.check) : null,
        ),
      ),
    );
  }
}
