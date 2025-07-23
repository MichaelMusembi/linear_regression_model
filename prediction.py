import pandas as pd
import numpy as np
import joblib
from sklearn.preprocessing import StandardScaler

class MalariaPredictor:
    def __init__(self, model_path='malaria_model.pkl', scaler_path='scaler.pkl'):
        self.model = joblib.load(model_path)
        self.scaler = joblib.load(scaler_path)
        
        # EXACT feature order from the scaler
        self.required_features = [
            'People using safely managed drinking water services, urban (% of urban population)',
            'Rural population growth (annual %)',
            'Urban population growth (annual %)',
            'People using at least basic drinking water services (% of population)',
            'People using at least basic drinking water services, rural (% of rural population)',
            'People using at least basic drinking water services, urban (% of urban population)',
            'People using at least basic sanitation services (% of population)',
            'People using at least basic sanitation services, rural (% of rural population)',
            'People using at least basic sanitation services, urban  (% of urban population)'
        ]
        
    def preprocess_data(self, input_data):
        if isinstance(input_data, dict):
            df = pd.DataFrame([input_data])
        else:
            df = input_data.copy()
            
        # Add any missing features with NaN
        for feature in self.required_features:
            if feature not in df.columns:
                df[feature] = np.nan
                
        # Ensure exact feature order
        df = df[self.required_features]
        
        # Fill missing values
        df.fillna(df.median(), inplace=True)
        
        return self.scaler.transform(df)
    
    def predict(self, input_data):
        processed_data = self.preprocess_data(input_data)
        return self.model.predict(processed_data)[0]

if __name__ == "__main__":
    predictor = MalariaPredictor()
    
    # Example input with ONLY the required features in any order
    example_data = {
        'People using safely managed drinking water services, urban (% of urban population)': 50.0,
        'Rural population growth (annual %)': 1.5,
        'Urban population growth (annual %)': 3.0,
        'People using at least basic drinking water services (% of population)': 70.0,
        'People using at least basic drinking water services, rural (% of rural population)': 60.0,
        'People using at least basic drinking water services, urban (% of urban population)': 80.0,
        'People using at least basic sanitation services (% of population)': 35.0,
        'People using at least basic sanitation services, rural (% of rural population)': 25.0,
        'People using at least basic sanitation services, urban  (% of urban population)': 45.0
    }
    
    try:
        prediction = predictor.predict(example_data)
        print(f"Predicted malaria incidence: {prediction:.2f} per 1,000 population at risk")
    except Exception as e:
        print(f"Error: {str(e)}")
        print("\nPlease ensure your input contains EXACTLY these features:")
        for i, feature in enumerate(predictor.required_features, 1):
            print(f"{i}. {feature}")