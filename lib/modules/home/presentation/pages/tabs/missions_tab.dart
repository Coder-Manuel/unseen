import 'package:flutter/material.dart';
import 'package:unseen/config/colors.dart';

class MissionsTab extends StatelessWidget {
  const MissionsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Missions',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, color: Colors.black, size: 18),
                        SizedBox(width: 4),
                        Text(
                          'New',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _FilterRow(),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(24),
                itemCount: _missions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (_, i) => _MissionCard(mission: _missions[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  final _filters = const ['All', 'Active', 'Pending', 'Completed'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final selected = i == 0;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              color: selected ? AppColors.primary : AppColors.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _filters[i],
              style: TextStyle(
                color: selected ? Colors.black : AppColors.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MissionCard extends StatelessWidget {
  final _Mission mission;
  const _MissionCard({required this.mission});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  mission.title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _StatusBadge(status: mission.status),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            mission.description,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  color: AppColors.textSecondary, size: 14),
              const SizedBox(width: 4),
              Text(
                mission.location,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 12),
              ),
              const Spacer(),
              const Icon(Icons.access_time,
                  color: AppColors.textSecondary, size: 14),
              const SizedBox(width: 4),
              Text(
                mission.time,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      'Active' => const Color(0xFF22C55E),
      'Pending' => AppColors.primary,
      _ => AppColors.textSecondary,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _Mission {
  final String title;
  final String description;
  final String location;
  final String time;
  final String status;

  const _Mission({
    required this.title,
    required this.description,
    required this.location,
    required this.time,
    required this.status,
  });
}

const _missions = [
  _Mission(
    title: 'Surveillance — Downtown',
    description: 'Monitor target location and report movement patterns.',
    location: 'Nairobi CBD',
    time: '2h ago',
    status: 'Active',
  ),
  _Mission(
    title: 'Intel Gathering',
    description: 'Collect information on subject and document findings.',
    location: 'Westlands',
    time: '5h ago',
    status: 'Pending',
  ),
  _Mission(
    title: 'Perimeter Check',
    description: 'Verify security perimeter at the specified coordinates.',
    location: 'Karen Estate',
    time: '1d ago',
    status: 'Completed',
  ),
  _Mission(
    title: 'Extraction Support',
    description: 'Provide real-time intel support for extraction team.',
    location: 'Mombasa Road',
    time: '2d ago',
    status: 'Completed',
  ),
];
