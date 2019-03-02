class PlmType {
  String code;
  String name;


  PlmType({
    this.code, 
    this.name
  });

  factory PlmType.fromJson(Map<String, dynamic> plmType) => 
    PlmType(
      code: plmType['code'], 
      name: plmType['name']
    );

  Map toJson() => {
    'code': code, 
    'name': name
    };
}