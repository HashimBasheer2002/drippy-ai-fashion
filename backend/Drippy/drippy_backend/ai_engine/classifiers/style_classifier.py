import torch
import open_clip
from PIL import Image
import logging

logger = logging.getLogger(__name__)

# -----------------------------
# DEVICE (IMPORTANT)
# -----------------------------
DEVICE = "cuda" if torch.cuda.is_available() else "cpu"

# -----------------------------
# LOAD MODEL (ONCE)
# -----------------------------
model, _, preprocess = open_clip.create_model_and_transforms(
    'ViT-B-32',
    pretrained='openai'
)

model = model.to(DEVICE)
model.eval()

tokenizer = open_clip.get_tokenizer('ViT-B-32')

# -----------------------------
# IMPROVED STYLE LABELS
# -----------------------------
STYLE_LABELS = [
    "a streetwear fashion outfit",
    "a minimal clean outfit",
    "a casual everyday outfit",
    "a formal elegant outfit",
    "an old money aesthetic outfit",
    "a vintage retro outfit",
    "a techwear futuristic outfit",
]


# -----------------------------
# SAFE IMAGE LOADER
# -----------------------------
def load_image(image_path):
    try:
        image = Image.open(image_path).convert("RGB")
        return preprocess(image).unsqueeze(0).to(DEVICE)
    except Exception as e:
        logger.error(f"[IMAGE LOAD ERROR] {e}")
        return None


# -----------------------------
# CLASSIFY STYLE
# -----------------------------
def classify_style(image_path):

    try:
        image_tensor = load_image(image_path)

        if image_tensor is None:
            raise ValueError("Invalid image")

        text_tokens = tokenizer(STYLE_LABELS).to(DEVICE)

        with torch.no_grad():
            image_features = model.encode_image(image_tensor)
            text_features = model.encode_text(text_tokens)

            # normalize safely
            image_features = image_features / image_features.norm(dim=-1, keepdim=True)
            text_features = text_features / text_features.norm(dim=-1, keepdim=True)

            similarity = (image_features @ text_features.T).softmax(dim=-1)

        probs = similarity[0].cpu().tolist()

        best_idx = probs.index(max(probs))
        confidence_raw = probs[best_idx]

        # -----------------------------
        # CONFIDENCE LABEL
        # -----------------------------
        if confidence_raw > 0.6:
            confidence_label = "High"
        elif confidence_raw > 0.4:
            confidence_label = "Medium"
        else:
            confidence_label = "Low"

        # clean label output
        style = STYLE_LABELS[best_idx] \
            .replace("a ", "") \
            .replace("an ", "") \
            .replace(" outfit", "") \
            .strip()

        return {
            "style": style,
            "confidence": round(confidence_raw * 100, 2),
            "confidence_label": confidence_label,
        }

    except Exception as e:
        logger.error(f"[STYLE CLASSIFIER ERROR] {e}")

        return {
            "style": "unknown",
            "confidence": 0.0,
            "confidence_label": "Low",
        }