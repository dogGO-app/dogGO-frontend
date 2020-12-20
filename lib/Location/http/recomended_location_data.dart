import 'package:doggo_frontend/Location/http/location.dart';
import 'package:doggo_frontend/Location/http/useranddogs.dart';

class RecommendedLocation {
  final double rating;
  final LocationMarker marker;
  final List<UserAndDogsInLocation> usersanddogs;


  const RecommendedLocation({this.marker, this.usersanddogs, this.rating});

  factory RecommendedLocation.fromJson(Map<String, dynamic> json) {

    return RecommendedLocation(
      marker: LocationMarker.fromJsonRecommendation(json['mapMarkerRecommendation']),
      usersanddogs: (json['dogLoversInLocation'] as List).map((e) => UserAndDogsInLocation.fromJson(e)).toList(),
      rating: json['rating']
    );
  }
}
