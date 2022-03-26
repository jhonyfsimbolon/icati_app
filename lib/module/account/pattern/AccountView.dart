abstract class AccountView {
  onSuccessProfile(Map data);

  onFailProfile(Map data);

  onSuccessLogout(Map data);

  onFailLogout(Map data);

  onSuccessWaKeyword(Map data);

  onSuccessResendVerifyEmail(Map data);

  onFailResendVerifyEmail(Map data);

  onNetworkError();

  onSuccessMemberCard(Map data);

  onFailMemberCard(Map data);
}
