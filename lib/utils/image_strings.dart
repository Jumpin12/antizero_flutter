import 'package:flutter/material.dart';

const String progress1 = 'assets/images/Onboarding/onboardingProgress1.png';
const String progress2 = 'assets/images/Onboarding/onboardingProgress2.png';
const String progress3 = 'assets/images/Onboarding/onboardingProgress3.png';

const String male = 'assets/images/Onboarding/gender_male.png';
const String female = 'assets/images/Onboarding/gender_female.png';
const String binary = 'assets/images/Onboarding/gender_non_binary.png';

const String calendar = 'assets/images/Home/calendar_cicon.png';

const String academicIconP = "assets/people/teacher.svg";
const String workIconP = "assets/people/briefcasework.svg";
const String educationIconP = "assets/people/bookeducation.svg";
const String bioIconP = "assets/people/bio.svg";
const String injumpinForIconP = "assets/people/injumpinfor.svg";

const String editIcon = "assets/images/Profile/edit.png";
const String noLocationIcon = "assets/images/Profile/location-error.png";
const String locationIcon = "assets/images/SideNav/placeholder.png";
const String bioIcon = "assets/images/SideNav/information.png";
const String ageIcon = "assets/images/Profile/age.png";
const String workIcon = "assets/images/Profile/mortarboard.png";
const String professionIcon = "assets/images/Profile/suitcase.png";
const String collegeIcon = "assets/images/Profile/college.png";
const String academicIcon = "assets/images/Profile/certificate.png";

const String logoIcon = "assets/images/OnBoard/logo_final.png";
const String femaleIcon = 'assets/images/Home/female_black.png';
const String maleIcon = 'assets/images/Home/male_blue.png';
const String placeOfStudyIcon = 'assets/images/Home/college.png';
const String placeOfWorkIcon = 'assets/images/Home/work.png';
const String interestIcon = 'assets/images/Home/interest_home.png';
const String mutualIcon = 'assets/images/Home/mutual_friend.png';
const String blueShadeIcon =
    'assets/images/Home/people_background_blue_shades.png';
const String referIcon = 'assets/images/Home/refer_icon.png';
const String avatarIcon = 'assets/images/Profile/avatar.png';
// const String sendIcon = "assets/images/chats/send.png";
// const String sendChatIcon = "assets/images/chats/sendchat.png";
const String publicIcon = 'assets/images/Home/peopleBookedSpot.png';
const String privateIcon = 'assets/images/Home/bnb_user_icon.png';
const String scheduleIcon = "assets/images/plans/schedule.png";
const String memberIcon = "assets/images/plans/attendees.png";
const String moneyIcon = "assets/images/plans/money.png";
const String connectionIcon = "assets/images/SideNav/connection.png";
const String planIcon = "assets/images/SideNav/plan.png";
const String peopleReqIcon = "assets/images/SideNav/request.png";
const String planInviteIcon = "assets/images/SideNav/plan-invite.png";
const String bookMarkIcon = "assets/images/SideNav/bookmark.png";
const String suggestIcon = "assets/images/SideNav/request.png";
const String settingIcon = "assets/images/SideNav/settings.png";
const String logoutIcon = "assets/images/SideNav/log-out.png";
const String rateIcon = "assets/images/SideNav/rating.png";
const String aboutIcon = "assets/images/SideNav/information.png";

// plan new
const String clockIcon = "assets/images/plans/clock.png";
const String spotsIcon = "assets/images/plans/spots.png";
const String documentIcon = "assets/images/plans/document.png";
const String locationNIcon = "assets/images/plans/location.png";
const String calendarIcon = "assets/images/plans/calendar.png";
const String peopleTabIcon = "assets/images/plans/tab_people.png";
const String planTabIcon = "assets/images/plans/tab_plan.png";
const String bookmarkIcon = "assets/images/plans/thumbnail.png";
const String bookmarkPIcon = "assets/images/plans/thumbnail_pressed.png";
const String recommendLogoIcon = "assets/images/recommend_logo.svg";
// people
const String cookingIcon = 'assets/images/people/cooking.png';
const String locationpIcon = 'assets/images/people/location.png';
const String musicIcon = 'assets/images/people/music.png';
const String videoIcon = 'assets/images/people/video.png';

// dharam
const String messagesIcon = 'assets/icon/messages.svg';
const String arrowIcon = 'assets/icon/arrow.svg';
const String navmessagesIcon = 'assets/icon/messages.svg';
const String logoWhiteIcon = 'assets/icon/logo_white.png';
const String logoSplashIcon = 'assets/icon/ogo_splash.png';
const String bellIcon = 'assets/icon/bell.svg';
const String userSquareIcon = 'assets/icon/usersquare.svg';
const String createCalendarIcon = 'assets/icon/calendar.svg';
const String createClipboardIcon = 'assets/icon/clipboard-text.svg';
const String createDocumentIcon = 'assets/icon/document-text.svg';
const String createDollarIcon = 'assets/icon/dollar_squa.svg';
const String createGalleryIcon = 'assets/icon/gallery.svg';
const String createLocationIcon = 'assets/icon/location.svg';
const String createAttachIcon = 'assets/icon/attach.svg';
const String navigationbarIcon = 'assets/icon/navigationbar_icon.png';
const String jumpInIcon = "assets/images/jumpin_plan_logo.svg";
const String recommendIcon = "assets/icon/recommend_logo.png";
const String logo = "assets/icon/rsz_logo_white.png";
const String rightIcon = 'assets/icon/right_icon.png';
const String wrongIcon = 'assets/icon/wrong_icon.png';

final Map<String, String> PlanCatName = {
  'Outdoor Sports': "assets/images/plans/outdoor.png",
  'Indoor Sports': "assets/images/plans/indoor.png",
  'Health & Fitness': "assets/images/plans/fitness.png",
  'Travel & Adventure': "assets/images/plans/travel.png",
  'Food & Drinks': "assets/images/plans/food.png",
  'Games': "assets/images/plans/games.png",
  'Academic interests': "assets/images/plans/academic.png",
  'Career & Professional interests': "assets/images/plans/professional.png",
  'Entertainment': "assets/images/plans/entertainment.png",
  'Hobbies': "assets/images/plans/hobbies.png",
  'Causes passionate about': "assets/images/plans/causes.png",
  'Fandoms': "assets/images/plans/fandoms.png",
  'Competitive Exams': "assets/images/plans/competitive.png",
  'Miscellaneous': "assets/images/plans/miscellaneous.png",
};

final Map<String, String> companyNameList = {
  'Vedantu': "assets/images/plans/outdoor.png",
  'Nykaa': "assets/images/plans/indoor.png",
  'Career Labs': "assets/images/plans/fitness.png",
  'AntiZero Technologies': "assets/images/plans/travel.png",
  'DevRev': "assets/images/plans/food.png",
  'JP Morgan Chase & Co': "assets/images/plans/games.png",
  'Ola Cabs': "assets/images/plans/academic.png",
  'White Tooth Technologies': "assets/images/plans/professional.png",
  'Wells Fargo': "assets/images/plans/entertainment.png",
  'Cello': "assets/images/plans/hobbies.png"
};
