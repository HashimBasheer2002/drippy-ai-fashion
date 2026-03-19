import numpy as np
import cv2


def analyze_colors(image_path):
    image = cv2.imread(image_path)

    if image is None:
        return {}

    # Resize for speed
    image = cv2.resize(image, (150, 150))

    # Convert to HSV (better for perception)
    hsv = cv2.cvtColor(image, cv2.COLOR_BGR2HSV)

    brightness = np.mean(hsv[:, :, 2])
    saturation = np.mean(hsv[:, :, 1])

    # -----------------------------
    # BRIGHTNESS
    # -----------------------------
    if brightness < 85:
        brightness_level = "dark"
    elif brightness < 170:
        brightness_level = "medium"
    else:
        brightness_level = "light"

    # -----------------------------
    # SATURATION
    # -----------------------------
    if saturation < 50:
        palette_type = "neutral"
    elif saturation < 120:
        palette_type = "balanced"
    else:
        palette_type = "vibrant"

    # -----------------------------
    # CONTRAST
    # -----------------------------
    contrast = np.std(hsv[:, :, 2])

    if contrast < 40:
        contrast_level = "low"
    elif contrast < 80:
        contrast_level = "medium"
    else:
        contrast_level = "high"

    return {
        "brightness": brightness_level,
        "palette_type": palette_type,
        "contrast": contrast_level,
    }

def analyze_structure(items):
    top = items.get("top")
    bottom = items.get("bottom")

    if top and not bottom:
        return "top-heavy"

    if bottom and not top:
        return "bottom-heavy"

    if top and bottom:
        return "balanced"

    return "unknown"

def extract_features(image_path, items):

    color_features = analyze_colors(image_path)
    structure = analyze_structure(items)

    return {
        **color_features,
        "structure": structure,
    }