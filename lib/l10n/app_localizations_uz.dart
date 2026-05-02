// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class AppLocalizationsUz extends AppLocalizations {
  AppLocalizationsUz([String locale = 'uz']) : super(locale);

  @override
  String get app_title => 'Ombor Tizimi';

  @override
  String get btn_save => 'Saqlash';

  @override
  String get btn_cancel => 'Bekor qilish';

  @override
  String get btn_delete => 'O\'chirish';

  @override
  String get btn_confirm => 'Tasdiqlash';

  @override
  String get btn_back => 'Orqaga';

  @override
  String get btn_retry => 'Qayta urinish';

  @override
  String get lbl_loading => 'Yuklanmoqda...';

  @override
  String get lbl_error_generic => 'Xatolik yuz berdi';

  @override
  String get lbl_empty_list => 'Ma\'lumot topilmadi';

  @override
  String get msg_success_saved => 'Muvaffaqiyatli saqlandi';

  @override
  String get msg_success_deleted => 'O\'chirildi';

  @override
  String get auth_login_title => 'Tizimga kirish';

  @override
  String get auth_login_subtitle => 'Ombor boshqaruv tizimi';

  @override
  String get auth_username_label => 'Foydalanuvchi nomi';

  @override
  String get auth_username_hint => 'username kiriting';

  @override
  String get auth_password_label => 'Parol';

  @override
  String get auth_password_hint => 'parol kiriting';

  @override
  String get auth_btn_login => 'Kirish';

  @override
  String get auth_error_invalid_credentials => 'Login yoki parol noto\'g\'ri';

  @override
  String get auth_error_field_required => 'Bu maydon majburiy';

  @override
  String get auth_demo_credentials_title => 'DEMO KIRISH MA\'LUMOTLARI';

  @override
  String get auth_role_admin => 'Admin';

  @override
  String get auth_role_manager => 'Menejer';

  @override
  String get auth_role_worker => 'Xodim';

  @override
  String dashboard_greeting(String name) {
    return 'Xush kelibsiz, $name!';
  }

  @override
  String get dashboard_subtitle => 'Bugun nima qilamiz?';

  @override
  String get dashboard_card_products => 'Mahsulotlar';

  @override
  String get dashboard_card_add_product => 'Mahsulot qo\'shish';

  @override
  String get dashboard_card_stock_in => 'Kirim';

  @override
  String get dashboard_card_stock_out => 'Chiqim';

  @override
  String get dashboard_card_inventory => 'Inventarizatsiya';

  @override
  String get dashboard_card_history => 'Tarix';

  @override
  String get dashboard_card_settings => 'Sozlamalar';

  @override
  String get dashboard_card_assistant => 'AI Yordamchi';

  @override
  String get analytics_section_title => 'Ombor holati';

  @override
  String get analytics_health_title => 'Ombor sogʻligʻi';

  @override
  String get analytics_health_ok => 'Yetarli';

  @override
  String get analytics_health_low => 'Kam';

  @override
  String get analytics_health_critical => 'Tugagan';

  @override
  String get analytics_action_title => 'Diqqat talab qiladi';

  @override
  String analytics_action_count(int count) {
    return '$count ta mahsulot toʻldirilishi kerak';
  }

  @override
  String get analytics_action_view => 'Roʻyxatni koʻrish';

  @override
  String get analytics_action_clear => 'Hammasi joyida — kritik tovarlar yoʻq';

  @override
  String get analytics_flow_title => 'Bugungi oborot';

  @override
  String get analytics_flow_in => 'Kirim';

  @override
  String get analytics_flow_out => 'Chiqim';

  @override
  String get analytics_flow_net => 'Net';

  @override
  String analytics_flow_fallback(String date) {
    return 'Soʻnggi faol kun: $date';
  }

  @override
  String get analytics_value_title => 'Ombor qiymati';

  @override
  String get analytics_value_subtitle => 'xarid narxida';

  @override
  String get analytics_reorder_title => 'Birinchi navbatda toʻldirish';

  @override
  String get analytics_reorder_empty => 'Toʻldirish kerak boʻlgan tovar yoʻq';

  @override
  String analytics_slow_movers_chip(int count) {
    return '$count ta tovar 30 kundan beri harakatsiz';
  }

  @override
  String get welcome_empty_title => 'Ombor boʻsh';

  @override
  String get welcome_empty_subtitle =>
      'Birinchi mahsulotni qoʻshing va analitika faol boʻladi.';

  @override
  String get welcome_empty_cta => 'Birinchi mahsulotni qoʻshish';

  @override
  String get stock_no_products =>
      'Hali mahsulot yoʻq. Avval mahsulot qoʻshing.';

  @override
  String get stock_no_products_cta => 'Mahsulot qoʻshish';

  @override
  String get assistant_title => 'Ombor yordamchisi';

  @override
  String get assistant_clear => 'Suhbatni tozalash';

  @override
  String get assistant_input_hint => 'Savolingizni yozing...';

  @override
  String get assistant_welcome_title => 'Sizga qanday yordam berishim mumkin?';

  @override
  String get assistant_welcome_subtitle =>
      'Ombor holati, mahsulotlar va biznes haqida savol bering. Maslahatlar berish uchun real maʼlumotlardan foydalanaman.';

  @override
  String get assistant_suggestion_low_stock => 'Qaysi mahsulotlar tugayapti?';

  @override
  String get assistant_suggestion_recommendations =>
      'Qanday tavsiyalaringiz bor?';

  @override
  String get assistant_suggestion_top_categories =>
      'Eng katta kategoriyalarim qaysilar?';

  @override
  String get dashboard_stat_total => 'Jami';

  @override
  String get dashboard_stat_low => 'Kam';

  @override
  String get dashboard_stat_out => 'Tugagan';

  @override
  String get dashboard_stat_today => 'Bugun';

  @override
  String get products_list_title => 'Mahsulotlar';

  @override
  String get products_search_hint => 'Nomi yoki SKU bo\'yicha qidirish...';

  @override
  String get products_filter_category_all => 'Barchasi';

  @override
  String get products_filter_low_stock => 'Kam qoldiq';

  @override
  String get products_status_normal => 'Normal';

  @override
  String get products_status_low => 'Kam';

  @override
  String get products_status_critical => 'Tugagan';

  @override
  String get products_btn_add => 'Qo\'shish';

  @override
  String get products_empty => 'Mahsulotlar topilmadi';

  @override
  String get products_form_title_create => 'Mahsulot qo\'shish';

  @override
  String get products_form_title_edit => 'Mahsulotni tahrirlash';

  @override
  String get products_detail_title => 'Mahsulot';

  @override
  String get products_section_basic => 'Asosiy ma\'lumotlar';

  @override
  String get products_section_pricing => 'Narxlar';

  @override
  String get products_section_stock => 'Qoldiq';

  @override
  String get products_section_details => 'Qo\'shimcha';

  @override
  String get products_name_label => 'Nomi';

  @override
  String get products_category_label => 'Kategoriya';

  @override
  String get products_category_hint => 'Kategoriya tanlang';

  @override
  String get products_barcode_label => 'Barkod';

  @override
  String get products_unit_label => 'O\'lchov birligi';

  @override
  String get products_purchase_price_label => 'Sotib olish narxi';

  @override
  String get products_selling_price_label => 'Sotish narxi';

  @override
  String get products_qty_label => 'Miqdor';

  @override
  String get products_min_qty_label => 'Minimal miqdor';

  @override
  String get products_description_label => 'Tavsif';

  @override
  String get products_error_name_required => 'Mahsulot nomi majburiy';

  @override
  String get products_error_category_required => 'Kategoriya tanlash majburiy';

  @override
  String get products_error_sku_duplicate => 'Bu SKU allaqachon mavjud';

  @override
  String get products_success_created => 'Mahsulot muvaffaqiyatli qo\'shildi';

  @override
  String get products_sku_label => 'Artikul (SKU) — ixtiyoriy';

  @override
  String get products_sku_helper =>
      'Mahsulot kodi. Boʻsh qoldirsangiz avtomatik yaratiladi.';

  @override
  String get products_barcode_generate => 'Barkod yaratish';

  @override
  String get products_barcode_scan => 'Barkodni skanerlash';

  @override
  String get products_category_add => 'Yangi kategoriya';

  @override
  String get products_category_name_uz => 'Nomi (o\'zbekcha)';

  @override
  String get products_category_name_ru => 'Nomi (ruscha)';

  @override
  String get products_category_created => 'Kategoriya qo\'shildi';

  @override
  String get products_error_category_name_required => 'Nom majburiy';

  @override
  String get products_photo_label => 'Mahsulot fotosurati';

  @override
  String get products_photo_take => 'Kameradan olish';

  @override
  String get products_photo_pick => 'Galereyadan tanlash';

  @override
  String get products_photo_remove => 'O\'chirish';

  @override
  String get products_photo_required_for_new =>
      'Yangi mahsulot uchun fotosurat majburiy';

  @override
  String get stock_in_title => 'Kirim';

  @override
  String get stock_out_title => 'Chiqim';

  @override
  String get stock_product_label => 'Mahsulot';

  @override
  String get stock_warehouse_label => 'Ombor';

  @override
  String get stock_qty_label => 'Miqdor';

  @override
  String get stock_note_label => 'Izoh';

  @override
  String get stock_note_hint => 'Ixtiyoriy izoh...';

  @override
  String get stock_reason_label => 'Sabab';

  @override
  String get stock_reason_sale => 'Sotuv';

  @override
  String get stock_reason_damage => 'Yaroqsiz';

  @override
  String get stock_reason_return => 'Qaytarish';

  @override
  String get stock_reason_expired => 'Muddati o\'tgan';

  @override
  String get stock_reason_adjustment => 'Tuzatish';

  @override
  String get stock_error_qty_zero => 'Miqdor 0 dan katta bo\'lishi kerak';

  @override
  String get stock_error_qty_exceeds => 'Miqdor mavjud qoldiqdan oshib ketdi';

  @override
  String get stock_success_in => 'Kirim muvaffaqiyatli saqlandi';

  @override
  String get stock_success_out => 'Chiqim muvaffaqiyatli saqlandi';

  @override
  String get inventory_title => 'Inventarizatsiya';

  @override
  String get inventory_expected_label => 'Tizimda';

  @override
  String get inventory_actual_label => 'Haqiqiy';

  @override
  String get inventory_diff_label => 'Farq';

  @override
  String get inventory_btn_save_all => 'Saqlash';

  @override
  String get inventory_success_message =>
      'Inventarizatsiya muvaffaqiyatli saqlandi';

  @override
  String get movements_title => 'Harakatlar tarixi';

  @override
  String get movements_empty => 'Harakatlar topilmadi';

  @override
  String get settings_title => 'Sozlamalar';

  @override
  String get settings_language_label => 'Til';

  @override
  String get settings_language_uz => 'O\'zbek';

  @override
  String get settings_language_ru => 'Русский';

  @override
  String get settings_profile_label => 'Profil';

  @override
  String get settings_app_section => 'Ilova';

  @override
  String get settings_version_label => 'Versiya';

  @override
  String get settings_btn_logout => 'Chiqish';

  @override
  String get settings_logout_confirm => 'Tizimdan chiqishni tasdiqlaysizmi?';
}
