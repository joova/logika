class PlmUom {
  String code;
  String name;


  PlmUom({
    this.code, 
    this.name
  });

  factory PlmUom.fromJson(Map<String, dynamic> plmUom) => 
    PlmUom(
      code: plmUom['code'], 
      name: plmUom['name']
    );

  Map toJson() => {
    'code': code, 
    'name': name
    };
}