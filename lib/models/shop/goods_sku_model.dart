class GoodsSkuModel {
  int? id;
  String? skuId;
  num? price;
  int? quantity;
  String? properties;
  String? specName;
  late List<String> images;
  String? propertiesName;

  GoodsSkuModel();

  GoodsSkuModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    skuId = json['sku_id'];
    if (json['quantity'] is String) {
      price = int.parse(json['quantity']);
    } else {
      price = json['quantity'];
    }
    if (json['price'] is String) {
      price = num.parse(json['price']);
    } else {
      price = json['price'];
    }
    specName = json['spec_name'];
    properties = json['properties'];
    if (json['images'] != null) {
      images = (json['images'] as List).cast<String>();
    } else {
      images = [];
    }
    if (json['properties_name'] is String &&
        json['properties_name'].isNotEmpty) {
      propertiesName = json['properties_name'];
      for (var str in properties!.split(';')) {
        var propStr = str + ':';
        propertiesName = propertiesName!.replaceAll(RegExp(propStr), '');
      }
    } else {
      propertiesName = properties;
    }
  }
}
