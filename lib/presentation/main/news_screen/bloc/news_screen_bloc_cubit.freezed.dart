// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'news_screen_bloc_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NewsScreenBlocState {
  bool get isLoading;
  bool get isCommentLoading;
  bool get isReplyComment;
  String get type;
  List<EventNewsData>? get eventPostList;
  List<PostCommentData>? get eventPostCommentList;
  AnimationController? get animationController;
  int get currentPage;
  int get totalPages;
  bool get isBottomLoading;
  bool get isLikeAnimation;
  bool get isReacted;
  int get attachmentCurrentIndex;

  /// Create a copy of NewsScreenBlocState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NewsScreenBlocStateCopyWith<NewsScreenBlocState> get copyWith =>
      _$NewsScreenBlocStateCopyWithImpl<NewsScreenBlocState>(
          this as NewsScreenBlocState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NewsScreenBlocState &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isCommentLoading, isCommentLoading) ||
                other.isCommentLoading == isCommentLoading) &&
            (identical(other.isReplyComment, isReplyComment) ||
                other.isReplyComment == isReplyComment) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality()
                .equals(other.eventPostList, eventPostList) &&
            const DeepCollectionEquality()
                .equals(other.eventPostCommentList, eventPostCommentList) &&
            (identical(other.animationController, animationController) ||
                other.animationController == animationController) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.isBottomLoading, isBottomLoading) ||
                other.isBottomLoading == isBottomLoading) &&
            (identical(other.isLikeAnimation, isLikeAnimation) ||
                other.isLikeAnimation == isLikeAnimation) &&
            (identical(other.isReacted, isReacted) ||
                other.isReacted == isReacted) &&
            (identical(other.attachmentCurrentIndex, attachmentCurrentIndex) ||
                other.attachmentCurrentIndex == attachmentCurrentIndex));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      isCommentLoading,
      isReplyComment,
      type,
      const DeepCollectionEquality().hash(eventPostList),
      const DeepCollectionEquality().hash(eventPostCommentList),
      animationController,
      currentPage,
      totalPages,
      isBottomLoading,
      isLikeAnimation,
      isReacted,
      attachmentCurrentIndex);

  @override
  String toString() {
    return 'NewsScreenBlocState(isLoading: $isLoading, isCommentLoading: $isCommentLoading, isReplyComment: $isReplyComment, type: $type, eventPostList: $eventPostList, eventPostCommentList: $eventPostCommentList, animationController: $animationController, currentPage: $currentPage, totalPages: $totalPages, isBottomLoading: $isBottomLoading, isLikeAnimation: $isLikeAnimation, isReacted: $isReacted, attachmentCurrentIndex: $attachmentCurrentIndex)';
  }
}

/// @nodoc
abstract mixin class $NewsScreenBlocStateCopyWith<$Res> {
  factory $NewsScreenBlocStateCopyWith(
          NewsScreenBlocState value, $Res Function(NewsScreenBlocState) _then) =
      _$NewsScreenBlocStateCopyWithImpl;
  @useResult
  $Res call(
      {bool isLoading,
      bool isCommentLoading,
      bool isReplyComment,
      String type,
      List<EventNewsData>? eventPostList,
      List<PostCommentData>? eventPostCommentList,
      AnimationController? animationController,
      int currentPage,
      int totalPages,
      bool isBottomLoading,
      bool isLikeAnimation,
      bool isReacted,
      int attachmentCurrentIndex});
}

/// @nodoc
class _$NewsScreenBlocStateCopyWithImpl<$Res>
    implements $NewsScreenBlocStateCopyWith<$Res> {
  _$NewsScreenBlocStateCopyWithImpl(this._self, this._then);

  final NewsScreenBlocState _self;
  final $Res Function(NewsScreenBlocState) _then;

  /// Create a copy of NewsScreenBlocState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isCommentLoading = null,
    Object? isReplyComment = null,
    Object? type = null,
    Object? eventPostList = freezed,
    Object? eventPostCommentList = freezed,
    Object? animationController = freezed,
    Object? currentPage = null,
    Object? totalPages = null,
    Object? isBottomLoading = null,
    Object? isLikeAnimation = null,
    Object? isReacted = null,
    Object? attachmentCurrentIndex = null,
  }) {
    return _then(_self.copyWith(
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isCommentLoading: null == isCommentLoading
          ? _self.isCommentLoading
          : isCommentLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isReplyComment: null == isReplyComment
          ? _self.isReplyComment
          : isReplyComment // ignore: cast_nullable_to_non_nullable
              as bool,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      eventPostList: freezed == eventPostList
          ? _self.eventPostList
          : eventPostList // ignore: cast_nullable_to_non_nullable
              as List<EventNewsData>?,
      eventPostCommentList: freezed == eventPostCommentList
          ? _self.eventPostCommentList
          : eventPostCommentList // ignore: cast_nullable_to_non_nullable
              as List<PostCommentData>?,
      animationController: freezed == animationController
          ? _self.animationController
          : animationController // ignore: cast_nullable_to_non_nullable
              as AnimationController?,
      currentPage: null == currentPage
          ? _self.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _self.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      isBottomLoading: null == isBottomLoading
          ? _self.isBottomLoading
          : isBottomLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isLikeAnimation: null == isLikeAnimation
          ? _self.isLikeAnimation
          : isLikeAnimation // ignore: cast_nullable_to_non_nullable
              as bool,
      isReacted: null == isReacted
          ? _self.isReacted
          : isReacted // ignore: cast_nullable_to_non_nullable
              as bool,
      attachmentCurrentIndex: null == attachmentCurrentIndex
          ? _self.attachmentCurrentIndex
          : attachmentCurrentIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _Initial extends NewsScreenBlocState {
  const _Initial(
      {this.isLoading = false,
      this.isCommentLoading = false,
      this.isReplyComment = false,
      this.type = 'latest',
      final List<EventNewsData>? eventPostList,
      final List<PostCommentData>? eventPostCommentList,
      this.animationController,
      this.currentPage = 0,
      this.totalPages = 0,
      this.isBottomLoading = false,
      this.isLikeAnimation = false,
      this.isReacted = false,
      this.attachmentCurrentIndex = 0})
      : _eventPostList = eventPostList,
        _eventPostCommentList = eventPostCommentList,
        super._();

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isCommentLoading;
  @override
  @JsonKey()
  final bool isReplyComment;
  @override
  @JsonKey()
  final String type;
  final List<EventNewsData>? _eventPostList;
  @override
  List<EventNewsData>? get eventPostList {
    final value = _eventPostList;
    if (value == null) return null;
    if (_eventPostList is EqualUnmodifiableListView) return _eventPostList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<PostCommentData>? _eventPostCommentList;
  @override
  List<PostCommentData>? get eventPostCommentList {
    final value = _eventPostCommentList;
    if (value == null) return null;
    if (_eventPostCommentList is EqualUnmodifiableListView)
      return _eventPostCommentList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final AnimationController? animationController;
  @override
  @JsonKey()
  final int currentPage;
  @override
  @JsonKey()
  final int totalPages;
  @override
  @JsonKey()
  final bool isBottomLoading;
  @override
  @JsonKey()
  final bool isLikeAnimation;
  @override
  @JsonKey()
  final bool isReacted;
  @override
  @JsonKey()
  final int attachmentCurrentIndex;

  /// Create a copy of NewsScreenBlocState
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
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isCommentLoading, isCommentLoading) ||
                other.isCommentLoading == isCommentLoading) &&
            (identical(other.isReplyComment, isReplyComment) ||
                other.isReplyComment == isReplyComment) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality()
                .equals(other._eventPostList, _eventPostList) &&
            const DeepCollectionEquality()
                .equals(other._eventPostCommentList, _eventPostCommentList) &&
            (identical(other.animationController, animationController) ||
                other.animationController == animationController) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.isBottomLoading, isBottomLoading) ||
                other.isBottomLoading == isBottomLoading) &&
            (identical(other.isLikeAnimation, isLikeAnimation) ||
                other.isLikeAnimation == isLikeAnimation) &&
            (identical(other.isReacted, isReacted) ||
                other.isReacted == isReacted) &&
            (identical(other.attachmentCurrentIndex, attachmentCurrentIndex) ||
                other.attachmentCurrentIndex == attachmentCurrentIndex));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      isCommentLoading,
      isReplyComment,
      type,
      const DeepCollectionEquality().hash(_eventPostList),
      const DeepCollectionEquality().hash(_eventPostCommentList),
      animationController,
      currentPage,
      totalPages,
      isBottomLoading,
      isLikeAnimation,
      isReacted,
      attachmentCurrentIndex);

  @override
  String toString() {
    return 'NewsScreenBlocState(isLoading: $isLoading, isCommentLoading: $isCommentLoading, isReplyComment: $isReplyComment, type: $type, eventPostList: $eventPostList, eventPostCommentList: $eventPostCommentList, animationController: $animationController, currentPage: $currentPage, totalPages: $totalPages, isBottomLoading: $isBottomLoading, isLikeAnimation: $isLikeAnimation, isReacted: $isReacted, attachmentCurrentIndex: $attachmentCurrentIndex)';
  }
}

/// @nodoc
abstract mixin class _$InitialCopyWith<$Res>
    implements $NewsScreenBlocStateCopyWith<$Res> {
  factory _$InitialCopyWith(_Initial value, $Res Function(_Initial) _then) =
      __$InitialCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      bool isCommentLoading,
      bool isReplyComment,
      String type,
      List<EventNewsData>? eventPostList,
      List<PostCommentData>? eventPostCommentList,
      AnimationController? animationController,
      int currentPage,
      int totalPages,
      bool isBottomLoading,
      bool isLikeAnimation,
      bool isReacted,
      int attachmentCurrentIndex});
}

/// @nodoc
class __$InitialCopyWithImpl<$Res> implements _$InitialCopyWith<$Res> {
  __$InitialCopyWithImpl(this._self, this._then);

  final _Initial _self;
  final $Res Function(_Initial) _then;

  /// Create a copy of NewsScreenBlocState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isLoading = null,
    Object? isCommentLoading = null,
    Object? isReplyComment = null,
    Object? type = null,
    Object? eventPostList = freezed,
    Object? eventPostCommentList = freezed,
    Object? animationController = freezed,
    Object? currentPage = null,
    Object? totalPages = null,
    Object? isBottomLoading = null,
    Object? isLikeAnimation = null,
    Object? isReacted = null,
    Object? attachmentCurrentIndex = null,
  }) {
    return _then(_Initial(
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isCommentLoading: null == isCommentLoading
          ? _self.isCommentLoading
          : isCommentLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isReplyComment: null == isReplyComment
          ? _self.isReplyComment
          : isReplyComment // ignore: cast_nullable_to_non_nullable
              as bool,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      eventPostList: freezed == eventPostList
          ? _self._eventPostList
          : eventPostList // ignore: cast_nullable_to_non_nullable
              as List<EventNewsData>?,
      eventPostCommentList: freezed == eventPostCommentList
          ? _self._eventPostCommentList
          : eventPostCommentList // ignore: cast_nullable_to_non_nullable
              as List<PostCommentData>?,
      animationController: freezed == animationController
          ? _self.animationController
          : animationController // ignore: cast_nullable_to_non_nullable
              as AnimationController?,
      currentPage: null == currentPage
          ? _self.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _self.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      isBottomLoading: null == isBottomLoading
          ? _self.isBottomLoading
          : isBottomLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isLikeAnimation: null == isLikeAnimation
          ? _self.isLikeAnimation
          : isLikeAnimation // ignore: cast_nullable_to_non_nullable
              as bool,
      isReacted: null == isReacted
          ? _self.isReacted
          : isReacted // ignore: cast_nullable_to_non_nullable
              as bool,
      attachmentCurrentIndex: null == attachmentCurrentIndex
          ? _self.attachmentCurrentIndex
          : attachmentCurrentIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
