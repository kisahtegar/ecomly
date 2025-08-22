<p align="center">
   <a href="https://expressjs.com/" target="_blank">
      <img src="https://upload.wikimedia.org/wikipedia/commons/6/64/Expressjs.png" alt="Express.js Logo" width="400">
   </a>
</p>

<p align="center">
   <a href="https://expressjs.com/">
      <img src="https://img.shields.io/badge/Express.js-Fast,%20unopinionated,%20minimalist-32CD32" alt="Express.js Badge">
   </a>
   <a href="https://www.npmjs.com/package/express">
      <img src="https://img.shields.io/npm/dw/express" alt="NPM Downloads">
   </a>
   <a href="https://github.com/expressjs/express">
      <img src="https://img.shields.io/github/stars/expressjs/express?style=social" alt="GitHub Stars">
   </a>
</p>

---

## Overview

This backend application is designed to handle the business logic and data processing for our project. It serves as the API layer for the frontend and interacts with a database to provide and store data.

This project utilizes:

- **Express.js**: as the backend framework.
- **MongoDB**: for the database.
- **Nodemailer**: For sending emails.
- **firebase-admin**: For sending notifications and utilizing Firebase services.

---

## Features

- **User Authentication**: Secure authentication using JWT (JSON Web Token) with role-based access.
  - **Admin**: Full access to manage users, addresses, and orders.
  - **User**: Can manage their profile, addresses, and orders.
- **Address Management**: Allows users to manage their addresses efficiently.
  - **Add, Edit, Delete**: Users can perform CRUD operations on addresses.
  - **Set Default Address**: Mark an address as default for easier access.
  - **Reverse Geocoding**: Automatically retrieves address details from latitude and longitude.
- **Order Management**: End-to-end order processing system.
  - **Place Orders**: Users can create new orders with their selected items.
  - **Track Orders**: Includes features to view and update order statuses.
  - **Payment Integration**: Supports secure payment handling.
- **Real-Time Notifications**: Firebase integration to send notifications to users for updates.
- **Email Support**: Automatic email notifications for order confirmations using Nodemailer.
- **API Integration**:
  - **Google Places API**: Enables address autocomplete and geolocation for a seamless user experience.
- **Security**:
  - **Encrypted Data**: Sensitive data encrypted with CryptoJS.
  - **CORS Support**: Enables secure communication between the backend and frontend.
- **Database Management**: Utilizes MongoDB and Mongoose for data persistence with schema validation.
- **Robust Error Handling**: Provides clear and consistent API responses for error scenarios.

---

## Installation

### Prerequisites

Ensure you have the following installed:

- [Node.js](https://nodejs.org/) (v16 or higher)
- [npm](https://www.npmjs.com/) or [yarn](https://yarnpkg.com/)
- A running instance of MongoDB (local or cloud)
- `.env` file with the required environment variables

### Steps to Install

1. Clone the repository:

   ```bash
   git clone https://github.com/kisahtegar/foodly_app.git
   cd foodly_backend
   ```

2. Install dependencies:

   ```bash
   npm install
   # or
   yarn install
   ```

3. Set up environment variables: Create a `.env` file in the root directory and add the following variables:

   ```env
   IP="192.168.0.1"
   PORT=6002
   MONGO_URL=your_mongodb_url
   FIREBASE_URL=your_firebasedb_url
   JWT_SEC=your_jwt_secret
   SECRET=your_code_secret
   # ACCOUNT FOR SENDING EMAIL
   AUTH_USER = antonio@gmail.com
   AUTH_PASSWORD = loremipsum # PASSWORD GENERATED FROM GOOGLE
   ```

### Firebase Setup

This project uses Firebase Admin SDK for features like real-time notifications and secure user management. Follow these steps to configure Firebase:

1. **Generate the `serviceAccountKey.json` File**:
   - Go to your [Firebase Console](https://console.firebase.google.com/).
   - Select your project.
   - Navigate to **Project Settings > Service Accounts**.
   - Click **Generate New Private Key** and download the `serviceAccountKey.json` file.

2. **Add the File to the Backend Project**:
   - Place the downloaded `serviceAccountKey.json` file in the root directory of your project (or any secure location).
   - Make sure this file is **excluded from version control** by adding the following entry to your `.gitignore` file:

     ```gitignore
     serviceAccountKey.json
     ```

3. **Set the Path in Your Code**:
   - In your backend code, ensure the Firebase Admin SDK is initialized using the `serviceAccountKey.json` file:

     ```javascript
     const admin = require("firebase-admin");
     const serviceAccount = require("./serviceAccountKey.json");

     admin.initializeApp({
       credential: admin.credential.cert(serviceAccount),
     });
     ```

By following these steps, your Firebase services will be configured securely.

---

## Usage

### Running the Server

Start the development server:

```bash
npm start
```

The server will start at `http://0.0.0.0:3000` by default.

### Running in Production

1. Build the project:

   ```bash
   npm run build
   # or
   yarn build
   ```

2. Start the server:

   ```bash
   npm start
   # or
   yarn start
   ```

---

## Postman Collection

To view the complete API documentation and test the endpoints, you can import the [Postman collection](./postman/ecomly.postman_collection.json) into your Postman application. Follow these steps:

1. Download the file from the above link.
2. Open Postman and select **Import**.
3. Upload the file and explore the endpoints.

This makes it easier for contributors and users to understand and test the API functionality.

---

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the project.
2. Create a new branch (`git checkout -b feature/my-feature`).
3. Commit your changes (`git commit -m 'Add feature'`).
4. Push the branch (`git push origin feature/my-feature`).
5. Submit a pull request.

---

## ✨ About Us

- 💻 All of my projects are available at [github.com/kisahtegar](https://github.com/kisahtegar)
- 📫 How to reach me **<code.kisahtegar@gmail.com>**
- 📄 Know about my experiences [kisahcode.web.app](https://kisahcode.web.app)
