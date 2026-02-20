import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentinel/core/theme/app_theme.dart';
import 'package:sentinel/features/events/presentation/event_providers.dart';
import 'package:sentinel/features/home/presentation/widgets/app_drawer.dart';
import 'package:sentinel/features/home/presentation/widgets/event_card.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Auto-refresh when app comes to foreground
      ref.refresh(eventListProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventListAsync = ref.watch(eventListProvider);

    return Scaffold(
      backgroundColor: Colors.black, // Pure black background
      appBar: AppBar(
        title: const Text(
          'SENTINEL',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_sharp), // Sharp icon
            onPressed: () {},
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        color: AppTheme.primaryColor,
        backgroundColor: AppTheme.darkSurface,
        onRefresh: () async {
          return ref.refresh(eventListProvider);
        },
        child: eventListAsync.when(
          data: (events) {
            if (events.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'S',
                      style: TextStyle(
                        fontFamily: 'SentinelBrand',
                        fontSize: 80,
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'NO EVENT CREATED YET',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.3),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return EventCard(
                  event: event,
                  onTap: () {
                    // "Active" = !terminated && !fired
                    // If Terminated or Fired -> History
                    // Else -> Active Screen
                    if (event.terminated || event.fired) {
                      context.push('/history/${event.id}');
                    } else {
                      context.push('/event/${event.id}');
                    }
                  },
                );
              },
            );
          },
          loading: () => ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: 3,
            separatorBuilder: (c, i) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return Container(
                height: 100,
                color: AppTheme.darkSurface,
              ); // Skeleton
            },
          ),
          error: (err, stack) => Center(
            child: Text(
              'Failed to load events',
              style: TextStyle(color: Colors.red.withValues(alpha: 0.7)),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/create-event');
        },
        backgroundColor: AppTheme.primaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ), // Sharp FAB
        child: const Icon(Icons.add_sharp, color: Colors.white),
      ),
    );
  }
}
