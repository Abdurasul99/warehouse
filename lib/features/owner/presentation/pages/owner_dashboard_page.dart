import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/owner_dashboard.dart';
import '../providers/owner_dashboard_provider.dart';

final _money = NumberFormat('#,##0', 'ru_RU');

String _fmtMoney(num v) {
  final n = v.round();
  return _money.format(n).replaceAll(',', ' ');
}

class OwnerDashboardPage extends ConsumerStatefulWidget {
  const OwnerDashboardPage({super.key});

  @override
  ConsumerState<OwnerDashboardPage> createState() => _OwnerDashboardPageState();
}

class _OwnerDashboardPageState extends ConsumerState<OwnerDashboardPage> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).maybeWhen(
          data: (u) => u,
          orElse: () => null,
        );
    final dashboardAsync = ref.watch(ownerDashboardProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(user?.name ?? '—'),
            Expanded(
              child: IndexedStack(
                index: _tab,
                children: [
                  _OverviewTab(
                    dashboardAsync: dashboardAsync,
                    onRefresh: () =>
                        ref.read(ownerDashboardProvider.notifier).refresh(),
                  ),
                  const _BranchesTab(),
                  const _PlaceholderTab(
                    title: 'Симуляции',
                    subtitle: 'Что будет если…',
                    description:
                        'Здесь появятся прогнозы:\n· Изменю цену → прибыль\n· Увеличу закуп → деньги',
                  ),
                  const _PlaceholderTab(
                    title: 'ИИ-помощник',
                    subtitle: 'Подключаем в следующей итерации',
                    description:
                        '«Сравни прибыль филиалов»,\n«Где теряем деньги?»',
                  ),
                ],
              ),
            ),
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String userName) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Учредитель',
                    style: TextStyle(fontSize: 13, color: Color(0xFF8A8A8E))),
                const SizedBox(height: 2),
                Text(userName,
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1C1C1E))),
              ],
            ),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFFE7E3FF),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              userName.isNotEmpty ? userName.characters.first : '?',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF6E5BFF),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    final items = const [
      ('Сводка', Icons.dashboard_outlined),
      ('Филиалы', Icons.store_mall_directory_outlined),
      ('Симуляции', Icons.auto_graph),
      ('ИИ', Icons.bolt_outlined),
    ];
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E5EA), width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: List.generate(items.length, (i) {
              final selected = _tab == i;
              return Expanded(
                child: InkWell(
                  onTap: () => setState(() => _tab = i),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      children: [
                        Icon(
                          items[i].$2,
                          size: 22,
                          color: selected
                              ? const Color(0xFF1F2A6E)
                              : const Color(0xFF8A8A8E),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          items[i].$1,
                          style: TextStyle(
                            fontSize: 11,
                            color: selected
                                ? const Color(0xFF1F2A6E)
                                : const Color(0xFF8A8A8E),
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  final AsyncValue<OwnerDashboard> dashboardAsync;
  final Future<void> Function() onRefresh;
  const _OverviewTab({required this.dashboardAsync, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: dashboardAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 80),
            Icon(Icons.cloud_off, size: 48, color: Colors.red[300]),
            const SizedBox(height: 12),
            Text('Не удалось загрузить данные',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red[700])),
            const SizedBox(height: 8),
            Text('$e',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(height: 16),
            Center(
              child: OutlinedButton(
                onPressed: onRefresh,
                child: const Text('Повторить'),
              ),
            ),
          ],
        ),
        data: (d) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          children: [
            _RevenueHeroCard(today: d.today),
            const SizedBox(height: 20),
            const _SectionLabel('ФИЛИАЛЫ · НАЖМИ ЧТОБЫ ОТКРЫТЬ'),
            const SizedBox(height: 8),
            ...d.branches.map((b) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _BranchCard(branch: b),
                )),
            if (d.branches.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text('Филиалов пока нет',
                      style: TextStyle(color: Colors.black54)),
                ),
              ),
            const SizedBox(height: 16),
            const _SectionLabel('ЧТО БУДЕТ ЕСЛИ'),
            const SizedBox(height: 8),
            const _SimulationsPlaceholder(),
            const SizedBox(height: 12),
            ...d.notifications.map((n) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _NotificationCard(notification: n),
                )),
            const SizedBox(height: 8),
            const _AiAssistantCard(),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xFF8A8A8E),
          letterSpacing: 1.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _RevenueHeroCard extends StatelessWidget {
  final OwnerToday today;
  const _RevenueHeroCard({required this.today});

  @override
  Widget build(BuildContext context) {
    final delta = today.deltaPercent;
    final deltaSign = delta >= 0 ? '+' : '';
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF14143A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Выручка сети сегодня',
              style: TextStyle(color: Color(0xFF9D9DD0), fontSize: 13)),
          const SizedBox(height: 8),
          Text('${_fmtMoney(today.revenue)} сум',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              )),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _Pill(
                text: '$deltaSign${delta.toStringAsFixed(0)}%',
                color: delta >= 0
                    ? const Color(0xFF34D399)
                    : const Color(0xFFFCA5A5),
              ),
              _PillText(text: '${today.checkCount} чеков'),
              _PillText(
                  text: 'маржа ${today.marginPercent.toStringAsFixed(0)}%'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final Color color;
  const _Pill({required this.text, required this.color});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600),
    );
  }
}

class _PillText extends StatelessWidget {
  final String text;
  const _PillText({required this.text});
  @override
  Widget build(BuildContext context) {
    return Text(
      '· $text',
      style: const TextStyle(color: Color(0xFFB7B7DD), fontSize: 13),
    );
  }
}

class _BranchCard extends StatelessWidget {
  final OwnerBranchSummary branch;
  const _BranchCard({required this.branch});

  @override
  Widget build(BuildContext context) {
    final delta = branch.deltaPercent;
    final positive = delta >= 0;
    final sign = positive ? '+' : '';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E5EA)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(branch.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1C1C1E),
                    )),
                const SizedBox(height: 4),
                Text(
                  '${_fmtMoney(branch.todayRevenue)} сум · ${branch.checkCount} чеков · ${branch.employeeCount} чел',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6E6E73),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: positive
                  ? const Color(0xFFE5F8EE)
                  : const Color(0xFFFEEAEA),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$sign${delta.toStringAsFixed(0)}%',
              style: TextStyle(
                color: positive
                    ? const Color(0xFF15803D)
                    : const Color(0xFFB91C1C),
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SimulationsPlaceholder extends StatelessWidget {
  const _SimulationsPlaceholder();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFEEFF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Симуляции',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: Color(0xFF1F2A6E),
              )),
          SizedBox(height: 6),
          Text('Изменю цену → прибыль · увеличу закуп → деньги',
              style: TextStyle(fontSize: 13, color: Color(0xFF44447A))),
          SizedBox(height: 4),
          Text('Риск отсутствия / переполнение склада / падение продаж',
              style: TextStyle(fontSize: 13, color: Color(0xFF7A7AA0))),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final OwnerNotification notification;
  const _NotificationCard({required this.notification});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF6E5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${notification.branchName} ${notification.deltaPercent.toStringAsFixed(0)}%',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF8B5A00),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Открой филиал чтобы посмотреть где теряем',
            style: TextStyle(color: Colors.brown.shade700, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _AiAssistantCard extends StatelessWidget {
  const _AiAssistantCard();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2A6E),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('ИИ-помощник',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              )),
          SizedBox(height: 4),
          Text('«Сравни прибыль филиалов»',
              style: TextStyle(color: Color(0xFFB7B7DD), fontSize: 13)),
        ],
      ),
    );
  }
}

class _BranchesTab extends ConsumerWidget {
  const _BranchesTab();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDash = ref.watch(ownerDashboardProvider);
    return asyncDash.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) =>
          Center(child: Text('Ошибка: $e', textAlign: TextAlign.center)),
      data: (d) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final b in d.branches)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _BranchCard(branch: b),
            ),
        ],
      ),
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  const _PlaceholderTab({
    required this.title,
    required this.subtitle,
    required this.description,
  });
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 60),
        Icon(Icons.construction,
            size: 56, color: Colors.deepPurple.shade200),
        const SizedBox(height: 16),
        Text(title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1C1C1E),
            )),
        const SizedBox(height: 8),
        Text(subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF6E6E73))),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFEFEEFF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF44447A), height: 1.4),
          ),
        ),
      ],
    );
  }
}
