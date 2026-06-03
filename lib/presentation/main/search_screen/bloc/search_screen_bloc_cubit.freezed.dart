// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_screen_bloc_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchScreenBlocState {
  TextEditingController? get searchController;
  bool get isSearchLoading;
  bool get isPost; // SpeechToText? speech,
  List<SearchAddress>? get searchAddressList;
  Timer? get debounceTimer;
  List<SelectedAreaEventPostData>? get inThisAreaEventDataList;

  /// Create a copy of SearchScreenBlocState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SearchScreenBlocStateCopyWith<SearchScreenBlocState> get copyWith =>
      _$SearchScreenBlocStateCopyWithImpl<SearchScreenBlocState>(
          this as SearchScreenBlocState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SearchScreenBlocState &&
            (identical(other.searchController, searchController) ||
                other.searchController == searchController) &&
            (identical(other.isSearchLoading, isSearchLoading) ||
                other.isSearchLoading == isSearchLoading) &&
            (identical(other.isPost, isPost) || other.isPost == isPost) &&
            const DeepCollectionEquality()
                .equals(other.searchAddressList, searchAddressList) &&
            (identical(other.debounceTimer, debounceTimer) ||
                other.debounceTimer == debounceTimer) &&
            const DeepCollectionEquality().equals(
                other.inThisAreaEventDataList, inThisAreaEventDataList));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      searchController,
      isSearchLoading,
      isPost,
      const DeepCollectionEquality().hash(searchAddressList),
      debounceTimer,
      const DeepCollectionEquality().hash(inThisAreaEventDataList));

  @override
  String toString() {
    return 'SearchScreenBlocState(searchController: $searchController, isSearchLoading: $isSearchLoading, isPost: $isPost, searchAddressList: $searchAddressList, debounceTimer: $debounceTimer, inThisAreaEventDataList: $inThisAreaEventDataList)';
  }
}

/// @nodoc
abstract mixin class $SearchScreenBlocStateCopyWith<$Res> {
  factory $SearchScreenBlocStateCopyWith(SearchScreenBlocState value,
          $Res Function(SearchScreenBlocState) _then) =
      _$SearchScreenBlocStateCopyWithImpl;
  @useResult
  $Res call(
      {TextEditingController? searchController,
      bool isSearchLoading,
      bool isPost,
      List<SearchAddress>? searchAddressList,
      Timer? debounceTimer,
      List<SelectedAreaEventPostData>? inThisAreaEventDataList});
}

/// @nodoc
class _$SearchScreenBlocStateCopyWithImpl<$Res>
    implements $SearchScreenBlocStateCopyWith<$Res> {
  _$SearchScreenBlocStateCopyWithImpl(this._self, this._then);

  final SearchScreenBlocState _self;
  final $Res Function(SearchScreenBlocState) _then;

  /// Create a copy of SearchScreenBlocState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchController = freezed,
    Object? isSearchLoading = null,
    Object? isPost = null,
    Object? searchAddressList = freezed,
    Object? debounceTimer = freezed,
    Object? inThisAreaEventDataList = freezed,
  }) {
    return _then(_self.copyWith(
      searchController: freezed == searchController
          ? _self.searchController
          : searchController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      isSearchLoading: null == isSearchLoading
          ? _self.isSearchLoading
          : isSearchLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isPost: null == isPost
          ? _self.isPost
          : isPost // ignore: cast_nullable_to_non_nullable
              as bool,
      searchAddressList: freezed == searchAddressList
          ? _self.searchAddressList
          : searchAddressList // ignore: cast_nullable_to_non_nullable
              as List<SearchAddress>?,
      debounceTimer: freezed == debounceTimer
          ? _self.debounceTimer
          : debounceTimer // ignore: cast_nullable_to_non_nullable
              as Timer?,
      inThisAreaEventDataList: freezed == inThisAreaEventDataList
          ? _self.inThisAreaEventDataList
          : inThisAreaEventDataList // ignore: cast_nullable_to_non_nullable
              as List<SelectedAreaEventPostData>?,
    ));
  }
}

/// @nodoc

class _Initial extends SearchScreenBlocState {
  const _Initial(
      {this.searchController,
      this.isSearchLoading = false,
      this.isPost = false,
      final List<SearchAddress>? searchAddressList,
      this.debounceTimer,
      final List<SelectedAreaEventPostData>? inThisAreaEventDataList})
      : _searchAddressList = searchAddressList,
        _inThisAreaEventDataList = inThisAreaEventDataList,
        super._();

  @override
  final TextEditingController? searchController;
  @override
  @JsonKey()
  final bool isSearchLoading;
  @override
  @JsonKey()
  final bool isPost;
// SpeechToText? speech,
  final List<SearchAddress>? _searchAddressList;
// SpeechToText? speech,
  @override
  List<SearchAddress>? get searchAddressList {
    final value = _searchAddressList;
    if (value == null) return null;
    if (_searchAddressList is EqualUnmodifiableListView)
      return _searchAddressList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final Timer? debounceTimer;
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

  /// Create a copy of SearchScreenBlocState
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
            (identical(other.searchController, searchController) ||
                other.searchController == searchController) &&
            (identical(other.isSearchLoading, isSearchLoading) ||
                other.isSearchLoading == isSearchLoading) &&
            (identical(other.isPost, isPost) || other.isPost == isPost) &&
            const DeepCollectionEquality()
                .equals(other._searchAddressList, _searchAddressList) &&
            (identical(other.debounceTimer, debounceTimer) ||
                other.debounceTimer == debounceTimer) &&
            const DeepCollectionEquality().equals(
                other._inThisAreaEventDataList, _inThisAreaEventDataList));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      searchController,
      isSearchLoading,
      isPost,
      const DeepCollectionEquality().hash(_searchAddressList),
      debounceTimer,
      const DeepCollectionEquality().hash(_inThisAreaEventDataList));

  @override
  String toString() {
    return 'SearchScreenBlocState.initial(searchController: $searchController, isSearchLoading: $isSearchLoading, isPost: $isPost, searchAddressList: $searchAddressList, debounceTimer: $debounceTimer, inThisAreaEventDataList: $inThisAreaEventDataList)';
  }
}

/// @nodoc
abstract mixin class _$InitialCopyWith<$Res>
    implements $SearchScreenBlocStateCopyWith<$Res> {
  factory _$InitialCopyWith(_Initial value, $Res Function(_Initial) _then) =
      __$InitialCopyWithImpl;
  @override
  @useResult
  $Res call(
      {TextEditingController? searchController,
      bool isSearchLoading,
      bool isPost,
      List<SearchAddress>? searchAddressList,
      Timer? debounceTimer,
      List<SelectedAreaEventPostData>? inThisAreaEventDataList});
}

/// @nodoc
class __$InitialCopyWithImpl<$Res> implements _$InitialCopyWith<$Res> {
  __$InitialCopyWithImpl(this._self, this._then);

  final _Initial _self;
  final $Res Function(_Initial) _then;

  /// Create a copy of SearchScreenBlocState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? searchController = freezed,
    Object? isSearchLoading = null,
    Object? isPost = null,
    Object? searchAddressList = freezed,
    Object? debounceTimer = freezed,
    Object? inThisAreaEventDataList = freezed,
  }) {
    return _then(_Initial(
      searchController: freezed == searchController
          ? _self.searchController
          : searchController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      isSearchLoading: null == isSearchLoading
          ? _self.isSearchLoading
          : isSearchLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isPost: null == isPost
          ? _self.isPost
          : isPost // ignore: cast_nullable_to_non_nullable
              as bool,
      searchAddressList: freezed == searchAddressList
          ? _self._searchAddressList
          : searchAddressList // ignore: cast_nullable_to_non_nullable
              as List<SearchAddress>?,
      debounceTimer: freezed == debounceTimer
          ? _self.debounceTimer
          : debounceTimer // ignore: cast_nullable_to_non_nullable
              as Timer?,
      inThisAreaEventDataList: freezed == inThisAreaEventDataList
          ? _self._inThisAreaEventDataList
          : inThisAreaEventDataList // ignore: cast_nullable_to_non_nullable
              as List<SelectedAreaEventPostData>?,
    ));
  }
}

// dart format on
