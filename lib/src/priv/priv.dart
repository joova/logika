class Priv {
  String id;
  Resource resource;
  Action action;


  Priv({
    this.id, 
    this.resource,
    this.action,
  });

  factory Priv.fromJson(Map<String, dynamic> priv) => 
    Priv(
      id: priv['id'], 
      resource: Resource.fromJson(priv['resource']),
      action: Action.fromJson(priv['action']),
    );

  Map toJson() => {
    // 'id': _id, 
    'resource': resource.toJson(),
    'action':action.toJson()
    };
}

class Resource {
  String id;
  String name;
  String uri;

   Resource({
    this.id, 
    this.name,
    this.uri,
  });

  factory Resource.fromJson(Map<String, dynamic> res) => 
    Resource(
      id: res['id'], 
      name: res['name'],
      uri: res['uri']
    );

  Map toJson() => {
    // 'id': _id, 
    'name': name
    };
}

class Action {
  String code;
  String name;
 
   Action({
    this.code, 
    this.name
  });

  factory Action.fromJson(Map<String, dynamic> act) => 
    Action(
      code: act['code'], 
      name: act['name']
    );

  Map toJson() => {
    'code': code, 
    'name': name
    };
}