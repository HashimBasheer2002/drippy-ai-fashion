# -----------------------------
# COLOR HARMONY
# -----------------------------
def score_color_harmony(colors):
    if not colors:
        return 4  # safer baseline

    unique_colors = len(set(colors))

    if unique_colors == 1:
        return 5
    if unique_colors == 2:
        return 8
    if unique_colors == 3:
        return 9
    if unique_colors >= 4:
        return 6

    return 6


# -----------------------------
# STRUCTURE
# -----------------------------
def score_structure(items):
    if not items:
        return 5  # fallback baseline

    score = 0

    if items.get("top"):
        score += 3
    if items.get("bottom"):
        score += 3
    if items.get("shoes"):
        score += 4

    # prevent zero score collapse
    return score if score > 0 else 5


# -----------------------------
# COMPLETENESS
# -----------------------------
def score_completeness(items):
    if not items:
        return 5

    count = sum([
        1 if items.get("top") else 0,
        1 if items.get("bottom") else 0,
        1 if items.get("shoes") else 0,
    ])

    score = (count / 3) * 10

    # avoid extreme penalty due to AI miss
    return max(score, 4)


# -----------------------------
# ACCESSORIES
# -----------------------------
def score_accessories(items):
    accessories = items.get("accessories", []) if items else []

    if not accessories:
        return 5  # slightly less harsh
    if len(accessories) == 1:
        return 7
    if len(accessories) >= 2:
        return 9

    return 5


# -----------------------------
# STYLE
# -----------------------------
def score_style(style):
    if not style or style == "unknown":
        return 5
    return 7


# -----------------------------
# FINAL SCORE
# -----------------------------
def calculate_drip_score(items, colors, style):

    # safety normalization
    items = items or {}
    colors = colors or []
    style = style or "unknown"

    color_score = score_color_harmony(colors)
    structure_score = score_structure(items)
    completeness_score = score_completeness(items)
    accessories_score = score_accessories(items)
    style_score = score_style(style)

    # weighted scoring
    weights = {
        "color": 0.30,
        "structure": 0.25,
        "completeness": 0.20,
        "accessories": 0.15,
        "style": 0.10,
    }

    final_score = (
        color_score * weights["color"] +
        structure_score * weights["structure"] +
        completeness_score * weights["completeness"] +
        accessories_score * weights["accessories"] +
        style_score * weights["style"]
    )

    # clamp score between 0–10
    return round(min(max(final_score, 0), 10), 2)