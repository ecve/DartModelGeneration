import 'package:lugwing/utils/app_exports.dart';
import 'package:lugwing/utils/constants/app_components.dart';
import 'package:lugwing/utils/helpers/api_helpers/api_helper.dart';

class SingleRequestResponse {
  bool success;
  String message;
  SinglePickupRequest pickupRequest;

  SingleRequestResponse(
      {this.success = false, this.message = '', required this.pickupRequest});

  factory SingleRequestResponse.fromJson(Map<String, dynamic> json) {
    return SingleRequestResponse(
      success: APIHelper.getSafeBoolValue(json['success']),
      message: APIHelper.getSafeStringValue(json['message']),
      pickupRequest: SinglePickupRequest.getAPIResponseObjectSafeValue(
          json['pickup_request']),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'pickup_request': pickupRequest.toJson(),
      };

  factory SingleRequestResponse.empty() => SingleRequestResponse(
        pickupRequest: SinglePickupRequest.empty(),
      );
  static SingleRequestResponse getAPIResponseObjectSafeValue(
          dynamic unsafeResponseValue) =>
      APIHelper.isAPIResponseObjectSafe(unsafeResponseValue)
          ? SingleRequestResponse.fromJson(
              unsafeResponseValue as Map<String, dynamic>)
          : SingleRequestResponse.empty();
}

class SinglePickupRequest {
  int id;
  int userId;
  String pickupRequestId;
  String flightId;
  String airline;
  String origin;
  DateTime departureDatetime;
  String destination;
  DateTime arrivalDatetime;
  int largeBags;
  int caryOnBags;
  int specialtyBags;
  String bagImages;
  String pickupRequestStatus;
  double serviceFee;
  double taxFee;
  double totalCost;
  DateTime createdAt;
  DateTime updatedAt;
  PickupAddress pickupAddress;

  SinglePickupRequest({
    this.id = 0,
    this.userId = 0,
    this.pickupRequestId = '',
    this.flightId = '',
    this.airline = '',
    this.origin = '',
    required this.departureDatetime,
    this.destination = '',
    required this.arrivalDatetime,
    this.largeBags = 0,
    this.caryOnBags = 0,
    this.specialtyBags = 0,
    this.bagImages = '',
    this.pickupRequestStatus = '',
    this.serviceFee = 0,
    this.taxFee = 0,
    this.totalCost = 0,
    required this.createdAt,
    required this.updatedAt,
    required this.pickupAddress,
  });

  factory SinglePickupRequest.fromJson(Map<String, dynamic> json) =>
      SinglePickupRequest(
        id: APIHelper.getSafeIntValue(json['id']),
        userId: APIHelper.getSafeIntValue(json['user_id']),
        pickupRequestId:
            APIHelper.getSafeStringValue(json['pickup_request_id']),
        flightId: APIHelper.getSafeStringValue(json['flight_id']),
        airline: APIHelper.getSafeStringValue(json['airline']),
        origin: APIHelper.getSafeStringValue(json['origin']),
        departureDatetime:
            APIHelper.getSafeDateTimeValue(json['departure_datetime']),
        destination: APIHelper.getSafeStringValue(json['destination']),
        arrivalDatetime:
            APIHelper.getSafeDateTimeValue(json['arrival_datetime']),
        largeBags: APIHelper.getSafeIntValue(json['large_bags']),
        caryOnBags: APIHelper.getSafeIntValue(json['cary_on_bags']),
        specialtyBags: APIHelper.getSafeIntValue(json['specialty_bags']),
        bagImages: APIHelper.getSafeStringValue(json['bag_images']),
        pickupRequestStatus:
            APIHelper.getSafeStringValue(json['pickup_request_status']),
        serviceFee: APIHelper.getSafeDoubleValue(json['service_fee']),
        taxFee: APIHelper.getSafeDoubleValue(json['tax_fee']),
        totalCost: APIHelper.getSafeDoubleValue(json['total_cost']),
        createdAt: APIHelper.getSafeDateTimeValue(json['created_at']),
        updatedAt: APIHelper.getSafeDateTimeValue(json['updated_at']),
        pickupAddress:
            PickupAddress.getAPIResponseObjectSafeValue(json['pickup_address']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'pickup_request_id': pickupRequestId,
        'flight_id': flightId,
        'airline': airline,
        'origin': origin,
        'departure_datetime':
            APIHelper.toServerDateTimeFormattedStringFromDateTime(
                departureDatetime),
        'destination': destination,
        'arrival_datetime':
            APIHelper.toServerDateTimeFormattedStringFromDateTime(
                arrivalDatetime),
        'large_bags': largeBags,
        'cary_on_bags': caryOnBags,
        'specialty_bags': specialtyBags,
        'bag_images': bagImages,
        'pickup_request_status': pickupRequestStatus,
        'service_fee': serviceFee,
        'tax_fee': taxFee,
        'total_cost': totalCost,
        'created_at':
            APIHelper.toServerDateTimeFormattedStringFromDateTime(createdAt),
        'updated_at':
            APIHelper.toServerDateTimeFormattedStringFromDateTime(updatedAt),
        'pickup_address': pickupAddress.toJson(),
      };

  factory SinglePickupRequest.empty() => SinglePickupRequest(
        departureDatetime: AppComponents.defaultUnsetDateTime,
        arrivalDatetime: AppComponents.defaultUnsetDateTime,
        createdAt: AppComponents.defaultUnsetDateTime,
        updatedAt: AppComponents.defaultUnsetDateTime,
        pickupAddress: PickupAddress.empty(),
      );
  static SinglePickupRequest getAPIResponseObjectSafeValue(
          dynamic unsafeResponseValue) =>
      APIHelper.isAPIResponseObjectSafe(unsafeResponseValue)
          ? SinglePickupRequest.fromJson(
              unsafeResponseValue as Map<String, dynamic>)
          : SinglePickupRequest.empty();
}

class PickupAddress {
  int id;
  int pickupRequestId;
  String address;
  DateTime pickupDate;
  TimeOfDay pickupTime;
  String pickupLocation;
  String driverInstructions;
  DateTime createdAt;
  DateTime updatedAt;

  PickupAddress({
    this.id = 0,
    this.pickupRequestId = 0,
    this.address = '',
    required this.pickupDate,
    required this.pickupTime,
    this.pickupLocation = '',
    this.driverInstructions = '',
    required this.createdAt,
    required this.updatedAt,
  });

  factory PickupAddress.fromJson(Map<String, dynamic> json) => PickupAddress(
        id: APIHelper.getSafeIntValue(json['id']),
        pickupRequestId: APIHelper.getSafeIntValue(json['pickup_request_id']),
        address: APIHelper.getSafeStringValue(json['address']),
        pickupDate: APIHelper.getSafeDateTimeValue(json['pickup_date']),
        pickupTime: APIHelper.getSafeTimeOfDayValue(json['pickup_time']),
        pickupLocation: APIHelper.getSafeStringValue(json['pickup_location']),
        driverInstructions:
            APIHelper.getSafeStringValue(json['driver_instructions']),
        createdAt: APIHelper.getSafeDateTimeValue(json['created_at']),
        updatedAt: APIHelper.getSafeDateTimeValue(json['updated_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'pickup_request_id': pickupRequestId,
        'address': address,
        'pickup_date':
            APIHelper.toServerDateTimeFormattedStringFromDateTime(pickupDate),
        'pickup_time': APIHelper.toTimeOfDayToString24HourFormat(pickupTime),
        'pickup_location': pickupLocation,
        'driver_instructions': driverInstructions,
        'created_at':
            APIHelper.toServerDateTimeFormattedStringFromDateTime(createdAt),
        'updated_at':
            APIHelper.toServerDateTimeFormattedStringFromDateTime(updatedAt),
      };

  factory PickupAddress.empty() => PickupAddress(
        pickupDate: AppComponents.defaultUnsetDateTime,
        pickupTime: AppComponents.defaultUnsetTimeOfDay,
        createdAt: AppComponents.defaultUnsetDateTime,
        updatedAt: AppComponents.defaultUnsetDateTime,
      );
  static PickupAddress getAPIResponseObjectSafeValue(
          dynamic unsafeResponseValue) =>
      APIHelper.isAPIResponseObjectSafe(unsafeResponseValue)
          ? PickupAddress.fromJson(unsafeResponseValue as Map<String, dynamic>)
          : PickupAddress.empty();
}