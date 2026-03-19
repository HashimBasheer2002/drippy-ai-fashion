import cv2
import numpy as np
from sklearn.cluster import KMeans
import logging

logger = logging.getLogger(__name__)


def extract_color_palette(image_path, k=3):
    """
    Extract dominant colors from image using KMeans
    Returns HEX color list
    """

    try:
        image = cv2.imread(image_path)

        if image is None:
            raise ValueError("Image not loaded")

        # -----------------------------
        # RESIZE (BALANCED)
        # -----------------------------
        image = cv2.resize(image, (150, 150))

        # -----------------------------
        # CONVERT TO RGB
        # -----------------------------
        image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)

        # -----------------------------
        # FLATTEN
        # -----------------------------
        pixels = image.reshape((-1, 3))

        # -----------------------------
        # KMEANS (STABLE)
        # -----------------------------
        kmeans = KMeans(
            n_clusters=k,
            n_init=10,
            random_state=42  # ✅ deterministic
        )

        kmeans.fit(pixels)

        colors = kmeans.cluster_centers_.astype(int)

        # -----------------------------
        # CLEAN + UNIQUE COLORS
        # -----------------------------
        unique_colors = []
        for c in colors:
            color_tuple = tuple(c.tolist())
            if color_tuple not in unique_colors:
                unique_colors.append(color_tuple)

        # -----------------------------
        # CONVERT TO HEX
        # -----------------------------
        hex_colors = [
            "#{:02x}{:02x}{:02x}".format(c[0], c[1], c[2])
            for c in unique_colors
        ]

        return hex_colors[:k]  # ensure max k

    except Exception as e:
        logger.error(f"[COLOR PALETTE ERROR] {e}")
        return []