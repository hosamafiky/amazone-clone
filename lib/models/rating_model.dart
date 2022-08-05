class RatingModel {
  late String userId;
  late dynamic rating;

  RatingModel(this.userId, this.rating);

  RatingModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    rating = json['rating'];
  }
}
