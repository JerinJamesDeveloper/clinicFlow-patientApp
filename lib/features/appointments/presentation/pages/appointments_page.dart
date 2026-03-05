/// Appointments Page
///
/// Main page for appointments feature.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../bloc/appointments_bloc.dart';
import '../bloc/appointments_event.dart';
import '../bloc/appointments_state.dart';
import '../widgets/appointments_list_widget.dart';

/// Appointments page widget
class AppointmentsPage extends StatelessWidget {
  const AppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AppointmentsBloc>()
        ..add(const AppointmentsListLoadRequested()),
      child: const AppointmentsView(),
    );
  }
}

class AppointmentsView extends StatelessWidget {
  const AppointmentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<AppointmentsBloc>().add(
                const AppointmentsRefreshRequested(),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<AppointmentsBloc, AppointmentsState>(
        listener: (context, state) {
          if (state is AppointmentsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: 'Dismiss',
                  textColor: Colors.white,
                  onPressed: () {
                    context.read<AppointmentsBloc>().add(
                      const AppointmentsErrorCleared(),
                    );
                  },
                ),
              ),
            );
          }
          if (state is AppointmentsOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          return switch (state) {
            AppointmentsInitial() => const _InitialView(),
            AppointmentsLoading() => const _LoadingView(),
            AppointmentsListLoaded(:final appointmentss) =>
              AppointmentsListWidget(appointmentss: appointmentss),
            AppointmentsOperating(:final appointmentss) =>
              AppointmentsListWidget(appointmentss: appointmentss, isOperating: true),
            AppointmentsOperationSuccess(:final appointmentss) =>
              AppointmentsListWidget(appointmentss: appointmentss),
            AppointmentsError(:final appointmentss) =>
              appointmentss != null && appointmentss.isNotEmpty
                  ? AppointmentsListWidget(appointmentss: appointmentss)
                  : const _ErrorView(),
            _ => const SizedBox(),
          };
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Create Appointments'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Enter name',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter description (optional)',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                context.read<AppointmentsBloc>().add(
                  AppointmentsCreateRequested(
                    name: nameController.text.trim(),
                    description: descriptionController.text.trim().isEmpty
                        ? null
                        : descriptionController.text.trim(),
                  ),
                );
                Navigator.of(dialogContext).pop();
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

class _InitialView extends StatelessWidget {
  const _InitialView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Press refresh to load data'),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text('Failed to load data'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<AppointmentsBloc>().add(
                const AppointmentsListLoadRequested(),
              );
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
