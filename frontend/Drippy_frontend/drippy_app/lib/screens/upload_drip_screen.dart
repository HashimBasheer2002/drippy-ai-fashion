import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/drip_service.dart';

class UploadDripScreen extends StatefulWidget {
  const UploadDripScreen({super.key});

  @override
  State<UploadDripScreen> createState() => _UploadDripScreenState();
}

class _UploadDripScreenState extends State<UploadDripScreen>
    with SingleTickerProviderStateMixin {
  final ImagePicker picker = ImagePicker();
  final DripService dripService = DripService();

  XFile? image;
  bool uploading = false;

  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> pickImage(ImageSource source) async {
    final picked = await picker.pickImage(
      source: source,
      imageQuality: 85,
    );
    if (picked != null) {
      setState(() => image = picked);
      _fadeController.forward(from: 0);
    }
  }

  Future<void> uploadDrip() async {
    if (image == null) return;
    setState(() => uploading = true);

    try {
      final dripId = await dripService.uploadDrip(image!);
      if (dripId != null && mounted) {
        Navigator.pushReplacementNamed(context, "/drip-result",arguments: dripId,
);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              "Upload failed. Please try again.",
              style: TextStyle(color: Colors.white, letterSpacing: 0.4),
            ),
            backgroundColor: Colors.red.shade900,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => uploading = false);
    }
  }

  void _showSourceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF141414),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Handle bar
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "SELECT SOURCE",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.3),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 16),
              _sourceOption(
                icon: Icons.photo_library_outlined,
                label: "Choose from Gallery",
                sub: "Pick an existing outfit photo",
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.gallery);
                },
              ),
              const SizedBox(height: 12),
              if (!kIsWeb)
                _sourceOption(
                  icon: Icons.camera_alt_outlined,
                  label: "Take a Photo",
                  sub: "Snap your drip right now",
                  onTap: () {
                    Navigator.pop(context);
                    pickImage(ImageSource.camera);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sourceOption({
    required IconData icon,
    required String label,
    required String sub,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.07),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white70, size: 20),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sub,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.35),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: Colors.white.withOpacity(0.3)),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview(double maxW) {
    final double previewW = (maxW - 48).clamp(200.0, 360.0);
    final double previewH = previewW * 1.3;

    if (image == null) {
      return GestureDetector(
        onTap: _showSourceSheet,
        child: Container(
          width: previewW,
          height: previewH,
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.08),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Colors.white.withOpacity(0.1), width: 1),
                ),
                child: Icon(
                  Icons.add_photo_alternate_outlined,
                  color: Colors.white.withOpacity(0.4),
                  size: 28,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "TAP TO ADD PHOTO",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.3),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Gallery or Camera",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.18),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget imgWidget = kIsWeb
        ? Image.network(image!.path, fit: BoxFit.cover)
        : Image.file(File(image!.path), fit: BoxFit.cover);

    return FadeTransition(
      opacity: _fadeAnim,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              width: previewW,
              height: previewH,
              child: imgWidget,
            ),
          ),

          /// RE-PICK BUTTON
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: _showSourceSheet,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.65),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.15)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.swap_horiz_rounded,
                        color: Colors.white.withOpacity(0.8), size: 14),
                    const SizedBox(width: 6),
                    Text(
                      "Change",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final hPad = isTablet ? size.width * 0.15 : 24.0;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: hPad),
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 28),

                      /// BACK BUTTON
                      GestureDetector(
                        onTap: () => Navigator.maybePop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.08)),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white.withOpacity(0.7),
                            size: 16,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      /// HEADER
                      Text(
                        "UPLOAD",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.28),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 3.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Your\nDrip",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          height: 1.08,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Show the world what you're wearing.",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.38),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 32),

                      /// IMAGE PREVIEW — centered
                      Center(
                        child: _buildPreview(constraints.maxWidth - hPad * 2),
                      ),

                      const SizedBox(height: 32),

                      /// TIPS ROW
                      if (image == null) ...[
                        Row(
                          children: [
                            _tipChip(Icons.light_mode_outlined,
                                "Good lighting"),
                            const SizedBox(width: 8),
                            _tipChip(
                                Icons.person_outline_rounded, "Full body"),
                            const SizedBox(width: 8),
                            _tipChip(Icons.hd_outlined, "Clear photo"),
                          ],
                        ),
                        const SizedBox(height: 32),
                      ],

                      const Spacer(),

                      /// ANALYZE BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed:
                              image == null || uploading ? null : uploadDrip,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor:
                                Colors.white.withOpacity(0.04),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side: BorderSide(
                                color: image == null
                                    ? Colors.white.withOpacity(0.08)
                                    : Colors.white24,
                              ),
                            ),
                          ),
                          child: uploading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  image == null
                                      ? "ADD A PHOTO FIRST"
                                      : "ANALYZE MY DRIP  →",
                                  style: TextStyle(
                                    color: image == null
                                        ? Colors.white.withOpacity(0.2)
                                        : Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    letterSpacing: 2,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      /// SELECT PHOTO BUTTON (secondary)
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton(
                          onPressed: uploading ? null : _showSourceSheet,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: BorderSide(
                              color: Colors.white.withOpacity(0.12),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            backgroundColor: Colors.white.withOpacity(0.04),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 18,
                                color: Colors.white.withOpacity(0.6),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                image == null
                                    ? "SELECT OUTFIT PHOTO"
                                    : "CHANGE PHOTO",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _tipChip(IconData icon, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withOpacity(0.07)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 13, color: Colors.white.withOpacity(0.35)),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.35),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}