part of 'news_screen_bloc_cubit.dart';

@freezed
class NewsScreenBlocState with _$NewsScreenBlocState {
  const NewsScreenBlocState._();
  const factory NewsScreenBlocState({
    @Default(false) bool isLoading,
    @Default(false) bool isCommentLoading,
    @Default(false) bool isReplyComment,
    @Default('latest') String type,
    List<EventNewsData>? eventPostList,
    List<PostCommentData>? eventPostCommentList,
    AnimationController? animationController,
    @Default(0) int currentPage,
    @Default(0) int totalPages,
    @Default(false) bool isBottomLoading,
    @Default(false) bool isLikeAnimation,
    @Default(false) bool isReacted,
    @Default(0) int attachmentCurrentIndex,
  }) = _Initial;

  @override
  // TODO: implement animationController
  AnimationController? get animationController => throw UnimplementedError();

  @override
  // TODO: implement attachmentCurrentIndex
  int get attachmentCurrentIndex => throw UnimplementedError();

  @override
  // TODO: implement currentPage
  int get currentPage => throw UnimplementedError();

  @override
  // TODO: implement eventPostCommentList
  List<PostCommentData>? get eventPostCommentList => throw UnimplementedError();

  @override
  // TODO: implement eventPostList
  List<EventNewsData>? get eventPostList => throw UnimplementedError();

  @override
  // TODO: implement isBottomLoading
  bool get isBottomLoading => throw UnimplementedError();

  @override
  // TODO: implement isCommentLoading
  bool get isCommentLoading => throw UnimplementedError();

  @override
  // TODO: implement isLikeAnimation
  bool get isLikeAnimation => throw UnimplementedError();

  @override
  // TODO: implement isLoading
  bool get isLoading => throw UnimplementedError();

  @override
  // TODO: implement isReacted
  bool get isReacted => throw UnimplementedError();

  @override
  // TODO: implement isReplyComment
  bool get isReplyComment => throw UnimplementedError();

  @override
  // TODO: implement totalPages
  int get totalPages => throw UnimplementedError();

  @override
  // TODO: implement type
  String get type => throw UnimplementedError();

}