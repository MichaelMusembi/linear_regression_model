from fastapi import FastAPI, HTTPException, Body
from pydantic import BaseModel, Field
from prediction import MalariaPredictor
from typing import Dict, Any
import os

app = FastAPI(
    title="Malaria Prediction API",
    description="API for predicting malaria incidence rates per 1,000 population",
    version="1.0",
    docs_url="/docs",  # Enables Swagger UI at /docs
    redoc_url=None,    # Disables ReDoc to keep only Swagger
)

predictor = MalariaPredictor()

# Pydantic model for request validation
class PredictionInput(BaseModel):
    """All fields use Field(..., alias="original name") to handle spaces in JSON keys"""
    urban_managed_water: float = Field(..., alias="People using safely managed drinking water services, urban (% of urban population)")
    rural_pop_growth: float = Field(..., alias="Rural population growth (annual %)")
    urban_pop_growth: float = Field(..., alias="Urban population growth (annual %)")
    basic_water: float = Field(..., alias="People using at least basic drinking water services (% of population)")
    basic_water_rural: float = Field(..., alias="People using at least basic drinking water services, rural (% of rural population)")
    basic_water_urban: float = Field(..., alias="People using at least basic drinking water services, urban (% of urban population)")
    basic_sanitation: float = Field(..., alias="People using at least basic sanitation services (% of population)")
    basic_sanitation_rural: float = Field(..., alias="People using at least basic sanitation services, rural (% of rural population)")
    basic_sanitation_urban: float = Field(..., alias="People using at least basic sanitation services, urban  (% of urban population)")

@app.post("/predict", 
          summary="Predict malaria incidence",
          response_description="Prediction result with rate per 1,000 population")
async def predict(input_data: PredictionInput):
    """
    Predict malaria incidence rate based on socioeconomic factors.
    
    Requires all 9 features with their original names as keys.
    Example input is available in the Swagger UI.
    """
    try:
        # Convert Pydantic model to dict with original field names
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

# For Render deployment
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=int(os.getenv("PORT", 8000)))