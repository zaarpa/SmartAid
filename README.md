# SmartAid

**Authors:** Sadnam Sakib Apurbo, Zaara Zabeen Arpa, Nazia Karim Khan Oishee

## Overview

This is SmartAid, and AI assisted healthcare app developed for the hackathon segment of SUST CSE Carnival 2024.

## Features

- **Authentication:**
  - Firebase authentication was used to implement sign in features including Google OAuth.
  - Basic features such as reset password were also implemented.
    
- **Chat with SmartAid**
  - Users can talk to the chatbot which has been implemented using GPT-4.
  - Users can get help and assistance regarding primary treatments or health advice according to their health condition.

- **Medical History:**
  - Patients can store and access their medical reports within the app.
  - They can also generate a simplified version of the reports using GPT-4.

- **Health Tracking:**
  - Chronic disease patients can keep track of important metrics relevant to their disease.
  - As of now we have implemented a kidney disease tracker.Which consists of :
    - Tracking water intake , urine condition , protein intake , weight measurement , blood pressure.
    - For protein calculation we have used nutritionix api to get protein value for different food.
    - For providing customized diet plan we have used the protein threshold and the diet plan is developed by GPT-4.

## Technological Stack

<img src="https://logowik.com/content/uploads/images/flutter5786.jpg" width="100" /><img src="https://cdn4.iconfinder.com/data/icons/google-i-o-2016/512/google_firebase-2-512.png" width="100" /><img src="https://cdn.icon-icons.com/icons2/3053/PNG/512/android_studio_alt_macos_bigsur_icon_190395.png" width="100" />

## Setup

1. **Install Android Studio**
   - Download and install android studio from this [link](https://developer.android.com/studio).

2. **Install Flutter Plugin**
   - Install the flutter plugin from the plugins section inside android studio.
3. **Setup Firebase App**
   - Setup your firebase applciation by creating a new project in firebase console.
   - [This article from medium shows the necessary steps to create a new project in firebase](https://medium.com/firebase-ninja/how-to-add-new-apps-to-a-firebase-project-39b1223d04a3#:~:text=Add%20new%20Firebase%20app%20step,existing%20apps%20grouped%20by%20platform.)
4. **Setup firebase with flutter**
   - [Follow firebase documentation to setup firebase app with flutter](https://firebase.google.com/docs/flutter/setup?platform=android)
6. **Resolve Dependencies**
   - After initialization , runn this command in the flutter console inside android studio :
     ```
     flutter pub get
     ```
7. **Run App**
   - Run the app using this command :
     ```
     flutter run
     ```
## **Installing App On Your Phone**
  - Build the release version of the app
    ```
    flutter build --release
    ```
  - The release version of apk will be located at [root_folder/build/app/outputs/flutter-apk]
  - Copy and install the app on your phone and use it.
