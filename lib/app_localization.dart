import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final ValueNotifier<Locale> appLocale = ValueNotifier(const Locale('ar'));

const Map<String, String> _arabicTranslations = {
  'Home': 'الرئيسية',
  'Plan': 'الخطة',
  'Log': 'السجل',
  'Progress': 'التقدم',
  'Add Food': 'إضافة طعام',
  'Settings': 'الإعدادات',
  'Back': 'رجوع',
  'Good morning, Mahmoud 👋': 'صباح الخير، محمود 👋',
  'Sunday, 23 August': 'الأحد، 23 أغسطس',
  "Today's Progress": 'تقدم اليوم',
  'Details': 'التفاصيل',
  'View all nutrients': 'عرض جميع العناصر الغذائية',
  'Water': 'الماء',
  'Next Meal': 'الوجبة التالية',
  "Today's Plan": 'خطة اليوم',
  'Edit Plan': 'تعديل الخطة',
  'Breakfast': 'الفطور',
  'Lunch': 'الغداء',
  'Snack': 'وجبة خفيفة',
  'Dinner': 'العشاء',
  'Plan your meals. Stay on track.': 'خطط لوجباتك وحافظ على تقدمك.',
  'Log Food': 'سجل الطعام',
  'Track what you eat': 'تابع ما تأكله',
  'Search for a food, brand or meal': 'ابحث عن طعام أو علامة أو وجبة',
  'Logged Today': 'المسجل اليوم',
  'items': 'عناصر',
  'Suggestions for you': 'اقتراحات لك',
  'Add More Food': 'إضافة المزيد من الطعام',
  'Track your journey. See how far you have come.':
      'تابع رحلتك وشاهد مدى تقدمك.',
  'Overview': 'نظرة عامة',
  'Nutrition': 'التغذية',
  'Trends': 'الاتجاهات',
  '7 Days': '7 أيام',
  '30 Days': '30 يوما',
  '3 Months': '3 أشهر',
  '6 Months': '6 أشهر',
  '1 Year': 'سنة',
  'Search and add food to your log.': 'ابحث عن الطعام وأضفه إلى سجلك.',
  'Scan': 'مسح',
  'Quick Add': 'إضافة سريعة',
  'My Foods': 'أطعميتي',
  'Brands': 'العلامات التجارية',
  'Recent Searches': 'عمليات البحث الأخيرة',
  'Clear all': 'مسح الكل',
  'Your Favorites': 'المفضلة لديك',
  'See all': 'عرض الكل',
  'Search Results': 'نتائج البحث',
  'Serving Size': 'حجم الحصة',
  'Number of Servings': 'عدد الحصص',
  'Add to Lunch': 'إضافة إلى الغداء',
  'Manage your account and preferences.': 'أدر حسابك وتفضيلاتك.',
  'Mahmoud': 'محمود',
  'Go Premium': 'الترقية إلى Premium',
  'View Plan': 'عرض الخطة',
  'Goals & Profile': 'الأهداف والملف الشخصي',
  'Goals': 'الأهداف',
  'Profile Information': 'معلومات الملف الشخصي',
  'Body Stats': 'بيانات الجسم',
  'Activity Level': 'مستوى النشاط',
  'Preferences': 'التفضيلات',
  'Notifications': 'الإشعارات',
  'Units': 'الوحدات',
  'Appearance': 'المظهر',
  'Language': 'اللغة',
  'Account & Data': 'الحساب والبيانات',
  'Privacy': 'الخصوصية',
  'Backup & Restore': 'النسخ الاحتياطي والاستعادة',
  'Delete Account': 'حذف الحساب',
  'Support': 'الدعم',
  'Help Center': 'مركز المساعدة',
  'Contact Us': 'تواصل معنا',
  'About': 'حول التطبيق',
  'Calorie, macros, water and more': 'السعرات والعناصر الغذائية والماء والمزيد',
  'Update your personal details': 'حدّث بياناتك الشخصية',
  'Weight, height, activity level & more': 'الوزن والطول ومستوى النشاط والمزيد',
  'Moderately active': 'نشاط متوسط',
  'Customize your notifications': 'خصّص إشعاراتك',
  'Metric (kg, cm, kcal)': 'متري (كجم، سم، Kcal)',
  'Light mode': 'الوضع الفاتح',
  'Manage your privacy settings': 'أدر إعدادات الخصوصية',
  'Backup your data to the cloud': 'انسخ بياناتك احتياطيا إلى السحابة',
  'Permanently delete your account and data': 'احذف حسابك وبياناتك نهائيا',
  'FAQs and support articles': 'الأسئلة الشائعة ومقالات الدعم',
  'We are here to help': 'نحن هنا لمساعدتك',
  'App version 2.3.0': 'إصدار التطبيق 2.3.0',
  'English': 'الإنجليزية',
  'Arabic': 'العربية',
  'Premium': 'Premium',
  'Ingredients': 'المكونات',
  'Nutrition Details': 'تفاصيل التغذية',
  'Calories': 'السعرات الحرارية',
  'Protein': 'البروتين',
  'Carbs': 'الكربوهيدرات',
  'Carbohydrates': 'الكربوهيدرات',
  'Fats': 'الدهون',
  'Daily Insight': 'نصيحة اليوم',
  'History': 'السجل السابق',
  'Calendar': 'التقويم',
  'Filters': 'الفلاتر',
  'More options': 'خيارات إضافية',
  'Edit': 'تعديل',
  'Current': 'الحالي',
  'Change': 'التغيير',
  'Insights': 'الرؤى',
  'Remaining': 'المتبقي',
  "You're on track! 🎯": 'على المسار الصحيح! 🎯',
  'Log water': 'تسجيل الماء',
  'You have': 'لديك',
  'kcal remaining': 'Kcal متبقٍ',
  'Logged': 'مسجل',
  'Planned': 'مخطط',
  'Skipped': 'متخطى',
  'Meal Plan': 'خطة الوجبات',
  'Food List': 'قائمة الطعام',
  'Daily Targets': 'الأهداف اليومية',
  'Meals': 'الوجبات',
  '4 meals  •  1 snack': '4 وجبات • وجبة خفيفة',
  'Add Meal / Snack': 'إضافة وجبة / وجبة خفيفة',
  'Nutrition Summary': 'ملخص التغذية',
  'Try adding a high-protein snack.': 'جرّب إضافة وجبة خفيفة غنية بالبروتين.',
  'Target': 'الهدف',
  'Total Consumed': 'الإجمالي المستهلك',
  'Daily Average': 'المتوسط اليومي',
  'Goal Average': 'متوسط الهدف',
  'Other': 'أخرى',
  'Weight  |  Last 30 days': 'الوزن | آخر 30 يوما',
  'Great job! You were consistent with your goals this week.':
      'عمل رائع! التزمت بأهدافك هذا الأسبوع.',
  'Saturated Fat': 'الدهون المشبعة',
  'Cholesterol': 'الكوليسترول',
  'Sodium': 'الصوديوم',
  'Carbohydrate': 'الكربوهيدرات',
  'Dietary Fiber': 'الألياف الغذائية',
  'Total Sugars': 'إجمالي السكريات',
  'Duplicate': 'تكرار',
  'Swap': 'تبديل',
  'Favorite': 'مفضلة',
  'What would you like to do?': 'ماذا تريد أن تفعل؟',
  'Portion Size': 'حجم الحصة',
  'grams': 'جرام',
  'servings': 'حصص',
  '1 serving = 300 g': 'الحصة الواحدة = 300 جرام',
  '% Daily Value*': '% من القيمة اليومية*',
  '* Percent Daily Values are based on a 2,000 calorie diet.':
      '* النسب اليومية مبنية على نظام غذائي يحتوي على 2000 Kcal.',
  '2,340 kcal more than last week': '2340 Kcal أكثر من الأسبوع الماضي',
  'Protein intake is improving': 'استهلاك البروتين يتحسن',
  'Goal hit 5 of 7 days': 'تحقق الهدف خلال 5 من 7 أيام',
  'of 1,800 kcal': 'من أصل 1800 Kcal',
  'remaining': 'متبقٍ',
  'Results for': 'نتائج',
  'Chicken Breast (Grilled)': 'صدر دجاج (مشوي)',
  'Brown Rice (Cooked)': 'أرز بني (مطبوخ)',
  'Greek Yogurt 0%': 'زبادي يوناني 0%',
  'Greek Yogurt': 'زبادي يوناني',
  '1 medium': '1 متوسطة',
  'Greek yogurt': 'زبادي يوناني',
  'Brown rice': 'أرز بني',
  'Chicken breast': 'صدر دجاج',
  'Banana': 'موز',
  'Almonds': 'لوز',
  'Grilled Chicken': 'دجاج مشوي',
  'White Rice': 'أرز أبيض',
  'Mixed Salad': 'سلطة مشكلة',
  'Olive Oil': 'زيت الزيتون',
  'Egg': 'بيض',
  'Bread': 'خبز',
  'Chicken': 'دجاج',
  'Rice': 'أرز',
  'Salad': 'سلطة',
  'Oil': 'زيت',
  'Apple': 'تفاح',
  'Tuna': 'تونة',
  'Generic': 'عام',
  'Fage': 'فاج',
  'Blue Diamond': 'بلو دايموند',
  'Total Fat': 'إجمالي الدهون',
  'Nutrition Distribution': 'توزيع التغذية',
  'Macronutrients': 'العناصر الغذائية الكبرى',
  'You need ': 'تحتاج إلى ',
  '~45g more protein': 'حوالي 45 جراما إضافية من البروتين',
  'to reach your daily goal.': 'لتحقيق هدفك اليومي.',
  'See suggestions': 'عرض الاقتراحات',
  'Lunch  •  02:00 PM': 'الغداء • 02:00 مساءً',
  'Grilled Chicken\nwith Rice & Salad': 'دجاج مشوي\nمع أرز وسلطة',
  '4 items': '4 عناصر',
  'Barcode': 'باركود',
  'Scan Meal': 'مسح الوجبة',
  'Recent': 'الأخيرة',
  'You have ': 'لديك ',
  '2:00 PM  •  620 kcal  •  52g protein':
      '02:00 مساءً • 620 Kcal • 52 جرام بروتين',
  'Egg 100g': 'بيض 100 جرام',
  'Bread 60g': 'خبز 60 جرام',
  'Chicken 200g': 'دجاج 200 جرام',
  'Rice 150g': 'أرز 150 جرام',
  'Salad 100g': 'سلطة 100 جرام',
  'Apple 150g': 'تفاح 150 جرام',
  'Almonds 20g': 'لوز 20 جرام',
  'Tuna 120g': 'تونة 120 جرام',
  'Bread 80g': 'خبز 80 جرام',
  '420 kcal': '420 Kcal',
  '620 kcal': '620 Kcal',
  '200 kcal': '200 Kcal',
  '450 kcal': '450 Kcal',
  '28g protein': '28 جرام بروتين',
  '52g protein': '52 جرام بروتين',
  '5g protein': '5 جرام بروتين',
  '40g protein': '40 جرام بروتين',
  '52g protein  |  6g fat  |  0g carbs':
      '52 جرام بروتين | 6 جرام دهون | 0 جرام كربوهيدرات',
  '4g protein  |  0.4g fat  |  42g carbs':
      '4 جرام بروتين | 0.4 جرام دهون | 42 جرام كربوهيدرات',
  '2g protein  |  4g fat  |  6g carbs':
      '2 جرام بروتين | 4 جرام دهون | 6 جرام كربوهيدرات',
  '0g protein  |  10g fat  |  0g carbs':
      '0 جرام بروتين | 10 جرام دهون | 0 جرام كربوهيدرات',
  'Mon': 'الإثنين',
  'Tue': 'الثلاثاء',
  'Wed': 'الأربعاء',
  'Thu': 'الخميس',
  'Fri': 'الجمعة',
  'Sat': 'السبت',
  'Sun': 'الأحد',
};

class AppLocalization {
  static bool isArabic(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar';

  static String text(BuildContext context, String english, String arabic) {
    return isArabic(context) ? arabic : english;
  }

  static TextDirection direction(BuildContext context) =>
      isArabic(context) ? TextDirection.rtl : TextDirection.ltr;
}

class AppLanguageScope extends StatelessWidget {
  final Widget child;

  const AppLanguageScope({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: appLocale,
      builder: (context, locale, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Nutrition',
          locale: locale,
          supportedLocales: const [Locale('en'), Locale('ar')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFFF7F8FC),
            fontFamily: 'Arial',
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF5B35F5),
              brightness: Brightness.light,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFFF7F8FC),
              foregroundColor: Color(0xFF17203A),
              elevation: 0,
              scrolledUnderElevation: 0,
              centerTitle: true,
            ),
            inputDecorationTheme: const InputDecorationTheme(
              filled: true,
              fillColor: Color(0xFFF1F2F6),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(14)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(14)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF5B35F5), width: 1.2),
                borderRadius: BorderRadius.all(Radius.circular(14)),
              ),
            ),
          ),
          builder: (context, child) {
            return Directionality(
              textDirection: locale.languageCode == 'ar'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: child!,
            );
          },
          home: child,
        );
      },
    );
  }
}

String appText(BuildContext context, String english, String arabic) =>
    AppLocalization.text(context, english, arabic);

String translateText(BuildContext context, String english) {
  return AppLocalization.isArabic(context)
      ? _arabicTranslations[english] ?? english
      : english;
}
