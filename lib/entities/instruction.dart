class Instruction {
  final String id;
  final String materialName;
  final bool editable;
  final double lat;
  final double lon;
  final String? provincia;
  final String? departamento;
  final String? municipio;


  Instruction(this.materialName, this.editable, this.lat, this.lon,
      this.provincia, this.departamento, this.municipio, this.id);

  Instruction.fromJson(Map<String, dynamic> json)
      : materialName = json['material_name'],
        editable = json['editable'],
        lat = json['lat'],
        lon = json['lon'],
        provincia = json['provincia'],
        departamento = json['departamento'],
        municipio = json['municipio'],
        id = json['id'];

  Map<String, dynamic> toJson() => {
        'material_name': materialName,
        'editable': editable,
        'lat': lat,
        'lon': lon,
        'provincia': provincia,
        'departamento': departamento,
        'municipio': municipio,
        'id': id,
      };
}
