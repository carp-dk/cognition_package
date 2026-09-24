import 'package:cognition_package/model.dart';
import 'package:cognition_package/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:research_package/research_package.dart';

void main() {
  testWidgets('a vertical fling keeps the card, and the last swipe ends the test', (tester) async {
    const cards = 3;
    final activity = RPFlankerActivity(
      identifier: 'flanker',
      includeInstructions: false,
      numberOfCards: cards,
      lengthOfTest: 60,
    );
    dynamic result;
    await tester.pumpWidget(MaterialApp(
      home: RPUIFlankerActivity(
        activity,
        RPActivityEventLogger(RPActivityResult(identifier: 'flanker')),
        (r) => result = r,
      ),
    ));

    // A thumb swipe which ends up mostly vertical must not discard a card.
    await tester.fling(find.byType(FlankerCard).last, const Offset(100, -600), 3000);
    await tester.pump(const Duration(milliseconds: 400));

    // The top card is the last one in the stack.
    for (var i = cards - 1; i >= 0; i--) {
      await tester.fling(find.byType(FlankerCard).at(i), const Offset(400, 0), 3000);
      await tester.pump(const Duration(milliseconds: 400));
    }

    expect(result, isNotNull);
    expect(find.byType(FlankerCard), findsNothing);
    await tester.pump(const Duration(seconds: 61)); // let the test timer run out
  });
}
