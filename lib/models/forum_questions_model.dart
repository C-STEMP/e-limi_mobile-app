class ForumQuestions {
  String? id;
  String? userId;
  String? courseId;
  String? title;
  String? description;
  String? upvotedUserId;
  String? isParent;
  String? dateAdded;
  String? userName;
  String? userImage;
  int? upvotedUserNumber;
  int? commentNumber;
  bool? isLiked;

  ForumQuestions(
      {this.id,
      this.userId,
      this.courseId,
      this.title,
      this.description,
      this.upvotedUserId,
      this.isParent,
      this.dateAdded,
      this.userName,
      this.userImage,
      this.upvotedUserNumber,
      this.commentNumber,
      this.isLiked});
}
