import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart' as http;

// import 'package:speech_to_text/speech_recognition_result.dart';
// import 'package:speech_to_text/speech_to_text.dart';

import '../../../../data/models/in_this_area_event_model.dart';
import '../../../../data/models/response_model.dart';
import '../../../../data/models/search_location_model.dart';
import '../../../../data/models/selected_area_event_post_model.dart';
import '../../../../data/repositories/main_repo.dart';

part 'search_screen_bloc_cubit.freezed.dart';
part 'search_screen_bloc_state.dart';

class SearchScreenBlocCubit extends Cubit<SearchScreenBlocState> {
  SearchScreenBlocCubit() : super(const SearchScreenBlocState.initial());

  // init() {
  //   emit(state.copyWith(
  //       searchController: TextEditingController(),
  //       speech: SpeechToText(),
  //       searchAddressList: [],
  //       inThisAreaEventDataList: []));
  //   // initSpeechState();
  // }

  // Future<void> initSpeechState() async {
  //   log('Initialize');
  //   try {
  //     var hasSpeech = await state.speech!.initialize(
  //       onError: (errorNotification) {
  //         log("initSpeechState ${errorNotification.errorMsg}");
  //       },
  //       onStatus: (status) {
  //         log("initSpeechState $status");
  //       },
  //       debugLogging: true,
  //     );
  //     if (hasSpeech) {
  //       var localeNames = await state.speech!.locales();
  //
  //       var systemLocale = await state.speech!.systemLocale();
  //       var currentLocaleId = systemLocale?.localeId ?? '';
  //       log('Current locale: $currentLocaleId');
  //       log('Available locales: $localeNames');
  //     }
  //   } catch (e) {
  //     log('Error initializing speech: $e');
  //   }
  // }

  // void startListening() {
  //   log('start listening');
  //   final options = SpeechListenOptions(
  //       listenMode: ListenMode.confirmation,
  //       cancelOnError: true,
  //       partialResults: true,
  //       autoPunctuation: true,
  //       enableHapticFeedback: true);
  //   state.speech!.listen(
  //     onResult: resultListener,
  //     listenOptions: options,
  //   );
  // }
  //
  // void stopListening() {
  //   log('Stop Listening');
  //   state.speech!.stop();
  // }
  //
  // void resultListener(SpeechRecognitionResult result) {
  //   log('Result listener final: ${result.finalResult}, words: ${result.recognizedWords}');
  //   state.searchController!.text = result.recognizedWords;
  // }

  Future<void> searchAddress(String searchQuery) async {
    emit(state.copyWith(isSearchLoading: true));
    try {
      final response = await http.get(
          Uri.parse(
              'https://api.radar.io/v1/search/autocomplete?query=$searchQuery&layers=place%2Cstreet%2Cneighborhood%2CpostalCode%2Clocality&limit=15'),
          headers: {
            'Authorization':
                'prj_live_pk_e6cc102efc32ced4de39e61566b1c17cf1449697'
          });
      log('response.statusCode :- ${response.statusCode}');
      if (response.statusCode == 200) {
        SearchLocationModel searchLocationModel =
            SearchLocationModel.fromJson(jsonDecode(response.body));
        List<SearchAddress> tempList = searchLocationModel.addresses ?? [];
        emit(state.copyWith(
            isSearchLoading: false, searchAddressList: tempList));
      }
    } catch (e) {
      emit(state.copyWith(isSearchLoading: false));
      log('Error getting location: $e');
    }
    emit(state.copyWith(isSearchLoading: false));
  }

  Future<void> searchEventPost(
      {required BuildContext context, required String searchQuery}) async {
    emit(state.copyWith(isSearchLoading: true));
    try {
      ResponseModel response = await MainRepository.searchEventPostWithHashtag(
          data: {"postType": "incident", "hashTag": searchQuery});
      if (response.status == true) {
        InThisAreaEventModel inThisAreaResponseModel =
            InThisAreaEventModel.fromJson(response.toJson());
        List<SelectedAreaEventPostData> tempList =
            inThisAreaResponseModel.body ?? [];
        emit(state.copyWith(
            isSearchLoading: false, inThisAreaEventDataList: tempList));
      } else {
        emit(state.copyWith(isSearchLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isSearchLoading: false));
      debugPrint('Cache Error ${e.toString()}');
    }
  }

  void clearSearchList() {
    emit(state.copyWith(searchAddressList: [], inThisAreaEventDataList: []));
  }

  void changeIsPostValue(bool value) {
    emit(state.copyWith(
        isPost: value, searchAddressList: [], inThisAreaEventDataList: []));
  }
}
