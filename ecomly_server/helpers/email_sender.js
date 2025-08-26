const nodemailer = require("nodemailer");

/**
 * 📧 Email Sender Helper
 *
 * This module provides a utility function to send emails using `nodemailer`.
 * It uses environment variables for configuration, making it flexible across
 * environments (development, staging, production).
 *
 * SMTP configuration (loaded from `.env`):
 * - `SMTP_HOST`: Mail server host (e.g., smtp.gmail.com).
 * - `SMTP_SERVICE`: Email service provider.
 * - `SMTP_PORT`: Port for SMTP (commonly 465 for SSL, 587 for TLS).
 * - `EMAIL_ADDRESS`: Sender email address.
 * - `EMAIL_PASSWORD`: Password or App Password for the sender email.
 *
 * Exports:
 * - `sendMail(email, subject, body)` → Sends an email and returns a Promise.
 */

/**
 * Send an email via SMTP.
 *
 * @async
 * @function sendMail
 * @param {string} email - Recipient email address.
 * @param {string} subject - Subject line of the email.
 * @param {string} body - Plain text content of the email.
 * @returns {Promise<string>} Resolves with a success message if sent, rejects if failed.
 *
 * @example
 * await sendMail(
 *   "user@example.com",
 *   "Password Reset",
 *   "Your OTP is 123456"
 * );
 */
exports.sendMail = async (email, subject, body) => {
  return new Promise((resolve, reject) => {
    const transporter = nodemailer.createTransport({
      host: process.env.SMTP_HOST,
      service: process.env.SMTP_SERVICE,
      port: process.env.SMTP_PORT,
      auth: {
        user: process.env.EMAIL_ADDRESS,
        pass: process.env.EMAIL_PASSWORD,
      },
      tls: {
        rejectUnauthorized: false,
      },
    });

    const mailOptions = {
      from: process.env.EMAIL_ADDRESS,
      to: email,
      subject: subject,
      text: body,
    };

    transporter.sendMail(mailOptions, (error, info) => {
      if (error) {
        console.error("Error sending email:", error);
        reject(Error("Error sending email"));
      }
      console.log("Email sent:", info.response);
      resolve("Password reset OTP sent to your email");
    });
  });
};
