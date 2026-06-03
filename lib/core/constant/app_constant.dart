import 'package:eagle_eye/data/models/report_option_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logic_go_network/network.dart';
import 'app_assets.dart';

String androidId = 'com.invoice.maker';
String iosId = 'com.app.mintinvoices';
String robotoFont = 'roboto';
String testTiemposHeadline = 'test_tiempos_headline';
String alice = 'alice';
String baseUrlLive = 'https://awaazeye.com';
String baseUrlDev = 'http://139.59.32.181:8002';
String baseSocketUrlLive = 'https://awaazeye.com/';
String baseSocketUrlDev = 'http://139.59.32.181:8002/';
String baseUrl = isLiveMode ? baseUrlLive : baseUrlDev;
String baseSocketUrl = isLiveMode ? baseSocketUrlLive : baseSocketUrlDev;
late RestClient restClient;
String token = '';
bool isLiveMode = true;
double defaultLat = 21.170240;
double defaultLang = 72.831062;
String androidID = 'com.awaazeye.cityalerts';
String iosID = '';

extension SpaceWidget on Widget {
  spaceH(double height) {
    return SizedBox(
      height: height,
    );
  }

  spaceW(double width) {
    return SizedBox(
      width: width,
    );
  }
}

List<ReportOptionModel> postReportOptionList = [
  ReportOptionModel(title: 'I just don’t like it', status: false),
  ReportOptionModel(title: 'Bullying or unwanted contact', status: false),
  ReportOptionModel(
      title: 'Suicide, self-injury or eating disorders', status: false),
  ReportOptionModel(title: 'Violence,hate or exploitation', status: false),
  ReportOptionModel(title: 'Nudity or sexual activity', status: false),
  ReportOptionModel(title: 'Scam, fraud or spam', status: false),
  ReportOptionModel(title: 'False information', status: false),
];

List<ReportOptionModel> commentsReportOptionList = [
  ReportOptionModel(title: 'Sexual Content', status: false),
  ReportOptionModel(title: 'Violent or repulsive content', status: false),
  ReportOptionModel(title: 'Hateful or abusive content', status: false),
  ReportOptionModel(title: 'Harassment or bullying', status: false),
  ReportOptionModel(title: 'Harmful or dangerous acts', status: false),
  ReportOptionModel(title: 'Misinformation', status: false),
  ReportOptionModel(title: 'Child abuse', status: false),
  ReportOptionModel(title: 'Promotes terrorism', status: false),
  ReportOptionModel(title: 'Spam or misleading', status: false),
];

List<ReportOptionModel> userReportOptionList = [
  ReportOptionModel(title: "It's spam", status: false),
  ReportOptionModel(title: 'Nudity or sexual activity', status: false),
  ReportOptionModel(title: 'Hate Speech or Symbols', status: false),
  ReportOptionModel(
      title: 'Violence or dangerous organisations', status: false),
  ReportOptionModel(title: 'Sale of illegal or regulated goods', status: false),
  ReportOptionModel(title: 'Bullying or harassment', status: false),
  ReportOptionModel(title: 'Intellectual property violation', status: false),
  ReportOptionModel(title: 'False Infortmation', status: false),
  ReportOptionModel(
      title: 'Suicide, Self-injury or eating disorders', status: false),
  ReportOptionModel(title: 'Drugs', status: false),
  ReportOptionModel(title: 'Other', status: false),
];

class HashtagFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    final hashtags =
        text.split(' ').where((tag) => tag.startsWith('#') && tag.length > 1);

    // Reconstruct text with valid hashtags only
    final formattedText = hashtags.join(' ');

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

String timeAgo(DateTime dateTime, {bool? hideAgoSuffix}) {
  final Duration difference = DateTime.now().difference(dateTime);

  if (difference.inSeconds <= 5) {
    // "Just now" for the first 5 seconds
    return 'just now';
  } else if (difference.inSeconds < 60) {
    // Less than 1 minute (after 5 seconds)
    return hideAgoSuffix ?? false
        ? '${difference.inSeconds}s'
        : '${difference.inSeconds} sec ago';
  } else if (difference.inMinutes < 60) {
    // Less than 1 hour
    return hideAgoSuffix ?? false
        ? '${difference.inMinutes}m'
        : '${difference.inMinutes} min ago';
  } else if (difference.inHours < 24) {
    // Less than 1 day
    return hideAgoSuffix ?? false
        ? '${difference.inHours}h'
        : '${difference.inHours}hour ago';
  } else if (difference.inDays < 30) {
    // Less than 1 month
    return hideAgoSuffix ?? false
        ? '${difference.inDays}d'
        : '${difference.inDays} day${difference.inDays != 1 ? 's' : ''} ago';
  } else if (difference.inDays < 365) {
    // Less than 1 year
    final int months = (difference.inDays / 30).floor();
    return hideAgoSuffix ?? false
        ? '${months}mo'
        : '$months month${months != 1 ? 's' : ''} ago';
  } else {
    // More than 1 year
    final int years = (difference.inDays / 365).floor();
    return hideAgoSuffix ?? false
        ? '${years}y'
        : '$years year${years != 1 ? 's' : ''} ago';
  }
}

List<EventCategoryModel> eventCategoryList = [
  /* EventCategoryModel(
      title: 'Fire', icon: AppImageAsset.fireIcon, color: Colors.red),
  EventCategoryModel(
      title: 'Traffic Accidents',
      icon: AppImageAsset.trafficAccidentsIcon,
      color: Colors.orange),
  EventCategoryModel(
      title: 'Health Advisories',
      icon: AppImageAsset.healthAdvisoriesIcon,
      color: Colors.blue),
  EventCategoryModel(
      title: 'Crime', icon: AppImageAsset.crimeIcon, color: Colors.grey),
  EventCategoryModel(
      title: 'Air Quality Reports',
      icon: AppImageAsset.airQualityReportIcon,
      color: Colors.grey),
  EventCategoryModel(
      title: 'Heavy Rain',
      icon: AppImageAsset.heavyRainIcon,
      color: Colors.grey),
  EventCategoryModel(
      title: 'Party', icon: AppImageAsset.partyIcon, color: Colors.orange),
  EventCategoryModel(
      title: 'Police', icon: AppImageAsset.policeIcon, color: Colors.grey),
  EventCategoryModel(
      title: 'Train', icon: AppImageAsset.trainIcon, color: Colors.grey),
  EventCategoryModel(
      title: 'Fighting', icon: AppImageAsset.fightingIcon, color: Colors.grey),
  EventCategoryModel(
      title: 'Arrest', icon: AppImageAsset.arrestIcon, color: Colors.orange),
  EventCategoryModel(
      title: 'Fire Brigade',
      icon: AppImageAsset.fireBrigadeIcon,
      color: Colors.orange),
  EventCategoryModel(
      title: 'Gun fire', icon: AppImageAsset.gunFireIcon, color: Colors.grey),
  EventCategoryModel(
      title: 'Angry', icon: AppImageAsset.angryIcon, color: Colors.red),
  EventCategoryModel(
      title: 'Bank robbery',
      icon: AppImageAsset.bankRobberyIcon,
      color: Colors.grey),
  EventCategoryModel(
      title: 'Car accident',
      icon: AppImageAsset.carAccidentIcon,
      color: Colors.orange),
  EventCategoryModel(
      title: 'Airplane',
      icon: AppImageAsset.airplaneIcon,
      color: Colors.cyanAccent),
  EventCategoryModel(
      title: 'Alert', icon: AppImageAsset.alertIcon, color: Colors.red),
  EventCategoryModel(
      title: 'Theft alert',
      icon: AppImageAsset.theftAlertIcon,
      color: Colors.deepOrange),*/
  EventCategoryModel(
      title: 'Dangerous Tools',
      icon: AppImageAsset.dangerousIcon,
      color: Colors.grey),
  EventCategoryModel(
      title: 'Traffic Mishaps',
      icon: AppImageAsset.trafficMishapsIcon,
      color: Colors.grey),
  EventCategoryModel(
      title: 'Firearm Incidents',
      icon: AppImageAsset.fireArmsIcon,
      color: Colors.grey),
  EventCategoryModel(
      title: 'Physical Altercations',
      icon: AppImageAsset.physicalAltercationsIcon,
      color: Colors.grey),
  EventCategoryModel(
      title: 'Minor Fires',
      icon: AppImageAsset.minorFiresIcon,
      color: Colors.grey),
  EventCategoryModel(
      title: 'Major Blazes',
      icon: AppImageAsset.majorBlazesIcon,
      color: Colors.grey),
  EventCategoryModel(
      title: 'Lost Pets', icon: AppImageAsset.lostPetsIcon, color: Colors.grey),
  EventCategoryModel(
      title: 'Community Health',
      icon: AppImageAsset.communityHealthIcon,
      color: Colors.grey),
  EventCategoryModel(
      title: 'Severe Weather & Disasters',
      icon: AppImageAsset.severeWeatherIcon,
      color: Colors.grey),
  EventCategoryModel(
      title: 'Transport Updates',
      icon: AppImageAsset.transportUpdatesIcon,
      color: Colors.grey),
  EventCategoryModel(
      title: 'Promotional Alerts',
      icon: AppImageAsset.promotionalAlertsIcon,
      color: Colors.grey),
  EventCategoryModel(
      title: 'Police', icon: AppImageAsset.policeIcon, color: Colors.grey),
  EventCategoryModel(
      title: 'Goons', icon: AppImageAsset.goonIcon, color: Colors.grey),
  EventCategoryModel(
      title: 'Local Offender Watch',
      icon: AppImageAsset.localOffenderIcon,
      color: Colors.grey),
  EventCategoryModel(
      title: 'Rally', icon: AppImageAsset.rallyIcon, color: Colors.grey),
  EventCategoryModel(
      title: 'Mass Running',
      icon: AppImageAsset.massRunningIcon,
      color: Colors.grey),
  EventCategoryModel(
      title: 'Unknown Event',
      icon: AppImageAsset.unknownIcon,
      color: Colors.grey),
  EventCategoryModel(
      title: 'Others', icon: AppImageAsset.otherIcon, color: Colors.grey),
];

class EventCategoryModel {
  final String title;
  final String icon;
  final Color color;

  EventCategoryModel(
      {required this.title, required this.icon, required this.color});
}
