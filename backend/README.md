# MobiPass Backend

Backend server for the MobiPass bus ticket application.

## Setup

1. Install dependencies:
```bash
npm install
```

2. Create a `.env` file in the root directory with the following variables:
```
MONGODB_URI=your_mongodb_connection_string
JWT_SECRET=your_jwt_secret
PORT=3000
```

3. Start the server:
```bash
# Development mode
npm run dev

# Production mode
npm start
```

## API Endpoints

### Authentication

#### Sign Up
- **POST** `/api/auth/signup`
- Body:
```json
{
  "email": "user@example.com",
  "password": "password123",
  "name": "John Doe"
}
```

#### Login
- **POST** `/api/auth/login`
- Body:
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

## Response Format

Both endpoints return a JSON response with:
- `message`: Status message
- `token`: JWT token for authentication
- `user`: User object containing id, email, name, and role 