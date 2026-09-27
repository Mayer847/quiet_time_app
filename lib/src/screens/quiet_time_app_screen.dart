import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/reading.dart';
import '../services/readings_service.dart';
import '../theme/theme_provider.dart';
import '../utils/date_utils.dart';

class QuietTimeAppScreen extends StatefulWidget {
  const QuietTimeAppScreen({super.key});

  @override
  State<QuietTimeAppScreen> createState() => _QuietTimeAppScreenState();
}

class _QuietTimeAppScreenState extends State<QuietTimeAppScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<ThemeProvider>().setInitialTheme(_selectedDate);
    });
  }

  void _changeDate(int numberOfDays) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: numberOfDays));
    });
  }

  void _goToToday() {
    setState(() {
      _selectedDate = DateTime.now();
    });
  }

  bool get _isToday {
    final now = DateTime.now();

    return _selectedDate.year == now.year &&
        _selectedDate.month == now.month &&
        _selectedDate.day == now.day;
  }

  String _getTitle(DateTime date) {
    final now = DateTime.now();

    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final selectedDate = DateTime(
      date.year,
      date.month,
      date.day,
    );

    final difference = selectedDate.difference(today).inDays;

    return switch (difference) {
      0 => "Today's Readings",
      -1 => "Yesterday's Readings",
      1 => "Tomorrow's Readings",
      _ => "Readings for ${formatDate(date)}",
    };
  }

  void _handleHorizontalDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;

    if (velocity.abs() < 200) {
      return;
    }

    if (velocity > 0) {
      _changeDate(-1);
    } else {
      _changeDate(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    final DailyReading? reading =
        ReadingsService.instance.getReading(_selectedDate);

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle(_selectedDate)),
        actions: [
          if (!_isToday)
            IconButton(
              tooltip: 'Return to today',
              onPressed: _goToToday,
              icon: const Icon(Icons.today),
            ),
          IconButton(
            tooltip: themeProvider.isNightMode
                ? 'Switch to light mode'
                : 'Switch to dark mode',
            onPressed: themeProvider.toggleTheme,
            icon: Icon(
              themeProvider.isNightMode ? Icons.light_mode : Icons.dark_mode,
            ),
          ),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragEnd: _handleHorizontalDragEnd,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 600,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      formatDate(_selectedDate),
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatDay(_selectedDate),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    if (reading == null)
                      _NoReadingCard(
                        date: _selectedDate,
                      )
                    else
                      _ReadingContent(
                        reading: reading,
                      ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton.filledTonal(
                          tooltip: 'Previous day',
                          onPressed: () => _changeDate(-1),
                          icon: const Icon(Icons.arrow_back),
                        ),
                        const SizedBox(width: 16),
                        FilledButton.icon(
                          onPressed: _isToday ? null : _goToToday,
                          icon: const Icon(Icons.today),
                          label: const Text('Today'),
                        ),
                        const SizedBox(width: 16),
                        IconButton.filledTonal(
                          tooltip: 'Next day',
                          onPressed: () => _changeDate(1),
                          icon: const Icon(Icons.arrow_forward),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Swipe left or right to change the date',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ReadingContent extends StatelessWidget {
  const _ReadingContent({
    required this.reading,
  });

  final DailyReading reading;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ReadingCard(
          title: 'Morning',
          icon: Icons.wb_sunny_outlined,
          reading: reading.morning,
        ),
        const SizedBox(height: 16),
        _ReadingCard(
          title: 'Evening',
          icon: Icons.nightlight_outlined,
          reading: reading.evening,
        ),
      ],
    );
  }
}

class _ReadingCard extends StatelessWidget {
  const _ReadingCard({
    required this.title,
    required this.icon,
    required this.reading,
  });

  final String title;
  final IconData icon;
  final ReadingPassage reading;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 30,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    reading.book,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    reading.passage,
                    style: textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoReadingCard extends StatelessWidget {
  const _NoReadingCard({
    required this.date,
  });

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 40,
              color: colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(
              'No readings found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'There are no readings available for ${formatDate(date)}.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
