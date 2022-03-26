import 'package:icati_app/model/CheckingResponse.dart';

abstract class SplashView {
  saveToken(CheckingResponse checkingResponse);

  updateNewVersion(CheckingResponse checkingResponse);

  onSuccessIndex(Map data);

  onFailIndex(Map data);

  onSuccessCheckNewNotification(Map data);

  onFailCheckNewNotification(Map data);
}
