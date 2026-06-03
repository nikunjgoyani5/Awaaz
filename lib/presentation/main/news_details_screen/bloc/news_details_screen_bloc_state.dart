part of 'news_details_screen_bloc_cubit.dart';

@freezed
class NewsDetailsScreenBlocState with _$NewsDetailsScreenBlocState {
  const NewsDetailsScreenBlocState._();
  const factory NewsDetailsScreenBlocState.initial({
    TextEditingController? sendCommentController,
    @Default(true) bool isNewsCritical,
    @Default(false) bool isLoading,
    @Default(false) bool isInThisAreaLoading,
    @Default(false) bool isSaved,
    @Default('') String reason,
    @Default('') String postId,
    @Default(0) int attachmentCurrentIndex,
    @Default('') String reactionCount,
    @Default('') String commentCount,
    @Default(false) bool isNotification,
    @Default(false) bool isNotificationAnimation,
    @Default(false) bool isLikeAnimation,
    @Default(false) bool isReacted,
    @Default(0) int selectedAttachmentIndex,
    List<VideoPlayerController?>? attachmentVideoControllers,
    EventNewsDetailData? eventNewsDetailData,
    List<SelectedAreaEventPostData>? inThisAreaEventDataList,
  }) = _Initial;

  @override
  // TODO: implement attachmentCurrentIndex
  int get attachmentCurrentIndex => throw UnimplementedError();

  @override
  // TODO: implement attachmentVideoControllers
  List<VideoPlayerController?>? get attachmentVideoControllers => throw UnimplementedError();

  @override
  // TODO: implement commentCount
  String get commentCount => throw UnimplementedError();

  @override
  // TODO: implement eventNewsDetailData
  EventNewsDetailData? get eventNewsDetailData => throw UnimplementedError();

  @override
  // TODO: implement inThisAreaEventDataList
  List<SelectedAreaEventPostData>? get inThisAreaEventDataList => throw UnimplementedError();

  @override
  // TODO: implement isInThisAreaLoading
  bool get isInThisAreaLoading => throw UnimplementedError();

  @override
  // TODO: implement isLikeAnimation
  bool get isLikeAnimation => throw UnimplementedError();

  @override
  // TODO: implement isLoading
  bool get isLoading => throw UnimplementedError();

  @override
  // TODO: implement isNewsCritical
  bool get isNewsCritical => throw UnimplementedError();

  @override
  // TODO: implement isNotification
  bool get isNotification => throw UnimplementedError();

  @override
  // TODO: implement isNotificationAnimation
  bool get isNotificationAnimation => throw UnimplementedError();

  @override
  // TODO: implement isReacted
  bool get isReacted => throw UnimplementedError();

  @override
  // TODO: implement isSaved
  bool get isSaved => throw UnimplementedError();

  @override
  // TODO: implement postId
  String get postId => throw UnimplementedError();

  @override
  // TODO: implement reactionCount
  String get reactionCount => throw UnimplementedError();

  @override
  // TODO: implement reason
  String get reason => throw UnimplementedError();

  @override
  // TODO: implement selectedAttachmentIndex
  int get selectedAttachmentIndex => throw UnimplementedError();

  @override
  // TODO: implement sendCommentController
  TextEditingController? get sendCommentController => throw UnimplementedError();

}