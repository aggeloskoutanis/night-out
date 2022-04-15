import 'user.dart';

class InvitedUserItem {
  final UserDetails user;
  bool isInvited;

  InvitedUserItem({required this.user, this.isInvited = false});
}
