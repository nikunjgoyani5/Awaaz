// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'news_details_screen_bloc_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NewsDetailsScreenBlocState {
  TextEditingController? get sendCommentController;
  bool get isNewsCritical;
  bool get isLoading;
  bool get isInThisAreaLoading;
  bool get isSaved;
  String get reason;
  String get postId;
  int get attachmentCurrentIndex;
  String get reactionCount;
  String get commentCount;
  bool get isNotification;
  bool get isNotificationAnimation;
  bool get isLikeAnimation;
  bool get isReacted;
  int get selectedAttachmentIndex;
  List<VideoPlayerController?>? get attachmentVideoControllers;
  EventNewsDetailData? get eventNewsDetailData;
  List<SelectedAreaEventPostData>? get inThisAreaEventDataList;

  /// Create a copy of NewsDetailsScreenBlocState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NewsDetailsScreenBlocStateCopyWith<NewsDetailsScreenBlocState>
      get copyWith =>
          _$NewsDetailsScreenBlocStateCopyWithImpl<NewsDetailsScreenBlocState>(
              this as NewsDetailsScreenBlocState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NewsDetailsScreenBlocState &&
            (identical(other.sendCommentController, sendCommentController) ||
                other.sendCommentController == sendCommentController) &&
            (identical(other.isNewsCritical, isNewsCritical) ||
                other.isNewsCritical == isNewsCritical) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isInThisAreaLoading, isInThisAreaLoading) ||
                other.isInThisAreaLoading == isInThisAreaLoading) &&
            (identical(other.isSaved, isSaved) || other.isSaved == isSaved) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.postId, postId) || other.postId == postId) &&
            (identical(other.attachmentCurrentIndex, attachmentCurrentIndex) ||
                other.attachmentCurrentIndex == attachmentCurrentIndex) &&
            (identical(other.reactionCount, reactionCount) ||
                other.reactionCount == reactionCount) &&
            (identical(other.commentCount, commentCount) ||
                other.commentCount == commentCount) &&
            (identical(other.isNotification, isNotification) ||
                other.isNotification == isNotification) &&
            (identical(
                    other.isNotificationAnimation, isNotificationAnimation) ||
                other.isNotificationAnimation == isNotificationAnimation) &&
            (identical(other.isLikeAnimation, isLikeAnimation) ||
                other.isLikeAnimation == isLikeAnimation) &&
            (identical(other.isReacted, isReacted) ||
                other.isReacted == isReacted) &&
            (identical(
                    other.selectedAttachmentIndex, selectedAttachmentIndex) ||
                other.selectedAttachmentIndex == selectedAttachmentIndex) &&
            const DeepCollectionEquality().equals(
                other.attachmentVideoControllers, attachmentVideoControllers) &&
            (identical(other.eventNewsDetailData, eventNewsDetailData) ||
                other.eventNewsDetailData == eventNewsDetailData) &&
            const DeepCollectionEquality().equals(
                other.inThisAreaEventDataList, inThisAreaEventDataList));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      sendCommentController,
      isNewsCritical,
      isLoading,
      isInThisAreaLoading,
      isSaved,
      reason,
      postId,
      attachmentCurrentIndex,
      reactionCount,
      commentCount,
      isNotification,
      isNotificationAnimation,
      isLikeAnimation,
      isReacted,
      selectedAttachmentIndex,
      const DeepCollectionEquality().hash(attachmentVideoControllers),
      eventNewsDetailData,
      const DeepCollectionEquality().hash(inThisAreaEventDataList));

  @override
  String toString() {
    return 'NewsDetailsScreenBlocState(sendCommentController: $sendCommentController, isNewsCritical: $isNewsCritical, isLoading: $isLoading, isInThisAreaLoading: $isInThisAreaLoading, isSaved: $isSaved, reason: $reason, postId: $postId, attachmentCurrentIndex: $attachmentCurrentIndex, reactionCount: $reactionCount, commentCount: $commentCount, isNotification: $isNotification, isNotificationAnimation: $isNotificationAnimation, isLikeAnimation: $isLikeAnimation, isReacted: $isReacted, selectedAttachmentIndex: $selectedAttachmentIndex, attachmentVideoControllers: $attachmentVideoControllers, eventNewsDetailData: $eventNewsDetailData, inThisAreaEventDataList: $inThisAreaEventDataList)';
  }
}

/// @nodoc
abstract mixin class $NewsDetailsScreenBlocStateCopyWith<$Res> {
  factory $NewsDetailsScreenBlocStateCopyWith(NewsDetailsScreenBlocState value,
          $Res Function(NewsDetailsScreenBlocState) _then) =
      _$NewsDetailsScreenBlocStateCopyWithImpl;
  @useResult
  $Res call(
      {TextEditingController? sendCommentController,
      bool isNewsCritical,
      bool isLoading,
      bool isInThisAreaLoading,
      bool isSaved,
      String reason,
      String postId,
      int attachmentCurrentIndex,
      String reactionCount,
      String commentCount,
      bool isNotification,
      bool isNotificationAnimation,
      bool isLikeAnimation,
      bool isReacted,
      int selectedAttachmentIndex,
      List<VideoPlayerController?>? attachmentVideoControllers,
      EventNewsDetailData? eventNewsDetailData,
      List<SelectedAreaEventPostData>? inThisAreaEventDataList});
}

/// @nodoc
class _$NewsDetailsScreenBlocStateCopyWithImpl<$Res>
    implements $NewsDetailsScreenBlocStateCopyWith<$Res> {
  _$NewsDetailsScreenBlocStateCopyWithImpl(this._self, this._then);

  final NewsDetailsScreenBlocState _self;
  final $Res Function(NewsDetailsScreenBlocState) _then;

  /// Create a copy of NewsDetailsScreenBlocState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sendCommentController = freezed,
    Object? isNewsCritical = null,
    Object? isLoading = null,
    Object? isInThisAreaLoading = null,
    Object? isSaved = null,
    Object? reason = null,
    Object? postId = null,
    Object? attachmentCurrentIndex = null,
    Object? reactionCount = null,
    Object? commentCount = null,
    Object? isNotification = null,
    Object? isNotificationAnimation = null,
    Object? isLikeAnimation = null,
    Object? isReacted = null,
    Object? selectedAttachmentIndex = null,
    Object? attachmentVideoControllers = freezed,
    Object? eventNewsDetailData = freezed,
    Object? inThisAreaEventDataList = freezed,
  }) {
    return _then(_self.copyWith(
      sendCommentController: freezed == sendCommentController
          ? _self.sendCommentController
          : sendCommentController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      isNewsCritical: null == isNewsCritical
          ? _self.isNewsCritical
          : isNewsCritical // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isInThisAreaLoading: null == isInThisAreaLoading
          ? _self.isInThisAreaLoading
          : isInThisAreaLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isSaved: null == isSaved
          ? _self.isSaved
          : isSaved // ignore: cast_nullable_to_non_nullable
              as bool,
      reason: null == reason
          ? _self.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      postId: null == postId
          ? _self.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
      attachmentCurrentIndex: null == attachmentCurrentIndex
          ? _self.attachmentCurrentIndex
          : attachmentCurrentIndex // ignore: cast_nullable_to_non_nullable
              as int,
      reactionCount: null == reactionCount
          ? _self.reactionCount
          : reactionCount // ignore: cast_nullable_to_non_nullable
              as String,
      commentCount: null == commentCount
          ? _self.commentCount
          : commentCount // ignore: cast_nullable_to_non_nullable
              as String,
      isNotification: null == isNotification
          ? _self.isNotification
          : isNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      isNotificationAnimation: null == isNotificationAnimation
          ? _self.isNotificationAnimation
          : isNotificationAnimation // ignore: cast_nullable_to_non_nullable
              as bool,
      isLikeAnimation: null == isLikeAnimation
          ? _self.isLikeAnimation
          : isLikeAnimation // ignore: cast_nullable_to_non_nullable
              as bool,
      isReacted: null == isReacted
          ? _self.isReacted
          : isReacted // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedAttachmentIndex: null == selectedAttachmentIndex
          ? _self.selectedAttachmentIndex
          : selectedAttachmentIndex // ignore: cast_nullable_to_non_nullable
              as int,
      attachmentVideoControllers: freezed == attachmentVideoControllers
          ? _self.attachmentVideoControllers
          : attachmentVideoControllers // ignore: cast_nullable_to_non_nullable
              as List<VideoPlayerController?>?,
      eventNewsDetailData: freezed == eventNewsDetailData
          ? _self.eventNewsDetailData
          : eventNewsDetailData // ignore: cast_nullable_to_non_nullable
              as EventNewsDetailData?,
      inThisAreaEventDataList: freezed == inThisAreaEventDataList
          ? _self.inThisAreaEventDataList
          : inThisAreaEventDataList // ignore: cast_nullable_to_non_nullable
              as List<SelectedAreaEventPostData>?,
    ));
  }
}

/// @nodoc

class _Initial extends NewsDetailsScreenBlocState {
  const _Initial(
      {this.sendCommentController,
      this.isNewsCritical = true,
      this.isLoading = false,
      this.isInThisAreaLoading = false,
      this.isSaved = false,
      this.reason = '',
      this.postId = '',
      this.attachmentCurrentIndex = 0,
      this.reactionCount = '',
      this.commentCount = '',
      this.isNotification = false,
      this.isNotificationAnimation = false,
      this.isLikeAnimation = false,
      this.isReacted = false,
      this.selectedAttachmentIndex = 0,
      final List<VideoPlayerController?>? attachmentVideoControllers,
      this.eventNewsDetailData,
      final List<SelectedAreaEventPostData>? inThisAreaEventDataList})
      : _attachmentVideoControllers = attachmentVideoControllers,
        _inThisAreaEventDataList = inThisAreaEventDataList,
        super._();

  @override
  final TextEditingController? sendCommentController;
  @override
  @JsonKey()
  final bool isNewsCritical;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isInThisAreaLoading;
  @override
  @JsonKey()
  final bool isSaved;
  @override
  @JsonKey()
  final String reason;
  @override
  @JsonKey()
  final String postId;
  @override
  @JsonKey()
  final int attachmentCurrentIndex;
  @override
  @JsonKey()
  final String reactionCount;
  @override
  @JsonKey()
  final String commentCount;
  @override
  @JsonKey()
  final bool isNotification;
  @override
  @JsonKey()
  final bool isNotificationAnimation;
  @override
  @JsonKey()
  final bool isLikeAnimation;
  @override
  @JsonKey()
  final bool isReacted;
  @override
  @JsonKey()
  final int selectedAttachmentIndex;
  final List<VideoPlayerController?>? _attachmentVideoControllers;
  @override
  List<VideoPlayerController?>? get attachmentVideoControllers {
    final value = _attachmentVideoControllers;
    if (value == null) return null;
    if (_attachmentVideoControllers is EqualUnmodifiableListView)
      return _attachmentVideoControllers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final EventNewsDetailData? eventNewsDetailData;
  final List<SelectedAreaEventPostData>? _inThisAreaEventDataList;
  @override
  List<SelectedAreaEventPostData>? get inThisAreaEventDataList {
    final value = _inThisAreaEventDataList;
    if (value == null) return null;
    if (_inThisAreaEventDataList is EqualUnmodifiableListView)
      return _inThisAreaEventDataList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Create a copy of NewsDetailsScreenBlocState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$InitialCopyWith<_Initial> get copyWith =>
      __$InitialCopyWithImpl<_Initial>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Initial &&
            (identical(other.sendCommentController, sendCommentController) ||
                other.sendCommentController == sendCommentController) &&
            (identical(other.isNewsCritical, isNewsCritical) ||
                other.isNewsCritical == isNewsCritical) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isInThisAreaLoading, isInThisAreaLoading) ||
                other.isInThisAreaLoading == isInThisAreaLoading) &&
            (identical(other.isSaved, isSaved) || other.isSaved == isSaved) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.postId, postId) || other.postId == postId) &&
            (identical(other.attachmentCurrentIndex, attachmentCurrentIndex) ||
                other.attachmentCurrentIndex == attachmentCurrentIndex) &&
            (identical(other.reactionCount, reactionCount) ||
                other.reactionCount == reactionCount) &&
            (identical(other.commentCount, commentCount) ||
                other.commentCount == commentCount) &&
            (identical(other.isNotification, isNotification) ||
                other.isNotification == isNotification) &&
            (identical(
                    other.isNotificationAnimation, isNotificationAnimation) ||
                other.isNotificationAnimation == isNotificationAnimation) &&
            (identical(other.isLikeAnimation, isLikeAnimation) ||
                other.isLikeAnimation == isLikeAnimation) &&
            (identical(other.isReacted, isReacted) ||
                other.isReacted == isReacted) &&
            (identical(
                    other.selectedAttachmentIndex, selectedAttachmentIndex) ||
                other.selectedAttachmentIndex == selectedAttachmentIndex) &&
            const DeepCollectionEquality().equals(
                other._attachmentVideoControllers,
                _attachmentVideoControllers) &&
            (identical(other.eventNewsDetailData, eventNewsDetailData) ||
                other.eventNewsDetailData == eventNewsDetailData) &&
            const DeepCollectionEquality().equals(
                other._inThisAreaEventDataList, _inThisAreaEventDataList));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      sendCommentController,
      isNewsCritical,
      isLoading,
      isInThisAreaLoading,
      isSaved,
      reason,
      postId,
      attachmentCurrentIndex,
      reactionCount,
      commentCount,
      isNotification,
      isNotificationAnimation,
      isLikeAnimation,
      isReacted,
      selectedAttachmentIndex,
      const DeepCollectionEquality().hash(_attachmentVideoControllers),
      eventNewsDetailData,
      const DeepCollectionEquality().hash(_inThisAreaEventDataList));

  @override
  String toString() {
    return 'NewsDetailsScreenBlocState.initial(sendCommentController: $sendCommentController, isNewsCritical: $isNewsCritical, isLoading: $isLoading, isInThisAreaLoading: $isInThisAreaLoading, isSaved: $isSaved, reason: $reason, postId: $postId, attachmentCurrentIndex: $attachmentCurrentIndex, reactionCount: $reactionCount, commentCount: $commentCount, isNotification: $isNotification, isNotificationAnimation: $isNotificationAnimation, isLikeAnimation: $isLikeAnimation, isReacted: $isReacted, selectedAttachmentIndex: $selectedAttachmentIndex, attachmentVideoControllers: $attachmentVideoControllers, eventNewsDetailData: $eventNewsDetailData, inThisAreaEventDataList: $inThisAreaEventDataList)';
  }
}

/// @nodoc
abstract mixin class _$InitialCopyWith<$Res>
    implements $NewsDetailsScreenBlocStateCopyWith<$Res> {
  factory _$InitialCopyWith(_Initial value, $Res Function(_Initial) _then) =
      __$InitialCopyWithImpl;
  @override
  @useResult
  $Res call(
      {TextEditingController? sendCommentController,
      bool isNewsCritical,
      bool isLoading,
      bool isInThisAreaLoading,
      bool isSaved,
      String reason,
      String postId,
      int attachmentCurrentIndex,
      String reactionCount,
      String commentCount,
      bool isNotification,
      bool isNotificationAnimation,
      bool isLikeAnimation,
      bool isReacted,
      int selectedAttachmentIndex,
      List<VideoPlayerController?>? attachmentVideoControllers,
      EventNewsDetailData? eventNewsDetailData,
      List<SelectedAreaEventPostData>? inThisAreaEventDataList});
}

/// @nodoc
class __$InitialCopyWithImpl<$Res> implements _$InitialCopyWith<$Res> {
  __$InitialCopyWithImpl(this._self, this._then);

  final _Initial _self;
  final $Res Function(_Initial) _then;

  /// Create a copy of NewsDetailsScreenBlocState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? sendCommentController = freezed,
    Object? isNewsCritical = null,
    Object? isLoading = null,
    Object? isInThisAreaLoading = null,
    Object? isSaved = null,
    Object? reason = null,
    Object? postId = null,
    Object? attachmentCurrentIndex = null,
    Object? reactionCount = null,
    Object? commentCount = null,
    Object? isNotification = null,
    Object? isNotificationAnimation = null,
    Object? isLikeAnimation = null,
    Object? isReacted = null,
    Object? selectedAttachmentIndex = null,
    Object? attachmentVideoControllers = freezed,
    Object? eventNewsDetailData = freezed,
    Object? inThisAreaEventDataList = freezed,
  }) {
    return _then(_Initial(
      sendCommentController: freezed == sendCommentController
          ? _self.sendCommentController
          : sendCommentController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      isNewsCritical: null == isNewsCritical
          ? _self.isNewsCritical
          : isNewsCritical // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isInThisAreaLoading: null == isInThisAreaLoading
          ? _self.isInThisAreaLoading
          : isInThisAreaLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isSaved: null == isSaved
          ? _self.isSaved
          : isSaved // ignore: cast_nullable_to_non_nullable
              as bool,
      reason: null == reason
          ? _self.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      postId: null == postId
          ? _self.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
      attachmentCurrentIndex: null == attachmentCurrentIndex
          ? _self.attachmentCurrentIndex
          : attachmentCurrentIndex // ignore: cast_nullable_to_non_nullable
              as int,
      reactionCount: null == reactionCount
          ? _self.reactionCount
          : reactionCount // ignore: cast_nullable_to_non_nullable
              as String,
      commentCount: null == commentCount
          ? _self.commentCount
          : commentCount // ignore: cast_nullable_to_non_nullable
              as String,
      isNotification: null == isNotification
          ? _self.isNotification
          : isNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      isNotificationAnimation: null == isNotificationAnimation
          ? _self.isNotificationAnimation
          : isNotificationAnimation // ignore: cast_nullable_to_non_nullable
              as bool,
      isLikeAnimation: null == isLikeAnimation
          ? _self.isLikeAnimation
          : isLikeAnimation // ignore: cast_nullable_to_non_nullable
              as bool,
      isReacted: null == isReacted
          ? _self.isReacted
          : isReacted // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedAttachmentIndex: null == selectedAttachmentIndex
          ? _self.selectedAttachmentIndex
          : selectedAttachmentIndex // ignore: cast_nullable_to_non_nullable
              as int,
      attachmentVideoControllers: freezed == attachmentVideoControllers
          ? _self._attachmentVideoControllers
          : attachmentVideoControllers // ignore: cast_nullable_to_non_nullable
              as List<VideoPlayerController?>?,
      eventNewsDetailData: freezed == eventNewsDetailData
          ? _self.eventNewsDetailData
          : eventNewsDetailData // ignore: cast_nullable_to_non_nullable
              as EventNewsDetailData?,
      inThisAreaEventDataList: freezed == inThisAreaEventDataList
          ? _self._inThisAreaEventDataList
          : inThisAreaEventDataList // ignore: cast_nullable_to_non_nullable
              as List<SelectedAreaEventPostData>?,
    ));
  }
}

// dart format on
