def generate_suggestions(features, style, items=None):

    if not isinstance(features, dict):
        features = {}

    if not isinstance(items, dict):
        items = {}

    suggestions = []

    contrast = features.get("contrast")
    palette = features.get("palette_type")
    structure = features.get("structure")
    brightness = features.get("brightness")

    accessories = items.get("accessories") or []
    has_accessories = len(accessories) > 0

    # -----------------------------
    # STYLE-LEVEL ANALYSIS
    # -----------------------------
    if style == "streetwear":
        if not has_accessories:
            suggestions.append(
                "Adding accessories like a chain, cap, or crossbody bag can elevate the streetwear aesthetic."
            )

    elif style == "minimal":
        if palette == "vibrant":
            suggestions.append(
                "Toning down the color intensity would better align with a minimal aesthetic."
            )

    elif style == "formal":
        if palette == "vibrant":
            suggestions.append(
                "Subtle and muted tones would enhance the elegance of this formal look."
            )

    # -----------------------------
    # COLOR INTELLIGENCE
    # -----------------------------
    if contrast == "low":
        suggestions.append(
            "Introducing a contrasting piece can improve visual depth and separation."
        )

    elif contrast == "high":
        suggestions.append(
            "The contrast is strong—ensuring cohesion between pieces will keep the look refined."
        )

    if palette == "neutral" and style != "minimal":
        suggestions.append(
            "A subtle accent color could add more visual interest without overwhelming the outfit."
        )

    # -----------------------------
    # STRUCTURE
    # -----------------------------
    if structure == "top-heavy":
        suggestions.append(
            "Balancing the lower half with heavier or more structured pieces would improve proportions."
        )

    elif structure == "bottom-heavy":
        suggestions.append(
            "Adding layering or detail to the upper half can help balance the silhouette."
        )

    # -----------------------------
    # BRIGHTNESS BALANCE
    # -----------------------------
    if brightness == "dark" and contrast == "low":
        suggestions.append(
            "Introducing lighter elements can break the monotony and add dimension."
        )

    elif brightness == "light" and contrast == "low":
        suggestions.append(
            "Adding a darker element can help ground the outfit and create balance."
        )

    # -----------------------------
    # COMPLETENESS CHECK
    # -----------------------------
    if not items.get("shoes"):
        suggestions.append(
            "Footwear plays a key role in finishing the outfit—consider refining it."
        )

    # -----------------------------
    # HIGH-QUALITY OUTFIT HANDLING
    # -----------------------------
    if not suggestions:
        suggestions.append(
            "Clean, well-balanced outfit with a cohesive palette. Subtle additions like accessories or layering could elevate it further."
        )

    # -----------------------------
    # REMOVE DUPLICATES (SAFE)
    # -----------------------------
    suggestions = list(dict.fromkeys(suggestions))

    return suggestions[:3]