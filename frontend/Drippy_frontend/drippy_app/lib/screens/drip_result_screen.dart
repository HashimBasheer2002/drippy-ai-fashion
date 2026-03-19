import 'package:flutter/material.dart';
import '../services/drip_service.dart';

class DripResultScreen extends StatefulWidget {
  const DripResultScreen({super.key});

  @override
  State<DripResultScreen> createState() => _DripResultScreenState();
}

class _DripResultScreenState extends State<DripResultScreen>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic>? drip;
  bool loading = true;
  bool error = false;

  late AnimationController _animController;
  late Animation<double> _scoreAnim;

  final DripService service = DripService();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _scoreAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final dripId = ModalRoute.of(context)!.settings.arguments as int;
    loadDrip(dripId);
  }

  Future<void> loadDrip(int id) async {
    try {
      final data = await service.getDrip(id);
      setState(() {
        drip = data;
        loading = false;
      });
      _animController.forward();
    } catch (e) {
      setState(() {
        error = true;
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0A0A0A),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: Colors.white24,
                strokeWidth: 1.5,
              ),
              SizedBox(height: 20),
              Text(
                "Analyzing your drip...",
                style: TextStyle(
                  color: Colors.white24,
                  fontSize: 13,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (error || drip == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF0A0A0A),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline_rounded,
                    color: Colors.white.withOpacity(0.2), size: 48),
                const SizedBox(height: 16),
                const Text(
                  "Failed to load analysis",
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white.withOpacity(0.15)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Go Back"),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final detected = drip?["detected_items"] ?? {};

    final items = [
      if (detected["top"] != null) detected["top"].toString(),
      if (detected["bottom"] != null) detected["bottom"].toString(),
      if (detected["shoes"] != null) detected["shoes"].toString(),
      if (detected["accessories"] is List)
        ...(detected["accessories"] as List).map((e) => e.toString()),
    ];

    final colors = (detected["colors"] is List)
        ? List<String>.from(detected["colors"])
        : <String>[];

    final features =
        (detected["features"] is Map) ? detected["features"] as Map : {};

    final style = detected["style"] ?? "Unknown";
    final confidenceLabel = detected["confidence_label"] ?? "Low";

    final score =
        (drip?["ai_score"] is num) ? (drip!["ai_score"]).toDouble() : 0.0;

    final feedback = drip?["feedback"] ?? "";
    final List<String> suggestions =
        feedback.isNotEmpty ? feedback.split("|") : [];

    Color confidenceColor;
    switch (confidenceLabel) {
      case "High":
        confidenceColor = const Color(0xFF4ADE80);
        break;
      case "Medium":
        confidenceColor = const Color(0xFFFBBF24);
        break;
      default:
        confidenceColor = const Color(0xFFF87171);
    }

    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final hPad = isTablet ? size.width * 0.12 : 22.0;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: hPad),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              /// ── TOP BAR ────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.08)),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white.withOpacity(0.6),
                        size: 16,
                      ),
                    ),
                  ),
                  Text(
                    "DRIP ANALYSIS",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.28),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),

              const SizedBox(height: 36),

              /// ── SCORE HERO ─────────────────────────────────────
              Center(
                child: Column(
                  children: [
                    Text(
                      "YOUR DRIP SCORE",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.28),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(height: 24),
                    AnimatedBuilder(
                      animation: _scoreAnim,
                      builder: (_, __) {
                        final displayScore = score * _scoreAnim.value;
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            /// OUTER RING
                            SizedBox(
                              width: 160,
                              height: 160,
                              child: CircularProgressIndicator(
                                value: (displayScore / 10).clamp(0.0, 1.0),
                                strokeWidth: 3,
                                backgroundColor:
                                    Colors.white.withOpacity(0.06),
                                valueColor:
                                    const AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                strokeCap: StrokeCap.round,
                              ),
                            ),
                            /// SCORE TEXT
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  displayScore.toStringAsFixed(1),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 48,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -1,
                                    height: 1,
                                  ),
                                ),
                                Text(
                                  "out of 10",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.3),
                                    fontSize: 11,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    /// STYLE + CONFIDENCE ROW
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.1)),
                          ),
                          child: Text(
                            style,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: confidenceColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: confidenceColor.withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: confidenceColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "$confidenceLabel Confidence",
                                style: TextStyle(
                                  color: confidenceColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              /// ── VISUAL ANALYSIS ────────────────────────────────
              if (features.isNotEmpty) ...[
                _sectionLabel("VISUAL ANALYSIS"),
                const SizedBox(height: 14),
                ...["brightness", "palette_type", "contrast", "structure"]
                    .where((k) => features[k] != null)
                    .map((k) => _featureTile(
                          _capitalize(k.replaceAll("_", " ")),
                          features[k],
                        )),
                const SizedBox(height: 32),
              ],

              /// ── DETECTED ITEMS ─────────────────────────────────
              if (items.isNotEmpty) ...[
                _sectionLabel("DETECTED ITEMS"),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: items.map((e) => _itemChip(e)).toList(),
                ),
                const SizedBox(height: 32),
              ],

              /// ── COLOR PALETTE ──────────────────────────────────
              if (colors.isNotEmpty) ...[
                _sectionLabel("COLOR PALETTE"),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.07)),
                  ),
                  child: Row(
                    children: [
                      /// COLOR SWATCHES
                      Expanded(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: colors.map((c) {
                            try {
                              final color = Color(
                                  int.parse(c.replaceFirst("#", "0xff")));
                              return Tooltip(
                                message: c,
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius:
                                        BorderRadius.circular(8),
                                    border: Border.all(
                                      color:
                                          Colors.white.withOpacity(0.1),
                                    ),
                                  ),
                                ),
                              );
                            } catch (_) {
                              return const SizedBox();
                            }
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],

              /// ── SUGGESTIONS ────────────────────────────────────
              _sectionLabel("STYLIST NOTES"),
              const SizedBox(height: 14),

              if (suggestions.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.06)),
                  ),
                  child: Text(
                    "No suggestions — your drip is solid.",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.35),
                      fontSize: 13,
                    ),
                  ),
                )
              else
                ...suggestions.asMap().entries.map((entry) {
                  final i = entry.key;
                  final s = entry.value.trim();
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.07)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.07),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              "${i + 1}",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            s,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 13,
                              height: 1.5,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

              const SizedBox(height: 36),

              /// ── POST BUTTON ────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, "/feed"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: const BorderSide(color: Colors.white24),
                    ),
                  ),
                  child: const Text(
                    "POST TO FEED  →",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              /// SECONDARY — share/save
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () => Navigator.pushReplacementNamed(
                      context, "/upload"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(
                        color: Colors.white.withOpacity(0.1)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    backgroundColor: Colors.white.withOpacity(0.04),
                  ),
                  child: Text(
                    "UPLOAD ANOTHER",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white.withOpacity(0.28),
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 3,
      ),
    );
  }

  Widget _featureTile(String label, dynamic value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.45),
              fontSize: 13,
              letterSpacing: 0.2,
            ),
          ),
          Text(
            value?.toString() ?? "—",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s
        .split(" ")
        .map((w) => w.isEmpty
            ? w
            : w[0].toUpperCase() + w.substring(1))
        .join(" ");
  }
}