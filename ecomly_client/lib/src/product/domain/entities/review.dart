import 'package:equatable/equatable.dart';

/// Represents a review left by a user for a product.
///
/// A [Review] contains the user’s feedback including a textual comment, rating
/// score, and metadata such as author information and submission date.
class Review extends Equatable {
  /// Creates a new [Review] instance.
  const Review({
    required this.id,
    required this.userId,
    required this.userName,
    required this.comment,
    required this.rating,
    required this.date,
  });

  /// Creates a placeholder [Review] with sample values.
  ///
  /// Useful for testing, mock data, or initializing state.
  Review.empty()
    : id = "Test String",
      userId = "Test String",
      userName = "Test String",
      comment = "Test String",
      rating = 1,
      date = DateTime.now();

  /// Unique identifier of the review.
  final String id;

  /// The ID of the user who submitted the review.
  final String userId;

  /// The display name of the user.
  final String userName;

  /// The textual feedback provided by the user.
  final String comment;

  /// Numerical rating score (e.g., from 1.0 to 5.0).
  final double rating;

  /// The date and time when the review was submitted.
  final DateTime date;

  @override
  List<dynamic> get props => [id, userId, userName, rating, date];
}
