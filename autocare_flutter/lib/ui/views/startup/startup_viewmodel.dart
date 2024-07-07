import 'package:autocare_flutter/app/app.locator.dart';
import 'package:autocare_flutter/app/app.router.dart';
import 'package:autocare_flutter/models/appuser.dart';
import 'package:autocare_flutter/services/firestore_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../services/database_service.dart';
import '../../../services/user_service.dart';

class StartupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _userService = locator<UserService>();
  final _dbService = locator<DatabaseService>();
  final _firestoreService = locator<FirestoreService>();

  // Place anything here that needs to happen before we get into the application
  Future runStartupLogic() async {
    if (_userService.hasLoggedInUser) {
      AppUser? user = await _userService.fetchUser();
      if (user != null && user.userRole == "user") {
        _firestoreService.listenToServicesForUser(true);
        _dbService.setupNodeListening();
        _navigationService.replaceWithHomeView();
      } else if (user != null) {
        _firestoreService.listenToServicesForUser(false);
        _navigationService.replaceWithAdminView();
      } else {
        _navigationService.replaceWithLoginRegisterView();
      }
    } else {
      await Future.delayed(const Duration(seconds: 1));
      _navigationService.replaceWithLoginRegisterView();
    }
  }
}
