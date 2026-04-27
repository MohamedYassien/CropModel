import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../data/model/restaurant_model.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';


class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(FavoritesInitial()) {
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<RemoveFavoriteEvent>(_onRemoveFavorite);
    on<ClearFavoritesEvent>(_onClearFavorites);
  }

  Future<void> _clearCorruptedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('favorites');
    } catch (e) {
      print('Error clearing corrupted data: $e');
    }
  }

  Future<void> _onLoadFavorites(LoadFavoritesEvent event, Emitter<FavoritesState> emit) async {
    emit(FavoritesLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getString('favorites') ?? '[]';
      
      // Debug: Print the raw JSON to see what we're working with
      print('Raw favorites JSON: $favoritesJson');
      
      // If the JSON is empty or just '[]', return empty list
      if (favoritesJson == '[]' || favoritesJson.isEmpty) {
        emit(FavoritesLoaded([]));
        return;
      }
      
      final decoded = jsonDecode(favoritesJson);
      
      // Handle different possible types
      List<dynamic> favoritesList;
      if (decoded is List) {
        favoritesList = decoded;
      } else if (decoded is Map) {
        // If it's a single object, wrap it in a list
        favoritesList = [decoded];
      } else {
        // If it's something else, clear the corrupted data and start fresh
        await prefs.remove('favorites');
        emit(FavoritesLoaded([]));
        return;
      }
      
      final favoriteRestaurants = <RestaurantModel>[];
      
      for (final item in favoritesList) {
        try {
          if (item is Map<String, dynamic>) {
            favoriteRestaurants.add(RestaurantModel.fromJson(item));
          } else {
            print('Skipping invalid item: $item (${item.runtimeType})');
          }
        } catch (e) {
          print('Error parsing item: $item, error: $e');
        }
      }
      
      emit(FavoritesLoaded(favoriteRestaurants));
    } catch (e) {
      print('Error in _onLoadFavorites: $e');
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> _onToggleFavorite(ToggleFavoriteEvent event, Emitter<FavoritesState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getString('favorites') ?? '[]';
      
      // Start with empty list if there's any issue
      List<RestaurantModel> favoriteRestaurants = [];
      
      if (favoritesJson != '[]' && favoritesJson.isNotEmpty) {
        try {
          final decoded = jsonDecode(favoritesJson);
          List<dynamic> favoritesList;
          
          if (decoded is List) {
            favoritesList = decoded;
          } else if (decoded is Map) {
            favoritesList = [decoded];
          } else {
            favoritesList = [];
          }
          
          favoriteRestaurants = favoritesList
              .where((item) => item is Map<String, dynamic>)
              .map((json) => RestaurantModel.fromJson(json as Map<String, dynamic>))
              .toList();
        } catch (e) {
          print('Error loading existing favorites in toggle: $e');
          favoriteRestaurants = [];
        }
      }
      
      final existingIndex = favoriteRestaurants.indexWhere((r) => r.id == event.restaurant.id);
      
      if (existingIndex != -1) {
        favoriteRestaurants.removeAt(existingIndex);
      } else {
        favoriteRestaurants.add(event.restaurant);
      }
      
      final updatedFavoritesJson = jsonEncode(favoriteRestaurants.map((r) => {
        'id': r.id,
        'name': r.name,
        'description': r.description,
        'location': r.location,
        'rating': r.rating,
        'imageUrl': r.imageUrl,
        'latitude': r.latitude,
        'longitude': r.longitude,
        'menuCategories': r.menuCategories.map((m) => m.toJson()).toList(),
      }).toList());
      
      await prefs.setString('favorites', updatedFavoritesJson);
      
      emit(FavoritesLoaded(favoriteRestaurants));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> _onRemoveFavorite(RemoveFavoriteEvent event, Emitter<FavoritesState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getString('favorites') ?? '[]';
      
      List<RestaurantModel> favoriteRestaurants = [];
      
      if (favoritesJson != '[]' && favoritesJson.isNotEmpty) {
        try {
          final decoded = jsonDecode(favoritesJson);
          List<dynamic> favoritesList;
          
          if (decoded is List) {
            favoritesList = decoded;
          } else if (decoded is Map) {
            favoritesList = [decoded];
          } else {
            favoritesList = [];
          }
          
          favoriteRestaurants = favoritesList
              .where((item) => item is Map<String, dynamic>)
              .map((json) => RestaurantModel.fromJson(json as Map<String, dynamic>))
              .toList();
        } catch (e) {
          print('Error loading existing favorites in remove: $e');
          favoriteRestaurants = [];
        }
      }
      
      favoriteRestaurants.removeWhere((r) => r.id == event.restaurantId);
      
      final updatedFavoritesJson = jsonEncode(favoriteRestaurants.map((r) => {
        'id': r.id,
        'name': r.name,
        'description': r.description,
        'location': r.location,
        'rating': r.rating,
        'imageUrl': r.imageUrl,
        'latitude': r.latitude,
        'longitude': r.longitude,
        'menuCategories': r.menuCategories.map((m) => m.toJson()).toList(),
      }).toList());
      
      await prefs.setString('favorites', updatedFavoritesJson);
      
      emit(FavoritesLoaded(favoriteRestaurants));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> _onClearFavorites(ClearFavoritesEvent event, Emitter<FavoritesState> emit) async {
    try {
      await _clearCorruptedData();
      emit(FavoritesLoaded([]));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }
}
