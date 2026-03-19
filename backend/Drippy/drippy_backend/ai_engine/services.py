import logging

from .analyzers.color_palette import extract_color_palette
from .classifiers.style_classifier import classify_style
from .features.feature_extractor import extract_features

from .scoring.drip_score import (
    calculate_drip_score,
    score_color_harmony,
    score_structure,
    score_completeness,
    score_accessories,
    score_style,
)

# ✅ Gemini Provider
from .ai_providers.gemini_provider import GeminiProvider

# ✅ IMPORT CORRECT SUGGESTION ENGINE
from .suggestions.suggestions_engine import generate_suggestions

logger = logging.getLogger(__name__)


# -----------------------------
# DEFAULT SAFE RESPONSE
# -----------------------------
def default_ai_response():
    return {
        "score": 5.0,
        "items": {},
        "colors": [],
        "style": "unknown",
        "confidence": 0.0,
        "confidence_label": "Low",
        "feedback": "Unable to analyze outfit properly.",
        "breakdown": {},
        "features": {},
    }


# -----------------------------
# NORMALIZE ITEMS
# -----------------------------
def normalize_items(items):
    if not isinstance(items, dict):
        return {
            "top": None,
            "bottom": None,
            "shoes": None,
            "accessories": [],
        }

    return {
        "top": items.get("top") or None,
        "bottom": items.get("bottom") or None,
        "shoes": items.get("shoes") or None,
        "accessories": items.get("accessories") or [],
    }


# -----------------------------
# CORE PIPELINE
# -----------------------------
def analyze_drip_core(drip):

    image_path = drip.image.path
    provider = GeminiProvider()

    # -----------------------------
    # 1. ITEMS (GEMINI)
    # -----------------------------
    try:
        raw_items = provider.detect_items(image_path)
    except Exception as e:
        logger.error(f"[ITEM DETECTION ERROR] {e}")
        raw_items = {}

    items = normalize_items(raw_items)
    logger.info(f"[AI ITEMS] {items}")

    # -----------------------------
    # 2. COLORS
    # -----------------------------
    try:
        colors = extract_color_palette(image_path)
    except Exception as e:
        logger.error(f"[COLOR ERROR] {e}")
        colors = []

    # -----------------------------
    # 3. STYLE (CLIP)
    # -----------------------------
    try:
        style_data = classify_style(image_path)
    except Exception as e:
        logger.error(f"[STYLE ERROR] {e}")
        style_data = {}

    style = style_data.get("style", "unknown")
    confidence = style_data.get("confidence", 0.0)
    confidence_label = style_data.get("confidence_label", "Low")

    # -----------------------------
    # 4. FEATURES
    # -----------------------------
    try:
        features = extract_features(image_path, items or {})
    except Exception as e:
        logger.error(f"[FEATURE ERROR] {e}")
        features = {}

    # -----------------------------
    # SCORING
    # -----------------------------
    color_score = score_color_harmony(colors)
    structure_score = score_structure(items)
    completeness_score = score_completeness(items)
    accessories_score = score_accessories(items)
    style_score = score_style(style)

    score = calculate_drip_score(
        items or {},
        colors or [],
        style or "unknown"
    )

    # -----------------------------
    # SUGGESTIONS (FIXED)
    # -----------------------------
    suggestions = generate_suggestions(features, style, items)
    feedback = " | ".join(suggestions)

    return {
        "score": score,
        "items": items,
        "colors": colors,
        "style": style,
        "confidence": confidence,
        "confidence_label": confidence_label,
        "feedback": feedback,
        "features": features,
        "breakdown": {
            "color": color_score,
            "structure": structure_score,
            "completeness": completeness_score,
            "accessories": accessories_score,
            "style": style_score,
        },
    }


# -----------------------------
# SAFE WRAPPER
# -----------------------------
def analyze_drip_safe(drip):

    try:
        result = analyze_drip_core(drip)

        if not result or not isinstance(result, dict):
            raise ValueError("Invalid AI result")

    except Exception as e:
        logger.error(f"[AI ERROR] Drip {drip.id}: {str(e)}")
        result = default_ai_response()

    drip.ai_score = float(result.get("score") or 5.0)

    drip.detected_items = {
        "top": result.get("items", {}).get("top"),
        "bottom": result.get("items", {}).get("bottom"),
        "shoes": result.get("items", {}).get("shoes"),
        "accessories": result.get("items", {}).get("accessories", []),
        "colors": result.get("colors", []),
        "style": result.get("style", "unknown"),
        "confidence": result.get("confidence", 0.0),
        "confidence_label": result.get("confidence_label", "Low"),
        "features": result.get("features", {}),
        "breakdown": result.get("breakdown", {}),
    }

    drip.feedback = result.get("feedback", "")
    drip.save(update_fields=["ai_score", "detected_items", "feedback"])

    return result


# -----------------------------
# ENTRY POINT
# -----------------------------
def analyze_drip(drip):
    return analyze_drip_safe(drip)


# -----------------------------
# OUTFIT WRAPPER
# -----------------------------
def analyze_outfit(outfit):

    try:
        result = analyze_drip_core(outfit)

    except Exception as e:
        logger.error(f"[OUTFIT AI ERROR] {outfit.id}: {str(e)}")
        result = default_ai_response()

    outfit.ai_score = float(result.get("score") or 5.0)

    outfit.detected_items = {
        "top": result.get("items", {}).get("top"),
        "bottom": result.get("items", {}).get("bottom"),
        "shoes": result.get("items", {}).get("shoes"),
        "accessories": result.get("items", {}).get("accessories", []),
        "colors": result.get("colors", []),
        "style": result.get("style", "unknown"),
        "confidence": result.get("confidence", 0.0),
        "confidence_label": result.get("confidence_label", "Low"),
        "features": result.get("features", {}),
        "breakdown": result.get("breakdown", {}),
    }

    outfit.feedback = result.get("feedback", "")
    outfit.save(update_fields=["ai_score", "detected_items", "feedback"])

    return result