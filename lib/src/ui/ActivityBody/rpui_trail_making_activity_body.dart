// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
part of '../../../../ui.dart';

/// The [RPUITrailMakingActivityBody] class defines the UI for the
/// instructions and test phase of the continuous visual tracking task.
class RPUITrailMakingActivityBody extends StatefulWidget {
  /// The [RPUITrailMakingActivityBody] activity.
  final RPTrailMakingActivity activity;

  /// The results function for the [RPUITrailMakingActivityBody].
  final void Function(dynamic) onResultChange;

  /// the [RPActivityEventLogger] for the [RPUITrailMakingActivityBody].
  final RPActivityEventLogger eventLogger;

  /// The [RPUITrailMakingActivityBody] constructor.
  const RPUITrailMakingActivityBody(
    this.activity,
    this.eventLogger,
    this.onResultChange, {
    super.key,
  });

  @override
  RPUITrailMakingActivityBodyState createState() =>
      RPUITrailMakingActivityBodyState();
}

class RPUITrailMakingActivityBodyState
    extends State<RPUITrailMakingActivityBody> {
  PathTracker? pathTracker;
  ActivityStatus activityStatus = ActivityStatus.Instruction;
  List<Location>? boxLocations;

  Future<void>? canvasReady;
  int? taskTime;

  bool get isTypeA => widget.activity.trailType == TrailType.A;

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

  void startTest() {
    setState(() {
      activityStatus = ActivityStatus.Test;
    });
  }

  Future<bool> buildCanvas(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    boxLocations = isTypeA
        ? TrailMakingLists().A(
            size.width,
            size.height - AppBar().preferredSize.height - 100,
          )
        : TrailMakingLists().B(
            size.width,
            size.height - AppBar().preferredSize.height - 100,
          );
    pathTracker = PathTracker(widget.eventLogger, boxLocations!);
    return Future.value(true);
  }

  void _onPanStart(DragStartDetails start) {
    Offset pos = (context.findRenderObject() as RenderBox).globalToLocal(
      start.globalPosition,
    );
    pathTracker?.addNewPath(pos);
    pathTracker?.notifyListeners();
  }

  void _onPanUpdate(DragUpdateDetails update) {
    Offset pos = (context.findRenderObject() as RenderBox).globalToLocal(
      update.globalPosition,
    );
    pathTracker?.updateCurrentPath(pos, testConcluded);
    pathTracker?.notifyListeners();
  }

  void _onPanEnd(DragEndDetails end) {
    pathTracker?.endCurrentPath();
    pathTracker?.notifyListeners();
  }

  void testConcluded(int result, int mistakes) {
    int score = 5 - mistakes;
    widget.onResultChange({'Completion time': result, 'score': score});
    taskTime = result;
    if (widget.activity.includeResults) {
      widget.eventLogger.resultsShown();
    }
    if (mounted) {
      setState(() {
        activityStatus = ActivityStatus.Result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var locale = CPLocalizations.of(context);
    switch (activityStatus) {
      case ActivityStatus.Instruction:
        return SingleChildScrollView(
          child: Column(
            //entry screen with rules and start button
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  isTypeA
                      ? locale?.translate(
                              "trail_making.connect_boxes_type_A",
                            ) ??
                            "Connect the boxes to each other by drawing lines between them in numerical order, starting at '1'."
                      : locale?.translate(
                              'trail_making.connect_boxes_type_B',
                            ) ??
                            "Connect the boxes to each other by drawing lines between them.",
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  isTypeA
                      ? ""
                      : locale?.translate(
                              'trail_making.alternate_letters_numbers',
                            ) ??
                            "You must alternate between numbers and letters and should order them alphabetically and numerically, respectively. Start with the number '1'.",
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Image.asset(
                  isTypeA
                      ? 'packages/cognition_package/assets/images/trailmaking_a.png'
                      : 'packages/cognition_package/assets/images/trailmaking_b.png',
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
                    startTest();
                  },
                  child: Text(
                    locale?.translate('ready') ?? 'Ready',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        );
      case ActivityStatus.Test:
        canvasReady = buildCanvas(context);
        return FutureBuilder(
          future: canvasReady,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const CircularProgressIndicator();
            return SizedBox(
              height:
                  MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height,
              width: MediaQuery.of(context).size.width,
              child: GestureDetector(
                onPanStart: _onPanStart,
                onPanUpdate: _onPanUpdate,
                onPanEnd: _onPanEnd,
                child: ClipRect(
                  child: CustomPaint(painter: TrailPainter(pathTracker)),
                ),
              ),
            );
          },
        );
      case ActivityStatus.Result:
        if (widget.activity.includeResults) {
          return Container(
            alignment: Alignment.center,
            child: Text(
              '${locale?.translate('trail_making.completed_task') ?? "You completed the task in"}: $taskTime ${locale?.translate('seconds') ?? 'seconds'}!',
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

class TrailPainter extends CustomPainter {
  final PathTracker? pathTracker;

  TrailPainter(this.pathTracker) : super(repaint: pathTracker);

  @override
  void paint(Canvas canvas, Size size) {
    if (pathTracker != null) {
      canvas.drawRect(
        Rect.fromLTWH(0.0, 0.0, size.width, size.height),
        Paint()..color = Colors.transparent,
      );
      for (Location location in pathTracker!.locations) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: location.id,
            style: const TextStyle(color: Colors.black, fontSize: 20),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout(
          minWidth: 0,
          maxWidth: size.width,
          //        maxWidth: 0,
        );
        // offset for id 10, as it is wider than the rest.
        int tx = location.id == '10' ? 11 : 6;
        Offset textOffset = Offset(
          location.offset.dx - tx,
          location.offset.dy - 12,
        );
        textPainter.paint(canvas, textOffset);
        canvas.drawRect(
          location.rect,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.0,
        );
      }
      for (Path path in pathTracker!._paths) {
        canvas.drawPath(
          path,
          (Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.0),
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class PathTracker extends ChangeNotifier {
  RPActivityEventLogger gestureController;
  List<Location> locations;
  List<Path> _paths = [];
  bool _isDraging = false;
  bool _isFinished = false;
  bool taskStarted = false;
  late Location prevLocation;
  late Location nextLocation;
  int index = 0;
  DateTime startTime = DateTime.now();
  int mistakeCount = 0;

  PathTracker(this.gestureController, this.locations) {
    _paths = [];
    _isDraging = false;
    taskStarted = false;
    prevLocation = locations.first;
    nextLocation = locations[1];
    index = 1;
  }

  void addNewPath(Offset pos) {
    if (!taskStarted) {
      taskStarted = true;
      startTime = DateTime.now();
    }
    if (!_isDraging) {
      _isDraging = true;
      Path path = Path();
      path.moveTo(pos.dx, pos.dy);
      // starting point - also removes errors when trying to remove paths not yet drawn
      path.addOval(Rect.fromLTWH(pos.dx, pos.dy, 1, 1));
      _paths.add(path);
    }
  }

  void updateCurrentPath(Offset newPos, void Function(int, int) testConcluded) {
    if (_isDraging && !_isFinished) {
      Path path = _paths.last;
      path.lineTo(newPos.dx, newPos.dy);
      Offset firstPoint = path
          .computeMetrics()
          .first
          .getTangentForOffset(0)!
          .position;

      // Avoid if drag hits another locations before hitting the next location (e.g. A-C-B)
      List<Location> locationCopy = List.from(locations);
      locationCopy.remove(prevLocation);
      locationCopy.remove(nextLocation);
      for (Location l in locationCopy) {
        if (l.rect.contains(newPos)) {
          _isDraging = false;
          gestureController.addWrongGesture(
            'Draw path',
            'Drew a path which hit ${l.id} instead of the correct, next item ${nextLocation.id}',
          );
          deleteWrong();
          mistakeCount++;
          return;
        }
      }

      // If dragging directly without lifting finger
      if (prevLocation.rect.contains(firstPoint) &&
          nextLocation.rect.contains(newPos)) {
        gestureController.addCorrectGesture(
          'Draw path',
          'Drew a correct path from ${prevLocation.id} to ${nextLocation.id}',
        );
        Path newPath = Path();
        newPath.moveTo(newPos.dx, newPos.dy);
        _paths.add(newPath);
        if (index < locations.length - 1) {
          prevLocation = nextLocation;
          index += 1;
          nextLocation = locations[index];
        } else {
          _isFinished = true;

          gestureController.testEnded();
          gestureController.resultsShown();
          int secondsUsed = DateTime.now().difference(startTime).inSeconds;
          testConcluded(secondsUsed, mistakeCount);
        }
      }
    }
  }

  void endCurrentPath() {
    if (_isDraging) {
      _isDraging = false;
      if (!_isFinished) {
        Path path = _paths.last;
        Offset lastPoint = path
            .computeMetrics(forceClosed: true)
            .last
            .getTangentForOffset(path.computeMetrics().last.length)!
            .position;
        Offset firstPoint = path
            .computeMetrics()
            .first
            .getTangentForOffset(0)!
            .position;
        if (!prevLocation.rect.contains(firstPoint)) {
          gestureController.addWrongGesture(
            'Draw path',
            'Drew a path which didnt start in ${prevLocation.id}',
          );
          deleteWrong();
        } else if (!nextLocation.rect.contains(lastPoint)) {
          gestureController.addWrongGesture(
            'Draw path',
            'Drew a path which didnt end in ${nextLocation.id}',
          );
          deleteWrong();
        }
      }
    }
  }

  void deleteWrong() {
    if (!_isDraging) {
      _paths.removeLast();
    }
  }
}

class Location {
  String id;
  Offset offset;
  late Rect rect;

  Location(this.id, this.offset) {
    rect = Rect.fromCircle(center: offset, radius: 26);
  }
}

class TrailMakingLists {
  List<Location> A(double w, double h) {
    return [
      Location('1', Offset(w * 0.6, h * 0.5)),
      Location('2', Offset(w * 0.17, h * 0.28)),
      Location('3', Offset(w * 0.45, h * 0.08)),
      Location('4', Offset(w * 0.55, h * 0.30)),
      Location('5', Offset(w * 0.80, h * 0.20)),
      Location('6', Offset(w * 0.85, h * 0.72)),
      Location('7', Offset(w * 0.45, h * 0.60)),
      Location('8', Offset(w * 0.60, h * 0.88)),
      Location('9', Offset(w * 0.12, h * 0.92)),
      Location('10', Offset(w * 0.2, h * 0.50)),
    ];
  }

  List<Location> B(double w, double h) {
    return [
      Location('1', Offset(w * 0.6, h * 0.5)),
      Location('A', Offset(w * 0.17, h * 0.28)),
      Location('2', Offset(w * 0.45, h * 0.08)),
      Location('B', Offset(w * 0.55, h * 0.30)),
      Location('3', Offset(w * 0.80, h * 0.20)),
      Location('C', Offset(w * 0.85, h * 0.72)),
      Location('4', Offset(w * 0.45, h * 0.60)),
      Location('D', Offset(w * 0.60, h * 0.88)),
      Location('5', Offset(w * 0.12, h * 0.82)),
      Location('E', Offset(w * 0.2, h * 0.50)),
    ];
  }
}
