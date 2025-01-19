# task_management_app

A new Flutter project.

<img width="300" alt="Screenshot 2025-01-12 at 6 36 12 PM" src="https://github.com/user-attachments/assets/5f1ff683-71b4-4fd2-9ba8-c5e0c6ffb937" />
<img width="300" alt="Screenshot 2025-01-12 at 6 36 12 PM" src="https://github.com/user-attachments/assets/560da7dd-be4a-4bb0-8119-8b47ea700943" />
<img width="300" alt="Screenshot 2025-01-12 at 6 36 12 PM" src="https://github.com/user-attachments/assets/b121ae76-a515-416a-a368-f2a2267c7660" />

## Create a Firebase app
1. Do to you Firebase console and follow the steps to create a new app
2. Upload the google-services.json which you will get while creating an app to the ```<our_project_name>/android/app/google-services.json```
3. These steps will configure firebase for your project

# Supported Features
- [x] CRUD operations for Task
- [x] Offline feature - Caches Tasks locally in Hive DB 
- [x] Online Feature - Stores task in Firebase for cross device access
- [x] Syncs Task automatically to the firebase once the device is online
- [x] Real time CRUD updates across all the devices online.
- [x] Progress indicator showing the progess while syncing the data 

# Packages Used
 1. [riverpod](https://pub.dev/packages/riverpod) for state management
 2. [go_router](https://pub.dev/packages/go_router) for routing
 3. [hive](https://pub.dev/packages/hive_flutter) for local data
 4. [dio](https://pub.dev/packages/dio) for network calls
 5. [json_serializable](https://pub.dev/packages/json_serializable) for serialization
 6. [firebase](https://firebase.google.com/docs/database/flutter/read-and-write) for storing data

# How to run app
1. Clone repository
2. ```cd task_management_app```
3. Run command: ```flutter run```

