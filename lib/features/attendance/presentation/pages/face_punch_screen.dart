import 'dart:async';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:oxcode_payroll/general/core/constants/app_colors.dart';
import 'package:oxcode_payroll/general/core/widgets/premium_app_bar.dart';

class FacePunchScreen extends StatefulWidget {
  const FacePunchScreen({super.key});

  @override
  State<FacePunchScreen> createState() => _FacePunchScreenState();
}

class _FacePunchScreenState extends State<FacePunchScreen>
    with TickerProviderStateMixin {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _isFaceDetected = false;

  late AnimationController _scanningController;
  late AnimationController _pulseController;
  late AnimationController _gridController;
  Timer? _detectionTimer;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initAnimations();

    // Smooth simulation of verification for best UX
    _startSimulation();
  }

  void _initAnimations() {
    _scanningController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _gridController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  void _startSimulation() {
    // Artificial delay to mimic "Scanning" and "Verifying" for premium feel
    _detectionTimer = Timer(const Duration(milliseconds: 2000), () {
      if (mounted) {
        HapticFeedback.mediumImpact();
        setState(() {
          _isFaceDetected = true;
        });
      }
    });
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) return;

      final frontCamera = _cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras!.first,
      );

      _controller = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller!.initialize();
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint("Camera Error: $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _scanningController.dispose();
    _pulseController.dispose();
    _gridController.dispose();
    _detectionTimer?.cancel();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (!_isFaceDetected ||
        _controller == null ||
        !_controller!.value.isInitialized) {
      HapticFeedback.vibrate();
      return;
    }

    try {
      HapticFeedback.heavyImpact();
      final XFile image = await _controller!.takePicture();
      if (mounted) {
        Navigator.pop(context, image.path);
      }
    } catch (e) {
      debugPrint("Take Picture Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _isFaceDetected ? AppColors.success : AppColors.primary;

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: const PremiumAppBar(
        title: "Biometric Identity",
        backgroundColor: Colors.transparent,
        titleColor: Colors.white,
        iconColor: Colors.white,
      ),
      body: _isInitialized
          ? Stack(
              children: [
                // 1. Full Screen Camera View
                Positioned.fill(child: CameraPreview(_controller!)),

                // 2. High-Tech Glass Overlay
                _buildGlassOverlay(statusColor),

                // 3. Central Scanning Frame
                Center(child: _buildScanningFrame(statusColor)),

                // 4. Instructional HUD
                _buildHUD(statusColor),

                // 5. Capture Controls
                _buildControls(statusColor),
              ],
            )
          : _buildLoadingState(),
    );
  }

  Widget _buildGlassOverlay(Color statusColor) {
    return Positioned.fill(
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          Colors.black.withOpacity(0.8),
          BlendMode.srcOut,
        ),
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.black,
                backgroundBlendMode: BlendMode.dstOut,
              ),
            ),
            Center(
              child: Container(
                width: 280.w,
                height: 340.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanningFrame(Color statusColor) {
    return Container(
      width: 280.w,
      height: 340.h,
      child: Stack(
        children: [
          // Subtle Neural Grid (Animated)
          if (_isFaceDetected)
            Opacity(
              opacity: 0.1,
              child: AnimatedBuilder(
                animation: _gridController,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size(280.w, 340.h),
                    painter: GridPainter(
                      progress: _gridController.value,
                      color: statusColor,
                    ),
                  );
                },
              ),
            ),

          // Glowing Scanning Line
          AnimatedBuilder(
            animation: _scanningController,
            builder: (context, child) {
              return Positioned(
                top: _scanningController.value * 340.h,
                left: 10.w,
                right: 10.w,
                child: Container(
                  height: 3.h,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: statusColor.withOpacity(0.8),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                    gradient: LinearGradient(
                      colors: [
                        statusColor.withOpacity(0),
                        statusColor,
                        statusColor.withOpacity(0),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // High-Tech Corners
          _buildCorners(statusColor),

          // Face Alignment Marking Icon
          Center(
            child: Opacity(
              opacity: _isFaceDetected ? 0.05 : 0.2,
              child: Icon(LucideIcons.user, size: 200.w, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorners(Color statusColor) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final glow = _pulseController.value * 12;
        return Stack(
          children: [
            _corner(top: 0, left: 0, color: statusColor, glow: glow),
            _corner(
              top: 0,
              right: 0,
              mirrorX: true,
              color: statusColor,
              glow: glow,
            ),
            _corner(
              bottom: 0,
              left: 0,
              mirrorY: true,
              color: statusColor,
              glow: glow,
            ),
            _corner(
              bottom: 0,
              right: 0,
              mirrorX: true,
              mirrorY: true,
              color: statusColor,
              glow: glow,
            ),
          ],
        );
      },
    );
  }

  Widget _corner({
    double? top,
    double? bottom,
    double? left,
    double? right,
    bool mirrorX = false,
    bool mirrorY = false,
    required Color color,
    required double glow,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..scale(mirrorX ? -1.0 : 1.0, mirrorY ? -1.0 : 1.0),
        child: Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: color, width: 6.w),
              left: BorderSide(color: color, width: 6.w),
            ),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24.r)),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: glow,
                spreadRadius: glow / 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHUD(Color statusColor) {
    return Positioned(
      top: 150.h,
      left: 0,
      right: 0,
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: Container(
            key: ValueKey(_isFaceDetected),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30.r),
              border: Border.all(color: statusColor.withOpacity(0.5)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _isFaceDetected
                    ? Icon(
                        LucideIcons.circleCheck,
                        color: statusColor,
                        size: 20.w,
                      )
                    : const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                SizedBox(width: 12.w),
                Text(
                  _isFaceDetected
                      ? "IDENTITY VERIFIED"
                      : "VERIFYING IDENTITY...",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControls(Color statusColor) {
    return Positioned(
      bottom: 80.h,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Text(
            _isFaceDetected
                ? "READY TO PUNCH"
                : "ALIGN YOUR FACE IN THE CENTER",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 48.h),
          GestureDetector(
            onTap: _takePicture,
            child: AnimatedScale(
              duration: const Duration(milliseconds: 300),
              scale: _isFaceDetected ? 1.0 : 0.85,
              child: Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  color: _isFaceDetected ? statusColor : Colors.white24,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3.w),
                  boxShadow: [
                    if (_isFaceDetected)
                      BoxShadow(
                        color: statusColor.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                  ],
                ),
                child: Icon(
                  _isFaceDetected ? LucideIcons.camera : LucideIcons.scanFace,
                  color: Colors.white,
                  size: 32.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }
}

class GridPainter extends CustomPainter {
  final double progress;
  final Color color;

  GridPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.12)
      ..strokeWidth = 1.0;

    const step = 30.0;
    final offset = progress * step;

    for (double i = offset; i < size.width; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = offset; i < size.height; i += step) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
