import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:quadsu_app/modal/student_dashboard_model.dart' as student_model;
import 'package:quadsu_app/provider/book_guide_provider.dart';
import 'package:quadsu_app/constants/api_keys.dart';
import 'package:quadsu_app/constants/global_data.dart';
import 'package:quadsu_app/functions/common_function.dart';
import 'package:quadsu_app/services/paypal_v2_service.dart';
import 'package:quadsu_app/widget/show_snackbar.dart';
import 'bookingSuccess.dart';

class ConfirmBookingScreen extends StatefulWidget {
  const ConfirmBookingScreen({Key? key}) : super(key: key);

  @override
  State<ConfirmBookingScreen> createState() => _ConfirmBookingScreenState();
}

class _ConfirmBookingScreenState extends State<ConfirmBookingScreen> {
  // Exact Colors from the UI Mockup
  final Color primaryBlue = const Color(0xFF22328C);
  final Color textDark = const Color(0xFF0F172A);
  final Color textSlate = const Color(0xFF334155);
  final Color textLightGrey = const Color(0xFF64748B);
  final Color textMuted = const Color(0xFF94A3B8);
  final Color orangeAccent = const Color(0xFFFF7A00);
  final Color cardBorderColor = const Color(0xFFF1F5F9);
  final Color dividerColor = const Color(0xFFF1F5F9);
  final Color paypalYellow = const Color(0xFFFFC439);
  final TextEditingController promoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<BookGuideProvider>(context, listen: false);
      if (provider.selectedGuide != null &&
          provider.selectedGuide!.id != null) {
        print("DEBUG: ConfirmBooking - Triggering fetchCheckoutDetails");
        provider.fetchCheckoutDetails(provider.selectedGuide!.id!);
      }
    });
  }

  @override
  void dispose() {
    promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookGuideProvider>(
      builder: (context, provider, child) {
        final guide = provider.selectedGuide;
        if (guide == null ||
            provider.selectedDate == null ||
            provider.selectedSlot == null) {
          return const Scaffold(
              body: Center(child: Text("Incomplete selection")));
        }

        return Stack(
          children: [
            Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: primaryBlue,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,
                  color: Colors.white, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              'Confirm and Pay',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTutorInfoCard(guide, provider),
                      const SizedBox(height: 32),

                      // Pricing Details
                      _buildPriceRow("Session Rate",
                          "\$${provider.totalCost.toStringAsFixed(2)}"),
                      const SizedBox(height: 16),
                      if (provider.serviceFee > 0) ...[
                        _buildPriceRow("Service Fee (${provider.servicePer}%)",
                            "\$${provider.serviceFee.toStringAsFixed(2)}"),
                        const SizedBox(height: 16),
                      ],
                      _buildPriceRow(
                          "Tax", "\$${provider.tax.toStringAsFixed(2)}"),
                      if (provider.discount > 0) ...[
                        const SizedBox(height: 16),
                        _buildPriceRow("Discount",
                            "-\$${provider.discount.toStringAsFixed(2)}"),
                      ],
                      const SizedBox(height: 24),

                      // Promo Code
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.local_offer_outlined,
                                color: orangeAccent, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: promoController,
                                decoration: const InputDecoration(
                                  hintText: "Enter Promo Code",
                                  border: InputBorder.none,
                                  isDense: true,
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF94A3B8),
                                  ),
                                ),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                if (promoController.text.isNotEmpty) {
                                  provider.fetchCheckoutDetails(
                                    provider.selectedGuide!.id!,
                                    promoCode: promoController.text,
                                  );
                                }
                              },
                              child: Text(
                                "Apply",
                                style: TextStyle(
                                  color: orangeAccent,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (provider.promoMessage != null) ...[
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            provider.promoMessage!,
                            style: TextStyle(
                              color: provider.discount > 0 ? Colors.green : Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      Divider(color: dividerColor, thickness: 1.5, height: 1),
                      const SizedBox(height: 24),

                      // Total
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total",
                            style: TextStyle(
                              color: textDark,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            "\$${provider.grandTotal.toStringAsFixed(2)}",
                            style: TextStyle(
                              color: textDark,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),

                    ],
                  ),
                ),
              ),
              _buildBottomArea(provider),
            ],
          ),
            ),
            if (provider.isCheckoutLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  // --- CUSTOM WIDGETS ---

  Widget _buildTutorInfoCard(
      student_model.Guide guide, BookGuideProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorderColor, width: 2),
      ),
      child: Column(
        children: [
          // Profile Row
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFFE89381),
                backgroundImage: (guide.guidePrefrence?.profileImage != null &&
                            guide.guidePrefrence!.profileImage.isNotEmpty)
                        ? NetworkImage(guide.guidePrefrence!.profileImage)
                        : (guide.studentPrefrence?.profileImage != null &&
                                guide.studentPrefrence!.profileImage.isNotEmpty)
                            ? NetworkImage(guide.studentPrefrence!.profileImage)
                            : null,
                child: (guide.guidePrefrence?.profileImage == null ||
                            guide.guidePrefrence!.profileImage.isEmpty) &&
                        (guide.studentPrefrence?.profileImage == null ||
                            guide.studentPrefrence!.profileImage.isEmpty)
                    ? Text(
                        (guide.firstName.isNotEmpty ? guide.firstName[0] : "") +
                            (guide.lastName.isNotEmpty
                                ? guide.lastName[0]
                                : ""),
                        style: const TextStyle(color: Colors.white),
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            "${guide.firstName} ${guide.lastName}",
                            style: TextStyle(
                              color: textDark,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(Icons.verified, color: orangeAccent, size: 18),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${guide.guidePrefrence?.university ?? "Peer Guide"}",
                      style: TextStyle(
                        color: textLightGrey,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(color: dividerColor, thickness: 1.5, height: 1),
          const SizedBox(height: 20),

          // Schedule Details
          _buildInfoRow(Icons.calendar_today_outlined,
              DateFormat('EEEE, MMM d, yyyy').format(provider.selectedDate!)),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.access_time, "${provider.selectedSlot} (1 hour)"),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.online_prediction_outlined, "Online Session"),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: orangeAccent, size: 20),
        const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
            color: textSlate,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: textSlate,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            color: textSlate,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomArea(BookGuideProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: dividerColor, width: 1.5),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                color: textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
              children: const [
                TextSpan(
                    text: 'By tapping "Confirm and Pay", you agree to the\n'),
                TextSpan(
                  text: 'Terms of Service',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: Color(0xFF94A3B8)),
                ),
                TextSpan(text: ' and our cancellation policy.'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              usePayPalV2(
                message: "Session with ${provider.selectedGuide!.firstName}",
                payAmount: provider.grandTotal,
                onSuccess: (String orderId) async {
                  print("DEBUG: PayPal v2 orderId: $orderId");

                  // finalization call
                  final verifyResult = await provider.verifyPaypalPayment(orderId: orderId);

                  if (verifyResult != null && verifyResult['success'] == true) {
                    final data = verifyResult['data'];
                    if (mounted) {
                      // Extract meeting link and booking ID (nested support for 'scheduled_sessions')
                      String meetingLink = data?['meeting_link'] ?? "";
                      String bookingIdStr = data?['booking_id']?.toString() ?? "";

                      if (meetingLink.isEmpty &&
                          data?['scheduled_sessions'] is List &&
                          (data?['scheduled_sessions'] as List).isNotEmpty) {
                        final session = data?['scheduled_sessions'][0];
                        meetingLink = session['meeting_link'] ?? "";
                        bookingIdStr = session['booking_id']?.toString() ??
                            session['id']?.toString() ??
                            "";
                      }

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => BookingSuccessScreen(
                            meetingLink: meetingLink,
                            bookingId: bookingIdStr,
                          ),
                        ),
                      );
                    }
                  } else {
                    showSnackbar("Booking couldn't be confirmed. Please contact support.");
                  }
                  },
                  onError: (error) => showSnackbar("PayPal Error: $error"),
                  onCancel: () => showSnackbar("Payment Cancelled"),
                );
              },
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: primaryBlue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Confirm and Pay',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.lock,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
