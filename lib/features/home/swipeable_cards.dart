// //not used

// import 'package:dana/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';

// class SwipeableCards extends StatefulWidget {
//   const SwipeableCards({super.key});

//   @override
//   State<SwipeableCards> createState() => _SwipeableCardsState();
// }

// class _SwipeableCardsState extends State<SwipeableCards>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<Offset> _slideAnimation;
//   late Animation<double> _fadeAnimation;

//   final List<int> _cardOrder = [0, 1, 2, 3];

//   double _dragX = 0;
//   bool _isSwiping = false;

//   final List<String> _childNames = [
//     'شنجل منجل',
//     'شاكب راكب',
//     'سالم غانم',
//     'نوح عبدالرحمن',
//   ];

//   final List<String> _cardSvgs = [
//     'assets/Icons/child_body.svg',
//     'assets/Icons/child_body.svg',
//     'assets/Icons/child_body.svg',
//     'assets/Icons/child_body.svg',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 600),
//     );

//     _slideAnimation = Tween<Offset>(
//       begin: Offset.zero,
//       end: const Offset(1.5, 0),
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

//     _fadeAnimation = Tween<double>(
//       begin: 1,
//       end: 0,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _onSwipe() {
//     setState(() => _isSwiping = true);

//     _slideAnimation = Tween<Offset>(
//       begin: Offset(_dragX / 300, 0),
//       end: const Offset(1.5, 0),
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

//     _controller.forward().then((_) {
//       setState(() {
//         final first = _cardOrder.removeAt(0);
//         _cardOrder.add(first);
//         _dragX = 0;
//         _isSwiping = false;
//       });
//       _controller.reset();
//     });
//   }

//   void _resetPosition() {
//     _slideAnimation = Tween<Offset>(
//       begin: Offset(_dragX / 300, 0),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

//     _controller.forward().then((_) {
//       setState(() {
//         _dragX = 0;
//       });
//       _controller.reset();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 300.h,
//       child: Stack(
//         alignment: Alignment.centerRight,
//         children: [
//           for (int i = _cardOrder.length - 1; i >= 0; i--) _buildCard(i),
//         ],
//       ),
//     );
//   }

//   Widget _buildCard(int stackIndex) {
//     final cardIndex = _cardOrder[stackIndex];
//     final isTop = stackIndex == 0;
//     final isLast = stackIndex == _cardOrder.length - 1;

//     final double offsetX = -stackIndex * 45.w;

//     if (isTop) {
//       return Positioned(
//         right: 0,
//         child: GestureDetector(
//           onHorizontalDragUpdate: (details) {
//             if (details.delta.dx > 0 || _dragX > 0) {
//               setState(() {
//                 _dragX += details.delta.dx;
//               });
//             }
//           },
//           onHorizontalDragEnd: (details) {
//             if (_dragX > 100.w || details.velocity.pixelsPerSecond.dx > 500) {
//               _onSwipe();
//             } else {
//               _resetPosition();
//             }
//           },
//           child: AnimatedBuilder(
//             animation: _controller,
//             builder: (context, child) {
//               final slideOffset = _controller.isAnimating
//                   ? _slideAnimation.value
//                   : Offset(_dragX / 300, 0);

//               return Transform.translate(
//                 offset: Offset(slideOffset.dx * 300, 0),
//                 child: Opacity(
//                   opacity: _controller.isAnimating ? _fadeAnimation.value : 1,
//                   child: child,
//                 ),
//               );
//             },
//             child: _cardContent(cardIndex, showButton: true),
//           ),
//         ),
//       );
//     }
//     return AnimatedPositioned(
//       duration: const Duration(milliseconds: 500),
//       curve: Curves.easeOutQuart,
//       right: _isSwiping && isLast ? -300.w : -offsetX,
//       child: AnimatedOpacity(
//         duration: const Duration(milliseconds: 400),
//         opacity: _isSwiping && isLast ? 0 : 1,
//         child: _cardContent(cardIndex, showButton: false),
//       ),
//     );
//   }

//   Widget _cardContent(int cardIndex, {required bool showButton}) {
//     return Container(
//       width: 255.w,
//       height: 250.h,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12.r),
//         border: Border.all(
//           color: AppColors.border_card_default_light,
//           width: AppRadius.stroke_more_thin.w,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.boxShadow.withOpacity(0.1),
//             offset: const Offset(-2, 0),
//             blurRadius: 3,
//           ),
//           BoxShadow(
//             color: AppColors.boxShadow.withOpacity(0.09),
//             offset: const Offset(-6, 0),
//             blurRadius: 6,
//           ),
//           BoxShadow(
//             color: AppColors.boxShadow.withOpacity(0.05),
//             offset: const Offset(-14, 0),
//             blurRadius: 8,
//           ),
//           BoxShadow(
//             color: AppColors.boxShadow.withOpacity(0.01),
//             offset: const Offset(-24, 0),
//             blurRadius: 10,
//           ),
//         ],
//       ),
//       child: Stack(
//         children: [
//           Center(
//             child: SvgPicture.asset(
//               _cardSvgs[cardIndex % _cardSvgs.length],
//               width: 94.w,
//               height: 181.h,
//               placeholderBuilder: (context) => Icon(
//                 Icons.image_outlined,
//                 size: 100.sp,
//                 color: Colors.grey.shade200,
//               ),
//             ),
//           ),
//           Positioned(
//             top: 12.h,
//             right: 12.w,
//             child: Text(
//               _childNames[cardIndex % _childNames.length],
//               style: AppTextStyle.semiboldSmTextBody,
//             ),
//           ),
//           Positioned(
//             bottom: 15.h,
//             left: 15.w,
//             child: AnimatedScale(
//               scale: showButton ? 1.0 : 0.0,
//               duration: const Duration(milliseconds: 500),
//               curve: Curves.easeOutBack, // تأثير Pop مرن
//               child: AnimatedOpacity(
//                 opacity: showButton ? 1.0 : 0.0,
//                 duration: const Duration(milliseconds: 300),
//                 child: Container(
//                   padding: EdgeInsets.all(8.r),
//                   decoration: const BoxDecoration(
//                     color: Colors.cyan,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     Icons.arrow_back_ios_new,
//                     color: Colors.white,
//                     size: 15.sp,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
