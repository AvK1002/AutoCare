import 'package:flutter_test/flutter_test.dart';
import 'package:autocare_flutter/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('AdminVehicleServiceViewModel Tests -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
