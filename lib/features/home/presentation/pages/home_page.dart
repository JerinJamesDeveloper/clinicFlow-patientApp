/// Home Page
///
/// Dashboard style landing page for the home feature.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../navigation/route_names.dart';
import '../../domain/entities/home_entity.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeBloc>()..add(const HomeListLoadRequested()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () {
              context.read<HomeBloc>().add(const HomeRefreshRequested());
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is HomeOperationSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HomeError &&
              (state.homes == null || state.homes!.isEmpty)) {
            return _ErrorState(
              onRetry: () =>
                  context.read<HomeBloc>().add(const HomeListLoadRequested()),
            );
          }

          final homes = switch (state) {
            HomeListLoaded(:final homes) => homes,
            HomeOperating(:final homes) => homes,
            HomeOperationSuccess(:final homes) => homes,
            HomeError(:final homes) => homes ?? const <HomeEntity>[],
            _ => const <HomeEntity>[],
          };

          return _HomeDashboard(
            homes: homes,
            busy: state is HomeOperating,
            onRefresh: () =>
                context.read<HomeBloc>().add(const HomeRefreshRequested()),
          );
        },
      ),
    );
  }
}

class _HomeDashboard extends StatelessWidget {
  final List<HomeEntity> homes;
  final bool busy;
  final VoidCallback onRefresh;

  const _HomeDashboard({
    required this.homes,
    required this.busy,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final active = homes.where((e) => e.isActive).length;
    final inactive = homes.length - active;

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () async => onRefresh(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Welcome back',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Your care dashboard overview',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Total',
                      value: '${homes.length}',
                      icon: Icons.dashboard_outlined,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'Active',
                      value: '$active',
                      icon: Icons.check_circle_outline,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'Inactive',
                      value: '$inactive',
                      icon: Icons.pause_circle_outline,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _SectionCard(
                title: 'Quick Actions',
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _QuickActionButton(
                      label: 'Appointments',
                      icon: Icons.calendar_today_outlined,
                      onTap: () => context.go(RoutePaths.appointments),
                    ),
                    _QuickActionButton(
                      label: 'Profile',
                      icon: Icons.person_outline,
                      onTap: () => context.go(RoutePaths.profile),
                    ),
                    _QuickActionButton(
                      label: 'Notifications',
                      icon: Icons.notifications_none,
                      onTap: () => context.go(RoutePaths.notifications),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _SectionCard(
                title: 'Recent Home Items',
                child: homes.isEmpty
                    ? const Text('No home items yet.')
                    : Column(
                        children: homes
                            .take(5)
                            .map(
                              (item) => ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                leading: Icon(
                                  item.isActive
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  size: 18,
                                ),
                                title: Text(item.name),
                                subtitle: Text(
                                  item.description ?? 'No description',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .toList(),
                      ),
              ),
            ],
          ),
        ),
        if (busy)
          Container(
            color: Colors.black26,
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 2),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 44),
            const SizedBox(height: 10),
            const Text('Unable to load home data'),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
