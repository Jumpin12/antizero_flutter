import 'package:antizero_jumpin/services/auth.dart';
import 'package:antizero_jumpin/services/bookmark.dart';
import 'package:antizero_jumpin/services/chat.dart';
import 'package:antizero_jumpin/services/interest.dart';
import 'package:antizero_jumpin/services/notification.dart';
import 'package:antizero_jumpin/services/plan.dart';
import 'package:antizero_jumpin/services/user.dart';
import 'package:get_it/get_it.dart';

AuthService get authServ => GetIt.I<AuthService>();
UserService get userServ => GetIt.I<UserService>();
InterestService get intServ => GetIt.I<InterestService>();
ChatService get chatServ => GetIt.I<ChatService>();
PlanService get planServ => GetIt.I<PlanService>();
BookMarkService get bookServ => GetIt.I<BookMarkService>();
NotificationService get notServ => GetIt.I<NotificationService>();
