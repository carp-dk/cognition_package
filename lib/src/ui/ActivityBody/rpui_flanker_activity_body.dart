part of '../../../../ui.dart';

/// The [RPUIFlankerActivity] class defines the UI for the
/// instructions and test phase of the continuous visual tracking task.
class RPUIFlankerActivity extends StatefulWidget {
  /// The [RPUIFlankerActivity] activity.
  final RPFlankerActivity activity;

  /// The results function for the [RPUIFlankerActivity].
  final void Function(dynamic) onResultChange;

  /// the [RPActivityEventLogger] for the [RPUIFlankerActivity].
  final RPActivityEventLogger eventLogger;

  /// The [RPUIFlankerActivity] constructor.
  const RPUIFlankerActivity(
    this.activity,
    this.eventLogger,
    this.onResultChange, {
    super.key,
  });

  @override
  RPUIFlankerActivityState createState() => RPUIFlankerActivityState();
}

class RPUIFlankerActivityState extends State<RPUIFlankerActivity> {
  ActivityStatus activityStatus = ActivityStatus.Instruction;

  /// Score counter for the flanker task used in [RPUIFlankerActivity]
  int flankerScore = 0;

  /// Counter for the wrong swipes in the flanker task used in [RPUIFlankerActivity]
  int wrongSwipe = 0;

  /// Counter for the right swipes in the flanker task used in [RPUIFlankerActivity]
  int rightSwipe = 0;

  List<int> congruentTimes = [];
  List<int> incongruentTimes = [];

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

  Timer? testTimer;
  int seconds = 0;
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    testTimer = Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (seconds < 0) {
            timer.cancel();
          } else {
            seconds = seconds + 1;
          }
        },
      ),
    );
  }

  Timer? flankerTimer;
  int flankerSeconds = 0;
  void startFlankerTimer() {
    const oneSec = Duration(milliseconds: 1);
    flankerTimer = Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (flankerSeconds < 0) {
            flankerTimer?.cancel();
          } else {
            flankerSeconds = flankerSeconds + 1;
          }
        },
      ),
    );
  }

  void startTest() async {
    startTimer();
    await Future<dynamic>.delayed(const Duration(seconds: 1));
    Timer(Duration(seconds: widget.activity.lengthOfTest), finish);
  }

  /// Ends the test - when all cards are swiped or the time is up.
  void finish() {
    if (!mounted || activityStatus == ActivityStatus.Result) return;
    widget.eventLogger.testEnded();
    var flankerScoreResults = widget.activity.calculateScoreFlanker({
      'mistakes': wrongSwipe,
      'correct': rightSwipe,
      'congruentTimes': congruentTimes,
      'incongruentTimes': incongruentTimes
    });
    var flankerResult = RPFlankerResult.fromResults(
      wrongSwipe,
      rightSwipe,
      seconds,
      flankerScoreResults[0] as int,
      flankerScoreResults[1] as double,
      flankerScoreResults[2] as double,
      congruentTimes.length,
      incongruentTimes.length,
    );
    testTimer?.cancel();
    flankerTimer?.cancel();
    widget.onResultChange(flankerResult.results);
    if (widget.activity.includeResults) {
      widget.eventLogger.resultsShown();
    }
    setState(() => activityStatus = ActivityStatus.Result);
  }

  @override
  void dispose() {
    testTimer?.cancel();
    flankerTimer?.cancel();
    super.dispose();
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                locale?.translate('flanker.5_arrows') ??
                    "Each card has 5 arrows on it.",
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
                maxLines: 10,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                locale?.translate('flanker.swipe_cards') ??
                    "Swipe the cards in the direction of the middle arrow on each card.",
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
                maxLines: 10,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                locale?.translate('flanker.ignored_arrows') ??
                    "Ignore all other arrows on the cards, they are only there to distract you.",
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
                            'packages/cognition_package/assets/images/flanker.png'))),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: OutlinedButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                  shape: MaterialStateProperty.all(
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
              child: Flanker(
                  numberOfCards: widget.activity.numberOfCards,
                  flankerState: this)),
        );
      case ActivityStatus.Result:
        if (widget.activity.includeResults) {
          return Center(
            child: Text(
              '${locale?.translate('flanker.correct_swipes') ?? "Correct swipes"}: $rightSwipe',
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
      default:
        return Container();
    }
  }
}

class Flanker extends StatefulWidget {
  final int numberOfCards;
  final RPUIFlankerActivityState flankerState;

  const Flanker({
    super.key,
    required this.numberOfCards,
    required this.flankerState,
  });

  @override
  FlankerState createState() => FlankerState(numberOfCards, flankerState);
}

class FlankerState extends State<Flanker> {
  final int numberOfCards;
  final RPUIFlankerActivityState flankerState;
  bool even = false;

  FlankerState(this.numberOfCards, this.flankerState);

  List<Widget> flankerCards = [];
  List<FlankerCard> cards(int amount) {
    List<FlankerCard> cards = [];
    for (var i = 0; i < amount; i++) {
      even = !even;
      if (Random().nextBool()) {
        cards.add(
            FlankerCard('→', even ? 0xff003F6E : 0xffC32C39, flankerState));
      } else {
        cards.add(
            FlankerCard('←', even ? 0xff003F6E : 0xffC32C39, flankerState));
      }
    }
    flankerState.startFlankerTimer();
    return cards;
  }

  @override
  initState() {
    super.initState();
    flankerCards = cards(numberOfCards);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.7,
      child: Stack(children: flankerCards),
    );
  }
}

class FlankerCard extends StatelessWidget {
  final int color;
  final String direction;
  final RPUIFlankerActivityState flankerState;

  FlankerCard(this.direction, this.color, this.flankerState, {super.key});

  final String right = '→';
  final String left = '←';
  final bool congruent = Random().nextBool();

  String stimuli() {
    String ret = '';
    for (var i = 0; i < 5; i++) {
      if (i == 2) {
        ret += direction;
      } else if (congruent) {
        ret += direction;
      } else {
        if (direction == '→') {
          ret += '←';
        } else {
          ret += '→';
        }
      }
    }
    return ret;
  }

  void onSwipe(String swiped) {
    if (direction == swiped) {
      flankerState.rightSwipe++;
      (congruent ? flankerState.congruentTimes : flankerState.incongruentTimes)
          .add(flankerState.flankerSeconds);
    } else {
      flankerState.wrongSwipe++;
    }
    flankerState.flankerSeconds = 0;
    if (++flankerState.flankerScore ==
        flankerState.widget.activity.numberOfCards) {
      flankerState.finish();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Swipable(
      onSwipeRight: (_) => onSwipe(right),
      onSwipeLeft: (_) => onSwipe(left),
      // Only left/right answer a card - a vertical fling must not discard it.
      verticalSwipe: false,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: Color(color),
        ),
        child: Center(
            child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            stimuli(),
            style: const TextStyle(fontSize: 55, color: Colors.white),
          ),
        )),
      ),
    );
  }
}

class Swipable extends StatefulWidget {
  /// @param child [Widget]
  /// @required
  /// Swipable content.
  final Widget? child;

  /// Callback
  /// Hook triggered when the card starts being dragged.
  /// @param details [DragStartDetails]
  final void Function(DragStartDetails details)? onSwipeStart;

  /// Callback
  /// Hook triggered when the card position changes.
  /// @param details [DragUpdateDetails]
  final void Function(DragUpdateDetails details)? onPositionChanged;

  /// Callback
  /// Hook triggered when the card stopped being dragged and doesn't meet the requirement to be swiped.
  /// @param details [DragEndDetails]
  final void Function(Offset position, DragEndDetails details)? onSwipeCancel;

  /// Callback
  /// Hook triggered when the card stopped being dragged and meets the requirement to be swiped.
  /// @param details [DragEndDetails]
  final void Function(Offset position, DragEndDetails details)? onSwipeEnd;

  /// Callback
  /// Hook triggered when the card finished swiping right.
  /// @param finalPosition [Offset]
  final void Function(Offset finalPosition)? onSwipeRight;

  /// Callback
  /// Hook triggered when the card finished swiping left.
  /// @param finalPosition [Offset]
  final void Function(Offset finalPosition)? onSwipeLeft;

  /// Callback
  /// Hook triggered when the card finished swiping up.
  /// @param finalPosition [Offset]
  final void Function(Offset finalPosition)? onSwipeUp;

  /// Callback
  /// Hook triggered when the card finished swiping down.
  /// @param finalPosition [Offset]
  final void Function(Offset finalPosition)? onSwipeDown;

  /// @param swipe [Stream<double>]
  /// Triggers an automatic swipe.
  /// Cancels automatically after first emission.R
  /// The double value sent corresponds to the direction the card should follow (clockwise radian angle).
  final Stream<double>? swipe;

  /// @param animationDuration [int]
  /// Animation duration (in milliseconds) for the card to swipe atuomatically or get back to its original position on swipe cancel.
  final int? animationDuration;

  /// @param animationCurve [Curve]
  /// Animation timing function.
  final Curve? animationCurve;

  /// @param threshold [double]
  /// Defines the strength needed for a card to be swiped.
  /// The bigger, the easier it is to swipe.
  final double? threshold;

  /// @param horizontalSwipe [bool]
  /// To enable or disable the swipe in horizontal direction.
  /// defaults to true.
  final bool horizontalSwipe;

  /// @param verticalSwipe [bool]
  /// To enable or disable the swipe in vertical direction.
  /// defaults to true.
  final bool verticalSwipe;

  const Swipable({
    super.key,
    @required this.child,
    this.onSwipeRight,
    this.onSwipeLeft,
    this.onSwipeDown,
    this.onSwipeUp,
    this.onPositionChanged,
    this.onSwipeStart,
    this.onSwipeCancel,
    this.onSwipeEnd,
    this.swipe,
    this.animationDuration = 300,
    this.animationCurve = Curves.easeInOut,
    this.horizontalSwipe = true,
    this.verticalSwipe = true,
    this.threshold = 0.3,
  });

  @override
  SwipableState createState() => SwipableState();
}

class SwipableState extends State<Swipable> {
  double _positionY = 0;
  double _positionX = 0;

  int _duration = 0;

  StreamSubscription? _swipeSub;

  @override
  void initState() {
    super.initState();

    _swipeSub = widget.swipe?.listen((angle) {
      _swipeSub?.cancel();
      _animate(angle);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
            onPanStart: _onPanStart,
            onPanEnd: _onPanEnd,
            onPanUpdate: _onPanUpdate,
            child: Stack(
              // overflow: Overflow.visible,
              children: [
                AnimatedPositioned(
                    duration: Duration(milliseconds: _duration),
                    top: _positionY,
                    left: _positionX,
                    child: Container(
                        constraints: BoxConstraints(
                            maxHeight: constraints.maxHeight,
                            maxWidth: constraints.maxWidth),
                        child: widget.child))
              ],
            )));
  }

  @override
  void dispose() {
    super.dispose();

    _swipeSub?.cancel();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _positionX += details.delta.dx;
      _positionY += details.delta.dy;
    });

    if (widget.onPositionChanged != null) widget.onPositionChanged!(details);
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _duration = 0;
    });

    if (widget.onSwipeStart != null) widget.onSwipeStart!(details);
  }

  void _onPanEnd(DragEndDetails details) {
    double newX = 0;
    double newY = 0;

    // Get screen dimensions.
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    double potentialX = _positionX +
        (details.velocity.pixelsPerSecond.dx * (widget.threshold ?? 1));
    double potentialY = _positionY +
        (details.velocity.pixelsPerSecond.dy * (widget.threshold ?? 1));

    Offset currentPosition = Offset(_positionX, _positionY);

    bool shouldSwipe = potentialX.abs() >= width || potentialY.abs() >= height;

    double angle = details.velocity.pixelsPerSecond.direction;

    //<=45 deg 1 quad to >=315 deg 4 quad
    bool swipedRight = angle.abs() <= (pi / 4);
    // As the angle is not continous as it breaks after 360 deg
    //  || angle.abs() >= (7 * math.pi / 4);

    //>=135 deg 2 quad to <=225 deg 3 quad
    bool swipedLeft =
        angle.abs() >= (3 * pi / 4) && angle.abs() <= (5 * pi / 4);
    //<135 deg 2 quad to >45 deg 1 quad
    bool swipedUp = angle.abs() < (3 * pi / 4) && angle.abs() > (pi / 4);
    //>225 deg 2 quad to <315 deg 1 quad
    bool swipedDown = angle.abs() > (5 * pi / 4) && angle.abs() < (7 * pi / 4);

    bool movingVertically = swipedUp || swipedDown;
    bool movingHorizontally = swipedRight || swipedLeft;

    //either it will be moving vertically or horizontally but not both
    if (movingVertically && !widget.verticalSwipe) shouldSwipe = false;
    if (movingHorizontally && !widget.horizontalSwipe) shouldSwipe = false;
    if (shouldSwipe) {
      // horizontal speed or vertical speed is enough to make the card disappear in _duration ms.
      newX = potentialX;
      newY = potentialY;
      widget.onSwipeEnd?.call(currentPosition, details);
    } else {
      newX = 0;
      newY = 0;

      widget.onSwipeCancel?.call(currentPosition, details);
    }

    setState(() {
      _positionX = newX;
      _positionY = newY;
      _duration = widget.animationDuration ?? 300;
    });

    if (shouldSwipe) {
      Future.delayed(Duration(milliseconds: widget.animationDuration ?? 300),
          () {
        // Clock wise radian angle of the velocity

        Offset finalPosition = Offset(newX, newY);
        if (swipedRight && widget.onSwipeRight != null) {
          widget.onSwipeRight!(finalPosition);
        } else if (swipedLeft && widget.onSwipeLeft != null) {
          widget.onSwipeLeft!(finalPosition);
        } else if (swipedDown && widget.onSwipeDown != null) {
          widget.onSwipeDown!(finalPosition);
        } else if (swipedUp && widget.onSwipeUp != null) {
          widget.onSwipeUp!(finalPosition);
        }
      });
    }
  }

  void _animate(double angle) {
    if (angle < -pi || angle > pi) {
      throw ('Angle must be between -π and π (inclusive).');
    }

    if (widget.onSwipeStart != null) {
      widget.onSwipeStart!(DragStartDetails());
    }

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // Horizontal distance to arrive to the final X.
    double remainingX;
    // Vertical distance to arrive to the final Y.
    double remainingY;

    if (angle.abs() <= pi / 4) {
      // Swiping right
      remainingX = width - _positionX;
      remainingY = 0;
    } else if (angle.abs() > 3 * pi / 4) {
      // Swiping left
      remainingX = -width - _positionX;
      remainingY = 0;
    } else if (angle >= 0) {
      // Swiping down
      remainingX = 0;
      remainingY = height - _positionY;
    } else {
      // Swiping up
      remainingX = 0;
      remainingY = -height - _positionY;
    }

    // Calculating velocity so the card arrives at it's final position when the animation ends.
    Velocity velocity = Velocity(
        pixelsPerSecond: Offset(remainingX / (widget.threshold ?? 1),
            remainingY / (widget.threshold ?? 1)));
    DragEndDetails details = DragEndDetails(velocity: velocity);
    _onPanEnd(details);
  }
}
