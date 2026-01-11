// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'ProPitch Booking';

  @override
  String get mainStadium => 'Main Stadium';

  @override
  String get pleaseFillAllFields => 'Please fill in all fields';

  @override
  String get userExists => 'Phone or Username already exists';

  @override
  String get invalidCredentials => 'Invalid phone or password';

  @override
  String errorOccurred(Object error) {
    return 'Error: $error';
  }

  @override
  String get createAccount => 'Create Account';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get joinCommunity => 'Join the stadium community';

  @override
  String get signInPrompt => 'Sign in using your phone';

  @override
  String get username => 'Username';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get phoneHint => 'e.g. 0123456789';

  @override
  String get password => 'Password';

  @override
  String get signUp => 'Sign Up';

  @override
  String get signIn => 'Sign In';

  @override
  String get alreadyHaveAccount => 'Already have an account? Sign In';

  @override
  String get noAccount => 'Don\'t have an account? Sign Up';

  @override
  String get continueAsGuest => 'Continue as Guest';

  @override
  String get loginToBook => 'Please login to book a slot';

  @override
  String get operationsInfo =>
      'Select an available slot to book your match. Operations start at 3:00 PM daily.';

  @override
  String get tapToCancel => 'Tap to cancel';

  @override
  String get available => 'Available';

  @override
  String bookSlot(Object time) {
    return 'Book $time';
  }

  @override
  String get teamName => 'Team Name';

  @override
  String get repeatWeekly => 'Repeat Weekly';

  @override
  String get weeksLabel => 'Weeks: ';

  @override
  String weeksCount(Object weeks) {
    return '$weeks weeks';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get allDatesTaken => 'All selected dates are already taken.';

  @override
  String bookingConfirmed(Object count) {
    return 'Booking confirmed for $count slots.';
  }

  @override
  String skippedDates(Object dates) {
    return '\nSkipped taken dates: $dates';
  }

  @override
  String get cancelBookingTitle => 'Cancel Booking?';

  @override
  String cancelBookingMessage(Object teamName, Object time) {
    return 'Are you sure you want to cancel the booking for $teamName at $time?';
  }

  @override
  String get no => 'No';

  @override
  String get yesCancel => 'Yes, Cancel';

  @override
  String get bookingCancelled => 'Booking cancelled successfully';

  @override
  String get supportCall => 'For support or announcements, call: 01112143221';

  @override
  String get weeklyMatrixReport => 'Weekly Matrix Report';

  @override
  String get dayLabel => 'DAY';

  @override
  String get noPhone => 'No phone';

  @override
  String get deleteBookingTitle => 'Delete Booking?';

  @override
  String deleteBookingMessage(Object teamName, Object time) {
    return 'Remove $teamName at $time?';
  }

  @override
  String get delete => 'Delete';

  @override
  String get pendingStatus => 'Pending';

  @override
  String get bookingRequestSent => 'Booking request sent';

  @override
  String get adminRequests => 'Booking Requests';

  @override
  String get approve => 'Approve';

  @override
  String get reject => 'Reject';

  @override
  String get noPendingRequests => 'No pending requests';

  @override
  String get manageBooking => 'Manage Booking';

  @override
  String get cancelBookingWarning =>
      'Are you sure you want to delete this booking?';

  @override
  String get close => 'Close';

  @override
  String get pendingRequest => 'Pending Request';

  @override
  String get adminRequestReviewMessage =>
      'Review this booking request. You can approve or reject it.';
}
