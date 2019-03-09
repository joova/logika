class PlmCategory {
  String code;
  String name;


  PlmCategory({
    this.code, 
    this.name
  });

  factory PlmCategory.fromJson(Map<String, dynamic> plmCategory) => 
    PlmCategory(
      code: plmCategory['code'], 
      name: plmCategory['name']
    );

  Map toJson() => {
    'code': code, 
    'name': name
    };
}