import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/constants/app_colors.dart';
import '../data/category_catalog.dart';
import '../features/study/data/study_resource_catalog.dart';
import '../features/study/data/study_resource_link_checker.dart';
import '../features/study/domain/entities/study_resource.dart';
import '../models/category_model.dart';

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
    setState(() {
      _checks[resource.id] = _checker.check(resource.url);
    });
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
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied ${resource.sourceName} link')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Study Resources',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh links',
            onPressed: () => setState(_checkAll),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const _ResourceHeader(),
          const SizedBox(height: 14),
          ...CategoryCatalog.all.map(_buildCategorySection),
        ],
      ),
    );
  }

  Widget _buildCategorySection(QuizCategory category) {
    final resources = StudyResourceCatalog.forCategory(category.id);
    if (resources.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        initiallyExpanded: true,
        tilePadding: const EdgeInsets.symmetric(horizontal: 4),
        childrenPadding: const EdgeInsets.only(bottom: 8),
        leading: CircleAvatar(
          backgroundColor: category.gradient.first.withValues(alpha: 0.14),
          child: Icon(category.icon, color: category.gradient.first),
        ),
        title: Text(
          category.title,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        subtitle: Text('${resources.length} researched sources'),
        children: resources
            .map(
              (resource) => _ResourceCard(
                resource: resource,
                statusFuture: _checks[resource.id],
                onRefresh: () => _refresh(resource),
                onOpen: () => _open(resource),
                onCopy: () => _copy(resource),
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}

class _ResourceHeader extends StatelessWidget {
  const _ResourceHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Row(
        children: [
          Icon(Icons.menu_book, color: Colors.white, size: 32),
          SizedBox(width: 14),
          Expanded(
            child: Text(
              'PDFs, books and online lessons matched to each quiz category.',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
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
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TypeIcon(type: resource.type),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        resource.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        resource.sourceName,
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              resource.description,
              style: const TextStyle(height: 1.35, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            FutureBuilder<StudyResourceLinkStatus>(
              future: statusFuture,
              builder: (context, snapshot) {
                final status = snapshot.data;
                return _StatusPill(
                  isLoading:
                      snapshot.connectionState == ConnectionState.waiting,
                  isAvailable: status?.isAvailable ?? false,
                  label: status?.summary ?? 'Checking source',
                );
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton.filledTonal(
                  tooltip: 'Fetch again',
                  onPressed: onRefresh,
                  icon: const Icon(Icons.sync),
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  tooltip: 'Copy link',
                  onPressed: onCopy,
                  icon: const Icon(Icons.link),
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: onOpen,
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Open'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeIcon extends StatelessWidget {
  const _TypeIcon({required this.type});

  final StudyResourceType type;

  @override
  Widget build(BuildContext context) {
    final icon = switch (type) {
      StudyResourceType.pdf => Icons.picture_as_pdf,
      StudyResourceType.book => Icons.book,
      StudyResourceType.online => Icons.language,
      StudyResourceType.officialPortal => Icons.account_balance,
    };

    final color = switch (type) {
      StudyResourceType.pdf => AppColors.danger,
      StudyResourceType.book => AppColors.success,
      StudyResourceType.online => AppColors.primary,
      StudyResourceType.officialPortal => AppColors.secondary,
    };

    return CircleAvatar(
      backgroundColor: color.withValues(alpha: 0.12),
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
