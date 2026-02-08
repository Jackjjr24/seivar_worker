import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'work.dart';

void main() {
  runApp(MaterialApp(
    home: SurveyPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class SurveyPage extends StatefulWidget {
  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  bool locationAllowed = false;
  List<String> selectedWork = [];
  String? selectedCurrentRevenue;
  String? selectedExpectedRevenue;
  TextEditingController commentsController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  bool showOtpField = false;

  Future<void> requestLocationPermission() async {
    var status = await Permission.location.request();
    setState(() {
      locationAllowed = status == PermissionStatus.granted;
    });
  }

  void sendOtp() {
    if (phoneController.text.isNotEmpty) {
      setState(() {
        showOtpField = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("OTP sent to ${phoneController.text}")),
      );
    }
  }

  Widget buildSelectableChips(List<String> options, List<String> selectedValues,
      int maxSelection, Function(List<String>) onSelectionChanged) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.map((option) {
        final isSelected = selectedValues.contains(option);
        return ChoiceChip(
          label: Text(option),
          selected: isSelected,
          backgroundColor: Colors.white,
          selectedColor: const Color(0xFF48C9B0),
          onSelected: (selected) {
            setState(() {
              if (isSelected) {
                selectedValues.remove(option);
              } else {
                if (selectedValues.length < maxSelection) {
                  selectedValues.add(option);
                }
              }
              onSelectionChanged(selectedValues);
            });
          },
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        );
      }).toList(),
    );
  }

  Widget buildSingleChoiceChips(List<String> options, String? selectedValue,
      Function(String) onSelectionChanged) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.map((option) {
        final isSelected = selectedValue == option;
        return ChoiceChip(
          label: Text(option),
          selected: isSelected,
          backgroundColor: Colors.white,
          selectedColor: const Color(0xFF48C9B0),
          onSelected: (_) {
            setState(() {
              onSelectionChanged(option);
            });
          },
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final workOptions = ['cleaning', 'care taking', 'washing', 'pickup & drop'];
    final revenueOptionsNow = [
      'No earnings..',
      '₹0 - ₹500',
      '₹500 - ₹5000',
      '₹5000 - ₹7000'
    ];
    final revenueOptionsExpected = [
      'No earnings..',
      '₹0 - ₹500',
      '₹5000 - ₹8000',
      '₹8000 - ₹10000'
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2C3E50), Color(0xFF34495E)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2C3E50).withOpacity(0.3),
                            blurRadius: 15,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.how_to_reg_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Worker Registration",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Help us know you better",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

                // Personal Information
                _buildSectionTitle("Personal Information", Icons.person_rounded),
                const SizedBox(height: 16),
                _buildModernTextField(
                  controller: nameController,
                  hintText: "Enter your full name",
                  icon: Icons.badge_rounded,
                ),
                const SizedBox(height: 24),

                // Contact Information
                _buildSectionTitle("Contact Information", Icons.phone_rounded),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildModernTextField(
                        controller: phoneController,
                        hintText: "Enter 10-digit number",
                        icon: Icons.phone_in_talk_rounded,
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00D084), Color(0xFF00B871)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00D084).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: sendOtp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          "Send OTP",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.info_outline, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Text(
                      "+91 will be added automatically",
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // OTP Field
                if (showOtpField) ...[
                  _buildModernTextField(
                    controller: otpController,
                    hintText: "Enter 6-digit OTP",
                    icon: Icons.lock_outline_rounded,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 24),
                ],

                // Location
                _buildSectionTitle("Location", Icons.location_on_rounded),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: locationAllowed
                          ? [Colors.green, Colors.green.shade700]
                          : [const Color(0xFF00D084), const Color(0xFF00B871)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: (locationAllowed ? Colors.green : const Color(0xFF00D084))
                            .withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: requestLocationPermission,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: Icon(
                      locationAllowed ? Icons.check_circle : Icons.location_on,
                      color: Colors.white,
                    ),
                    label: Text(
                      locationAllowed ? "Location Allowed" : "Allow Location Access",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Work Preference
                _buildSectionTitle("Work Preference", Icons.work_rounded),
                const SizedBox(height: 12),
                Text(
                  "Select up to 2 types of work",
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(height: 12),
                buildSelectableChips(workOptions, selectedWork, 2,
                    (val) => selectedWork = val),
                const SizedBox(height: 24),

                // Current Revenue
                _buildSectionTitle("Current Revenue", Icons.currency_rupee_rounded),
                const SizedBox(height: 12),
                Text(
                  "Revenue per month now",
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(height: 12),
                buildSingleChoiceChips(revenueOptionsNow, selectedCurrentRevenue,
                    (val) => selectedCurrentRevenue = val),
                const SizedBox(height: 24),

                // Expected Revenue
                _buildSectionTitle("Expected Revenue", Icons.trending_up_rounded),
                const SizedBox(height: 12),
                Text(
                  "Expected revenue through SEIVAR (per month)",
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(height: 12),
                buildSingleChoiceChips(revenueOptionsExpected,
                    selectedExpectedRevenue, (val) => selectedExpectedRevenue = val),
                const SizedBox(height: 24),

                // Comments
                _buildSectionTitle("Additional Comments", Icons.comment_rounded),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F0FF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: commentsController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: "Share anything you'd like us to know...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Submit Button
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2C3E50), Color(0xFF34495E)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2C3E50).withOpacity(0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TodaysWorkPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "SUBMIT & CONTINUE",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2C3E50), Color(0xFF34495E)],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
      ],
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLength: keyboardType == TextInputType.number ? 6 : null,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFF5DADE2)),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[400]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          counterText: '',
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }
}
