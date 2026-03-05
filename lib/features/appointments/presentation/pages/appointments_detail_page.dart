/// Appointments Detail Page
///
/// Detail page for viewing a single appointments.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../bloc/appointments_bloc.dart';
import '../bloc/appointments_event.dart';
import '../bloc/appointments_state.dart';

/// Appointments detail page widget
class AppointmentsDetailPage extends StatelessWidget {
  final String id;

  const AppointmentsDetailPage({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AppointmentsBloc>()
        ..add(AppointmentsLoadRequested(id: id)),
      child: const AppointmentsDetailView(),
    );
  }
}

class AppointmentsDetailView extends StatelessWidget {
  const AppointmentsDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments Details'),
      ),
      body: BlocBuilder<AppointmentsBloc, AppointmentsState>(
        builder: (context, state) {
          return switch (state) {
            AppointmentsLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            AppointmentsLoaded(:final appointments) => SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appointments.name,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text('ID: ${appointments.id}'),
                  if (appointments.description != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(appointments.description!),
                  ],
                  const SizedBox(height: 16),
                  Text('Status: ${appointments.isActive ? "Active" : "Inactive"}'),
                  const SizedBox(height: 8),
                  Text('Created: ${appointments.createdAt}'),
                  if (appointments.updatedAt != null)
                    Text('Updated: ${appointments.updatedAt}'),
                ],
              ),
            ),
            AppointmentsError(:final message) => Center(
              child: Text('Error: $message'),
            ),
            _ => const SizedBox(),
          };
        },
      ),
    );
  }
}
