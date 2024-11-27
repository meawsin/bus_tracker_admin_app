# BUP Bus Tracker Admin App

This is the admin dashboard for the **Bus Tracking App**, built using Flutter. The dashboard allows admins to manage buses, drivers, trips, and student complaints efficiently. The project is in its initial stages, and features are being added incrementally.

## Features

- **Manage Buses**: Add, edit, delete, and view bus details.
- **Manage Drivers**: Assign drivers to buses and edit driver details.
- **Set Trips**: Schedule trips by assigning buses and drivers.
- **Student Complaints**: View and resolve complaints from students.

---

## Getting Started

Follow these steps to get the project up and running on your local machine.

### Prerequisites

1. **Flutter SDK**:
   - Ensure Flutter is installed on your system.
   - [Flutter Installation Guide](https://flutter.dev/docs/get-started/install)

2. **IDE**:
   - Install a code editor like [Visual Studio Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio).

3. **Git**:
   - Ensure Git is installed to clone the repository.
   - [Git Installation Guide](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

4. **Dart**:
   - Dart comes with Flutter. No separate installation is required.

---

### Setup Instructions

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/yourusername/admin-dashboard-bus-tracking.git
   cd bus_tracker_admin_app
   ```

2. **Install Dependencies**:
   Run the following command to install all required Flutter dependencies:
   ```bash
   flutter pub get
   ```

3. **Run the App**:
   Use the Flutter CLI to run the app on your local machine:
   ```bash
   flutter run
   ```

4. **Directory Structure**:
   - `lib/`: Contains the main app code.
     - `screens/`: Individual pages for managing buses, drivers, trips, and complaints.
   - `assets/`: Placeholder for app assets like images or fonts.
   - `test/`: Placeholder for test cases (to be added later).

---

### Current Progress

- A functional **sidebar navigation** for switching between different admin features.
- Fully developed pages for:
  - Managing buses.
  - Managing drivers.
  - Setting trips.
  - Viewing and resolving student complaints.
- Basic UI for adding, editing, and deleting items.

---

## Next Steps

1. **Firebase Integration**:
   - Connect the app to Firebase to dynamically fetch and update data.

2. **CRUD Operations**:
   - Implement full Create, Read, Update, Delete functionality for all admin features.

3. **Responsive Design**:
   - Optimize UI for different screen sizes.

4. **Testing**:
   - Add unit and integration tests for robust functionality.

---

## Contribution Guidelines

We welcome contributions to improve the admin dashboard. To contribute:

1. Fork the repository.
2. Create a feature branch: `git checkout -b feature-name`.
3. Commit your changes: `git commit -m "Add a new feature"`.
4. Push to the branch: `git push origin feature-name`.
5. Open a pull request.

---
Happy coding! 🚀
