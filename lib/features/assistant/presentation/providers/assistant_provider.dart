import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/mock_data/mock_database.dart';
import '../../../../shared/models/product_model.dart';
import '../../../../shared/services/deepseek_service.dart';
import '../../../products/presentation/providers/product_provider.dart';

class AssistantState {
  final List<ChatMessage> messages;
  final bool isSending;
  final String? error;

  const AssistantState({
    this.messages = const [],
    this.isSending = false,
    this.error,
  });

  AssistantState copyWith({
    List<ChatMessage>? messages,
    bool? isSending,
    String? error,
    bool clearError = false,
  }) =>
      AssistantState(
        messages: messages ?? this.messages,
        isSending: isSending ?? this.isSending,
        error: clearError ? null : (error ?? this.error),
      );
}

final assistantProvider =
    NotifierProvider<AssistantNotifier, AssistantState>(AssistantNotifier.new);

class AssistantNotifier extends Notifier<AssistantState> {
  final DeepSeekService _service = DeepSeekService();

  @override
  AssistantState build() => const AssistantState();

  String _buildSystemPrompt(String locale) {
    final db = MockDatabase();
    final userId = ref.read(currentUserIdProvider);
    final products = userId == null
        ? <ProductModel>[]
        : db.products.where((p) => p.ownerUserId == userId).toList();
    final productIds = products.map((p) => p.id).toSet();
    final categories = db.categories;
    final movements =
        db.movements.where((m) => productIds.contains(m.productId)).toList();
    final today = DateTime.now();

    final lowStock = products
        .where((p) => p.currentQuantity <= p.minQuantity)
        .toList();
    final outOfStock = products.where((p) => p.currentQuantity == 0).toList();

    final categoryStats = StringBuffer();
    for (final c in categories) {
      final count =
          products.where((p) => p.categoryId == c.id).length;
      if (count > 0) {
        categoryStats.writeln(
          '- ${c.localizedName(locale)}: $count mahsulot',
        );
      }
    }

    final lowStockList = StringBuffer();
    for (final p in lowStock.take(15)) {
      lowStockList.writeln(
        '- ${p.name} (SKU: ${p.sku}) — ${p.currentQuantity} ${p.unit}, '
        'minimum: ${p.minQuantity} ${p.unit}',
      );
    }

    final todayMovements = movements
        .where((m) =>
            m.createdAt.year == today.year &&
            m.createdAt.month == today.month &&
            m.createdAt.day == today.day)
        .length;

    final totalValue = products.fold<double>(
      0,
      (sum, p) => sum + (p.purchasePrice * p.currentQuantity),
    );

    final base = locale == 'ru'
        ? '''Ты — AI-помощник по управлению складом для малого/среднего бизнеса в Узбекистане. Твоя задача — анализировать состояние склада и давать практичные рекомендации.

Ориентируйся на реальные жизненные условия: рынок Узбекистана, особенности местного бизнеса (базары, оптовая закупка, сезонность спроса, наличные расчёты, валютные колебания, поставщики из Китая/России/Турции). Учитывай типичные практики ведения склада: минимальные запасы, срок хранения, ABC-анализ, оборачиваемость.

Отвечай кратко, по делу, на русском. Используй цифры и факты из данных склада.

ТЕКУЩЕЕ СОСТОЯНИЕ СКЛАДА:
- Всего товаров: ${products.length}
- Категорий: ${categories.length}
- Заканчиваются (low stock): ${lowStock.length}
- Закончились (out of stock): ${outOfStock.length}
- Движений сегодня: $todayMovements
- Общая стоимость склада (по закупочным ценам): ${totalValue.toStringAsFixed(0)} so'm

КАТЕГОРИИ:
$categoryStats
ТОВАРЫ С НИЗКИМ ОСТАТКОМ (первые 15):
${lowStockList.isEmpty ? '(нет)' : lowStockList}'''
        : '''Sen — Oʻzbekistondagi kichik/oʻrta biznes uchun ombor boshqaruvi boʻyicha AI-yordamchisan. Vazifang — ombor holatini tahlil qilish va amaliy tavsiyalar berish.

Real hayot sharoitlariga qara: Oʻzbekiston bozori, mahalliy biznes xususiyatlari (bozor, ulgurji xarid, mavsumiy talab, naqd toʻlovlar, valyuta tebranishlari, Xitoy/Rossiya/Turkiyadan yetkazib beruvchilar). Ombor boshqaruvining tipik amaliyotlarini hisobga ol: minimal zaxiralar, saqlash muddati, ABC-tahlil, aylanma tezligi.

Qisqa, aniq, oʻzbek tilida javob ber. Ombor maʼlumotlaridan raqamlar va faktlardan foydalan.

OMBORNING JORIY HOLATI:
- Jami mahsulotlar: ${products.length}
- Kategoriyalar: ${categories.length}
- Tugayapti (low stock): ${lowStock.length}
- Tugadi (out of stock): ${outOfStock.length}
- Bugungi harakatlar: $todayMovements
- Omborning umumiy qiymati (xarid narxi boʻyicha): ${totalValue.toStringAsFixed(0)} soʻm

KATEGORIYALAR:
$categoryStats
KAM QOLDIQLI MAHSULOTLAR (birinchi 15):
${lowStockList.isEmpty ? '(yoʻq)' : lowStockList}''';

    return base;
  }

  Future<void> send(String userText, {required String locale}) async {
    final trimmed = userText.trim();
    if (trimmed.isEmpty || state.isSending) return;

    final userMsg = ChatMessage(role: 'user', content: trimmed);
    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isSending: true,
      clearError: true,
    );

    try {
      final reply = await _service.chat(
        messages: state.messages,
        systemPrompt: _buildSystemPrompt(locale),
      );
      state = state.copyWith(
        messages: [
          ...state.messages,
          ChatMessage(role: 'assistant', content: reply),
        ],
        isSending: false,
      );
    } catch (e) {
      state = state.copyWith(
        isSending: false,
        error: e.toString(),
      );
    }
  }

  void clear() {
    state = const AssistantState();
  }
}
