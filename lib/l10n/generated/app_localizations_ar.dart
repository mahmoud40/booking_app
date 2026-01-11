// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'حجز الملاعب';

  @override
  String get mainStadium => 'ملعب الفؤادية';

  @override
  String get pleaseFillAllFields => 'يرجى ملء جميع الحقول';

  @override
  String get userExists => 'رقم الهاتف أو اسم المستخدم موجود بالفعل';

  @override
  String get invalidCredentials => 'رقم الهاتف أو كلمة المرور غير صحيحة';

  @override
  String errorOccurred(Object error) {
    return 'خطأ: $error';
  }

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get welcomeBack => 'أهلاً بك مجدداً';

  @override
  String get joinCommunity => 'انضم إلى مجتمع الملعب';

  @override
  String get signInPrompt => 'سجل الدخول باستخدام رقم هاتفك';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get phoneHint => 'مثال: 0123456789';

  @override
  String get password => 'كلمة المرور';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟ تسجيل الدخول';

  @override
  String get noAccount => 'ليس لديك حساب؟ إنشاء حساب';

  @override
  String get continueAsGuest => 'الاستمرار كضيف';

  @override
  String get loginToBook => 'يرجى تسجيل الدخول لحجز موعد';

  @override
  String get operationsInfo =>
      'اختر موعداً متاحاً لحجز مباراتك. يبدأ التشغيل يومياً من الساعة 3:00 مساءً.';

  @override
  String get tapToCancel => 'اضغط للإلغاء';

  @override
  String get available => 'متاح';

  @override
  String bookSlot(Object time) {
    return 'حجز $time';
  }

  @override
  String get teamName => 'اسم الفريق';

  @override
  String get repeatWeekly => 'تكرار أسبوعي';

  @override
  String get weeksLabel => 'عدد الأسابيع: ';

  @override
  String weeksCount(Object weeks) {
    return '$weeks أسابيع';
  }

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';

  @override
  String get allDatesTaken => 'جميع الأيام المختارة محجوزة بالفعل.';

  @override
  String bookingConfirmed(Object count) {
    return 'تم تأكيد الحجز لـ $count مواعيد.';
  }

  @override
  String skippedDates(Object dates) {
    return '\nتم تخطي الأيام المحجوزة: $dates';
  }

  @override
  String get cancelBookingTitle => 'إلغاء الحجز؟';

  @override
  String cancelBookingMessage(Object teamName, Object time) {
    return 'هل أنت متأكد من إلغاء حجز فريق $teamName في $time؟';
  }

  @override
  String get no => 'لا';

  @override
  String get yesCancel => 'نعم، إلغاء';

  @override
  String get bookingCancelled => 'تم إلغاء الحجز بنجاح';

  @override
  String get supportCall => 'للدعم أو الاستفسارات، اتصل على: 01023783968';

  @override
  String get weeklyMatrixReport => 'تقرير المصفوفة الأسبوعي';

  @override
  String get dayLabel => 'اليوم';

  @override
  String get noPhone => 'لا يوجد هاتف';

  @override
  String get deleteBookingTitle => 'حذف الحجز؟';

  @override
  String deleteBookingMessage(Object teamName, Object time) {
    return 'هل تريد حذف حجز $teamName في $time؟';
  }

  @override
  String get delete => 'حذف';

  @override
  String get pendingStatus => 'قيد الانتظار';

  @override
  String get bookingRequestSent => 'تم إرسال طلب الحجز';

  @override
  String get adminRequests => 'طلبات الحجز';

  @override
  String get approve => 'قبول';

  @override
  String get reject => 'رفض';

  @override
  String get noPendingRequests => 'لا توجد طلبات معلقة';

  @override
  String get manageBooking => 'إدارة الحجز';

  @override
  String get cancelBookingWarning => 'هل أنت متأكد من حذف هذا الحجز؟';

  @override
  String get close => 'إغلاق';

  @override
  String get pendingRequest => 'طلب معلق';

  @override
  String get adminRequestReviewMessage =>
      'راجع طلب الحجز هذا. يمكنك قبوله أو رفضه.';
}

/// The translations for Arabic, as used in Egypt (`ar_EG`).
class AppLocalizationsArEg extends AppLocalizationsAr {
  AppLocalizationsArEg() : super('ar_EG');

  @override
  String get appTitle => 'حجز الملاعب';

  @override
  String get mainStadium => 'الملعب الرئيسي';

  @override
  String get pleaseFillAllFields => 'يرجى ملء جميع الحقول';

  @override
  String get userExists => 'رقم الهاتف أو اسم المستخدم موجود بالفعل';

  @override
  String get invalidCredentials => 'رقم الهاتف أو كلمة المرور غير صحيحة';

  @override
  String errorOccurred(Object error) {
    return 'خطأ: $error';
  }

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get welcomeBack => 'أهلاً بك مجدداً';

  @override
  String get joinCommunity => 'انضم إلى مجتمع الملعب';

  @override
  String get signInPrompt => 'سجل الدخول باستخدام رقم هاتفك';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get phoneHint => 'مثال: 01012345678';

  @override
  String get password => 'كلمة المرور';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟ تسجيل الدخول';

  @override
  String get noAccount => 'ليس لديك حساب؟ إنشاء حساب';

  @override
  String get continueAsGuest => 'الاستمرار كضيف';

  @override
  String get loginToBook => 'يرجى تسجيل الدخول لحجز موعد';

  @override
  String get operationsInfo =>
      'اختر موعداً متاحاً لحجز مباراتك. يبدأ التشغيل يومياً من الساعة 3:00 مساءً.';

  @override
  String get tapToCancel => 'اضغط للإلغاء';

  @override
  String get available => 'متاح';

  @override
  String bookSlot(Object time) {
    return 'حجز $time';
  }

  @override
  String get teamName => 'اسم الفريق';

  @override
  String get repeatWeekly => 'تكرار أسبوعي';

  @override
  String get weeksLabel => 'عدد الأسابيع: ';

  @override
  String weeksCount(Object weeks) {
    return '$weeks أسابيع';
  }

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';

  @override
  String get allDatesTaken => 'جميع الأيام المختارة محجوزة بالفعل.';

  @override
  String bookingConfirmed(Object count) {
    return 'تم تأكيد الحجز لـ $count مواعيد.';
  }

  @override
  String skippedDates(Object dates) {
    return '\nتم تخطي الأيام المحجوزة: $dates';
  }

  @override
  String get cancelBookingTitle => 'إلغاء الحجز؟';

  @override
  String cancelBookingMessage(Object teamName, Object time) {
    return 'هل أنت متأكد من إلغاء حجز فريق $teamName في $time؟';
  }

  @override
  String get no => 'لا';

  @override
  String get yesCancel => 'نعم، إلغاء';

  @override
  String get bookingCancelled => 'تم إلغاء الحجز بنجاح';

  @override
  String get supportCall => 'للدعم أو الاستفسارات، اتصل على: 01023783968';

  @override
  String get weeklyMatrixReport => 'تقرير المصفوفة الأسبوعي';

  @override
  String get dayLabel => 'اليوم';

  @override
  String get noPhone => 'لا يوجد هاتف';

  @override
  String get deleteBookingTitle => 'حذف الحجز؟';

  @override
  String deleteBookingMessage(Object teamName, Object time) {
    return 'هل تريد حذف حجز $teamName في $time؟';
  }

  @override
  String get delete => 'حذف';

  @override
  String get pendingStatus => 'قيد الانتظار';

  @override
  String get bookingRequestSent => 'تم إرسال طلب الحجز';

  @override
  String get adminRequests => 'طلبات الحجز';

  @override
  String get approve => 'قبول';

  @override
  String get reject => 'رفض';

  @override
  String get noPendingRequests => 'لا توجد طلبات معلقة';

  @override
  String get manageBooking => 'إدارة الحجز';

  @override
  String get cancelBookingWarning => 'هل أنت متأكد من حذف هذا الحجز؟';

  @override
  String get close => 'إغلاق';

  @override
  String get pendingRequest => 'طلب معلق';

  @override
  String get adminRequestReviewMessage =>
      'راجع طلب الحجز هذا. يمكنك قبوله أو رفضه.';
}
