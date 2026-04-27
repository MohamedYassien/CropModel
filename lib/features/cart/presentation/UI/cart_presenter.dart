import 'package:cached_network_image/cached_network_image.dart';
import 'package:cropmodel/core/constants/app_colors.dart';
import 'package:cropmodel/core/shared/app_message.dart';
import 'package:cropmodel/core/utils/text_font_transformer.dart';
import 'package:flutter/material.dart' hide BottomNavigationBar;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';

class CartPresenter extends StatelessWidget {
  const CartPresenter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CartBloc()..add(LoadCartRequested()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, size: 20.w, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text(
            'Cart',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is! CartLoaded) {
              return const SizedBox.shrink();
            }

            if (state.items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart_outlined,
                        size: 64.sp, color: Colors.grey[300]),
                    SizedBox(height: 16.h),
                    Text(
                      'Your cart is empty',
                      style: getDynamicStyle(context,
                          size: 16.sp,
                          weight: FontWeight.w600,
                          color: Colors.grey[500]),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Add items from menu to get started',
                      style: getDynamicStyle(context,
                          size: 12.sp, color: Colors.grey[400]),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final cartItem = state.items[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 12,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: CachedNetworkImage(
                                imageUrl: cartItem.item.imageUrl,
                                width: 70.w,
                                height: 70.w,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    width: 70.w,
                                    height: 70.w,
                                    color: Colors.white,
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  width: 70.w,
                                  height: 70.w,
                                  color: Colors.grey[200],
                                  child: Icon(Icons.restaurant,
                                      color: Colors.grey[400], size: 30.sp),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cartItem.item.name,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Nunito',
                                      color: Colors.black,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    '${cartItem.item.price.toStringAsFixed(2)} EGP',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    '${cartItem.totalPrice.toStringAsFixed(2)} EGP total',
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      fontFamily: 'Nunito',
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      context.read<CartBloc>().add(
                                            DecrementCartItemRequested(
                                                cartItem.item),
                                          );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(8.w),
                                      child: Icon(Icons.remove,
                                          size: 18.sp,
                                          color: AppColors.primaryColor),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.w, vertical: 4.h),
                                    child: Text(
                                      '${cartItem.quantity}',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontFamily: 'Nunito',
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      context.read<CartBloc>().add(
                                          AddCartItemRequested(cartItem.item));
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(8.w),
                                      child: Icon(Icons.add,
                                          size: 18.sp,
                                          color: AppColors.primaryColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20.r)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 16,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total',
                                  style: getDynamicStyle(context,
                                      size: 12.sp,
                                      weight: FontWeight.w500,
                                      color: Colors.grey[600]),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  '${state.total.toStringAsFixed(2)} EGP',
                                  style: getDynamicStyle(context,
                                      size: 18.sp,
                                      weight: FontWeight.bold,
                                      color: AppColors.primaryColor),
                                ),
                              ],
                            ),
                            Text(
                              '${state.items.length} item(s)',
                              style: getDynamicStyle(context,
                                  size: 12.sp, color: Colors.grey[500]),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        SizedBox(
                          width: double.infinity,
                          height: 50.h,
                          child: ElevatedButton(
                            onPressed: () {
                              AppMessage.showSnackBar(
                                context,
                                'Checkout - Order placed successfully!',
                                const Color(0xFF71BC55),
                                Icons.check_circle,
                              );
                              context
                                  .read<CartBloc>()
                                  .add(ClearCartRequested());
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                            ),
                            child: Text(
                              'Checkout',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Nunito',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
