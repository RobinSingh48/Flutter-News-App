class Newmodel {
  String? title;
  String? description;
  String? url;
  String? urlToImage;

  Newmodel({this.title,this.description,this.url,this.urlToImage});

   Newmodel.fromJson(Map<String,dynamic> json){
    title = json["title"];
    description = json["description"];
    url = json["url"];
    urlToImage = json["urlToImage"];
   }
}