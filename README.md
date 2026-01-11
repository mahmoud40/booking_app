# أحجز - Stadium Booking App

A professional Flutter application for managing stadium bookings, designed with a dark, sporty aesthetic and localized for Arabic users.

## 📱 Features

### For Users
*   **Easy Booking System**: View available time slots in a responsive grid layout.
*   **Real-time Availability**: Visual indicators for Available, Pending, and Confirmed slots.
*   **Smart Scheduling**: Book slots from 3 PM to 2 AM (business day logic).
*   **Cancellation Policy**: Users can cancel their bookings up to **1 hour** before the scheduled time. 
*   **Recurring Bookings**: Option to book the same slot for multiple weeks in advance.
*   **Contact Support**: Direct "Call Support" button for immediate assistance.

### For Admins
*   **Request Management**: Approve or Reject pending booking requests.
*   **Weekly Matrix Report**: A comprehensive matrix view of all bookings for the week (Days x Times).
*   **Full Control**: Override cancellation rules (cancel any booking at any time).
*   **Communication**: View user contact details directly from the booking report.

## 🛠️ Tech Stack

*   **Framework**: [Flutter](https://flutter.dev) (Dart)
*   **Backend**: [Supabase](https://supabase.com) (PostgreSQL, Auth, Realtime)
*   **State Management**: `setState` & `FutureBuilder` (Simple & Effective)
*   **Localization**: `flutter_localizations` & `intl` (Arabic Primary)
*   **Theme**: Custom Dark Theme with "Sporty" Gradients (Green/Black/Anthracite)

## 📦 Dependencies

*   `supabase_flutter`: Backend integration.
*   `provider`: Dependency injection (if used).
*   `intl`: Date formatting and localization.
*   `uuid`: Unique ID generation.
*   `url_launcher`: Making phone calls from the app.
*   `shared_preferences`: Local session management.
*   `flutter_launcher_icons`: Custom app icons.

## 🚀 Getting Started

### Prerequisites
1.  **Flutter SDK**: Ensure you have Flutter installed (`flutter doctor`).
2.  **Supabase Project**: You need a valid Supabase project with the following tables:
    *   `users`: (id, username, phone, role)
    *   `bookings`: (id, user_id, pitch_id, start_time, end_time, status, team_name, etc.)
    *   `pitches`: (id, name, location, price_per_hour)

### Installation

1.  **Clone the repository**
    ```bash
    git clone https://github.com/mahmoud40/booking_app.git
    cd booking_app
    ```

2.  **Install dependencies**
    ```bash
    flutter pub get
    ```

3.  **Run the app**
    ```bash
    flutter run
    ```

## 🔐 Roles & Permissions

*   **Guest**: Can view the schedule but cannot book.
*   **User**: Can book slots, view their own bookings, and cancel (subject to 1-hour rule).
*   **Admin**: Can view reports, manage requests, and cancel any booking.

## 📸 Screenshots

*(Add screenshots of the Home Screen, Booking Dialog, and Admin Dashboard here)*

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.
