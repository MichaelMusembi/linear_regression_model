from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
from prediction import MalariaPredictor
import os

app = FastAPI(
    title="Malaria Prediction API",
    description="API for predicting malaria incidence rates per 1,000 population",
    version="1.0",
    docs_url="/docs",
    redoc_url=None,
)

# ✅ Enable CORS for all origins (use specific origins in production)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Change this to specific domains in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

predictor = MalariaPredictor()

# ✅ Root endpoint for basic health check
@app.get("/", tags=["Root"])
async def root():
    return {
        "message": "Welcome to the Malaria Prediction API!",
        "docs_url": "/docs",
        "usage": "Send a POST request to /predict with the required features."
    }

# ✅ Input model with type and range validation
class PredictionInput(BaseModel):
    urban_managed_water: float = Field(..., ge=0, le=100, alias="People using safely managed drinking water services, urban (% of urban population)")
    rural_pop_growth: float = Field(..., ge=-10, le=10, alias="Rural population growth (annual %)")
    urban_pop_growth: float = Field(..., ge=-10, le=10, alias="Urban population growth (annual %)")
    basic_water: float = Field(..., ge=0, le=100, alias="People using at least basic drinking water services (% of population)")
    basic_water_rural: float = Field(..., ge=0, le=100, alias="People using at least basic drinking water services, rural (% of rural population)")
    basic_water_urban: float = Field(..., ge=0, le=100, alias="People using at least basic drinking water services, urban (% of urban population)")
    basic_sanitation: float = Field(..., ge=0, le=100, alias="People using at least basic sanitation services (% of population)")
    basic_sanitation_rural: float = Field(..., ge=0, le=100, alias="People using at least basic sanitation services, rural (% of rural population)")
    basic_sanitation_urban: float = Field(..., ge=0, le=100, alias="People using at least basic sanitation services, urban  (% of urban population)")

# ✅ Prediction endpoint
@app.post("/predict", summary="Predict malaria incidence", response_description="Prediction result with rate per 1,000 population")
async def predict(input_data: PredictionInput):
    try:
        input_dict = input_data.dict(by_alias=True)
        prediction = predictor.predict(input_dict)
        return {
            "prediction": round(float(prediction), 2),
            "units": "per 1,000 population at risk",
            "required_features": predictor.required_features,
            "model_version": "1.0"
        }
    except Exception as e:
        raise HTTPException(
            status_code=400,
            detail=str(e),
            headers={"X-Error": "Invalid input"}
        )

# For local or Render deployment
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=int(os.getenv("PORT", 8000)))
