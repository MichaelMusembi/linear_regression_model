import joblib

try:
    scaler = joblib.load('scaler.pkl')
    print("Scaler was fitted with these features (in exact order):")
    print(scaler.feature_names_in_)
except AttributeError:
    print("Scaler doesn't store feature names. Need to reconstruct from training data.")
    print("Please check your original notebook for the exact feature list used in training.")