import '../../../core/config/supabase_config.dart';

class PaymentService {
  final supabase = SupabaseConfig.client;

  // Crear Payment Intent
  Future<String> createPaymentIntent({
    required String eventId,
    required String userId,
    required String ticketTypeId,
    required int quantity,
    String? promoCode,
  }) async {
    try {
      final response = await supabase.functions.invoke(
        'create-payment-intent',
        body: {
          'eventId': eventId,
          'userId': userId,
          'ticketTypeId': ticketTypeId,
          'quantity': quantity,
          'promoCode': promoCode,
        },
      );

      if (response.data == null) {
        throw Exception('No response from payment service');
      }

      return response.data['clientSecret'] as String;
    } catch (e) {
      throw Exception('Error al crear payment intent: $e');
    }
  }
}

