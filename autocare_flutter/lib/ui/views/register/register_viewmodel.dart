import 'package:stacked/stacked.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.bottomsheets.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../app/app.router.dart';
import '../../../models/appuser.dart';
import '../../../services/user_service.dart';
import 'register_view.form.dart';

class RegisterViewModel extends FormViewModel {
  final log = getLogger('RegisterViewModel');
  final _userService = locator<UserService>();

  final FirebaseAuthenticationService _firebaseAuthenticationService =
      locator<FirebaseAuthenticationService>();
  final _navigationService = locator<NavigationService>();
  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();

  // late String _userRole;
  // String get userRole => _userRole;

  void onModelReady() {
    // _userRole = userRole;
  }

  void registerUser() async {
    if (
        // (_userRole == "doctor" &&
        isFormValid && hasEmail && hasUserRole && hasPassword && hasName
        // hasAge &&
        // hasGender
        // ||
        // !hasNameValidationMessage &&
        //     !hasAgeValidationMessage &&
        //     !hasGenderValidationMessage &&
        //     !hasEmailValidationMessage &&
        //     !hasPasswordValidationMessage &&
        //     hasEmail &&
        //     hasPassword &&
        //     hasName &&
        //     hasAge &&
        //     hasGender
        ) {
      setBusy(true);
      log.i("email and pass valid");
      log.i(emailValue!);
      log.i(passwordValue!);
      FirebaseAuthenticationResult result =
          await _firebaseAuthenticationService.createAccountWithEmail(
        email: emailValue!,
        password: passwordValue!,
      );
      if (result.user != null) {
        String? error = await _userService.createUpdateUser(AppUser(
          id: result.user!.uid,
          fullName: nameValue!,
          photoUrl: "",
          email: result.user!.email!,
          userRole: userRoleValue!,
          latitude: 0.0,
          longitude: 0.0,
          regTime: DateTime.now(),
        ));
        if (error == null) {
          await _userService.fetchUser();
          if (userRoleValue! == 'user') {
            _navigationService.pushNamedAndRemoveUntil(Routes.homeView);
          } else {
            _navigationService.pushNamedAndRemoveUntil(Routes.adminView);
          }
        } else {
          log.i("Firebase error");
          _bottomSheetService.showCustomSheet(
            variant: BottomSheetType.notice,
            title: "Upload Error",
            description: error,
          );
        }
      } else {
        log.i("Error: ${result.errorMessage}");
        _bottomSheetService.showCustomSheet(
          variant: BottomSheetType.notice,
          title: "Error",
          description: result.errorMessage ?? "Enter valid credentials",
        );
      }
    }
    setBusy(false);
  }
}
