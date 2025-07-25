# Malaria Prediction with Linear Regression – Africa Focused 🌍

> **Mission**: Malaria remains a critical public health issue in Africa. This project uses a simple linear regression model to predict malaria incidence rates based on environmental and health-related factors, offering a tech-powered approach to guiding interventions and awareness.

---

## 🔗 GitHub Repository

All source files are hosted here:  
➡️ [https://github.com/MichaelMusembi/linear_regression_model](https://github.com/MichaelMusembi/linear_regression_model)

Contents include:
- `Notebook/`: Jupyter notebook for data analysis, preprocessing, and model training
- `API/`: FastAPI backend for serving predictions
- `flutter_app/`: Flutter mobile app to consume and visualize API predictions

---

## 📡 Public API Endpoint (Live)

🔗 **Base URL**:  
**https://linear-regression-model-qjrd.onrender.com/** 
📘 **Swagger UI Docs**:  
** https://linear-regression-model-qjrd.onrender.com/docs**

**YouTube Demo Video URL**:
https://youtu.be/vaVTie3-xiU

### ➕ Example API Request
`POST /predict`  
```json
{
  "rainfall": 130.2,
  "humidity": 79,
  "temperature": 27.5,
  "population": 1200000
}
````

### ✔️ Example Response

```json
{
  "predicted_cases": 458.92
}
```

---

## 🧠 Dataset Source

We use real-world data sourced from Kaggle:
[📊 Malaria in Africa Dataset](https://www.kaggle.com/datasets/lydia70/malaria-in-africa?resource=download)

---

## 📱 How to Run the Mobile App (Flutter)

> The Flutter app consumes the API and provides a mobile interface to enter inputs and view malaria predictions.

### 🚀 Prerequisites

* Flutter SDK (version ≥ 3.10)
* Android Studio or Visual Studio Code
* Internet access to connect to the public API

### 🛠️ Installation Steps

1. **Clone the repository**

   ```bash
   git clone https://github.com/MichaelMusembi/linear_regression_model.git
   cd /linear_regression_model/Summative/flutter_app
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the app**

   ```bash
   flutter run
   ```

4. **On emulator or real device**, input your environmental values and hit **Predict** to view malaria case predictions via API.

>  Make sure your emulator/device is connected to the internet to access the public API.

---

## Contributors

* Michael Musembi – [@MichaelMusembi](https://github.com/MichaelMusembi)

---

## License

MIT License © 2025 Michael Musembi
