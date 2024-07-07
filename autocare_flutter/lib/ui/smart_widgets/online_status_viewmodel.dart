import 'dart:async';

import 'package:autocare_flutter/services/database_service.dart';
import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../models/reading.dart';

class HomeViewModel extends BaseViewModel {
  final log = getLogger('StatusWidget');

  final _dbService = locator<DatabaseService>();

  DeviceReading? get node => _dbService.node;

  bool _isOnline = false;

  bool get isOnline => _isOnline;

  bool isOnlineCheck(DateTime? time) {
    if (time == null) return false;
    final DateTime now = DateTime.now();
    final difference = now.difference(time).inSeconds;
    // log.i("Status ${difference.abs()}");
    return difference.abs() <= 1;
  }

  late Timer timer;

  void setTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        _isOnline = isOnlineCheck(node?.lastSeen);
        notifyListeners();
      },
    );
  }
}
