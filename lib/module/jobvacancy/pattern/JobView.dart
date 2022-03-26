abstract class JobView {

  onNetworkError();

  onSuccessJobDetail(Map data);

  onFailJobDetail(Map data);

  onSuccessJobList(Map data, int tabIndex);

  onFailJobList(Map data, int tabIndex);

  onSuccessJobSearch(Map data);

  onFailJobSearch(Map data);

  onSuccessJobCategory(Map data);

  onFailJobCategory(Map data);

  onSuccessJobListAll(Map data);

  onFailJobListAll(Map data);

  onSuccessProvince(Map data);

  onFailProvince(Map data);
  
  onSuccessCity(Map data);
  
  onFailCity(Map data);

}
