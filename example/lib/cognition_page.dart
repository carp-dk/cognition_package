part of 'main.dart';

class CognitionPage extends StatelessWidget {
  final int? age;
  final String? name;
  final String? location;
  final DateTime? date;

  const CognitionPage({
    super.key,
    this.age,
    this.name,
    this.location,
    this.date,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
    body: RPUITask(
      task: cognitionTask,
      onSubmit: (result) {
        resultCallback(result);
      },
    ),
  );

  void resultCallback(RPTaskResult result) async {
    print('FINAL RESULTS');
    print(' age: $age');
    print(' name: $name');
    print(' location: $location');
    print(' date: $date');
    print('RESULTS:');
    result.results.forEach((key, value) {
      value = value as RPActivityResult;
      print(' $key\t: ${value.results}');
    });

    debugPrint(toJsonString(result));
  }
}
