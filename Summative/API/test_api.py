import requests
import json

# Sample data matching the required features
data = {
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

response = requests.post('http://localhost:5000/predict', json=data)
print(json.dumps(response.json(), indent=2))