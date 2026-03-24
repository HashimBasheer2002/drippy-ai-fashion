# 🚀 Drippy — AI-Powered Fashion Analysis & Social Platform

Drippy is a **production-grade AI fashion analysis and social platform** designed for Gen-Z users.
It combines **computer vision, AI styling intelligence, and social interaction** to deliver a unique fashion experience.

> Think: **Instagram + AI Stylist + Outfit Rating System**

---

## 🌟 Core Features

### 🤖 AI Outfit Analysis

* Detects clothing items (top, bottom, shoes, accessories)
* Identifies outfit style (streetwear, minimal, formal, etc.)
* Extracts dominant color palette
* Analyzes visual features:

  * brightness
  * contrast
  * structure
  * palette type

---

### 📊 Drip Score (0–10)

* Intelligent scoring based on:

  * color harmony
  * outfit structure
  * completeness
  * accessories
  * style alignment
* Designed to feel like a **real stylist evaluation**

---

### 💡 Smart Suggestions

* AI-generated, stylist-level feedback
* Context-aware (style + features + items)
* Example:

  * “Adding accessories can elevate the streetwear aesthetic”
  * “Introducing contrast improves visual depth”

---

### 📱 Clean Result UI

* Score display
* Style + confidence badge
* Detected items
* Color palette visualization
* Visual analysis (brightness, contrast, structure)
* Suggestions section

---

### 🔐 Authentication

* JWT-based login & registration
* Secure token handling

---

## 🏗️ Tech Stack

### Backend

* **Django** + Django REST Framework
* JWT Authentication (SimpleJWT)
* Modular AI engine architecture

### Frontend

* **Flutter**
* Cross-platform (Mobile + Web ready)

### AI & Processing

* **Google Gemini API** → outfit + style detection
* **OpenCV + KMeans** → color extraction
* Custom AI logic:

  * feature extraction
  * scoring engine
  * suggestion engine

---

## 🧠 AI Architecture

Drippy uses a **hybrid AI system**:

```
Gemini → items + style + confidence
OpenCV → color extraction
Custom Engine → features + scoring
Suggestion Engine → stylist feedback
```

### Key Principle:

> AI provides intelligence, logic ensures consistency.

---

## 📂 Project Structure

```
Drippy/
├── backend/
│   └── drippy_backend/
│       ├── ai_engine/
│       │   ├── services.py
│       │   ├── ai_providers/
│       │   ├── analyzers/
│       │   ├── features/
│       │   ├── scoring/
│       │   ├── suggestions/
│
├── frontend/
│   └── drippy_app/
│       ├── lib/
│
├── README.md
├── .gitignore
```

---

## 🔁 How It Works

1. User uploads an outfit image

2. Backend processes image:

   * Gemini → detects items & style
   * OpenCV → extracts colors
   * Feature engine → analyzes visuals
   * Scoring engine → calculates score
   * Suggestion engine → generates feedback

3. Frontend displays:

   * Drip score
   * Style + confidence
   * Color palette
   * Suggestions

---

## ⚙️ Setup Instructions

### 🔹 Backend

```bash
cd backend/drippy_backend
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
```

Create `.env` file:

```
GEMINI_API_KEY=your_api_key_here
```

Run server:

```bash
python manage.py runserver
```

---

### 🔹 Frontend

```bash
cd frontend/drippy_app
flutter pub get
flutter run
```

---

## ⚠️ Important Notes

* `.env` is NOT included for security reasons
* Ensure you add your Gemini API key
* Virtual environments (`venv/`) are excluded

---

## 🚧 Current Limitations

* Color detection includes some background noise
* AI runs synchronously (no async yet)
* No community feed yet
* No caching layer

---

## 🔥 Roadmap

### AI Improvements

* Color harmony intelligence (Gemini + OpenCV hybrid)
* Better outfit segmentation
* Advanced stylist suggestions

### Backend

* Async processing (Celery)
* Caching layer
* Rate limiting

### Product Features

* Community feed
* Like / rating system
* Leaderboards
* Trending outfits

### UX Enhancements

* Animated score
* Style badges (e.g., “Clean Fit”)
* Shareable results

---

## 🎯 Vision

Drippy aims to become:

> 💡 A daily-use AI fashion app that combines styling intelligence with social engagement.

---

## 👨‍💻 Author

**Hashim B**

* Full-stack developer
* Building AI-powered products

---

## ⭐ Contributing / Feedback

Contributions and feedback are welcome.
This project is actively evolving toward a **production-grade platform**.

---

## 📜 License

This project is for educational and development purposes (customize as needed).
