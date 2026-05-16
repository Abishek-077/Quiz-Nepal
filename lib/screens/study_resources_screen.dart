import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/constants/app_colors.dart';
import '../features/study/data/study_resource_catalog.dart';
import '../features/study/data/study_resource_link_checker.dart';
import '../features/study/domain/entities/study_resource.dart';
import '../widgets/app_chrome.dart';

class StudyResourcesScreen extends StatefulWidget {
  const StudyResourcesScreen({super.key});

  @override
  State<StudyResourcesScreen> createState() => _StudyResourcesScreenState();
}

class _StudyResourcesScreenState extends State<StudyResourcesScreen> {
  final StudyResourceLinkChecker _checker = StudyResourceLinkChecker();
  final Map<String, Future<StudyResourceLinkStatus>> _checks = {};

  @override
  void initState() {
    super.initState();
    _checkAll();
  }

  @override
  void dispose() {
    _checker.close();
    super.dispose();
  }

  void _checkAll() {
    for (final resource in StudyResourceCatalog.all) {
      _checks[resource.id] = _checker.check(resource.url);
    }
  }

  void _refresh(StudyResource resource) {
    setState(() => _checks[resource.id] = _checker.check(resource.url));
  }

  Future<void> _open(StudyResource resource) async {
    final uri = Uri.parse(resource.url);
    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!opened) {
        await _copyAfterOpenFailure(resource);
      }
    } on PlatformException {
      await _copyAfterOpenFailure(resource);
    } on Exception {
      await _copyAfterOpenFailure(resource);
    }
  }

  Future<void> _copyAfterOpenFailure(StudyResource resource) async {
    await Clipboard.setData(ClipboardData(text: resource.url));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not open ${resource.sourceName}. Link copied instead.',
          ),
        ),
      );
    }
  }

  Future<void> _copy(StudyResource resource) async {
    await Clipboard.setData(ClipboardData(text: resource.url));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied ${resource.sourceName} link')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const BattleHeader(score: 150, hearts: 5),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(22, 28, 22, 24),
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Study Resources',
                        style: TextStyle(
                          color: AppColors.text,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    IconButton.filledTonal(
                      tooltip: 'Refresh links',
                      onPressed: () => setState(_checkAll),
                      icon: const Icon(Icons.refresh),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Official portals, PDFs, and reading material matched to your quiz categories.',
                  style: TextStyle(
                    color: AppColors.muted,
                    fontWeight: FontWeight.w700,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 22),
                ...StudyResourceCatalog.all.map(
                  (resource) => Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: _ResourceCard(
                      resource: resource,
                      statusFuture: _checks[resource.id],
                      onRefresh: () => _refresh(resource),
                      onOpen: () => _open(resource),
                      onCopy: () => _copy(resource),
                    ),
                  ),
                ),
                const _WeeklyTipCard(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BattleBottomNav(current: BattleTab.resources),
    );
  }
}

class _ResourceCard extends StatelessWidget {
  const _ResourceCard({
    required this.resource,
    required this.statusFuture,
    required this.onRefresh,
    required this.onOpen,
    required this.onCopy,
  });

  final StudyResource resource;
  final Future<StudyResourceLinkStatus>? statusFuture;
  final VoidCallback onRefresh;
  final VoidCallback onOpen;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TypeIcon(type: resource.type),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      resource.title,
                      style: const TextStyle(
                        color: AppColors.text,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        height: 1.22,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      resource.description,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          FutureBuilder<StudyResourceLinkStatus>(
            future: statusFuture,
            builder: (context, snapshot) {
              final status = snapshot.data;
              return _StatusPill(
                isLoading: snapshot.connectionState == ConnectionState.waiting,
                isAvailable: status?.isAvailable ?? false,
                label: status?.summary ?? 'Checking source',
              );
            },
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Text(
                  _metaLabel(resource),
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              IconButton.outlined(
                tooltip: 'Fetch again',
                onPressed: onRefresh,
                icon: const Icon(Icons.sync),
              ),
              const SizedBox(width: 8),
              IconButton.outlined(
                tooltip: 'Copy link',
                onPressed: onCopy,
                icon: const Icon(Icons.link),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: onOpen,
                icon: Icon(_actionIcon(resource.type), size: 18),
                label: Text(_actionLabel(resource.type)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _metaLabel(StudyResource resource) {
    return switch (resource.type) {
      StudyResourceType.pdf => 'PDF',
      StudyResourceType.book => 'E-BOOK',
      StudyResourceType.online => 'ONLINE',
      StudyResourceType.officialPortal => 'OFFICIAL PORTAL',
    };
  }

  String _actionLabel(StudyResourceType type) {
    return switch (type) {
      StudyResourceType.pdf => 'Download',
      StudyResourceType.book => 'Read Now',
      StudyResourceType.online => 'View Site',
      StudyResourceType.officialPortal => 'View Site',
    };
  }

  IconData _actionIcon(StudyResourceType type) {
    return switch (type) {
      StudyResourceType.pdf => Icons.download,
      StudyResourceType.book => Icons.menu_book,
      StudyResourceType.online => Icons.open_in_new,
      StudyResourceType.officialPortal => Icons.open_in_new,
    };
  }
}

class _TypeIcon extends StatelessWidget {
  const _TypeIcon({required this.type});

  final StudyResourceType type;

  @override
  Widget build(BuildContext context) {
    final icon = switch (type) {
      StudyResourceType.pdf => Icons.picture_as_pdf,
      StudyResourceType.book => Icons.menu_book,
      StudyResourceType.online => Icons.link,
      StudyResourceType.officialPortal => Icons.account_balance,
    };

    final color = switch (type) {
      StudyResourceType.pdf => AppColors.primary,
      StudyResourceType.book => const Color(0xFF008E87),
      StudyResourceType.online => AppColors.secondary,
      StudyResourceType.officialPortal => AppColors.primaryDark,
    };

    final tint = switch (type) {
      StudyResourceType.pdf => AppColors.blush,
      StudyResourceType.book => const Color(0xFFA7F3EF),
      StudyResourceType.online => AppColors.navBlue,
      StudyResourceType.officialPortal => const Color(0xFFFFE8D9),
    };

    return Container(
      height: 58,
      width: 58,
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Icon(icon, color: color),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.isLoading,
    required this.isAvailable,
    required this.label,
  });

  final bool isLoading;
  final bool isAvailable;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = isLoading
        ? AppColors.muted
        : isAvailable
            ? AppColors.success
            : AppColors.danger;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading)
              const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Icon(
                isAvailable ? Icons.check_circle : Icons.error,
                color: color,
                size: 17,
              ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: TextStyle(color: color, fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeeklyTipCard extends StatelessWidget {
  const _WeeklyTipCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'WEEKLY TIP',
            style: TextStyle(
              color: Colors.white,
              letterSpacing: 1.4,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Memory Palace for GK',
            style: TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
