import 'package:lugwing/utils/constants/app_components.dart';
import 'package:lugwing/utils/helpers/api_helpers/api_helper.dart';

class TestingModel {
  bool booleanValue;
  String stringValue;
  double doubleValue;
  dynamic nullValue;
  Model model;
  DateTime createdAt;
  DateTime updatedAt;
  List<SingleData> data;
  List<String> listString;
  List<dynamic> listDynamic;
  MultiNestedModels multiNestedModels;

  TestingModel({
    this.booleanValue = false,
    this.stringValue = '',
    this.doubleValue = 0.0,
    this.nullValue,
    required this.model,
    required this.createdAt,
    required this.updatedAt,
    this.data = const [],
    this.listString = const [],
    this.listDynamic = const [],
    required this.multiNestedModels,
  });

  factory TestingModel.fromJson(Map<String, dynamic> json) => TestingModel(
        booleanValue: APIHelper.getSafeBoolValue(json['boolean_value']),
        stringValue: APIHelper.getSafeStringValue(json['string_value']),
        doubleValue: APIHelper.getSafeDoubleValue(json['double_value']),
        nullValue: json['null_value'],
        model: Model.getAPIResponseObjectSafeValue(json['model']),
        createdAt: APIHelper.getSafeDateTimeValue(json['created_at']),
        updatedAt: APIHelper.getSafeDateTimeValue(json['updated_at']),
        data: APIHelper.getSafeListValue(json['data'])
            .map((e) => SingleData.getAPIResponseObjectSafeValue(e))
            .toList(),
        listString: APIHelper.getSafeListValue(json['list_string'])
            .map((e) => APIHelper.getSafeStringValue(e))
            .toList(),
        listDynamic: APIHelper.getSafeListValue(json['list_dynamic'])
            .map((e) => e)
            .toList(),
        multiNestedModels: MultiNestedModels.getAPIResponseObjectSafeValue(
            json['multi_nested_models']),
      );

  Map<String, dynamic> toJson() => {
        'boolean_value': booleanValue,
        'string_value': stringValue,
        'double_value': doubleValue,
        'null_value': nullValue,
        'model': model.toJson(),
        'created_at':
            APIHelper.toServerDateTimeFormattedStringFromDateTime(createdAt),
        'updated_at':
            APIHelper.toServerDateTimeFormattedStringFromDateTime(updatedAt),
        'data': data.map((e) => e.toJson()).toList(),
        'list_string': listString,
        'list_dynamic': listDynamic,
        'multi_nested_models': multiNestedModels.toJson(),
      };

  factory TestingModel.empty() => TestingModel(
        createdAt: AppComponents.defaultUnsetDateTime,
        updatedAt: AppComponents.defaultUnsetDateTime,
        model: Model(),
        multiNestedModels: MultiNestedModels.empty(),
      );
  static TestingModel getAPIResponseObjectSafeValue(
          dynamic unsafeResponseValue) =>
      APIHelper.isAPIResponseObjectSafe(unsafeResponseValue)
          ? TestingModel.fromJson(unsafeResponseValue as Map<String, dynamic>)
          : TestingModel.empty();
}

class MultiNestedModels {
  int id;
  Product product;
  bool isApproved;
  int inStock;
  double price;

  MultiNestedModels({
    this.id = 0,
    required this.product,
    this.isApproved = false,
    this.inStock = 0,
    this.price = 0.0,
  });

  factory MultiNestedModels.fromJson(Map<String, dynamic> json) {
    return MultiNestedModels(
      id: APIHelper.getSafeIntValue(json['id']),
      product: Product.getAPIResponseObjectSafeValue(json['product']),
      isApproved: APIHelper.getSafeBoolValue(json['is_approved']),
      inStock: APIHelper.getSafeIntValue(json['in_stock']),
      price: APIHelper.getSafeDoubleValue(json['price']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'product': product.toJson(),
        'is_approved': isApproved,
        'in_stock': inStock,
        'price': price,
      };

  factory MultiNestedModels.empty() => MultiNestedModels(
        product: Product.empty(),
      );
  static MultiNestedModels getAPIResponseObjectSafeValue(
          dynamic unsafeResponseValue) =>
      APIHelper.isAPIResponseObjectSafe(unsafeResponseValue)
          ? MultiNestedModels.fromJson(
              unsafeResponseValue as Map<String, dynamic>)
          : MultiNestedModels.empty();
}

class Product {
  int id;
  String name;
  String description;
  String junkValue;
  User user;
  Category category;

  Product({
    this.id = 0,
    this.name = '',
    this.description = '',
    this.junkValue = '',
    required this.user,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: APIHelper.getSafeIntValue(json['id']),
        name: APIHelper.getSafeStringValue(json['name']),
        description: APIHelper.getSafeStringValue(json['description']),
        junkValue: APIHelper.getSafeStringValue(json['junk_value']),
        user: User.getAPIResponseObjectSafeValue(json['user']),
        category: Category.getAPIResponseObjectSafeValue(json['category']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'junk_value': junkValue,
        'user': user.toJson(),
        'category': category.toJson(),
      };

  factory Product.empty() => Product(user: User.empty(), category: Category());
  static Product getAPIResponseObjectSafeValue(dynamic unsafeResponseValue) =>
      APIHelper.isAPIResponseObjectSafe(unsafeResponseValue)
          ? Product.fromJson(unsafeResponseValue as Map<String, dynamic>)
          : Product.empty();
}

class User {
  int id;
  String name;
  String description;
  String junkValue;
  Address address;

  User({
    this.id = 0,
    this.name = '',
    this.description = '',
    this.junkValue = '',
    required this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: APIHelper.getSafeIntValue(json['id']),
        name: APIHelper.getSafeStringValue(json['name']),
        description: APIHelper.getSafeStringValue(json['description']),
        junkValue: APIHelper.getSafeStringValue(json['junk_value']),
        address: Address.getAPIResponseObjectSafeValue(json['address']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'junk_value': junkValue,
        'address': address.toJson(),
      };

  factory User.empty() => User(
        address: Address(),
      );
  static User getAPIResponseObjectSafeValue(dynamic unsafeResponseValue) =>
      APIHelper.isAPIResponseObjectSafe(unsafeResponseValue)
          ? User.fromJson(unsafeResponseValue as Map<String, dynamic>)
          : User.empty();
}

class Address {
  int id;
  String name;
  String description;
  String junkValue;

  Address(
      {this.id = 0,
      this.name = '',
      this.description = '',
      this.junkValue = ''});

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: APIHelper.getSafeIntValue(json['id']),
        name: APIHelper.getSafeStringValue(json['name']),
        description: APIHelper.getSafeStringValue(json['description']),
        junkValue: APIHelper.getSafeStringValue(json['junk_value']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'junk_value': junkValue,
      };

  static Address getAPIResponseObjectSafeValue(dynamic unsafeResponseValue) =>
      APIHelper.isAPIResponseObjectSafe(unsafeResponseValue)
          ? Address.fromJson(unsafeResponseValue as Map<String, dynamic>)
          : Address();
}

class Category {
  int id;
  String name;
  String description;
  String junkValue;
  List<SubCategory> subCategory;

  Category({
    this.id = 0,
    this.name = '',
    this.description = '',
    this.junkValue = '',
    this.subCategory = const [],
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: APIHelper.getSafeIntValue(json['id']),
        name: APIHelper.getSafeStringValue(json['name']),
        description: APIHelper.getSafeStringValue(json['description']),
        junkValue: APIHelper.getSafeStringValue(json['junk_value']),
        subCategory: APIHelper.getSafeListValue(json['sub_category'])
            .map((e) => SubCategory.getAPIResponseObjectSafeValue(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'junk_value': junkValue,
        'sub_category': subCategory.map((e) => e.toJson()).toList(),
      };

  static Category getAPIResponseObjectSafeValue(dynamic unsafeResponseValue) =>
      APIHelper.isAPIResponseObjectSafe(unsafeResponseValue)
          ? Category.fromJson(unsafeResponseValue as Map<String, dynamic>)
          : Category();
}

class SubCategory {
  int id;
  String name;
  String description;
  String junkValue;

  SubCategory(
      {this.id = 0,
      this.name = '',
      this.description = '',
      this.junkValue = ''});

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
        id: APIHelper.getSafeIntValue(json['id']),
        name: APIHelper.getSafeStringValue(json['name']),
        description: APIHelper.getSafeStringValue(json['description']),
        junkValue: APIHelper.getSafeStringValue(json['junk_value']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'junk_value': junkValue,
      };

  static SubCategory getAPIResponseObjectSafeValue(
          dynamic unsafeResponseValue) =>
      APIHelper.isAPIResponseObjectSafe(unsafeResponseValue)
          ? SubCategory.fromJson(unsafeResponseValue as Map<String, dynamic>)
          : SubCategory();
}

class SingleData {
  int id;
  String name;
  String description;
  String junkValue;

  SingleData(
      {this.id = 0,
      this.name = '',
      this.description = '',
      this.junkValue = ''});

  factory SingleData.fromJson(Map<String, dynamic> json) => SingleData(
        id: APIHelper.getSafeIntValue(json['id']),
        name: APIHelper.getSafeStringValue(json['name']),
        description: APIHelper.getSafeStringValue(json['description']),
        junkValue: APIHelper.getSafeStringValue(json['junk_value']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'junk_value': junkValue,
      };

  static SingleData getAPIResponseObjectSafeValue(
          dynamic unsafeResponseValue) =>
      APIHelper.isAPIResponseObjectSafe(unsafeResponseValue)
          ? SingleData.fromJson(unsafeResponseValue as Map<String, dynamic>)
          : SingleData();
}

class Model {
  int id;
  String name;
  String description;
  String junkValue;

  Model(
      {this.id = 0,
      this.name = '',
      this.description = '',
      this.junkValue = ''});

  factory Model.fromJson(Map<String, dynamic> json) => Model(
        id: APIHelper.getSafeIntValue(json['id']),
        name: APIHelper.getSafeStringValue(json['name']),
        description: APIHelper.getSafeStringValue(json['description']),
        junkValue: APIHelper.getSafeStringValue(json['junk_value']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'junk_value': junkValue,
      };

  static Model getAPIResponseObjectSafeValue(dynamic unsafeResponseValue) =>
      APIHelper.isAPIResponseObjectSafe(unsafeResponseValue)
          ? Model.fromJson(unsafeResponseValue as Map<String, dynamic>)
          : Model();
}
