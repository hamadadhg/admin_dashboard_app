# Flutter Admin Dashboard

A Flutter admin dashboard application built with MVC architecture that integrates with the admin authentication API endpoints.

## Features

- **Authentication System**
  - Admin login with mobile number and password
  - Secure token-based authentication
  - Auto-logout functionality
  - Session persistence

- **User Management**
  - View all registered users
  - Search users by username or mobile
  - User details display
  - Refresh user data

- **Category Management**
  - Add new categories with images
  - View categories in grid layout
  - Image upload from camera or gallery
  - Category validation and error handling

- **Dashboard**
  - Overview statistics
  - Quick action buttons
  - Recent activity display
  - Responsive design

## Architecture

This project follows the **MVC (Model-View-Controller)** architecture pattern:

```
lib/
├── config/                 # App configuration and constants
├── data/                   # Data layer
│   ├── models/            # Data models
│   └── providers/         # API providers
├── domain/                 # Business logic layer
│   ├── repositories/      # Data repositories
│   └── usecases/         # Business use cases
└── presentation/          # UI layer
    ├── auth/             # Authentication screens
    ├── home/             # Home and dashboard screens
    ├── users/            # User management screens
    ├── categories/       # Category management screens
    └── shared/           # Shared widgets and utilities
```

## API Endpoints

The app integrates with the following API endpoints:

1. **POST** `/api/admin/login` - Admin login
2. **POST** `/api/admin/logout` - Admin logout
3. **GET** `/api/admin/getUsers` - Get all users
4. **POST** `/api/addCategory` - Add new category

## Dependencies

- **get**: State management and navigation
- **dio**: HTTP client for API calls
- **flutter_secure_storage**: Secure token storage
- **image_picker**: Image selection from camera/gallery
- **provider**: Additional state management support
- **shared_preferences**: Local data storage

## Configuration

### API Base URL

Update the base URL in `lib/config/app_constants.dart`:

```dart
static const String baseUrl = 'YOUR_SERVER_URL/api';
```

Currently set to `http://localhost:8000/api` for local development.

## Getting Started

### Prerequisites

- Flutter SDK (3.1.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd flutter_admin_dashboard
```

2. Install dependencies:
```bash
flutter pub get
```

3. Update the API base URL in `lib/config/app_constants.dart`

4. Run the app:
```bash
flutter run
```

## Demo Credentials

For testing purposes, use these demo credentials:

- **Mobile**: 0911111111
- **Password**: admin1111

## Screens

### 1. Login Screen
- Mobile number and password input
- Form validation
- Error handling
- Demo credentials display

### 2. Dashboard Screen
- Welcome card with admin info
- Statistics overview (users, categories)
- Quick action buttons
- Recent activity feed

### 3. Users Screen
- List of all users
- Search functionality
- User details popup
- Pull-to-refresh

### 4. Categories Screen
- Grid view of categories
- Category images
- Add category button
- Category actions menu

### 5. Add Category Screen
- Category name input
- Image selection (camera/gallery)
- Form validation
- Upload progress

## State Management

The app uses **GetX** for state management with the following controllers:

- `AuthController`: Handles authentication logic
- `UserController`: Manages user data and operations
- `CategoryController`: Handles category operations
- `HomeController`: Manages dashboard and navigation

## Error Handling

- Network error handling with retry mechanisms
- Form validation with user-friendly messages
- API error responses with proper status codes
- Loading states and progress indicators

## Security Features

- Secure token storage using Flutter Secure Storage
- Automatic token refresh
- Session timeout handling
- Input validation and sanitization

## Responsive Design

- Adaptive layouts for different screen sizes
- Material Design 3 components
- Consistent color scheme and typography
- Touch-friendly interface elements

## Future Enhancements

- [ ] Edit category functionality
- [ ] Delete category with confirmation
- [ ] User role management
- [ ] Push notifications
- [ ] Offline data caching
- [ ] Advanced search and filtering
- [ ] Export data functionality
- [ ] Dark theme support

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions, please contact the development team or create an issue in the repository.
