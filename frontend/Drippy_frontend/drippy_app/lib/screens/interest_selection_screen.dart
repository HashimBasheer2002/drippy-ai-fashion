
import 'package:flutter/material.dart';
import '../services/category_service.dart';

class InterestSelectionScreen extends StatefulWidget {
  const InterestSelectionScreen({super.key});

  @override
  State<InterestSelectionScreen> createState() =>
      _InterestSelectionScreenState();
}

class _InterestSelectionScreenState extends State<InterestSelectionScreen> {
  final CategoryService service = CategoryService();

  List<dynamic> categories = [];
  Set<int> selected = {};

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  void loadCategories() async {
    final data = await service.getCategories();
    setState(() => categories = data);
  }

  void toggleCategory(int id) {
    setState(() {
      if (selected.contains(id)) {
        selected.remove(id);
      } else {
        selected.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final crossAxisCount = isTablet ? 3 : 2;
    final hPad = isTablet ? size.width * 0.08 : 16.0;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// HEADER
            Padding(
              padding: EdgeInsets.fromLTRB(hPad + 8, 28, hPad + 8, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    "PERSONALIZE",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.28),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 3.5,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Choose\nYour Style",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.w800,
                      height: 1.08,
                      letterSpacing: -1,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Select the styles that match your drip.",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.38),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// SELECTION INDICATOR
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: selected.isEmpty
                        ? Text(
                            "Pick at least one to continue",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.2),
                              fontSize: 12,
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.07),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "${selected.length} styles selected",
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 12,
                              ),
                            ),
                          ),
                  ),

                  const SizedBox(height: 22),
                ],
              ),
            ),

            /// GRID
            Expanded(
              child: categories.isEmpty
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.white.withOpacity(0.2),
                      ),
                    )
                  : GridView.builder(
                      padding: EdgeInsets.symmetric(horizontal: hPad),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.76,
                      ),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {

                        final cat = categories[index];
                        final isSelected = selected.contains(cat["id"]);
                        final image = cat["image"] as String?;

                        return GestureDetector(
                          onTap: () => toggleCategory(cat["id"]),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.white.withOpacity(0.55)
                                    : Colors.white.withOpacity(0.07),
                                width: isSelected ? 1.5 : 1,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(17),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [

                                  /// IMAGE
                                  if (image != null && image.isNotEmpty)
                                    Image.network(
                                      image,
                                      fit: BoxFit.cover,
                                    )
                                  else
                                    Container(color: const Color(0xFF1A1A1A)),

                                  /// GRADIENT
                                  Positioned.fill(
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withOpacity(0.18),
                                            Colors.black.withOpacity(0.82),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  /// CATEGORY NAME
                                  Positioned(
                                    bottom: 13,
                                    left: 13,
                                    right: 40,
                                    child: Text(
                                      cat["name"],
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(
                                            isSelected ? 1.0 : 0.88),
                                        fontWeight: isSelected
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),

                                  /// CHECK ICON
                                  if (isSelected)
                                    const Positioned(
                                      bottom: 11,
                                      right: 11,
                                      child: Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),

            /// CONTINUE BUTTON
            Padding(
              padding: EdgeInsets.fromLTRB(hPad, 12, hPad, 28),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: selected.isEmpty
                      ? null
                      : () {
                          Navigator.pushReplacementNamed(context, "/upload");
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(
                        color: selected.isEmpty
                            ? Colors.white.withOpacity(0.08)
                            : Colors.white24,
                      ),
                    ),
                  ),
                  child: Text(
                    selected.isEmpty ? "SELECT A STYLE" : "CONTINUE →",
                    style: TextStyle(
                      color: selected.isEmpty
                          ? Colors.white.withOpacity(0.2)
                          : Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

