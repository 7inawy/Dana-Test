import 'package:dana/core/utils/app_assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LargeAvatar extends StatelessWidget {
  final String imageUrl;
  const LargeAvatar({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final url = imageUrl.trim();
    if (url.startsWith('http')) {
      return ClipOval(
        child: Image.network(
          url,
          width: 90.w,
          height: 90.h,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Image.asset(
            AppAssets.imageBottomSheet,
            width: 90.w,
            height: 90.h,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    if (url.isNotEmpty && url.startsWith('assets/')) {
      return ClipOval(
        child: Image.asset(url, width: 90.w, height: 90.h, fit: BoxFit.cover),
      );
    }
    return ClipOval(
      child: Image.asset(
        AppAssets.imageBottomSheet,
        width: 90.w,
        height: 90.h,
        fit: BoxFit.cover,
      ),
    );
  }
}
