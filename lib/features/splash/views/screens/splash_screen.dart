import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_routes.dart';
import 'package:dana/core/auth/auth_session.dart';
import 'package:dana/core/di/injection_container.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = 'SplashScreen';

  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _bounceRightController;
  late AnimationController _bounceLeftController;

  late Animation<Offset> _leftSlide;
  late Animation<Offset> _rightSlide;
  late Animation<Offset> _bounceRight;
  late Animation<Offset> _bounceLeft;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _leftSlide = Tween<Offset>(begin: const Offset(-2.5, 0), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeInOut),
        );

    _rightSlide = Tween<Offset>(begin: const Offset(2.5, 0), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeInOut),
        );

    //  حركة الباونس للجزء اليمين
    _bounceRightController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _bounceRight = Tween<Offset>(begin: Offset.zero, end: const Offset(0, -1.2))
        .animate(
          CurvedAnimation(
            parent: _bounceRightController,
            curve: Curves.easeInOut,
          ),
        );

    //  حركة الباونس للجزء الشمال (تبدأ بعد اليمين)
    _bounceLeftController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _bounceLeft = Tween<Offset>(begin: Offset.zero, end: const Offset(0, -0.8))
        .animate(
          CurvedAnimation(
            parent: _bounceLeftController,
            curve: Curves.easeInOut,
          ),
        );

    // أول حاجة: حركة الدخول
    Future.delayed(Duration(milliseconds: 200), () {
      _slideController.forward();
    });

    // لما تخلص الدخول، نبدأ الباونسات
    _slideController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        // الأول اليمين
        await _bounceRightController.forward();
        await _bounceRightController.reverse();

        // بعدين الشمال
        await _bounceLeftController.forward();
        await _bounceLeftController.reverse();

        final hasToken = await sl<AuthSession>().hasToken();
        if (!mounted) return;
        Navigator.pushReplacementNamed(
          context,
          hasToken ? AppRoutes.home : AppRoutes.onboarding,
        );
      }
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _bounceRightController.dispose();
    _bounceLeftController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.bg_surface_default_dark
          : AppColors.bg_surface_default_light,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: isRTL
              ? [
                  // ===========================
                  //  الجزء اليمين (عادي)
                  // ===========================
                  SlideTransition(
                    position: _rightSlide,
                    child: Image.asset(
                      'assets/Images/right.png',
                      width: 136,
                      height: 123,
                    ),
                  ),

                  SizedBox(width: 20.w),

                  // ===========================
                  //  الجزء الشمال (علوي + سفلي)
                  // ===========================
                  SlideTransition(
                    position: _leftSlide,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // الجزء السفلي ثابت
                        // الجزء السفلي (صورة يمين + صورة شمال)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // الجزء اليمين (يتحرك الأول)
                            Row(
                              children: [
                                SlideTransition(
                                  position: _bounceRight,
                                  child: SvgPicture.asset(
                                    'assets/Icons/left_top_right.svg',
                                    width: 22.911792755126953,
                                    height: 22.56934356689453,
                                  ),
                                ),
                                SizedBox(width: 5.w),
                              ],
                            ),
                            SizedBox(height: 2.5.h),
                            Image.asset(
                              'assets/Images/left_bottom_right.png', // الجزء اليمين
                              width: 39,
                              height: 71.5,
                            ),
                          ],
                        ),

                        // صف علوي فيه جزئين
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // الجزء الشمال (يتحرك بعد اليمين)
                            SlideTransition(
                              position: _bounceLeft,
                              child: SvgPicture.asset(
                                'assets/Icons/left_top_left.svg',
                                width: 29.964195251464844,
                                height: 30.57416343688965,
                              ),
                            ),
                            Image.asset(
                              'assets/Images/left_bottom_left.png', // الجزء الشمال
                              width: 53.4,
                              height: 93.8,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ]
              : [
                  SlideTransition(
                    position: _leftSlide,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // صف علوي فيه جزئين
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // الجزء الشمال (يتحرك بعد اليمين)
                            SlideTransition(
                              position: _bounceLeft,
                              child: SvgPicture.asset(
                                'assets/Icons/left_top_left.svg',
                                width: 29.964195251464844,
                                height: 30.57416343688965,
                              ),
                            ),
                            Image.asset(
                              'assets/Images/left_bottom_left.png', // الجزء الشمال
                              width: 53.4,
                              height: 93.8,
                            ),
                          ],
                        ),

                        // الجزء السفلي ثابت
                        // الجزء السفلي (صورة يمين + صورة شمال)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // الجزء اليمين (يتحرك الأول)
                            Row(
                              children: [
                                SizedBox(width: 5),
                                SlideTransition(
                                  position: _bounceRight,
                                  child: SvgPicture.asset(
                                    'assets/Icons/left_top_right.svg',
                                    width: 22.911792755126953,
                                    height: 22.56934356689453,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 2.5),
                            Image.asset(
                              'assets/Images/left_bottom_right.png', // الجزء اليمين
                              width: 39,
                              height: 71.5,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 20.w),

                  SlideTransition(
                    position: _rightSlide,
                    child: Image.asset(
                      'assets/Images/right.png',
                      width: 136,
                      height: 123,
                    ),
                  ),
                ],
        ),
      ),
    );
  }
}
