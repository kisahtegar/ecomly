# 🗄️ Ecomly Server

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

## 🚀 Overview

**Ecomly Backend** is the API service powering the **Ecomly e-commerce platform**. It handles authentication, orders, products, addresses, cart management, and transactional emails. This backend is built with **Express.js** and connected to **MongoDB**, following a clean and modular architecture.

---

## 🛠️ Tech Stack

- **Express.js** → Web framework
- **MongoDB + Mongoose** → Database & schema management
- **JWT** → Authentication & authorization
- **Nodemailer** → Sending transactional emails (order confirmation, password reset, etc.)
- **CryptoJS** → Data encryption
- **CORS** → Secure API communication

---

## 📂 Project Structure

```bash
ecomly_server/
├── controllers/      # Request handlers (auth, products, cart, orders, etc.)
├── helpers/          # Utility functions (crypto, mailer, etc.)
├── middlewares/      # Authentication, validation, error handling
├── models/           # Mongoose models & schemas
├── postman/          # Postman collection for API testing
├── public/           # Static files (if needed)
├── routes/           # Express routes mapping to controllers
├── .env.example      # Example environment variables
├── .gitignore        # Git ignored files
├── app.js            # Main Express app entry point
├── package.json      # Dependencies and scripts
└── README.md         # Documentation
```

---

## ✨ Features

- **User Authentication**
  - Register, login, and secure sessions with JWT
  - Role-based access (Admin & User)
  - Forgot/Reset password flow with OTP
- **Address Management**
  - Add, update, delete addresses
  - Mark default address
  - Reverse geocoding with Google Places API
- **Cart & Order Management**
  - Cart system with add/remove/update items
  - Place orders & track order status
  - Order items linked to products
  - Payment flow integration ready
- **Admin Features**
  - Manage users, orders, and products
  - View user counts & delete users with cascading data cleanup
- **Notifications**
  - Email updates via Nodemailer

---

## ⚙️ Installation

### Prerequisites

Ensure you have the following installed:

- [Node.js](https://nodejs.org/) (v16 or higher)
- [npm](https://www.npmjs.com/) or [yarn](https://yarnpkg.com/)
- A running instance of MongoDB (local or cloud)
- `.env` file with the required environment variables

### Steps to Install

1. Clone the repository:

   ```bash
   git clone https://github.com/kisahtegar/ecomly.git
   cd ecomly_server
   ```

2. Install dependencies:

   ```bash
   npm install
   # or
   yarn install
   ```

3. Set up environment variables: Create a `.env` file in the root directory and add the following variables:

   ```env
   # API Configuration
   API_URL=/api/v1
   HOST=0.0.0.0
   PORT=3000

   # Database
   MONGODB_CONNECTION_STRING=mongodb+srv://username:<db_password>@cluster0.frunctl.mongodb.net/ecomly?retryWrites=true&w=majority&appName=Cluster0

   # Authentication
   ACCESS_TOKEN_SECRET=HI4aeaMd8SnkSzDkSeQG8FuapTLyDebS8KWQACZKvpW8yg99SDwK4vITFtkr
   REFRESH_TOKEN_SECRET=mhY2seTyUJ7rKQpFdIBRSjC3ILQfdsQpy4WQkbsGGH97hr6Izm6yLLQ6cESz

   # Email (Nodemailer)
   SMTP_HOST=smtp.gmail.com
   SMTP_SERVICE=gmail
   SMTP_PORT=587
   EMAIL_ADDRESS=your-mail@gmail.com
   EMAIL_PASSWORD=abcd efgh ijkl mnop
   # To generate EMAIL_PASSWORD, create an App Password: https://myaccount.google.com/apppasswords

   # Stripe Payments
   STRIPE_KEY=sk_test_your_api_key
   STRIPE_WEBHOOK_SECRET=your_webhook_endpoint_secret
   ```

---

## ▶️ Usage

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

## 📬 API Documentation

To view the complete API documentation and test the endpoints, you can import the [Postman collection](./postman/ecomly.postman_collection.json) into your Postman application. Follow these steps:

1. Download the file from the above link.
2. Open Postman and select **Import**.
3. Upload the file and explore the endpoints.

This makes it easier for contributors and users to understand and test the API functionality.

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the project.
2. Create a feature branch: `git checkout -b feature/my-feature`.
3. Commit your changes: `git commit -m 'Add my feature'`.
4. Push the branch: `git push origin feature/my-feature`.
5. Submit a pull request 🚀.

---

## 👨‍💻 About Me

- 💻 All of my projects are available at [github.com/kisahtegar](https://github.com/kisahtegar)
- 📫 How to reach me: **[code.kisahtegar@gmail.com](mailto:code.kisahtegar@gmail.com)**
- 🌐 Portfolio: [kisahcode.web.app](https://kisahcode.web.app)
