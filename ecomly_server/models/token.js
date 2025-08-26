const { Schema, model } = require("mongoose");

/**
 * Token Schema
 *
 * Stores authentication tokens for users to manage secure sessions. Uses a TTL
 * index (`expires`) to automatically remove expired tokens after 60 days.
 * Typically used for refresh tokens and optional access tokens.
 */
const tokenSchema = Schema({
  /** User token belongs to, it helps track which account the token is associated with. */
  userId: { type: Schema.Types.ObjectId, required: true, ref: "User" },

  /** Refresh token used to request new access tokens (critical for session persistence). */
  refreshToken: { type: String, required: true },

  /** Access token (optional) – may be stored if needed for quick validation. */
  accessToken: String,

  /**
   * Token creation date.
   * Includes a TTL index (`expires: 60 * 86400` → 60 days), so MongoDB
   * will automatically delete the document when expired.
   */
  createdAt: { type: Date, default: Date.now, expires: 60 * 86400 },
});

// Export the Token model
exports.Token = model("Token", tokenSchema);
