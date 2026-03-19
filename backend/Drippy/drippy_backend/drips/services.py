import random
import logging

logger = logging.getLogger(__name__)


# -----------------------------
# DEFAULT SAFE RESPONSE
# -----------------------------
def default_ai_response():
    return {
        "score": 5.0,
        "items": {},
        "feedback": "Unable to fully analyze outfit. Try uploading a clearer image.",
        "confidence": 0.0
    }


# -----------------------------
# STUB FUNCTIONS (REPLACE LATER)
# -----------------------------
def detect_items_stub():
    return {
        "top": "Black Hoodie",
        "bottom": "Blue Jeans",
        "shoes": "White Sneakers",
        "accessories": ["Silver Chain"]
    }


def generate_feedback_stub(items):
    if "White Sneakers" in str(items):
        return "Good color contrast. Consider adding layers for depth."
    return "Balanced outfit. Try adding accessories."


def calculate_score_stub(items):
    return round(random.uniform(6.0, 9.0), 2)


# -----------------------------
# CORE AI PIPELINE
# -----------------------------
def analyze_drip_core(drip):
    """
    Core AI logic (replaceable with real models later)
    """

    items = detect_items_stub()
    score = calculate_score_stub(items)
    feedback = generate_feedback_stub(items)

    return {
        "score": score,
        "items": items,
        "feedback": feedback,
        "confidence": 0.6
    }


# -----------------------------
# SAFE WRAPPER (CRITICAL)
# -----------------------------
def analyze_drip_safe(drip):
    """
    Ensures AI NEVER crashes backend
    """

    try:
        result = analyze_drip_core(drip)

        if not isinstance(result, dict):
            raise ValueError("Invalid AI response format")

        score = float(result.get("score", 5.0))
        items = result.get("items", {})
        feedback = result.get("feedback", "")

    except Exception as e:
        logger.error(f"[AI ERROR] Drip {drip.id}: {str(e)}")

        result = default_ai_response()

        score = result["score"]
        items = result["items"]
        feedback = result["feedback"]

    # SAFE ASSIGNMENT
    drip.ai_score = score
    drip.detected_items = items
    drip.feedback = feedback

    drip.save(update_fields=["ai_score", "detected_items", "feedback"])

    return result


# -----------------------------
# FINAL SCORE CALCULATION
# -----------------------------
def calculate_final_score(drip):
    """
    AI + Community (future-ready)
    """

    ai_score = drip.ai_score or 0

    if drip.total_ratings > 0:
        community_score = drip.rating_sum / drip.total_ratings
    else:
        community_score = 0

    final_score = (ai_score * 0.7) + (community_score * 0.3)

    drip.community_score = community_score
    drip.final_score = round(final_score, 2)

    drip.save(update_fields=["community_score", "final_score"])