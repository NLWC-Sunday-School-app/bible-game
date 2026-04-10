import 'package:bible_game/shared/constants/image_routes.dart';

String getBadgeUrl(rank) {
  if (rank == 'babe') {
    return ProductImageRoutes.babeBadge;
  }
  if (rank == 'child') {
    return ProductImageRoutes.childBadge;
  }
  if (rank == 'young believer') {
    return ProductImageRoutes.youngBelieverBadge;
  }
  if (rank == 'charity') {
    return ProductImageRoutes.charityBadge;
  }
  if (rank == 'father') {
    return ProductImageRoutes.fatherBadge;
  }
  if (rank == 'elder') {
    return ProductImageRoutes.elderBadge;
  }
  return ProductImageRoutes.defaultBadge;
}