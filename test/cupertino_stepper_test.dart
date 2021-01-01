// Copyright 2020 J-P Nurmi <jpnurmi@gmail.com>
// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Stepper tap callback test', (WidgetTester tester) async {
    int index = 0;

    await tester.pumpWidget(
      CupertinoApp(
        home: Container(
          child: CupertinoStepper(
            onStepTapped: (int i) {
              index = i;
            },
            steps: const <Step>[
              Step(
                title: Text('Step 1'),
                content: SizedBox(
                  width: 100.0,
                  height: 100.0,
                ),
              ),
              Step(
                title: Text('Step 2'),
                content: SizedBox(
                  width: 100.0,
                  height: 100.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.tap(find.text('Step 2'));
    expect(index, 1);
  });

  testWidgets('Stepper expansion test', (WidgetTester tester) async {
    await tester.pumpWidget(
      CupertinoApp(
        home: Center(
          child: Container(
            child: CupertinoStepper(
              steps: const <Step>[
                Step(
                  title: Text('Step 1'),
                  content: SizedBox(
                    width: 100.0,
                    height: 100.0,
                  ),
                ),
                Step(
                  title: Text('Step 2'),
                  content: SizedBox(
                    width: 200.0,
                    height: 200.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    RenderBox box = tester.renderObject(find.byType(CupertinoStepper));
    expect(box.size.height, 369.0);

    await tester.pumpWidget(
      CupertinoApp(
        home: Center(
          child: Container(
            child: CupertinoStepper(
              currentStep: 1,
              steps: const <Step>[
                Step(
                  title: Text('Step 1'),
                  content: SizedBox(
                    width: 100.0,
                    height: 100.0,
                  ),
                ),
                Step(
                  title: Text('Step 2'),
                  content: SizedBox(
                    width: 200.0,
                    height: 200.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 100));
    box = tester.renderObject(find.byType(CupertinoStepper));
    expect(box.size.height, greaterThan(369.0));
    await tester.pump(const Duration(milliseconds: 100));
    box = tester.renderObject(find.byType(CupertinoStepper));
    expect(box.size.height, greaterThan(432.0));
  });

  testWidgets('Stepper horizontal size test', (WidgetTester tester) async {
    await tester.pumpWidget(
      CupertinoApp(
        home: Center(
          child: Container(
            child: CupertinoStepper(
              type: StepperType.horizontal,
              steps: const <Step>[
                Step(
                  title: Text('Step 1'),
                  content: SizedBox(
                    width: 100.0,
                    height: 100.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    final RenderBox box = tester.renderObject(find.byType(CupertinoStepper));
    expect(box.size.height, 600.0);
  });

  testWidgets('Stepper visibility test', (WidgetTester tester) async {
    await tester.pumpWidget(
      CupertinoApp(
        home: Container(
          child: CupertinoStepper(
            type: StepperType.horizontal,
            steps: const <Step>[
              Step(
                title: Text('Step 1'),
                content: Text('A'),
              ),
              Step(
                title: Text('Step 2'),
                content: Text('B'),
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('A'), findsOneWidget);
    expect(find.text('B'), findsNothing);

    await tester.pumpWidget(
      CupertinoApp(
        home: Container(
          child: CupertinoStepper(
            currentStep: 1,
            type: StepperType.horizontal,
            steps: const <Step>[
              Step(
                title: Text('Step 1'),
                content: Text('A'),
              ),
              Step(
                title: Text('Step 2'),
                content: Text('B'),
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('A'), findsNothing);
    expect(find.text('B'), findsOneWidget);
  });

  testWidgets('Stepper button test', (WidgetTester tester) async {
    bool continuePressed = false;
    bool cancelPressed = false;

    await tester.pumpWidget(
      CupertinoApp(
        home: Container(
          child: CupertinoStepper(
            type: StepperType.horizontal,
            onStepContinue: () {
              continuePressed = true;
            },
            onStepCancel: () {
              cancelPressed = true;
            },
            steps: const <Step>[
              Step(
                title: Text('Step 1'),
                content: SizedBox(
                  width: 100.0,
                  height: 100.0,
                ),
              ),
              Step(
                title: Text('Step 2'),
                content: SizedBox(
                  width: 200.0,
                  height: 200.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.text('Continue'));
    await tester.tap(find.text('Cancel'));

    expect(continuePressed, isTrue);
    expect(cancelPressed, isTrue);
  });

  testWidgets('Stepper disabled step test', (WidgetTester tester) async {
    int index = 0;

    await tester.pumpWidget(
      CupertinoApp(
        home: Container(
          child: CupertinoStepper(
            onStepTapped: (int i) {
              index = i;
            },
            steps: const <Step>[
              Step(
                title: Text('Step 1'),
                content: SizedBox(
                  width: 100.0,
                  height: 100.0,
                ),
              ),
              Step(
                title: Text('Step 2'),
                state: StepState.disabled,
                content: SizedBox(
                  width: 100.0,
                  height: 100.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.text('Step 2'));
    expect(index, 0);
  });

  testWidgets('Stepper scroll test', (WidgetTester tester) async {
    await tester.pumpWidget(
      CupertinoApp(
        home: Container(
          child: CupertinoStepper(
            steps: const <Step>[
              Step(
                title: Text('Step 1'),
                content: SizedBox(
                  width: 100.0,
                  height: 280.0,
                ),
              ),
              Step(
                title: Text('Step 2'),
                content: SizedBox(
                  width: 100.0,
                  height: 280.0,
                ),
              ),
              Step(
                title: Text('Step 3'),
                content: SizedBox(
                  width: 100.0,
                  height: 100.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final ScrollableState scrollableState =
        tester.firstState(find.byType(Scrollable));
    expect(scrollableState.position.pixels, 0.0);

    await tester.tap(find.text('Step 3'));
    await tester.pumpWidget(
      CupertinoApp(
        home: Container(
          child: CupertinoStepper(
            currentStep: 2,
            steps: const <Step>[
              Step(
                title: Text('Step 1'),
                content: SizedBox(
                  width: 100.0,
                  height: 280.0,
                ),
              ),
              Step(
                title: Text('Step 2'),
                content: SizedBox(
                  width: 100.0,
                  height: 280.0,
                ),
              ),
              Step(
                title: Text('Step 3'),
                content: SizedBox(
                  width: 100.0,
                  height: 100.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 100));
    print(scrollableState.position);
    expect(scrollableState.position.pixels, greaterThan(0.0));
  });

  testWidgets('Stepper index test', (WidgetTester tester) async {
    await tester.pumpWidget(
      CupertinoApp(
        home: Center(
          child: Container(
            child: CupertinoStepper(
              steps: const <Step>[
                Step(
                  title: Text('A'),
                  state: StepState.complete,
                  content: SizedBox(
                    width: 100.0,
                    height: 100.0,
                  ),
                ),
                Step(
                  title: Text('B'),
                  content: SizedBox(
                    width: 100.0,
                    height: 100.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('1'), findsNothing);
    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('Stepper custom controls test', (WidgetTester tester) async {
    bool continuePressed = false;
    void setContinue() {
      continuePressed = true;
    }

    bool canceledPressed = false;
    void setCanceled() {
      canceledPressed = true;
    }

    final ControlsWidgetBuilder builder = (BuildContext context,
        {VoidCallback? onStepContinue, VoidCallback? onStepCancel}) {
      return Container(
        margin: const EdgeInsets.only(top: 16.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints.tightFor(height: 48.0),
          child: Row(
            children: <Widget>[
              CupertinoButton(
                onPressed: onStepContinue,
                child: const Text('Let us continue!'),
              ),
              Container(
                margin: const EdgeInsetsDirectional.only(start: 8.0),
                child: CupertinoButton(
                  onPressed: onStepCancel,
                  child: const Text('Cancel This!'),
                ),
              ),
            ],
          ),
        ),
      );
    };

    await tester.pumpWidget(
      CupertinoApp(
        home: Center(
          child: Container(
            child: CupertinoStepper(
              controlsBuilder: builder,
              onStepCancel: setCanceled,
              onStepContinue: setContinue,
              steps: const <Step>[
                Step(
                  title: Text('A'),
                  state: StepState.complete,
                  content: SizedBox(
                    width: 100.0,
                    height: 100.0,
                  ),
                ),
                Step(
                  title: Text('B'),
                  content: SizedBox(
                    width: 100.0,
                    height: 100.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // 2 because stepper creates a set of controls for each step
    expect(find.text('Let us continue!'), findsNWidgets(2));
    expect(find.text('Cancel This!'), findsNWidgets(2));

    await tester.tap(find.text('Cancel This!').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Let us continue!').first);
    await tester.pumpAndSettle();

    expect(canceledPressed, isTrue);
    expect(continuePressed, isTrue);
  });

  testWidgets('Stepper error test', (WidgetTester tester) async {
    await tester.pumpWidget(
      CupertinoApp(
        home: Center(
          child: Container(
            child: CupertinoStepper(
              steps: const <Step>[
                Step(
                  title: Text('A'),
                  state: StepState.error,
                  content: SizedBox(
                    width: 100.0,
                    height: 100.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('!'), findsOneWidget);
  });

  testWidgets('Nested stepper error test', (WidgetTester tester) async {
    FlutterErrorDetails? errorDetails;
    final FlutterExceptionHandler? oldHandler = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      errorDetails = details;
    };
    try {
      await tester.pumpWidget(
        CupertinoApp(
          home: Container(
            child: CupertinoStepper(
              type: StepperType.horizontal,
              steps: <Step>[
                Step(
                  title: const Text('Step 2'),
                  content: CupertinoStepper(
                    type: StepperType.vertical,
                    steps: const <Step>[
                      Step(
                        title: Text('Nested step 1'),
                        content: Text('A'),
                      ),
                      Step(
                        title: Text('Nested step 2'),
                        content: Text('A'),
                      ),
                    ],
                  ),
                ),
                const Step(
                  title: Text('Step 1'),
                  content: Text('A'),
                ),
              ],
            ),
          ),
        ),
      );
    } finally {
      FlutterError.onError = oldHandler;
    }

    expect(errorDetails, isNotNull);
    expect(errorDetails!.stack, isNotNull);
    // Check the ErrorDetails without the stack trace
    final String fullErrorMessage = errorDetails.toString();
    final List<String> lines = fullErrorMessage.split('\n');
    // The lines in the middle of the error message contain the stack trace
    // which will change depending on where the test is run.
    final String errorMessage = lines
        .takeWhile(
          (String line) => line != '',
        )
        .join('\n');
    expect(errorMessage.length, lessThan(fullErrorMessage.length));
    expect(
        errorMessage,
        startsWith(
            '══╡ EXCEPTION CAUGHT BY WIDGETS LIBRARY ╞════════════════════════\n'
            'The following assertion was thrown building\nCupertinoStepper('));
    // The description string of the stepper looks slightly different depending
    // on the platform and is omitted here.
    expect(
        errorMessage,
        endsWith('):\n'
            'Steppers must not be nested.\n'
            'The material specification advises that one should avoid\n'
            'embedding steppers within steppers.\n'
            'https://material.io/archive/guidelines/components/steppers.html#steppers-usage'));
  });

  ///https://github.com/flutter/flutter/issues/16920
  testWidgets('Stepper icons size test', (WidgetTester tester) async {
    await tester.pumpWidget(
      CupertinoApp(
        home: Container(
          child: CupertinoStepper(
            steps: const <Step>[
              Step(
                title: Text('A'),
                state: StepState.editing,
                content: SizedBox(width: 100.0, height: 100.0),
              ),
              Step(
                title: Text('B'),
                state: StepState.complete,
                content: SizedBox(width: 100.0, height: 100.0),
              ),
            ],
          ),
        ),
      ),
    );

    RenderBox renderObject =
        tester.renderObject(find.byIcon(CupertinoIcons.pencil));
    expect(renderObject.size, equals(const Size.square(20.0)));

    renderObject = tester.renderObject(find.byIcon(CupertinoIcons.check_mark));
    expect(renderObject.size, equals(const Size.square(40.0)));
  });

  testWidgets('Stepper physics scroll error test', (WidgetTester tester) async {
    await tester.pumpWidget(
      CupertinoApp(
        home: Container(
          child: ListView(
            children: <Widget>[
              CupertinoStepper(
                steps: const <Step>[
                  Step(title: Text('Step 1'), content: Text('Text 1')),
                  Step(title: Text('Step 2'), content: Text('Text 2')),
                  Step(title: Text('Step 3'), content: Text('Text 3')),
                  Step(title: Text('Step 4'), content: Text('Text 4')),
                  Step(title: Text('Step 5'), content: Text('Text 5')),
                  Step(title: Text('Step 6'), content: Text('Text 6')),
                  Step(title: Text('Step 7'), content: Text('Text 7')),
                  Step(title: Text('Step 8'), content: Text('Text 8')),
                  Step(title: Text('Step 9'), content: Text('Text 9')),
                  Step(title: Text('Step 10'), content: Text('Text 10')),
                ],
              ),
              const Text('Text After Stepper'),
            ],
          ),
        ),
      ),
    );

    await tester.fling(
        find.byType(CupertinoStepper), const Offset(0.0, -100.0), 1000.0);
    await tester.pumpAndSettle();

    expect(find.text('Text After Stepper'), findsNothing);
  });

  testWidgets("Vertical Stepper can't be focused when disabled.",
      (WidgetTester tester) async {
    await tester.pumpWidget(
      CupertinoApp(
        home: Container(
          child: CupertinoStepper(
            currentStep: 0,
            type: StepperType.vertical,
            steps: const <Step>[
              Step(
                title: Text('Step 0'),
                state: StepState.disabled,
                content: Text('Text 0'),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    final FocusNode disabledNode =
        Focus.maybeOf(tester.element(find.text('Step 0')), scopeOk: true)!;
    disabledNode.requestFocus();
    await tester.pump();
    expect(disabledNode.hasPrimaryFocus, isFalse);
  });

  testWidgets("Horizontal Stepper can't be focused when disabled.",
      (WidgetTester tester) async {
    await tester.pumpWidget(
      CupertinoApp(
        home: Container(
          child: CupertinoStepper(
            currentStep: 0,
            type: StepperType.horizontal,
            steps: const <Step>[
              Step(
                title: Text('Step 0'),
                state: StepState.disabled,
                content: Text('Text 0'),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    final FocusNode disabledNode =
        Focus.maybeOf(tester.element(find.text('Step 0')), scopeOk: true)!;
    disabledNode.requestFocus();
    await tester.pump();
    expect(disabledNode.hasPrimaryFocus, isFalse);
  });
}
