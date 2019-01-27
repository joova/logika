@TestOn('browser')
import 'package:angular_test/angular_test.dart';
import 'package:test/test.dart';
import 'package:logika/app_component.dart';
import 'package:logika/app_component.template.dart' as ng;

void main() {
  final testBed =
      NgTestBed.forComponent<AppComponent>(ng.AppComponentNgFactory);
  NgTestFixture<AppComponent> fixture;

  setUp(() async {
    fixture = await testBed.create();
  });

  tearDown(disposeAnyRunningTest);

  test('Test app component', () async {
    expect(fixture.text, contains('Logika'));
    // await fixture.update((c) => c.overlay = false);
    // expect(fixture.text, 'Hello Universe');
  });

  // Testing info: https://webdev.dartlang.org/angular/guide/testing
}
