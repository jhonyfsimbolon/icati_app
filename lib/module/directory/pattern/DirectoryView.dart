abstract class DirectoryView {
  onNetworkError();

  onSuccessDirectoryDetail(Map data);

  onFailDirectoryDetail(Map data);

  onSuccessDirectoryCategory(Map data);

  onFailDirectoryCategory(Map data);

  onSuccessDirectorySubCat(Map data, String page, int tapIndex);

  onFailDirectorySubCat(Map data, String page, int tapIndex);

  onSuccessDirectorySearch(Map data);

  onFailDirectorySearch(Map data);

  onSuccessCity(Map data);

  onFailCity(Map data);

  onSuccessProvince(Map data);

  onFailProvince(Map data);
}
