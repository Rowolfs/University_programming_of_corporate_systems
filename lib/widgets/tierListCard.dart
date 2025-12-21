import 'package:flutter/material.dart';
import 'package:smooth_corner/smooth_corner.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tier_list_app/pages/tierListPage.dart';
import 'package:tier_list_app/widgets/actionHeading.dart';

class TierListCard extends StatelessWidget {
  final String id;
  final String title;
  final String? previewUrl;
  final String? ownerId;

  // NEW: URL аватарки владельца
  final String? ownerAvatarUrl;

  const TierListCard({
    super.key,
    required this.id,
    required this.title,
    this.previewUrl,
    this.ownerId,
    this.ownerAvatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TierListPage(
            tierlistId: id,
          ),
        ),
      ),
      child: SmoothContainer(
        smoothness: 1,
        borderRadius: BorderRadiusGeometry.circular(17.r),
        color: const Color(0xFF101010),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 12.h),

            // preview area
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10.r),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: _TierlistPreview(previewUrl: previewUrl),
                ),
              ),
            ),

            SizedBox(height: 10.h),

            // bottom row (user + title)
            Padding(
              padding: EdgeInsets.only(left: 8.w, right: 10.w, bottom: 10.h),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 12.5.r,
                    backgroundColor: const Color(0xFF1A1A1A),
                    backgroundImage:
                        const AssetImage("assets/images/avatar_placeholder.png"),
                    foregroundImage:
                        (ownerAvatarUrl != null && ownerAvatarUrl!.trim().isNotEmpty)
                            ? NetworkImage(ownerAvatarUrl!.trim())
                            : null,
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: ActionHeading(
                      text: title.isEmpty ? "Без названия" : title,
                      fontSize: 10.sp,
                    ),
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

class _TierlistPreview extends StatelessWidget {
  final String? previewUrl;

  const _TierlistPreview({required this.previewUrl});

  @override
  Widget build(BuildContext context) {
    final url = previewUrl?.trim();

    if (url == null || url.isEmpty) {
      return Image.asset(
        'assets/images/tierlist.png',
        fit: BoxFit.contain,
      );
    }

    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          'assets/images/tierlist.png',
          fit: BoxFit.contain,
        );
      },
    );
  }
}
