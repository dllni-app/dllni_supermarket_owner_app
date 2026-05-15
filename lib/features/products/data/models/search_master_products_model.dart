import 'dart:convert';

String? _asString(dynamic value) {
  if (value == null) return null;
  if (value is String) return value;
  if (value is num || value is bool) return value.toString();
  return null;
}

int? _asInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) {
    return int.tryParse(value) ?? double.tryParse(value)?.toInt();
  }
  return null;
}

bool? _asBool(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (value is num) {
    if (value == 1) return true;
    if (value == 0) return false;
  }
  if (value is String) {
    final normalized = value.trim().toLowerCase();
    if (normalized == 'true' || normalized == '1') return true;
    if (normalized == 'false' || normalized == '0') return false;
  }
  return null;
}

dynamic _asDynamic(dynamic value) {
  if (value == null) return null;
  if (value is List) {
    return value.map(_asDynamic).toList();
  }
  if (value is Map) {
    final map = <String, dynamic>{};
    value.forEach((key, nestedValue) {
      map['$key'] = _asDynamic(nestedValue);
    });
    return map;
  }
  if (value is String || value is num || value is bool) {
    return value;
  }
  return value.toString();
}

SearchMasterProductsModel searchMasterProductsModelFromJson(dynamic str) =>
    SearchMasterProductsModel.fromJson(Map<String, dynamic>.from(str as Map));

String searchMasterProductsModelToJson(SearchMasterProductsModel data) =>
    json.encode(data.toJson());

class SearchMasterProductsModel {
  List<SearchMasterProductsDataItem>? data;
  SearchMasterProductsLinks? links;
  SearchMasterProductsMeta? meta;

  SearchMasterProductsModel({this.data, this.links, this.meta});

  factory SearchMasterProductsModel.fromJson(Map<String, dynamic> json) {
    return SearchMasterProductsModel(
      data: json['data'] is List
          ? (json['data'] as List)
                .whereType<Map>()
                .map(
                  (item) => SearchMasterProductsDataItem.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList()
          : null,
      links: json['links'] is Map
          ? SearchMasterProductsLinks.fromJson(
              Map<String, dynamic>.from(json['links'] as Map),
            )
          : null,
      meta: json['meta'] is Map
          ? SearchMasterProductsMeta.fromJson(
              Map<String, dynamic>.from(json['meta'] as Map),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.map((item) => item.toJson()).toList(),
      'links': links?.toJson(),
      'meta': meta?.toJson(),
    };
  }
}

class SearchMasterProductsMeta {
  int? currentPage;
  int? from;
  int? lastPage;
  List<SearchMasterProductsMetaLinksItem>? links;
  String? path;
  int? perPage;
  int? to;
  int? total;

  SearchMasterProductsMeta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.links,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  factory SearchMasterProductsMeta.fromJson(Map<String, dynamic> json) {
    return SearchMasterProductsMeta(
      currentPage: _asInt(json['current_page']),
      from: _asInt(json['from']),
      lastPage: _asInt(json['last_page']),
      links: json['links'] is List
          ? (json['links'] as List)
                .whereType<Map>()
                .map(
                  (item) => SearchMasterProductsMetaLinksItem.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList()
          : null,
      path: _asString(json['path']),
      perPage: _asInt(json['per_page']),
      to: _asInt(json['to']),
      total: _asInt(json['total']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'from': from,
      'last_page': lastPage,
      'links': links?.map((item) => item.toJson()).toList(),
      'path': path,
      'per_page': perPage,
      'to': to,
      'total': total,
    };
  }
}

class SearchMasterProductsMetaLinksItem {
  String? url;
  String? label;
  int? page;
  bool? active;

  SearchMasterProductsMetaLinksItem({
    this.url,
    this.label,
    this.page,
    this.active,
  });

  factory SearchMasterProductsMetaLinksItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return SearchMasterProductsMetaLinksItem(
      url: _asString(json['url']),
      label: _asString(json['label']),
      page: _asInt(json['page']),
      active: _asBool(json['active']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'url': url, 'label': label, 'page': page, 'active': active};
  }
}

class SearchMasterProductsLinks {
  String? first;
  String? last;
  dynamic prev;
  dynamic next;

  SearchMasterProductsLinks({this.first, this.last, this.prev, this.next});

  factory SearchMasterProductsLinks.fromJson(Map<String, dynamic> json) {
    return SearchMasterProductsLinks(
      first: _asString(json['first']),
      last: _asString(json['last']),
      prev: _asDynamic(json['prev']),
      next: _asDynamic(json['next']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'first': first, 'last': last, 'prev': prev, 'next': next};
  }
}

class SearchMasterProductsDataItem {
  int? id;
  int? masterProductId;
  String? name;
  String? unit;
  String? brand;
  String? description;
  String? primaryImage;
  bool? isActive;

  SearchMasterProductsDataItem({
    this.id,
    this.masterProductId,
    this.name,
    this.unit,
    this.brand,
    this.description,
    this.primaryImage,
    this.isActive,
  });

  factory SearchMasterProductsDataItem.fromJson(Map<String, dynamic> json) {
    return SearchMasterProductsDataItem(
      id: _asInt(json['id']),
      masterProductId: _asInt(json['masterProductId']),
      name: _asString(json['name']),
      unit: _asString(json['unit']),
      brand: _asString(json['brand']),
      description: _asString(json['description']),
      primaryImage: _asString(json['primaryImage']),
      isActive: _asBool(json['isActive']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'masterProductId': masterProductId,
      'name': name,
      'unit': unit,
      'brand': brand,
      'description': description,
      'primaryImage': primaryImage,
      'isActive': isActive,
    };
  }
}
