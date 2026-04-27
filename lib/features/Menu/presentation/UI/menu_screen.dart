import 'package:cropmodel/core/constants/app_colors.dart';
import 'package:cropmodel/core/services/navigation_history_service.dart';
import 'package:cropmodel/core/shared/app_message.dart';
import 'package:cropmodel/features/Menu/presentation/UI/widgets/MenuItemCard.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cropmodel/features/room/data/model/room.dart';
import 'package:cropmodel/features/cart/domain/usecases/add_item_to_cart_usecase.dart';
import 'package:cropmodel/features/room/domain/usecases/add_menu_item_to_room_usecase.dart';
import 'package:cropmodel/features/room/domain/usecases/get_open_rooms_usecase.dart';
import 'package:cropmodel/features/room/presentation/UI/my_rooms_presenter.dart';
import 'package:flutter/material.dart' hide BottomNavigationBar;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../bottom_navigation_bar.dart';
import '../../../../core/utils/text_font_transformer.dart';
import '../../../Login/presentation/UI/loginpage.dart';
import '../../../Login/presentation/UI/widgets/showLogoutDialog.dart';
import '../../data/model/menu_model.dart';
import '../bloc/menuBloc.dart';
import '../bloc/menu_event.dart';
import '../bloc/menu_state.dart';

class MenuScreen extends StatefulWidget {
  final String restaurantId;
  final Room? room;

  const MenuScreen({super.key, required this.restaurantId, this.room});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _selectedCategoryIndex = 0;
  final GetOpenRoomsUseCase _getOpenRoomsUseCase = GetOpenRoomsUseCase();
  final AddMenuItemToRoomUseCase _addMenuItemToRoomUseCase =
      AddMenuItemToRoomUseCase();
  final AddItemToCartUseCase _addItemToCartUseCase = AddItemToCartUseCase();

  @override
  void initState() {
    super.initState();
    NavigationHistoryService().saveLastPosition(
      'menu',
      routeName: 'menu',
      routeData: widget.restaurantId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MenuBloc()..add(LoadMenuEvent(widget.restaurantId)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          title: Text(
            'menu'.tr(),
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, size: 20.w, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            Builder(builder: (context) {
              return Padding(
                padding: EdgeInsets.only(right: 5.w),
                child: IconButton(
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  icon: Icon(Icons.menu_rounded,
                      size: 40.sp, color: Colors.black),
                ),
              );
            }),
          ],
        ),
        body: BlocBuilder<MenuBloc, MenuState>(
          builder: (context, state) {
            if (state is MenuLoading) {
              return _buildShimmerLoading();
            } else if (state is MenuLoaded) {
              final categories = state.categories;
              return SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Pills
                    _buildCategoryList(categories),
                    // Grid Items
                    Expanded(child: _buildMenuGrid(categories)),
                  ],
                ),
              );
            } else if (state is MenuError) {
              return Center(
                child: Text(state.message, style: TextStyle(fontSize: 14.sp)),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        endDrawer: Container(
          margin: EdgeInsets.only(top: 60.h, right: 2.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.r),
            color: Colors.white.withOpacity(0.9),
          ),
          height: 800.h,
          width: 214.w,
          child: Drawer(
            child: Column(
              children: [
                SizedBox(
                  height: 50.h,
                ),
                Container(
                  height: 68.h,
                  width: 68.w,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Color(0xffEEEEEE)),
                  child: Icon(
                    Icons.person,
                    size: 40.sp,
                    color: Color(0xff8E8E8E),
                  ),
                ),
                SizedBox(height: 15.h),
                Text(
                  'John Doe',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff000000),
                  ),
                ),
                SizedBox(height: 15.h),
                Text(
                  'johnDoe@gmail.com',
                  style: TextStyle(fontSize: 14.sp, color: Color(0xff8E8E8E)),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Divider(
                  thickness: 1,
                  color: Colors.grey.withOpacity(0.3),
                  indent: 10.w,
                  endIndent: 10.w,
                ),
                SizedBox(
                  height: 15.h,
                ),
                InkWell(
                  onTap: () {},
                  child: SizedBox(
                    height: 40.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.home_outlined,
                          color: AppColors.primaryColor,
                          size: 30.sp,
                        ),
                        Text('dashboard'.tr(),
                            style: getDynamicStyle(context, size: 14.sp)),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                BottomNavigationBar(index: 1)));
                  },
                  child: SizedBox(
                    height: 40.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.list_alt_sharp,
                          color: AppColors.primaryColor,
                          size: 30.sp,
                        ),
                        Text(
                          'restaurants_list'.tr(),
                          style: getDynamicStyle(context, size: 14.sp),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                InkWell(
                  onTap: () {},
                  child: SizedBox(
                    height: 40.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.history,
                          color: AppColors.primaryColor,
                          size: 30.sp,
                        ),
                        Text(
                          'latest_orders'.tr(),
                          style: getDynamicStyle(context, size: 14.sp),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyRoomsPresenter()));
                  },
                  child: SizedBox(
                    height: 40.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.group,
                          color: AppColors.primaryColor,
                          size: 30.sp,
                        ),
                        Text(
                          'orders_groups'.tr(),
                          style: getDynamicStyle(context, size: 14.sp),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                InkWell(
                  onTap: () {},
                  child: SizedBox(
                    height: 40.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.settings,
                          color: AppColors.primaryColor,
                          size: 30.sp,
                        ),
                        Text(
                          'settings'.tr(),
                          style: getDynamicStyle(context, size: 14.sp),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Divider(
                  thickness: 2,
                  color: Colors.grey.withOpacity(0.3),
                  indent: 10.w,
                  endIndent: 10.w,
                ),
                SizedBox(
                  height: 20.h,
                ),
                InkWell(
                  onTap: () {
                    showLogoutDialog(context, () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    });
                  },
                  child: SizedBox(
                    height: 40.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.power_settings_new,
                          color: AppColors.primaryColor,
                          size: 30.sp,
                        ),
                        Text(
                          'logout'.tr(),
                          style: getDynamicStyle(context, size: 14.sp),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryList(List<MenuCategoryModel> categories) {
    return SizedBox(
      height: 50.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          bool isSelected = index == _selectedCategoryIndex;
          return InkWell(
            onTap: () {
              setState(() {
                _selectedCategoryIndex = index;
              });
            },
            child: Container(
              margin: EdgeInsets.only(right: 10.w, top: 8.h, bottom: 8.h),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFD32F2F) : Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFD32F2F)
                      : Colors.grey.shade300,
                  width: 1,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                categories[index].name,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

// 🔥 ONLY THIS PART CHANGED INSIDE _buildMenuGrid

  Widget _buildMenuGrid(List<MenuCategoryModel> categories) {
    if (categories.isEmpty) return const SizedBox.shrink();

    final currentCategory =
    categories[_selectedCategoryIndex.clamp(0, categories.length - 1)];
    final items = currentCategory.items;

    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.58,
        crossAxisSpacing: 14.w,
        mainAxisSpacing: 16.h,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return MenuItemCard(
          item: items[index],
          onAdd: () {
            _showPickDestinationBottomSheet(context, items[index]);
          },
        );
      },
    );
  }

  void _showPickDestinationBottomSheet(
      BuildContext context, MenuItemModel item) {
    final openRooms = _getOpenRoomsUseCase.call();
    final notesController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      useSafeArea: true,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setSheetState) {
          return SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                padding: EdgeInsets.all(20.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Nunito',
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${item.price.toStringAsFixed(2)} EGP',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Nunito',
                        color: AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    TextField(
                      controller: notesController,
                      decoration: InputDecoration(
                        hintText: 'Add notes (e.g., No onions, Extra cheese)',
                        hintStyle: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 13.sp,
                          color: Colors.grey[400],
                        ),
                        prefixIcon: Icon(Icons.edit_note, color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                      ),
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 14.sp,
                        color: Colors.black,
                      ),
                      maxLines: 2,
                      textInputAction: TextInputAction.done,
                    ),
                    SizedBox(height: 20.h),

                    SizedBox(
                      width: double.infinity,
                      height: 48.h,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _addItemToCartUseCase.call(
                            item,
                            notes: notesController.text.trim().isEmpty
                                ? null
                                : notesController.text.trim(),
                          );

                          Navigator.pop(ctx);

                          AppMessage.showSnackBar(
                            context,
                            'Added to cart',
                            const Color(0xFF71BC55),
                            Icons.check_circle,
                          );
                        },
                        icon: Icon(Icons.shopping_cart_outlined, size: 20.sp),
                        label: Text(
                          'Add to Cart',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Nunito',
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: ExpansionTile(
                        tilePadding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                        childrenPadding: EdgeInsets.symmetric(horizontal: 16.w),
                        shape: const RoundedRectangleBorder(),
                        collapsedShape: const RoundedRectangleBorder(),
                        leading: Icon(Icons.group, color: AppColors.primaryColor),
                        title: Text(
                          'Add to Room',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          '${openRooms.length} open room(s)',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 12.sp,
                            color: Colors.grey[500],
                          ),
                        ),
                        children: openRooms.isEmpty
                            ? [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            child: Text(
                              'No open rooms yet. Create a room first.',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontFamily: 'Nunito',
                                color: Colors.grey[500],
                              ),
                            ),
                          ),
                        ]
                            : openRooms
                            .map((room) => _buildRoomTile(ctx, room, item, notesController))
                            .toList(),
                      ),
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Widget _buildRoomTile(
      BuildContext bottomSheetContext,
      Room room,
      MenuItemModel item,
      TextEditingController notesController,) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        room.name,
        style: TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w600,
          fontSize: 14.sp,
          color: Colors.black,
        ),
      ),
      subtitle: Text(
        '${room.orders.length} orders',
        style: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 12.sp,
          color: const Color.fromARGB(255, 96, 96, 96),
        ),
      ),
      trailing: Icon(
        Icons.add_circle,
        color: AppColors.primaryColor,
        size: 22.sp,
      ),
      onTap: () {
        final notes = notesController.text.trim().isEmpty
            ? null
            : notesController.text.trim();
        _addMenuItemToRoomUseCase.call(room: room, item: item, notes: notes);
        Navigator.pop(bottomSheetContext);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Added to ${room.name}',
              style: const TextStyle(fontFamily: 'Nunito'),
            ),
            backgroundColor: AppColors.primaryColor,
            duration: const Duration(seconds: 1),
          ),
        );
      },
    );
  }

  Widget _buildShimmerLoading() {
    return Column(
      children: [
        SizedBox(
          height: 50.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: AppColors.primaryColor,
                highlightColor: Colors.grey[300]!,
                child: Container(
                  margin: EdgeInsets.only(right: 10.w, top: 8.h, bottom: 8.h),
                  width: 100.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
              );
            },
          ),
        ),

        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.58,
              crossAxisSpacing: 14.w,
              mainAxisSpacing: 16.h,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 24.w, color: isSelected ? Colors.red : Colors.grey),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: isSelected ? Colors.red : Colors.grey,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
