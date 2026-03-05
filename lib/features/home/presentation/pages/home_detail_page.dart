/// Home Detail Page
///
/// Detail page for viewing a single home.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';

/// Home detail page widget
class HomeDetailPage extends StatelessWidget {
  final String id;

  const HomeDetailPage({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HomeBloc>()
        ..add(HomeLoadRequested(id: id)),
      child: const HomeDetailView(),
    );
  }
}

class HomeDetailView extends StatelessWidget {
  const HomeDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Details'),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return switch (state) {
            HomeLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            HomeLoaded(:final home) => SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    home.name,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text('ID: ${home.id}'),
                  if (home.description != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(home.description!),
                  ],
                  const SizedBox(height: 16),
                  Text('Status: ${home.isActive ? "Active" : "Inactive"}'),
                  const SizedBox(height: 8),
                  Text('Created: ${home.createdAt}'),
                  if (home.updatedAt != null)
                    Text('Updated: ${home.updatedAt}'),
                ],
              ),
            ),
            HomeError(:final message) => Center(
              child: Text('Error: $message'),
            ),
            _ => const SizedBox(),
          };
        },
      ),
    );
  }
}
