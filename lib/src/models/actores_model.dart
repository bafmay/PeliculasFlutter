
class Cast{
  List<Actor> actores = List();

  Cast.fromJsonList(List<dynamic> jsonList){
    if(jsonList == null ) return;
    final list = jsonList.map((item) {
      return Actor.fromJsonMap(item);
    });

    actores.addAll(list);
  }
}

class Actor {
  int castId;
  String character;
  String creditId;
  int gender;
  int id;
  String name;
  int order;
  String profilePath;

  Actor({
    this.castId,
    this.character,
    this.creditId,
    this.gender,
    this.id,
    this.name,
    this.order,
    this.profilePath,
  });

  Actor.fromJsonMap(Map<String,dynamic> json){
    this.castId = json['cast_id'];
    this.character = json['character'];
    this.creditId = json['credit_id'];
    this.gender = json['gender'];
    this.id = json['id'];
    this.name = json['name'];
    this.order = json['order'];
    this.profilePath = json['profile_path'];
  }

  String getPhoto() {
    if (profilePath != null) {
      return 'https://image.tmdb.org/t/p/w500$profilePath';
    } else {
      return 'https://pngimage.net/wp-content/uploads/2018/06/no-avatar-png-5.png';
    }
  }

}