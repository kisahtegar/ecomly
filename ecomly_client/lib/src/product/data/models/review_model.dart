import 'package:ecomly_client/core/utils/typedefs.dart';
import 'package:ecomly_client/src/product/domain/entities/review.dart';

/// Data model representing a product review in the data layer.
///
/// Extends the [Review] entity and adds support for JSON serialization and
/// deserialization, enabling seamless transformation between API responses
/// and domain entities.
class ReviewModel extends Review {
  /// Creates a [ReviewModel] with the provided fields.
  const ReviewModel({
    required super.id,
    required super.userId,
    required super.userName,
    required super.comment,
    required super.rating,
    required super.date,
  });

  /// Provides an empty [ReviewModel] for testing or placeholders.
  ReviewModel.empty([DateTime? date])
    : this(
        id: "Test String",
        userId: "Test String",
        userName: "Test String",
        comment: "Test String",
        rating: 1,
        date: date ?? DateTime.now(),
      );

  /// Creates a [ReviewModel] from a JSON [Map].
  ReviewModel.fromMap(DataMap map)
    : this(
        id: map['id'] as String? ?? map['_id'] as String,
        userId: map['user'] as String,
        userName: map['userName'] as String,
        comment: map['comment'] as String,
        rating: (map['rating'] as num).toDouble(),
        date: DateTime.parse(map['date'] as String),
      );

  /// Converts the [ReviewModel] to a JSON-compatible [Map].
  DataMap toMap() {
    return {
      'id': id,
      'user': userId,
      'userName': userName,
      'comment': comment,
      'rating': rating,
      'date': date.toIso8601String(),
    };
  }

  /// Creates a new [ReviewModel] by copying the current instance
  /// and overriding selected fields.
  ReviewModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? comment,
    double? rating,
    DateTime? date,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      comment: comment ?? this.comment,
      rating: rating ?? this.rating,
      date: date ?? this.date,
    );
  }
}
