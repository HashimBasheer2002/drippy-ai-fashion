from ai_engine.models import AIAnalysis


def calculate_drip_score(outfit):

    try:
        ai_score = outfit.analysis.score
    except AIAnalysis.DoesNotExist:
        ai_score = 0

    rating_score = outfit.avg_rating
    engagement_score = min(outfit.views / 10, 10)

    drip_score = (
        (ai_score * 0.5)
        + (rating_score * 0.3)
        + (engagement_score * 0.2)
    )

    outfit.drip_score = round(drip_score, 2)
    outfit.save(update_fields=["drip_score"])