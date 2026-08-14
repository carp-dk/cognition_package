## 1.8.0

- widen `carp_serializable` constraint to allow 3.x

## 1.7.0

- Upgrading gradle major version
- Upgrading agp version
- Upgrading kotlin version
- Updating gradle file structure 

## 1.6.2

* Upgrade to carp_serialization v. 2.0 - note that we now use **camelCase** for JSON.
* Support for deserialization of all `RPResult` classes and sub-classes (polymorphic serialization using the `carp_serializable` package) (issue [#83](https://github.com/cph-cachet/research.package/issues/83))
* Fix of bug in calculating score in Flanker
* Small updates to demo app

## 1.5.5

* Improved the Tapping task: edited the intro image to avoid confusion.
* Improved the Corsi Block task: corrected the French and the Portuguese translations.
* Improved the Trail Making task: added "fast and precise" instruction, and removed a duplicate instruction paragraph in case of Trail A.
* Improved the Reaction Time task: added "place the device on a flat surface" instruction, as recommended by a team of psychologists.
* Fixed the Flanker, the Picture Sequence, the Tapping, and the Trail Making tasks for the case in which the font size of the system is bigger than the standard - the instructions would overflow vertically.
* Improved the Flanker task: added the number of congruent and incongruent cards, and the mean reaction time for each type to the results.
* Changed the button "Guess" to "Submit" after recommendation from a team of psychologists.
* Changed the font color in the "Ready" button of the Picture Sequence task's instructions to force a minimum contrast with the button background.
* Improved the Reaction Time task: changed the colors to blue and yellow for color blind sensitivity.
* Improved Picture Sequence Memory task: storing the images locally in the app, so the task is possible to run while offline.
* Fixed the Tapping, Flanker, Picture Sequence Memory, Reaction Time, and Trail Making tasks not auto finishing when the showResults was false (issue [#24] <https://github.com/cph-cachet/cognition_package/issues/24>).

## 1.5.4

* Small updates to translations
* Fix of cumulative results in Flanker task (issue [#158](https://github.com/cph-cachet/carp-studies-app/issues/158))

## 1.5.2

* PR #18 (translations to Portuguese)

## 1.5.1

* Added translation support for English (`en`), Danish (`da`), French (`fr`), and Portuguese (`pt`).
* Fix of misc. null check bugs
* Upgrade to research_package 1.3.2
* Fix of misc. issues.
* Update to documentation and example app.

## 1.4.1

* Upgrade to `carp_serializable: ^1.1.0` and `research_package: ^1.3.0`. Note that this entails that all polymorphic json serialization uses the type key `__type`. Hence, the json format for all the domain classes is NOT compatible with earlier versions.
* Added the `CognitionPackage.ensureInitialized()` static method to be compliant with the other CARP packages.
* Small updates to README

## 1.3.2

* Removal of all `late` Timer objects.

## 1.3.1

* Implementation of `dispose()` methods on all tests to support cancellation of a test.

## 1.3.0

* Upgrade to Research Package v. 1.1.0
* Added support for JSON serialization of Steps and Results objects
* Upgraded to Dart 2.18 and Fluter 3
* Refactoring to comply to [official Dart recommended lint rules](https://pub.dev/packages/flutter_lints)
* Update and clean up in API documentation.

## 1.2.1

* Small updates to documentation
* Code cleanup based on linter
* Removal of old serialization code (which did not work - will be implemented in a later version)

## 1.2.0

* Upgraded to Research Package 0.9.3 incl. `carp_serializable`
* Major cleanup in demo app.

## 1.1.0

* Upgraded to Flutter 3.0.0 and fixed related issues.
* Upgraded to reorderables: ^0.5.0 and fixed a bug with missing ScrollController

## 1.0.5

* Bugfixes
* Added dark mode support

## 1.0.4

* Copyright notice in the README file

## 1.0.3

* Fixed visual bug in stroop effect test
* Fixed bug in corsi bloc tapping test
* Updated example app

## 1.0.2

* Updated README.md
* Updated pubspec.yaml

## 1.0.1

* Updated README.md

## 1.0.0

* Initial release
* Supports 14 cognitive tests
