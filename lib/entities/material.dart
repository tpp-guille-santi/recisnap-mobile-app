class RecyclableMaterial {
  final String id;
  final String name;
  final int order;
  final bool enabled;

  RecyclableMaterial(this.id, this.name, this.order, this.enabled);

  RecyclableMaterial.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        order = json['order'],
        enabled = json['enabled'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'order': order,
        'enabled': enabled,
      };
}
