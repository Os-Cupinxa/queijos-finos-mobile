import 'package:queijo_finos_mobile/models/ActiveContracts.dart';

class ProprietyDTO {

  ProprietyDTO({
    required this.name,
    required this.onwer,
    required this.city,
    required this.state,
    required this.status,
    required this.contractsActive,
    required this.latitude,
    required this.longitude,
  });
  final String name;
  final String onwer;
  final String city;
  final String state;
  final int status;
  final String latitude;
  final String longitude;
  final List<ActiveContracts> contractsActive;
}
