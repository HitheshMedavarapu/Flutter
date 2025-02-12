class MarketplaceModel {
  final String itemId;
  final String sellerId;
  final String title;
  final String description;
  final String category;
  final double price;
  final String location;
  final String imageUrl;
  final bool isService;
  final DateTime postedAt;

  MarketplaceModel({
    required this.itemId,
    required this.sellerId,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.location,
    required this.imageUrl,
    required this.isService,
    required this.postedAt,
  });

  // Convert MarketplaceModel to a Map
  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'sellerId': sellerId,
      'title': title,
      'description': description,
      'category': category,
      'price': price,
      'location': location,
      'imageUrl': imageUrl,
      'isService': isService,
      'postedAt': postedAt.toIso8601String(),
    };
  }

  // Create a MarketplaceModel from a Map
  factory MarketplaceModel.fromMap(Map<String, dynamic> map) {
    return MarketplaceModel(
      itemId: map['itemId'] ?? '',
      sellerId: map['sellerId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      location: map['location'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      isService: map['isService'] ?? false,
      postedAt: map['postedAt'] != null
          ? DateTime.tryParse(map['postedAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
