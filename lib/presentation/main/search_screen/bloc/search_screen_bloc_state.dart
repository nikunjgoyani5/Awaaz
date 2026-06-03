part of 'search_screen_bloc_cubit.dart';

@freezed
class SearchScreenBlocState with _$SearchScreenBlocState {
  const SearchScreenBlocState._();
  const factory SearchScreenBlocState.initial({
    TextEditingController? searchController,
    @Default(false) bool isSearchLoading,
    @Default(false) bool isPost,
    // SpeechToText? speech,
    List<SearchAddress>? searchAddressList,
    Timer? debounceTimer,
    List<SelectedAreaEventPostData>? inThisAreaEventDataList,
  }) = _Initial;

  @override
  // TODO: implement debounceTimer
  Timer? get debounceTimer => throw UnimplementedError();

  @override
  // TODO: implement inThisAreaEventDataList
  List<SelectedAreaEventPostData>? get inThisAreaEventDataList => throw UnimplementedError();

  @override
  // TODO: implement isPost
  bool get isPost => throw UnimplementedError();

  @override
  // TODO: implement isSearchLoading
  bool get isSearchLoading => throw UnimplementedError();

  @override
  // TODO: implement searchAddressList
  List<SearchAddress>? get searchAddressList => throw UnimplementedError();

  @override
  // TODO: implement searchController
  TextEditingController? get searchController => throw UnimplementedError();

}
