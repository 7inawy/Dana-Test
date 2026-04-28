// import 'package:dana/core/utils/app_assets.dart';
// import 'package:dana/core/utils/app_sizes.dart';
// import 'package:flutter/material.dart';

// import '../../../../core/utils/app_routes.dart';

// class SplashAnimationWidget extends StatefulWidget {
//   const SplashAnimationWidget({super.key});

//   @override
//   State<SplashAnimationWidget> createState() => _SplashAnimationWidgetState();
// }

// class _SplashAnimationWidgetState extends State<SplashAnimationWidget>
//     with TickerProviderStateMixin {
//   late final AnimationController _controller;
//   late final AnimationController _bounce1Controller;
//   late final AnimationController _bounce2Controller;

//   late final Animation<Offset> _heartSlide;
//   late final Animation<Offset> _dot1Slide;
//   late final Animation<Offset> _dot2Slide;
//   late final Animation<Offset> _danaSlide;
//   late final Animation<Offset> _bounce1;
//   late final Animation<Offset> _bounce2;

//   @override
//   void initState() {
//     super.initState();
//     _initControllers();
//     _initAnimations();
//     _startSequence();
//   }

//   void _initControllers() {
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1500),
//     );
//     _bounce1Controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 350),
//     );
//     _bounce2Controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 350),
//     );
//   }

//   void _initAnimations() {
//     _heartSlide = Tween<Offset>(
//       begin: const Offset(-3, 0),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

//     _dot1Slide = Tween<Offset>(
//       begin: const Offset(-3, -3),
//       end: const Offset(0, 1),
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

//     _dot2Slide = Tween<Offset>(
//       begin: const Offset(-1.5, -3),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

//     _danaSlide = Tween<Offset>(
//       begin: const Offset(3, 0),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

//     _bounce1 = Tween<Offset>(begin: Offset.zero, end: const Offset(0, -0.8))
//         .animate(
//           CurvedAnimation(parent: _bounce1Controller, curve: Curves.easeInOut),
//         );

//     _bounce2 = Tween<Offset>(begin: Offset.zero, end: const Offset(0, -0.8))
//         .animate(
//           CurvedAnimation(parent: _bounce2Controller, curve: Curves.easeInOut),
//         );
//   }

//   Future<void> _startSequence() async {
//     await Future.delayed(const Duration(milliseconds: 500));
//     if (!mounted) return;

//     await _controller.forward();

//     await _bounce1Controller.forward();
//     await _bounce1Controller.reverse();

//     await _bounce2Controller.forward();
//     await _bounce2Controller.reverse();

//     if (mounted) {
//       await Future.delayed(const Duration(milliseconds: 500));
//       Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _bounce1Controller.dispose();
//     _bounce2Controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           SlideTransition(
//             position: _danaSlide,
//             child: Image.asset(
//               AppAssets.right,
//               width: AppSizes.w136,
//               height: AppSizes.h123,
//               fit: BoxFit.contain,
//             ),
//           ),
//           SizedBox(width: AppSizes.w20),
//           Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SlideTransition(
//                     position: _dot1Slide,
//                     child: SlideTransition(
//                       position: _bounce1,
//                       child: Image.asset(
//                         AppAssets.logoTopLeft,
//                         width: AppSizes.w20,
//                         height: AppSizes.h23,
//                         fit: BoxFit.contain,
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: AppSizes.w10),
//                   SlideTransition(
//                     position: _dot2Slide,
//                     child: SlideTransition(
//                       position: _bounce2,
//                       child: Image.asset(
//                         AppAssets.logoTopRight,
//                         width: AppSizes.w30,
//                         height: AppSizes.h30,
//                         fit: BoxFit.contain,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: AppSizes.h5),
//               SlideTransition(
//                 position: _heartSlide,
//                 child: Image.asset(
//                   AppAssets.heartSplash,
//                   width: AppSizes.w100,
//                   height: AppSizes.h100,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
