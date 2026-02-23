import 'dart:io';
import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image/image.dart' as img;
import '../../../../core/utils/imageHelper.dart';
import '../../../../core/utils/text_font_transformer.dart';

class CropProfileScreen extends StatefulWidget {
  final File? initialImageFile;
  final Uint8List? initialImageBytes;

  const CropProfileScreen({
    super.key,
    this.initialImageFile,
    this.initialImageBytes,
  });

  @override
  State<CropProfileScreen> createState() => _CropProfileScreenState();
}

class _CropProfileScreenState extends State<CropProfileScreen> {
  final editorKey = GlobalKey<ExtendedImageEditorState>();
  File? _currentFile;
  Uint8List? _currentBytes;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentFile = widget.initialImageFile;
    _currentBytes = widget.initialImageBytes;
  }

  Future<void> _pickNewImage() async {
    final File? file = await ImageHelper.pickFromGallery();
    if (file != null) {
      setState(() {
        _currentFile = file;
        _currentBytes = null;
      });
    }
  }

  Future<void> _cropImage() async {
    final state = editorKey.currentState;
    if (state == null || (_currentFile == null && _currentBytes == null)) return;

    setState(() => _isLoading = true);

    try {
      final Rect? cropRect = state.getCropRect();
      final Uint8List data = state.rawImageData;

      if (cropRect != null) {
        final img.Image? decoded = img.decodeImage(data);
        if (decoded != null) {
          final img.Image cropped = img.copyCrop(
            decoded,
            x: cropRect.left.toInt(),
            y: cropRect.top.toInt(),
            width: cropRect.width.toInt(),
            height: cropRect.height.toInt(),
          );

          final Uint8List result =
          Uint8List.fromList(img.encodeJpg(cropped, quality: 80));

          if (mounted) {
            Navigator.pop(context, result);
          }
        }
      }
    } catch (e) {
      debugPrint("Crop error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool hasImage = _currentFile != null || _currentBytes != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 22.w),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
        ),
        title: Text(
          "preview_photo".tr(),
          style: getDynamicStyle(context, size: 24, weight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(45.r),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(45.r),
                      child: !hasImage
                          ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(30.w),
                            decoration: const BoxDecoration(
                              color: Color(0xFFBDBDBD),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.image_not_supported,
                              size: 50.sp,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            "no_image_uploaded".tr(),
                            style: getDynamicStyle(context, size: 18, color: Colors.grey, weight: FontWeight.bold),
                          ),
                        ],
                      )
                          : _currentFile != null
                          ? ExtendedImage.file(
                        _currentFile!,
                        fit: BoxFit.contain,
                        cacheRawData: true,
                        mode: ExtendedImageMode.editor,
                        extendedImageEditorKey: editorKey,
                        initEditorConfigHandler: (state) => EditorConfig(
                          maxScale: 8.0,
                          cropAspectRatio: 1.0,
                        ),
                      )
                          : ExtendedImage.memory(
                        _currentBytes!,
                        fit: BoxFit.contain,
                        cacheRawData: true,
                        mode: ExtendedImageMode.editor,
                        extendedImageEditorKey: editorKey,
                        initEditorConfigHandler: (state) => EditorConfig(
                          maxScale: 8.0,
                          cropAspectRatio: 1.0,
                          cornerColor: const Color(0xFFCF2120),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                child: Column(
                  children: [
                    OutlinedButton(
                      onPressed: _isLoading ? null : _pickNewImage,
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(double.infinity, 55.h),
                        side: const BorderSide(color: Colors.grey, width: 0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                      ),
                      child: Text(
                        (!hasImage ? "upload_profile_picture" : "change_photo").tr(),
                        style: getDynamicStyle(context, size: 20, color: const Color(0xFFCF2120)),
                      ),
                    ),
                    SizedBox(height: 15.h),
                    if (hasImage)
                      ElevatedButton(
                        onPressed: _isLoading ? null : _cropImage,
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 55.h),
                          backgroundColor: const Color(0xFFCF2120),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                        ),
                        child: Text(
                          "confirm".tr(),
                          style: getDynamicStyle(context, size: 20, color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: CircularProgressIndicator(
                  color: const Color(0xFFCF2120),
                ),
              ),
            ),
        ],
      ),
    );
  }
}