import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ru.dart';
import 'app_localizations_uz.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('uz'),
    Locale('ru')
  ];

  /// No description provided for @app_title.
  ///
  /// In uz, this message translates to:
  /// **'Ombor Tizimi'**
  String get app_title;

  /// No description provided for @btn_save.
  ///
  /// In uz, this message translates to:
  /// **'Saqlash'**
  String get btn_save;

  /// No description provided for @btn_cancel.
  ///
  /// In uz, this message translates to:
  /// **'Bekor qilish'**
  String get btn_cancel;

  /// No description provided for @btn_delete.
  ///
  /// In uz, this message translates to:
  /// **'O\'chirish'**
  String get btn_delete;

  /// No description provided for @btn_confirm.
  ///
  /// In uz, this message translates to:
  /// **'Tasdiqlash'**
  String get btn_confirm;

  /// No description provided for @btn_back.
  ///
  /// In uz, this message translates to:
  /// **'Orqaga'**
  String get btn_back;

  /// No description provided for @btn_retry.
  ///
  /// In uz, this message translates to:
  /// **'Qayta urinish'**
  String get btn_retry;

  /// No description provided for @lbl_loading.
  ///
  /// In uz, this message translates to:
  /// **'Yuklanmoqda...'**
  String get lbl_loading;

  /// No description provided for @lbl_error_generic.
  ///
  /// In uz, this message translates to:
  /// **'Xatolik yuz berdi'**
  String get lbl_error_generic;

  /// No description provided for @lbl_empty_list.
  ///
  /// In uz, this message translates to:
  /// **'Ma\'lumot topilmadi'**
  String get lbl_empty_list;

  /// No description provided for @msg_success_saved.
  ///
  /// In uz, this message translates to:
  /// **'Muvaffaqiyatli saqlandi'**
  String get msg_success_saved;

  /// No description provided for @msg_success_deleted.
  ///
  /// In uz, this message translates to:
  /// **'O\'chirildi'**
  String get msg_success_deleted;

  /// No description provided for @auth_login_title.
  ///
  /// In uz, this message translates to:
  /// **'Tizimga kirish'**
  String get auth_login_title;

  /// No description provided for @auth_login_subtitle.
  ///
  /// In uz, this message translates to:
  /// **'Ombor boshqaruv tizimi'**
  String get auth_login_subtitle;

  /// No description provided for @auth_username_label.
  ///
  /// In uz, this message translates to:
  /// **'Foydalanuvchi nomi'**
  String get auth_username_label;

  /// No description provided for @auth_username_hint.
  ///
  /// In uz, this message translates to:
  /// **'username kiriting'**
  String get auth_username_hint;

  /// No description provided for @auth_password_label.
  ///
  /// In uz, this message translates to:
  /// **'Parol'**
  String get auth_password_label;

  /// No description provided for @auth_password_hint.
  ///
  /// In uz, this message translates to:
  /// **'parol kiriting'**
  String get auth_password_hint;

  /// No description provided for @auth_btn_login.
  ///
  /// In uz, this message translates to:
  /// **'Kirish'**
  String get auth_btn_login;

  /// No description provided for @auth_error_invalid_credentials.
  ///
  /// In uz, this message translates to:
  /// **'Login yoki parol noto\'g\'ri'**
  String get auth_error_invalid_credentials;

  /// No description provided for @auth_error_field_required.
  ///
  /// In uz, this message translates to:
  /// **'Bu maydon majburiy'**
  String get auth_error_field_required;

  /// No description provided for @auth_demo_credentials_title.
  ///
  /// In uz, this message translates to:
  /// **'DEMO KIRISH MA\'LUMOTLARI'**
  String get auth_demo_credentials_title;

  /// No description provided for @auth_role_admin.
  ///
  /// In uz, this message translates to:
  /// **'Admin'**
  String get auth_role_admin;

  /// No description provided for @auth_role_manager.
  ///
  /// In uz, this message translates to:
  /// **'Menejer'**
  String get auth_role_manager;

  /// No description provided for @auth_role_worker.
  ///
  /// In uz, this message translates to:
  /// **'Xodim'**
  String get auth_role_worker;

  /// No description provided for @dashboard_greeting.
  ///
  /// In uz, this message translates to:
  /// **'Xush kelibsiz, {name}!'**
  String dashboard_greeting(String name);

  /// No description provided for @dashboard_subtitle.
  ///
  /// In uz, this message translates to:
  /// **'Bugun nima qilamiz?'**
  String get dashboard_subtitle;

  /// No description provided for @dashboard_card_products.
  ///
  /// In uz, this message translates to:
  /// **'Mahsulotlar'**
  String get dashboard_card_products;

  /// No description provided for @dashboard_card_add_product.
  ///
  /// In uz, this message translates to:
  /// **'Mahsulot qo\'shish'**
  String get dashboard_card_add_product;

  /// No description provided for @dashboard_card_stock_in.
  ///
  /// In uz, this message translates to:
  /// **'Kirim'**
  String get dashboard_card_stock_in;

  /// No description provided for @dashboard_card_stock_out.
  ///
  /// In uz, this message translates to:
  /// **'Chiqim'**
  String get dashboard_card_stock_out;

  /// No description provided for @dashboard_card_inventory.
  ///
  /// In uz, this message translates to:
  /// **'Inventarizatsiya'**
  String get dashboard_card_inventory;

  /// No description provided for @dashboard_card_history.
  ///
  /// In uz, this message translates to:
  /// **'Tarix'**
  String get dashboard_card_history;

  /// No description provided for @dashboard_card_settings.
  ///
  /// In uz, this message translates to:
  /// **'Sozlamalar'**
  String get dashboard_card_settings;

  /// No description provided for @dashboard_card_assistant.
  ///
  /// In uz, this message translates to:
  /// **'AI Yordamchi'**
  String get dashboard_card_assistant;

  /// No description provided for @analytics_section_title.
  ///
  /// In uz, this message translates to:
  /// **'Ombor holati'**
  String get analytics_section_title;

  /// No description provided for @analytics_health_title.
  ///
  /// In uz, this message translates to:
  /// **'Ombor sogʻligʻi'**
  String get analytics_health_title;

  /// No description provided for @analytics_health_ok.
  ///
  /// In uz, this message translates to:
  /// **'Yetarli'**
  String get analytics_health_ok;

  /// No description provided for @analytics_health_low.
  ///
  /// In uz, this message translates to:
  /// **'Kam'**
  String get analytics_health_low;

  /// No description provided for @analytics_health_critical.
  ///
  /// In uz, this message translates to:
  /// **'Tugagan'**
  String get analytics_health_critical;

  /// No description provided for @analytics_action_title.
  ///
  /// In uz, this message translates to:
  /// **'Diqqat talab qiladi'**
  String get analytics_action_title;

  /// No description provided for @analytics_action_count.
  ///
  /// In uz, this message translates to:
  /// **'{count} ta mahsulot toʻldirilishi kerak'**
  String analytics_action_count(int count);

  /// No description provided for @analytics_action_view.
  ///
  /// In uz, this message translates to:
  /// **'Roʻyxatni koʻrish'**
  String get analytics_action_view;

  /// No description provided for @analytics_action_clear.
  ///
  /// In uz, this message translates to:
  /// **'Hammasi joyida — kritik tovarlar yoʻq'**
  String get analytics_action_clear;

  /// No description provided for @analytics_flow_title.
  ///
  /// In uz, this message translates to:
  /// **'Bugungi oborot'**
  String get analytics_flow_title;

  /// No description provided for @analytics_flow_in.
  ///
  /// In uz, this message translates to:
  /// **'Kirim'**
  String get analytics_flow_in;

  /// No description provided for @analytics_flow_out.
  ///
  /// In uz, this message translates to:
  /// **'Chiqim'**
  String get analytics_flow_out;

  /// No description provided for @analytics_flow_net.
  ///
  /// In uz, this message translates to:
  /// **'Net'**
  String get analytics_flow_net;

  /// No description provided for @analytics_flow_fallback.
  ///
  /// In uz, this message translates to:
  /// **'Soʻnggi faol kun: {date}'**
  String analytics_flow_fallback(String date);

  /// No description provided for @analytics_value_title.
  ///
  /// In uz, this message translates to:
  /// **'Ombor qiymati'**
  String get analytics_value_title;

  /// No description provided for @analytics_value_subtitle.
  ///
  /// In uz, this message translates to:
  /// **'xarid narxida'**
  String get analytics_value_subtitle;

  /// No description provided for @analytics_reorder_title.
  ///
  /// In uz, this message translates to:
  /// **'Birinchi navbatda toʻldirish'**
  String get analytics_reorder_title;

  /// No description provided for @analytics_reorder_empty.
  ///
  /// In uz, this message translates to:
  /// **'Toʻldirish kerak boʻlgan tovar yoʻq'**
  String get analytics_reorder_empty;

  /// No description provided for @analytics_slow_movers_chip.
  ///
  /// In uz, this message translates to:
  /// **'{count} ta tovar 30 kundan beri harakatsiz'**
  String analytics_slow_movers_chip(int count);

  /// No description provided for @welcome_empty_title.
  ///
  /// In uz, this message translates to:
  /// **'Ombor boʻsh'**
  String get welcome_empty_title;

  /// No description provided for @welcome_empty_subtitle.
  ///
  /// In uz, this message translates to:
  /// **'Birinchi mahsulotni qoʻshing va analitika faol boʻladi.'**
  String get welcome_empty_subtitle;

  /// No description provided for @welcome_empty_cta.
  ///
  /// In uz, this message translates to:
  /// **'Birinchi mahsulotni qoʻshish'**
  String get welcome_empty_cta;

  /// No description provided for @stock_no_products.
  ///
  /// In uz, this message translates to:
  /// **'Hali mahsulot yoʻq. Avval mahsulot qoʻshing.'**
  String get stock_no_products;

  /// No description provided for @stock_no_products_cta.
  ///
  /// In uz, this message translates to:
  /// **'Mahsulot qoʻshish'**
  String get stock_no_products_cta;

  /// No description provided for @assistant_title.
  ///
  /// In uz, this message translates to:
  /// **'Ombor yordamchisi'**
  String get assistant_title;

  /// No description provided for @assistant_clear.
  ///
  /// In uz, this message translates to:
  /// **'Suhbatni tozalash'**
  String get assistant_clear;

  /// No description provided for @assistant_input_hint.
  ///
  /// In uz, this message translates to:
  /// **'Savolingizni yozing...'**
  String get assistant_input_hint;

  /// No description provided for @assistant_welcome_title.
  ///
  /// In uz, this message translates to:
  /// **'Sizga qanday yordam berishim mumkin?'**
  String get assistant_welcome_title;

  /// No description provided for @assistant_welcome_subtitle.
  ///
  /// In uz, this message translates to:
  /// **'Ombor holati, mahsulotlar va biznes haqida savol bering. Maslahatlar berish uchun real maʼlumotlardan foydalanaman.'**
  String get assistant_welcome_subtitle;

  /// No description provided for @assistant_suggestion_low_stock.
  ///
  /// In uz, this message translates to:
  /// **'Qaysi mahsulotlar tugayapti?'**
  String get assistant_suggestion_low_stock;

  /// No description provided for @assistant_suggestion_recommendations.
  ///
  /// In uz, this message translates to:
  /// **'Qanday tavsiyalaringiz bor?'**
  String get assistant_suggestion_recommendations;

  /// No description provided for @assistant_suggestion_top_categories.
  ///
  /// In uz, this message translates to:
  /// **'Eng katta kategoriyalarim qaysilar?'**
  String get assistant_suggestion_top_categories;

  /// No description provided for @dashboard_stat_total.
  ///
  /// In uz, this message translates to:
  /// **'Jami'**
  String get dashboard_stat_total;

  /// No description provided for @dashboard_stat_low.
  ///
  /// In uz, this message translates to:
  /// **'Kam'**
  String get dashboard_stat_low;

  /// No description provided for @dashboard_stat_out.
  ///
  /// In uz, this message translates to:
  /// **'Tugagan'**
  String get dashboard_stat_out;

  /// No description provided for @dashboard_stat_today.
  ///
  /// In uz, this message translates to:
  /// **'Bugun'**
  String get dashboard_stat_today;

  /// No description provided for @products_list_title.
  ///
  /// In uz, this message translates to:
  /// **'Mahsulotlar'**
  String get products_list_title;

  /// No description provided for @products_search_hint.
  ///
  /// In uz, this message translates to:
  /// **'Nomi yoki SKU bo\'yicha qidirish...'**
  String get products_search_hint;

  /// No description provided for @products_filter_category_all.
  ///
  /// In uz, this message translates to:
  /// **'Barchasi'**
  String get products_filter_category_all;

  /// No description provided for @products_filter_low_stock.
  ///
  /// In uz, this message translates to:
  /// **'Kam qoldiq'**
  String get products_filter_low_stock;

  /// No description provided for @products_status_normal.
  ///
  /// In uz, this message translates to:
  /// **'Normal'**
  String get products_status_normal;

  /// No description provided for @products_status_low.
  ///
  /// In uz, this message translates to:
  /// **'Kam'**
  String get products_status_low;

  /// No description provided for @products_status_critical.
  ///
  /// In uz, this message translates to:
  /// **'Tugagan'**
  String get products_status_critical;

  /// No description provided for @products_btn_add.
  ///
  /// In uz, this message translates to:
  /// **'Qo\'shish'**
  String get products_btn_add;

  /// No description provided for @products_empty.
  ///
  /// In uz, this message translates to:
  /// **'Mahsulotlar topilmadi'**
  String get products_empty;

  /// No description provided for @products_form_title_create.
  ///
  /// In uz, this message translates to:
  /// **'Mahsulot qo\'shish'**
  String get products_form_title_create;

  /// No description provided for @products_form_title_edit.
  ///
  /// In uz, this message translates to:
  /// **'Mahsulotni tahrirlash'**
  String get products_form_title_edit;

  /// No description provided for @products_detail_title.
  ///
  /// In uz, this message translates to:
  /// **'Mahsulot'**
  String get products_detail_title;

  /// No description provided for @products_section_basic.
  ///
  /// In uz, this message translates to:
  /// **'Asosiy ma\'lumotlar'**
  String get products_section_basic;

  /// No description provided for @products_section_pricing.
  ///
  /// In uz, this message translates to:
  /// **'Narxlar'**
  String get products_section_pricing;

  /// No description provided for @products_section_stock.
  ///
  /// In uz, this message translates to:
  /// **'Qoldiq'**
  String get products_section_stock;

  /// No description provided for @products_section_details.
  ///
  /// In uz, this message translates to:
  /// **'Qo\'shimcha'**
  String get products_section_details;

  /// No description provided for @products_name_label.
  ///
  /// In uz, this message translates to:
  /// **'Nomi'**
  String get products_name_label;

  /// No description provided for @products_category_label.
  ///
  /// In uz, this message translates to:
  /// **'Kategoriya'**
  String get products_category_label;

  /// No description provided for @products_category_hint.
  ///
  /// In uz, this message translates to:
  /// **'Kategoriya tanlang'**
  String get products_category_hint;

  /// No description provided for @products_barcode_label.
  ///
  /// In uz, this message translates to:
  /// **'Barkod'**
  String get products_barcode_label;

  /// No description provided for @products_unit_label.
  ///
  /// In uz, this message translates to:
  /// **'O\'lchov birligi'**
  String get products_unit_label;

  /// No description provided for @products_purchase_price_label.
  ///
  /// In uz, this message translates to:
  /// **'Sotib olish narxi'**
  String get products_purchase_price_label;

  /// No description provided for @products_selling_price_label.
  ///
  /// In uz, this message translates to:
  /// **'Sotish narxi'**
  String get products_selling_price_label;

  /// No description provided for @products_qty_label.
  ///
  /// In uz, this message translates to:
  /// **'Miqdor'**
  String get products_qty_label;

  /// No description provided for @products_min_qty_label.
  ///
  /// In uz, this message translates to:
  /// **'Minimal miqdor'**
  String get products_min_qty_label;

  /// No description provided for @products_description_label.
  ///
  /// In uz, this message translates to:
  /// **'Tavsif'**
  String get products_description_label;

  /// No description provided for @products_error_name_required.
  ///
  /// In uz, this message translates to:
  /// **'Mahsulot nomi majburiy'**
  String get products_error_name_required;

  /// No description provided for @products_error_category_required.
  ///
  /// In uz, this message translates to:
  /// **'Kategoriya tanlash majburiy'**
  String get products_error_category_required;

  /// No description provided for @products_error_sku_duplicate.
  ///
  /// In uz, this message translates to:
  /// **'Bu SKU allaqachon mavjud'**
  String get products_error_sku_duplicate;

  /// No description provided for @products_success_created.
  ///
  /// In uz, this message translates to:
  /// **'Mahsulot muvaffaqiyatli qo\'shildi'**
  String get products_success_created;

  /// No description provided for @products_sku_label.
  ///
  /// In uz, this message translates to:
  /// **'Artikul (SKU) — ixtiyoriy'**
  String get products_sku_label;

  /// No description provided for @products_sku_helper.
  ///
  /// In uz, this message translates to:
  /// **'Mahsulot kodi. Boʻsh qoldirsangiz avtomatik yaratiladi.'**
  String get products_sku_helper;

  /// No description provided for @products_barcode_generate.
  ///
  /// In uz, this message translates to:
  /// **'Barkod yaratish'**
  String get products_barcode_generate;

  /// No description provided for @products_barcode_scan.
  ///
  /// In uz, this message translates to:
  /// **'Barkodni skanerlash'**
  String get products_barcode_scan;

  /// No description provided for @products_category_add.
  ///
  /// In uz, this message translates to:
  /// **'Yangi kategoriya'**
  String get products_category_add;

  /// No description provided for @products_category_name_uz.
  ///
  /// In uz, this message translates to:
  /// **'Nomi (o\'zbekcha)'**
  String get products_category_name_uz;

  /// No description provided for @products_category_name_ru.
  ///
  /// In uz, this message translates to:
  /// **'Nomi (ruscha)'**
  String get products_category_name_ru;

  /// No description provided for @products_category_created.
  ///
  /// In uz, this message translates to:
  /// **'Kategoriya qo\'shildi'**
  String get products_category_created;

  /// No description provided for @products_error_category_name_required.
  ///
  /// In uz, this message translates to:
  /// **'Nom majburiy'**
  String get products_error_category_name_required;

  /// No description provided for @products_photo_label.
  ///
  /// In uz, this message translates to:
  /// **'Mahsulot fotosurati'**
  String get products_photo_label;

  /// No description provided for @products_photo_take.
  ///
  /// In uz, this message translates to:
  /// **'Kameradan olish'**
  String get products_photo_take;

  /// No description provided for @products_photo_pick.
  ///
  /// In uz, this message translates to:
  /// **'Galereyadan tanlash'**
  String get products_photo_pick;

  /// No description provided for @products_photo_remove.
  ///
  /// In uz, this message translates to:
  /// **'O\'chirish'**
  String get products_photo_remove;

  /// No description provided for @products_photo_required_for_new.
  ///
  /// In uz, this message translates to:
  /// **'Yangi mahsulot uchun fotosurat majburiy'**
  String get products_photo_required_for_new;

  /// No description provided for @stock_in_title.
  ///
  /// In uz, this message translates to:
  /// **'Kirim'**
  String get stock_in_title;

  /// No description provided for @stock_out_title.
  ///
  /// In uz, this message translates to:
  /// **'Chiqim'**
  String get stock_out_title;

  /// No description provided for @stock_product_label.
  ///
  /// In uz, this message translates to:
  /// **'Mahsulot'**
  String get stock_product_label;

  /// No description provided for @stock_warehouse_label.
  ///
  /// In uz, this message translates to:
  /// **'Ombor'**
  String get stock_warehouse_label;

  /// No description provided for @stock_qty_label.
  ///
  /// In uz, this message translates to:
  /// **'Miqdor'**
  String get stock_qty_label;

  /// No description provided for @stock_note_label.
  ///
  /// In uz, this message translates to:
  /// **'Izoh'**
  String get stock_note_label;

  /// No description provided for @stock_note_hint.
  ///
  /// In uz, this message translates to:
  /// **'Ixtiyoriy izoh...'**
  String get stock_note_hint;

  /// No description provided for @stock_reason_label.
  ///
  /// In uz, this message translates to:
  /// **'Sabab'**
  String get stock_reason_label;

  /// No description provided for @stock_reason_sale.
  ///
  /// In uz, this message translates to:
  /// **'Sotuv'**
  String get stock_reason_sale;

  /// No description provided for @stock_reason_damage.
  ///
  /// In uz, this message translates to:
  /// **'Yaroqsiz'**
  String get stock_reason_damage;

  /// No description provided for @stock_reason_return.
  ///
  /// In uz, this message translates to:
  /// **'Qaytarish'**
  String get stock_reason_return;

  /// No description provided for @stock_reason_expired.
  ///
  /// In uz, this message translates to:
  /// **'Muddati o\'tgan'**
  String get stock_reason_expired;

  /// No description provided for @stock_reason_adjustment.
  ///
  /// In uz, this message translates to:
  /// **'Tuzatish'**
  String get stock_reason_adjustment;

  /// No description provided for @stock_error_qty_zero.
  ///
  /// In uz, this message translates to:
  /// **'Miqdor 0 dan katta bo\'lishi kerak'**
  String get stock_error_qty_zero;

  /// No description provided for @stock_error_qty_exceeds.
  ///
  /// In uz, this message translates to:
  /// **'Miqdor mavjud qoldiqdan oshib ketdi'**
  String get stock_error_qty_exceeds;

  /// No description provided for @stock_success_in.
  ///
  /// In uz, this message translates to:
  /// **'Kirim muvaffaqiyatli saqlandi'**
  String get stock_success_in;

  /// No description provided for @stock_success_out.
  ///
  /// In uz, this message translates to:
  /// **'Chiqim muvaffaqiyatli saqlandi'**
  String get stock_success_out;

  /// No description provided for @inventory_title.
  ///
  /// In uz, this message translates to:
  /// **'Inventarizatsiya'**
  String get inventory_title;

  /// No description provided for @inventory_expected_label.
  ///
  /// In uz, this message translates to:
  /// **'Tizimda'**
  String get inventory_expected_label;

  /// No description provided for @inventory_actual_label.
  ///
  /// In uz, this message translates to:
  /// **'Haqiqiy'**
  String get inventory_actual_label;

  /// No description provided for @inventory_diff_label.
  ///
  /// In uz, this message translates to:
  /// **'Farq'**
  String get inventory_diff_label;

  /// No description provided for @inventory_btn_save_all.
  ///
  /// In uz, this message translates to:
  /// **'Saqlash'**
  String get inventory_btn_save_all;

  /// No description provided for @inventory_success_message.
  ///
  /// In uz, this message translates to:
  /// **'Inventarizatsiya muvaffaqiyatli saqlandi'**
  String get inventory_success_message;

  /// No description provided for @movements_title.
  ///
  /// In uz, this message translates to:
  /// **'Harakatlar tarixi'**
  String get movements_title;

  /// No description provided for @movements_empty.
  ///
  /// In uz, this message translates to:
  /// **'Harakatlar topilmadi'**
  String get movements_empty;

  /// No description provided for @settings_title.
  ///
  /// In uz, this message translates to:
  /// **'Sozlamalar'**
  String get settings_title;

  /// No description provided for @settings_language_label.
  ///
  /// In uz, this message translates to:
  /// **'Til'**
  String get settings_language_label;

  /// No description provided for @settings_language_uz.
  ///
  /// In uz, this message translates to:
  /// **'O\'zbek'**
  String get settings_language_uz;

  /// No description provided for @settings_language_ru.
  ///
  /// In uz, this message translates to:
  /// **'Русский'**
  String get settings_language_ru;

  /// No description provided for @settings_profile_label.
  ///
  /// In uz, this message translates to:
  /// **'Profil'**
  String get settings_profile_label;

  /// No description provided for @settings_app_section.
  ///
  /// In uz, this message translates to:
  /// **'Ilova'**
  String get settings_app_section;

  /// No description provided for @settings_version_label.
  ///
  /// In uz, this message translates to:
  /// **'Versiya'**
  String get settings_version_label;

  /// No description provided for @settings_btn_logout.
  ///
  /// In uz, this message translates to:
  /// **'Chiqish'**
  String get settings_btn_logout;

  /// No description provided for @settings_logout_confirm.
  ///
  /// In uz, this message translates to:
  /// **'Tizimdan chiqishni tasdiqlaysizmi?'**
  String get settings_logout_confirm;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ru', 'uz'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ru':
      return AppLocalizationsRu();
    case 'uz':
      return AppLocalizationsUz();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
