import google.generativeai as genai
import json
from django.conf import settings

genai.configure(api_key=settings.GEMINI_API_KEY)


class GeminiProvider:

    def detect_items(self, image_path):
        try:
            model = genai.GenerativeModel("models/gemini-2.5-flash")

            prompt = """
            You are a professional fashion stylist AI.

            Analyze the outfit in this image.

            Return STRICT JSON ONLY:

            {
              "top": "hoodie/shirt/jacket or null",
              "bottom": "pants/jeans/shorts or null",
              "shoes": "sneakers/boots/sandals or null",
              "accessories": ["fashion accessories only"]
            }

            Rules:
            - ONLY include wearable fashion items
            - IGNORE phones, background, furniture
            - Be concise and accurate
            - NO explanation
            - ONLY JSON
            """

            response = model.generate_content(
                [prompt, genai.upload_file(image_path)]
            )

            raw_text = response.text.strip()

            print("\n========== GEMINI RAW ==========")
            print(raw_text)
            print("================================\n")

            cleaned = raw_text

            if "```" in cleaned:
                cleaned = cleaned.replace("```json", "").replace("```", "").strip()

            try:
                data = json.loads(cleaned)
            except Exception:
                print("❌ JSON PARSE FAILED")
                return self._fallback()

            return self._normalize_and_filter(data)

        except Exception as e:
            print("❌ GEMINI ERROR:", str(e))
            return self._fallback()

    # -----------------------------
    # FILTER NON-FASHION ITEMS
    # -----------------------------
    def _normalize_and_filter(self, data):

        allowed_accessories = [
            "chain", "necklace", "watch", "cap",
            "hat", "bag", "belt", "glasses"
        ]

        accessories = data.get("accessories") or []

        filtered_accessories = [
            a for a in accessories
            if any(key in a.lower() for key in allowed_accessories)
        ]

        return {
            "top": data.get("top") or None,
            "bottom": data.get("bottom") or None,
            "shoes": data.get("shoes") or None,
            "accessories": filtered_accessories,
        }

    # -----------------------------
    # FAILSAFE
    # -----------------------------
    def _fallback(self):
        return {
            "top": None,
            "bottom": None,
            "shoes": None,
            "accessories": [],
        }