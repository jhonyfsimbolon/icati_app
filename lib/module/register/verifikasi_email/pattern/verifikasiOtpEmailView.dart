abstract class VerifikasiOtpEmailView {
  onSuccessSendOtpEmail(Map data);

  onFailSendOtpEmail(Map data);

  onSuccessLoginOtpEmail(Map data);

  onFailLoginOtpEmail(Map data);

  onSuccessResendLoginOtpEmail(Map data);

  onFailResendLoginOtpEmail(Map data);

  onNetworkError();
}
