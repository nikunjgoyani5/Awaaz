import 'dart:developer';

import 'package:carousel_slider/carousel_options.dart';
import 'package:eagle_eye/data/models/notification_on_off_model.dart';
import 'package:eagle_eye/presentation/main/news_screen/bloc/news_screen_bloc_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/utils/app_functions.dart';
import '../../../../data/models/event_news_detail_model.dart';
import '../../../../data/models/in_this_area_event_model.dart';
import '../../../../data/models/response_model.dart';
import '../../../../data/models/selected_area_event_post_model.dart';
import '../../../../data/repositories/main_repo.dart';

part 'news_details_screen_bloc_cubit.freezed.dart';
part 'news_details_screen_bloc_state.dart';

class NewsDetailsScreenBlocCubit extends Cubit<NewsDetailsScreenBlocState> {
  NewsDetailsScreenBlocCubit() : super(NewsDetailsScreenBlocState.initial());

  init() {
    emit(state.copyWith(
        sendCommentController: TextEditingController(),
        isLoading: false,
        isInThisAreaLoading: false,
        reason: '',
        isNewsCritical: false,
        eventNewsDetailData: null,
        isSaved: false,
        attachmentVideoControllers: [],
        attachmentCurrentIndex: 0,
        reactionCount: '0',
        commentCount: '0',
        postId: '',
        inThisAreaEventDataList: []));
  }

  clearReason() {
    emit(state.copyWith(isLoading: false, reason: ''));
  }

  void getPostId(String postId) {
    emit(state.copyWith(postId: postId));
  }

  Future<void> reportPost() async {
    emit(state.copyWith(isLoading: true));
    try {
      ResponseModel response = await MainRepository.report(data: {
        "reportType": "post",
        "postId": state.postId,
        "reason": state.reason,
      });
      if (response.status == true) {
        emit(state.copyWith(
          isLoading: false,
        ));
        AppFunctions.showToast(response.message);
      } else {
        AppFunctions.showToast(response.message);
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      log('Cache Error ${e.toString()}');
      AppFunctions.showToast(e.toString());
    }
  }

  Future<void> reportComment(
      String commentId, String postId, String reason) async {
    emit(state.copyWith(isLoading: true));
    try {
      ResponseModel response = await MainRepository.report(data: {
        "reportType": "comment",
        "postId": postId,
        "commentId": commentId,
        "reason": reason,
      });
      if (response.status == true) {
        emit(state.copyWith(
          isLoading: false,
        ));
        AppFunctions.showToast(response.message);
      } else {
        AppFunctions.showToast(response.message);
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      log('Cache Error ${e.toString()}');
      AppFunctions.showToast(e.toString());
    }
  }

  Future<void> reportCommentReply(
      {required String commentId,
      required String replyCommentId,
      required String postId,
      required String reason}) async {
    emit(state.copyWith(isLoading: true));
    try {
      ResponseModel response = await MainRepository.report(data: {
        "reportType": "comment",
        "postId": postId,
        "commentId": commentId,
        "commentReplyId": replyCommentId,
        "reason": reason,
      });
      if (response.status == true) {
        emit(state.copyWith(
          isLoading: false,
        ));
        AppFunctions.showToast(response.message);
      } else {
        AppFunctions.showToast(response.message);
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      log('Cache Error ${e.toString()}');
      AppFunctions.showToast(e.toString());
    }
  }

  Future<void> savePost() async {
    try {
      ResponseModel response = await MainRepository.savePost(data: {
        "eventPostId": state.postId,
      });
      if (response.status == true) {
        bool isSaved = response.body['isPostSaved'] ?? false;
        changeIsSaveValue(isSaved);
        AppFunctions.showToast(response.message);
      } else {
        AppFunctions.showToast(response.message);
      }
    } catch (e) {
      log('Cache Error ${e.toString()}');
      AppFunctions.showToast(e.toString());
    }
  }

  setAttachmentIndex(int index) {
    emit(state.copyWith(
      selectedAttachmentIndex: index,
      attachmentCurrentIndex: index,
    ));
  }

  changeIsSaveValue(bool value) {
    emit(state.copyWith(isSaved: value));
  }

  Future<void> viewCountPost(BuildContext context) async {
    try {
      ResponseModel response = await MainRepository.addViewCountPost(data: {
        "eventPostId": state.postId,
      });
      if (response.status == true) {
        log('View Count Added');
        // context.read<NewsScreenBlocCubit>().init();
        // await context.read<NewsScreenBlocCubit>().getNewsEvents();
      } else {
        log('View Count Error');
      }
    } catch (e) {
      log('Cache Error ${e.toString()}');
    }
  }

  updateReactionCount(String reaction) {
    emit(state.copyWith(reactionCount: reaction));
  }

  setReactedOrNot(bool isReacted) {
    emit(state.copyWith(isReacted: isReacted));
  }

  updateCommentCount(String reaction) {
    emit(state.copyWith(commentCount: reaction));
  }

  Future<void> addReactionPost(
      String postId, BuildContext context, bool isDetail) async {
    try {
      ResponseModel response = await MainRepository.addReactionPost(data: {
        "eventPostId": postId,
      });
      if (response.status == true) {
        log('Reaction Added');
        if (isDetail) {
          updateReactionCount(response.body['reactionCounts'].toString());

          if (response.body['hasReacted'] == true) {
            emit(state.copyWith(
              isLikeAnimation: true,
            ));
          }

          emit(state.copyWith(
            isReacted: response.body['hasReacted'] ?? false,
          ));
          context.read<NewsScreenBlocCubit>().updateNewsListReactionCount(
              postId,
              response.body['reactionCounts'].toString(),
              response.body['hasReacted'] ?? false);
        } else {
          if (response.body['hasReacted'] == true) {
            context.read<NewsScreenBlocCubit>().setLikeAnimation(postId, true);
          }
          context.read<NewsScreenBlocCubit>().updateNewsListReactionCount(
              postId,
              response.body['reactionCounts'].toString(),
              response.body['hasReacted'] ?? false);

          // context.read<NewsScreenBlocCubit>().setISReactedOrNot(response.body['hasReacted']?? false);
        }
      } else {
        log('Reaction Added Error');
      }
    } catch (e) {
      log('Cache Error ${e.toString()}');
    }
  }

  Future<void> getInThisAreaPostList() async {
    emit(state.copyWith(isInThisAreaLoading: true));
    try {
      ResponseModel response =
          await MainRepository.inThisAreaPostList(postId: state.postId);
      if (response.status == true && response.body != null) {
        InThisAreaEventModel inThisAreaResponseModel =
            InThisAreaEventModel.fromJson(response.toJson());
        List<SelectedAreaEventPostData> tempList =
            inThisAreaResponseModel.body ?? [];
        emit(state.copyWith(
            isInThisAreaLoading: false, inThisAreaEventDataList: tempList));
      } else {
        emit(state.copyWith(isInThisAreaLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(
        isInThisAreaLoading: false,
      ));
      log('Cache Error ${e.toString()}');
    }
  }

  Future<void> getEventNewsDetailData() async {
    emit(state.copyWith(isLoading: true));
    try {
      ResponseModel response =
          await MainRepository.getEventNewsDetailData(postId: state.postId);
      if (response.status == true && response.body != null) {
        EventNewsDetailModel eventNewsDetailModel =
            EventNewsDetailModel.fromJson(response.toJson());
        emit(state.copyWith(
          isLoading: false,
          eventNewsDetailData: eventNewsDetailModel.body,
          reactionCount: eventNewsDetailModel.body!.reactionCounts ?? "0",
          commentCount: eventNewsDetailModel.body!.commentCounts ?? "0",
          isNotification: eventNewsDetailModel.body?.isNotificationOn ?? false,
          isReacted: eventNewsDetailModel.body?.hasReacted ?? false,
        ));
        changeIsSaveValue(eventNewsDetailModel.body?.isPostSaved ?? false);
        if (eventNewsDetailModel.body!.attachments!.isNotEmpty) {
          initializeControllers(eventNewsDetailModel.body!.attachments!);
        }
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
      ));
      log('Cache Error ${e.toString()}');
    }
  }

  Future<void> notificationOnOff() async {
    try {
      ResponseModel response =
          await MainRepository.onOrOffEventNotification(data: {
        "eventPostId": state.postId,
      });
      if (response.status == true) {
        NotificationOnOffModel notificationOnOffModel =
            NotificationOnOffModel.fromJson(response.toJson());
        emit(state.copyWith(
          isNotification:
              notificationOnOffModel.body?.isNotificationOn ?? false,
        ));
        if (notificationOnOffModel.body?.isNotificationOn == true) {
          AppFunctions.showToast(response.message);
          emit(state.copyWith(
            isNotificationAnimation: true,
          ));
        } else {
          AppFunctions.showToast(response.message);
        }
      } else {
        AppFunctions.showToast(response.message);
      }
    } catch (e) {
      log('Cache Error ${e.toString()}');
      AppFunctions.showToast(e.toString());
    }
  }

  setNotificationAnimationFalse() {
    emit(state.copyWith(
      isNotificationAnimation: false,
    ));
  }

  setLikeAnimationFalse() {
    emit(state.copyWith(
      isLikeAnimation: false,
    ));
  }

  void initializeControllers(List<Attachment> attachments) {
    if (attachments.isEmpty) return;

    List<VideoPlayerController?> tempList =
        List.generate(attachments.length, (index) => null);

    emit(state.copyWith(attachmentVideoControllers: tempList));

    // Ensure the first video is initialized only if the attachment is not null or empty
    if (attachments[0].attachment != null &&
        attachments[0].attachment!.isNotEmpty &&
        attachments[0].attachmentFileType == "Video") {
      _initializeControllerAtIndex(0, attachments[0]);
    }
  }

  Future<void> _initializeControllerAtIndex(
      int index, Attachment attachment) async {
    if (index < 0 || index >= state.attachmentVideoControllers!.length) return;
    if (state.attachmentVideoControllers?[index] != null) return;

    final controller = VideoPlayerController.networkUrl(
      Uri.parse(attachment.attachment ?? ''),
      videoPlayerOptions: VideoPlayerOptions(
        mixWithOthers: true,
      ),
    );

    await controller.initialize().then((_) {
      // if (index == state.attachmentCurrentIndex) {
      //   controller.play();
      // }

      // Ensure the state is properly updated
      final newControllers = List<VideoPlayerController?>.from(
          state.attachmentVideoControllers ?? []);

      if (index < newControllers.length) {
        newControllers[index] = controller;
        emit(state.copyWith(attachmentVideoControllers: newControllers));
      }
    }).catchError((error) {
      debugPrint("Error initializing video controller at index $index: $error");
    });
  }

  void onPageChanged(int index, CarouselPageChangedReason reason) {
    final prevIndex = state.attachmentCurrentIndex;
    if (state.attachmentVideoControllers![prevIndex]?.value.isPlaying ??
        false) {
      state.attachmentVideoControllers![prevIndex]?.pause();
    }

    // Initialize controller if not exists
    if (state.attachmentVideoControllers?[index] == null) {
      final attachment = state.eventNewsDetailData!.attachments![index];
      _initializeControllerAtIndex(index, attachment);
    } else {
      state.attachmentVideoControllers![index]!.play();
    }

    emit(state.copyWith(attachmentCurrentIndex: index));

    // Preload next and previous videos
    _preloadAdjacentVideos(index);
  }

  void _preloadAdjacentVideos(int currentIndex) {
    final attachments = state.eventNewsDetailData!.attachments!;
    final indicesToPreload = [
      currentIndex - 1,
      currentIndex + 1,
    ].where((i) => i >= 0 && i < attachments.length).toList();

    for (final index in indicesToPreload) {
      if (state.attachmentVideoControllers?[index] == null) {
        _initializeControllerAtIndex(index, attachments[index]);
      }
    }
  }

  @override
  Future<void> close() {
    disposeControllers();
    return super.close();
  }

  void disposeControllers() {
    for (var controller in state.attachmentVideoControllers!) {
      if (controller != null) {
        controller.dispose();
      }
    }
    emit(state.copyWith(attachmentVideoControllers: []));
  }

  void getReason(String reasonString) {
    emit(state.copyWith(reason: reasonString));
  }

/*  Future<void> addAttachmentView() async {
    try {
      ResponseModel response = await MainRepository.addViewAttachment(
        data: {
          'eventPostId': state.postId,
          'attachmentId':
              state.eventNewsDetailData?.attachments?[0].attachmentId
        },
      );
      log('${response.status}');
    } catch (e) {
      log('ADD ATTACHMENT VIEW ## ERROR ## $e');
    }
  }*/
}
