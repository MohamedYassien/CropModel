import 'package:cropmodel/core/constants/app_colors.dart';
import 'package:cropmodel/features/Menu/presentation/UI/widgets/MenuItemCard.dart';
import 'package:cropmodel/features/room/data/model/room.dart';
import 'package:cropmodel/features/room/domain/usecases/add_menu_item_to_room_usecase.dart';
import 'package:cropmodel/features/room/domain/usecases/get_open_rooms_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

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
            'Menu',
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
            IconButton(
              icon: Icon(Icons.menu, size: 24.w, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
        body: BlocBuilder<MenuBloc, MenuState>(
          builder: (context, state) {
            if (state is MenuLoading) {
              return _buildShimmerLoading();
            } else if (state is MenuLoaded) {
              final categories = state.categories;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Pills
                  _buildCategoryList(categories),
                  // Grid Items
                  Expanded(child: _buildMenuGrid(categories)),
                ],
              );
            } else if (state is MenuError) {
              return Center(
                child: Text(state.message, style: TextStyle(fontSize: 14.sp)),
              );
            }
            return const SizedBox.shrink();
          },
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
            final room = widget.room;
            if (room != null) {
              _addMenuItemToRoomUseCase.call(room: room, item: items[index]);
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
              return;
            }
            _showPickRoomBottomSheet(context, items[index]);
          },
        );
      },
    );
  }

  void _showPickRoomBottomSheet(BuildContext context, MenuItemModel item) {
    final openRooms = _getOpenRoomsUseCase.call();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add to room',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Nunito',
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 14.h),
              if (openRooms.isEmpty)
                Text(
                  'No open rooms yet. Create a room first.',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontFamily: 'Nunito',
                    color: const Color.fromARGB(255, 96, 96, 96),
                  ),
                )
              else
                ...openRooms.map((room) => _buildRoomTile(ctx, room, item)),
              SizedBox(height: 10.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRoomTile(
    BuildContext bottomSheetContext,
    Room room,
    MenuItemModel item,
  ) {
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
        _addMenuItemToRoomUseCase.call(room: room, item: item);
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
        // Grid shimmer
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
