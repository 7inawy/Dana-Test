import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:dana/core/di/injection_container.dart';
import 'package:dana/features/Chat_bot/presentation/views/screens/ai_chat_history_screen.dart';
import 'package:dana/features/child_profile/presentation/cubit/growth_cubit.dart';
import 'package:dana/features/home/presentation/cubit/doctors_list_cubit.dart';
import 'package:dana/features/home/presentation/screens/doctors_page.dart';
import 'package:dana/features/home/presentation/widgets/home_app_bar.dart';
import 'package:dana/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:dana/features/home/presentation/widgets/home_tab_body.dart';
import 'package:dana/features/parent_profile/presentation/cubit/parent_profile_cubit.dart';
import 'package:dana/features/parent_profile/presentation/screens/profile_section.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String routeName = 'HomeScreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<CurvedNavigationBarState> _navKey = GlobalKey();
  int _selectedIndex = 0;

  late final ParentProfileCubit _parentProfileCubit;
  late final DoctorsListCubit _doctorsListCubit;
  late final GrowthCubit _growthCubit;
  String? _growthChildId;
  String? _homeSelectedChildId;
  bool _homeChildPickerExpanded = false;

  @override
  void initState() {
    super.initState();
    _parentProfileCubit = sl<ParentProfileCubit>()..loadMe();
    _doctorsListCubit = sl<DoctorsListCubit>()..load();
    _growthCubit = sl<GrowthCubit>();
  }

  @override
  void dispose() {
    _parentProfileCubit.close();
    _doctorsListCubit.close();
    _growthCubit.close();
    super.dispose();
  }

  void _ensureGrowthLoadedForChild(String? childId) {
    if (childId == null || childId.isEmpty) return;
    if (_growthChildId == childId) return;
    _growthChildId = childId;
    _growthCubit.load(childId: childId);
  }

  (int years, int months) _ageFromBirth(DateTime? birthDate) {
    if (birthDate == null) return (0, 0);
    final now = DateTime.now();
    var y = now.year - birthDate.year;
    var m = now.month - birthDate.month;
    if (now.day < birthDate.day) m -= 1;
    if (m < 0) {
      y -= 1;
      m += 12;
    }
    return (y < 0 ? 0 : y, m < 0 ? 0 : m);
  }

  bool get _isDark {
    final themeProvider = context.read<AppThemeProvider>();
    return themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
  }

  Widget _getBody() {
    final isDark = _isDark;

    switch (_selectedIndex) {
      case 3:
        return ProfileSection(cubit: _parentProfileCubit);
      case 0:
        return HomeTabBody(
          isDark: isDark,
          parentProfileCubit: _parentProfileCubit,
          doctorsListCubit: _doctorsListCubit,
          growthCubit: _growthCubit,
          selectedChildId: _homeSelectedChildId,
          childPickerExpanded: _homeChildPickerExpanded,
          onChildSelected: (id) {
            if (id.isEmpty) {
              setState(() {
                _homeSelectedChildId = null;
                _homeChildPickerExpanded = false;
              });
              return;
            }
            setState(() {
              _homeSelectedChildId = id;
              _homeChildPickerExpanded = false;
            });
            _ensureGrowthLoadedForChild(id);
          },
          onTogglePicker: () => setState(() {
            _homeChildPickerExpanded = !_homeChildPickerExpanded;
          }),
          ageFromBirth: _ageFromBirth,
          ensureGrowthLoaded: _ensureGrowthLoadedForChild,
        );
      default:
        return const SizedBox();
    }
  }

  void _goHome() {
    setState(() {
      _selectedIndex = 0;
      _navKey = GlobalKey();
    });
    // force reload growth للطفل الحالي لما ترجع من أي صفحة
    if (_homeSelectedChildId != null) {
      _growthChildId = null; // reset الـ guard
      _ensureGrowthLoadedForChild(_homeSelectedChildId);
    }
  }

  void _onTap(int index) {
    if (index == 2 || index == 1) {
      final pages = {
        2: const AIChatHistoryScreen(),
        1: const DoctorsScreen(),
      };

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => pages[index]!),
      ).then((_) => _goHome());
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        context.watch<AppThemeProvider>().appTheme == ThemeMode.dark ||
        (context.watch<AppThemeProvider>().appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Scaffold(
      appBar: _selectedIndex == 0 ? HomeAppBar(isDark: isDark) : null,
      body: _getBody(),
      bottomNavigationBar: HomeBottomNavBar(
        navKey: _navKey,
        selectedIndex: _selectedIndex,
        isDark: isDark,
        onTap: _onTap,
      ),
    );
  }
}
