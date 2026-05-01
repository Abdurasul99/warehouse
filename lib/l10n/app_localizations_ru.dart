// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get app_title => 'Система склада';

  @override
  String get btn_save => 'Сохранить';

  @override
  String get btn_cancel => 'Отмена';

  @override
  String get btn_delete => 'Удалить';

  @override
  String get btn_confirm => 'Подтвердить';

  @override
  String get btn_back => 'Назад';

  @override
  String get btn_retry => 'Повторить';

  @override
  String get lbl_loading => 'Загрузка...';

  @override
  String get lbl_error_generic => 'Произошла ошибка';

  @override
  String get lbl_empty_list => 'Данные не найдены';

  @override
  String get msg_success_saved => 'Успешно сохранено';

  @override
  String get msg_success_deleted => 'Удалено';

  @override
  String get auth_login_title => 'Вход в систему';

  @override
  String get auth_login_subtitle => 'Система управления складом';

  @override
  String get auth_username_label => 'Имя пользователя';

  @override
  String get auth_username_hint => 'Введите имя пользователя';

  @override
  String get auth_password_label => 'Пароль';

  @override
  String get auth_password_hint => 'Введите пароль';

  @override
  String get auth_btn_login => 'Войти';

  @override
  String get auth_error_invalid_credentials => 'Неверный логин или пароль';

  @override
  String get auth_error_field_required => 'Это поле обязательно';

  @override
  String get auth_demo_credentials_title => 'ДЕМО ДАННЫЕ ДЛЯ ВХОДА';

  @override
  String get auth_role_admin => 'Администратор';

  @override
  String get auth_role_manager => 'Менеджер';

  @override
  String get auth_role_worker => 'Сотрудник';

  @override
  String dashboard_greeting(String name) {
    return 'Добро пожаловать, $name!';
  }

  @override
  String get dashboard_subtitle => 'Что делаем сегодня?';

  @override
  String get dashboard_card_products => 'Товары';

  @override
  String get dashboard_card_add_product => 'Добавить товар';

  @override
  String get dashboard_card_stock_in => 'Приход';

  @override
  String get dashboard_card_stock_out => 'Расход';

  @override
  String get dashboard_card_inventory => 'Инвентаризация';

  @override
  String get dashboard_card_history => 'История';

  @override
  String get dashboard_card_settings => 'Настройки';

  @override
  String get dashboard_card_assistant => 'AI Помощник';

  @override
  String get analytics_section_title => 'Состояние склада';

  @override
  String get analytics_health_title => 'Здоровье склада';

  @override
  String get analytics_health_ok => 'В норме';

  @override
  String get analytics_health_low => 'Мало';

  @override
  String get analytics_health_critical => 'Закончились';

  @override
  String get analytics_action_title => 'Требуется внимание';

  @override
  String analytics_action_count(int count) {
    return '$count товаров нужно пополнить';
  }

  @override
  String get analytics_action_view => 'Открыть список';

  @override
  String get analytics_action_clear => 'Все в порядке — критичных товаров нет';

  @override
  String get analytics_flow_title => 'Оборот сегодня';

  @override
  String get analytics_flow_in => 'Приход';

  @override
  String get analytics_flow_out => 'Расход';

  @override
  String get analytics_flow_net => 'Чистый';

  @override
  String analytics_flow_fallback(String date) {
    return 'Последний активный день: $date';
  }

  @override
  String get analytics_value_title => 'Стоимость склада';

  @override
  String get analytics_value_subtitle => 'по закупочной цене';

  @override
  String get analytics_reorder_title => 'Пополнить в первую очередь';

  @override
  String get analytics_reorder_empty => 'Нет товаров для пополнения';

  @override
  String analytics_slow_movers_chip(int count) {
    return '$count товаров без движения 30+ дней';
  }

  @override
  String get assistant_title => 'Помощник склада';

  @override
  String get assistant_clear => 'Очистить чат';

  @override
  String get assistant_input_hint => 'Введите ваш вопрос...';

  @override
  String get assistant_welcome_title => 'Чем могу помочь?';

  @override
  String get assistant_welcome_subtitle =>
      'Спрашивайте о состоянии склада, товарах и бизнесе. Использую реальные данные для рекомендаций.';

  @override
  String get assistant_suggestion_low_stock => 'Какие товары заканчиваются?';

  @override
  String get assistant_suggestion_recommendations =>
      'Какие у вас рекомендации?';

  @override
  String get assistant_suggestion_top_categories =>
      'Какие у меня самые большие категории?';

  @override
  String get dashboard_stat_total => 'Всего';

  @override
  String get dashboard_stat_low => 'Мало';

  @override
  String get dashboard_stat_out => 'Нет';

  @override
  String get dashboard_stat_today => 'Сегодня';

  @override
  String get products_list_title => 'Товары';

  @override
  String get products_search_hint => 'Поиск по названию или SKU...';

  @override
  String get products_filter_category_all => 'Все';

  @override
  String get products_filter_low_stock => 'Мало на складе';

  @override
  String get products_status_normal => 'Норма';

  @override
  String get products_status_low => 'Мало';

  @override
  String get products_status_critical => 'Нет';

  @override
  String get products_btn_add => 'Добавить';

  @override
  String get products_empty => 'Товары не найдены';

  @override
  String get products_form_title_create => 'Добавить товар';

  @override
  String get products_form_title_edit => 'Редактировать товар';

  @override
  String get products_detail_title => 'Товар';

  @override
  String get products_section_basic => 'Основная информация';

  @override
  String get products_section_pricing => 'Цены';

  @override
  String get products_section_stock => 'Остаток';

  @override
  String get products_section_details => 'Дополнительно';

  @override
  String get products_name_label => 'Название';

  @override
  String get products_category_label => 'Категория';

  @override
  String get products_category_hint => 'Выберите категорию';

  @override
  String get products_barcode_label => 'Штрихкод';

  @override
  String get products_unit_label => 'Единица измерения';

  @override
  String get products_purchase_price_label => 'Цена закупки';

  @override
  String get products_selling_price_label => 'Цена продажи';

  @override
  String get products_qty_label => 'Количество';

  @override
  String get products_min_qty_label => 'Минимальное количество';

  @override
  String get products_description_label => 'Описание';

  @override
  String get products_error_name_required => 'Название товара обязательно';

  @override
  String get products_error_category_required => 'Выбор категории обязателен';

  @override
  String get products_error_sku_duplicate => 'Такой SKU уже существует';

  @override
  String get products_success_created => 'Товар успешно добавлен';

  @override
  String get products_barcode_generate => 'Создать штрихкод';

  @override
  String get products_barcode_scan => 'Сканировать штрихкод';

  @override
  String get products_category_add => 'Новая категория';

  @override
  String get products_category_name_uz => 'Название (узбекский)';

  @override
  String get products_category_name_ru => 'Название (русский)';

  @override
  String get products_category_created => 'Категория добавлена';

  @override
  String get products_error_category_name_required => 'Название обязательно';

  @override
  String get products_photo_label => 'Фото товара';

  @override
  String get products_photo_take => 'Снять на камеру';

  @override
  String get products_photo_pick => 'Выбрать из галереи';

  @override
  String get products_photo_remove => 'Удалить';

  @override
  String get products_photo_required_for_new =>
      'Фото обязательно для нового товара';

  @override
  String get stock_in_title => 'Приход';

  @override
  String get stock_out_title => 'Расход';

  @override
  String get stock_product_label => 'Товар';

  @override
  String get stock_warehouse_label => 'Склад';

  @override
  String get stock_qty_label => 'Количество';

  @override
  String get stock_note_label => 'Примечание';

  @override
  String get stock_note_hint => 'Необязательное примечание...';

  @override
  String get stock_reason_label => 'Причина';

  @override
  String get stock_reason_sale => 'Продажа';

  @override
  String get stock_reason_damage => 'Брак';

  @override
  String get stock_reason_return => 'Возврат';

  @override
  String get stock_reason_expired => 'Истек срок';

  @override
  String get stock_reason_adjustment => 'Корректировка';

  @override
  String get stock_error_qty_zero => 'Количество должно быть больше 0';

  @override
  String get stock_error_qty_exceeds => 'Количество превышает текущий остаток';

  @override
  String get stock_success_in => 'Приход успешно сохранен';

  @override
  String get stock_success_out => 'Расход успешно сохранен';

  @override
  String get inventory_title => 'Инвентаризация';

  @override
  String get inventory_expected_label => 'В системе';

  @override
  String get inventory_actual_label => 'Фактически';

  @override
  String get inventory_diff_label => 'Разница';

  @override
  String get inventory_btn_save_all => 'Сохранить';

  @override
  String get inventory_success_message => 'Инвентаризация успешно сохранена';

  @override
  String get movements_title => 'История движений';

  @override
  String get movements_empty => 'Движения не найдены';

  @override
  String get settings_title => 'Настройки';

  @override
  String get settings_language_label => 'Язык';

  @override
  String get settings_language_uz => 'O\'zbek';

  @override
  String get settings_language_ru => 'Русский';

  @override
  String get settings_profile_label => 'Профиль';

  @override
  String get settings_app_section => 'Приложение';

  @override
  String get settings_version_label => 'Версия';

  @override
  String get settings_btn_logout => 'Выйти';

  @override
  String get settings_logout_confirm =>
      'Вы уверены, что хотите выйти из системы?';
}
