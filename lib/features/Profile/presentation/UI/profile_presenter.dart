import 'dart:io';
import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/text_font_transformer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';

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
  File? _currentFile;
  Uint8List? _currentBytes;
  bool _isLoading = false;
  bool _isEditing = false;
  final GlobalKey _renderKey = GlobalKey();

  final TransformationController _transformationController = TransformationController();

  @override
  void initState() {
    super.initState();
    _currentFile = widget.initialImageFile;
    _currentBytes = widget.initialImageBytes;
    if (_currentBytes != null || _currentFile != null) {
      _isEditing = false;
    }
  }

  void _updateZoom(double factor) {
    _transformationController.value = _transformationController.value.clone()..scale(factor);
  }

  Future<Uint8List?> _captureCroppedImage() async {
    try {
      RenderRepaintBoundary boundary =
      _renderKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint("Error capturing image: $e");
      return null;
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedImage = await ImagePicker().pickImage(
        source: source,
        imageQuality: 100,
      );

      if (pickedImage == null) return;
      final Uint8List bytes = await pickedImage.readAsBytes();

      setState(() {
        _currentFile = File(pickedImage.path);
        _currentBytes = bytes;
        _isEditing = true;
        _transformationController.value = Matrix4.identity();
      });
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  Future<void> _handlePermissionAndPick(ImageSource source) async {
    PermissionStatus status = source == ImageSource.camera
        ? await Permission.camera.request()
        : (Platform.isAndroid ? await Permission.photos.request() : await Permission.photos.request());

    if (status.isGranted) {
      _pickImage(source);
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  void _showPickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text("gallery".tr()),
              onTap: () { Navigator.pop(context); _handlePermissionAndPick(ImageSource.gallery); },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text("camera".tr()),
              onTap: () { Navigator.pop(context); _handlePermissionAndPick(ImageSource.camera); },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool hasImage = _currentFile != null || _currentBytes != null;
    String buttonText = hasImage ? "change_photo".tr() : "upload_profile_picture".tr();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        title: Text("preview_photo".tr(), style: getDynamicStyle(context, size: 24, weight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: _isEditing
                  ? _buildEditorView(hasImage)
                  : _buildPreviewView(hasImage),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              children: [
                OutlinedButton(
                  onPressed: () => _showPickerOptions(context),
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(double.infinity, 55.h),
                    side: BorderSide(color: AppColors.primaryColor.withOpacity(0.5)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
                  ),
                  child: Text(buttonText, style: getDynamicStyle(context, size: 18, color: AppColors.primaryColor)),
                ),
                if (_isEditing) ...[
                  SizedBox(height: 12.h),
                  ElevatedButton(
                    onPressed: _isLoading ? null : () async {
                      setState(() => _isLoading = true);
                      Uint8List? croppedImage = await _captureCroppedImage();
                      setState(() => _isLoading = false);
                      if (croppedImage != null) {
                        Navigator.pop(context, croppedImage);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 55.h),
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
                    ),
                    child: _isLoading
                        ? SizedBox(height: 20.h, width: 20.h, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Text("confirm".tr(), style: getDynamicStyle(context, size: 18, color: Colors.white)),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewView(bool hasImage) {
    return CircleAvatar(
      radius: 140.r,
      backgroundColor: Colors.grey[100],
      backgroundImage: _currentBytes != null
          ? MemoryImage(_currentBytes!)
          : (hasImage ? FileImage(_currentFile!) : null) as ImageProvider?,
      child: !hasImage
          ? Icon(Icons.person, size: 100.sp, color: Colors.grey[400])
          : null,
    );
  }

  Widget _buildEditorView(bool hasImage) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 24.w),
          width: double.infinity,
          height: 550.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30.r),
            child: Stack(
              alignment: Alignment.center,
              children: [
                RepaintBoundary(
                  key: _renderKey,
                  child: Container(
                    color: Colors.white,
                    width: double.infinity,
                    height: 550.h,
                    child: InteractiveViewer(
                      transformationController: _transformationController,
                      boundaryMargin: EdgeInsets.zero, // The "Wall"
                      minScale: 1.0,
                      maxScale: 8.0,
                      child: SizedBox(
                        width: double.infinity,
                        height: 550.h,
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: _currentBytes != null
                              ? Image.memory(_currentBytes!)
                              : Image.file(_currentFile!),
                        ),
                      ),
                    ),
                  ),
                ),
                IgnorePointer(
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.6),
                      BlendMode.srcOut,
                    ),
                    child: Stack(
                      children: [
                        Container(decoration: const BoxDecoration(color: Colors.black, backgroundBlendMode: BlendMode.dstOut)),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 280.w,
                            height: 280.w,
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 10.h,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.r),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(onPressed: () => _updateZoom(1.1), icon: const Icon(Icons.add)),
                IconButton(onPressed: () => _updateZoom(0.9), icon: const Icon(Icons.remove)),
                Container(width: 1, height: 20, color: Colors.grey[300]),
                TextButton(
                  onPressed: () => setState(() => _transformationController.value = Matrix4.identity()),
                  child: const Text("Reset", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ],
    );

  }
}