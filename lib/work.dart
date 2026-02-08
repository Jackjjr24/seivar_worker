import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'data.dart' as data; // Contains DashboardScreen
import 'settings.dart' as settings; // Contains SettingsPage

class WorkConfirmationPage extends StatefulWidget {
  final Map<String, dynamic> workDetails;
  final String requestId;

  const WorkConfirmationPage({
    Key? key,
    required this.workDetails,
    required this.requestId,
  }) : super(key: key);

  @override
  _WorkConfirmationPageState createState() => _WorkConfirmationPageState();
}

class _WorkConfirmationPageState extends State<WorkConfirmationPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool hasTools = false;
  bool understandsRequirements = false;
  Duration? estimatedDuration;
  bool isTimerRunning = false;
  DateTime? workStartTime;
  Timer? workTimer;
  Duration? remainingTime;

  @override
  void dispose() {
    workTimer?.cancel();
    super.dispose();
  }

  /// Mark work as started
  Future<void> startWork() async {
    await _firestore.collection("bookings").doc(widget.requestId).update({
      "status": "in_progress",
    });
    startWorkTimer();
  }

  void startWorkTimer() {
    setState(() {
      workStartTime = DateTime.now();
      remainingTime = estimatedDuration;
      isTimerRunning = true;
    });

    workTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime!.inSeconds <= 0) {
        timer.cancel();
        setState(() {
          remainingTime = Duration.zero;
        });
      } else {
        setState(() {
          remainingTime = Duration(seconds: remainingTime!.inSeconds - 1);
        });
      }
    });
  }

  void completeWork() {
    workTimer?.cancel();
    // Update status to completed in Firebase
    _firestore.collection("bookings").doc(widget.requestId).update({
      "status": "completed",
    });
    Navigator.pop(context, true); // Return true to indicate work is completed
  }

  void showSafetyAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Safety Alert"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Are you feeling unsafe or threatened?"),
            SizedBox(height: 20),
            Text("Options:"),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.call, color: Colors.red),
              title: Text("Call Emergency"),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Calling emergency services...")),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.message, color: Colors.orange),
              title: Text("Message Supervisor"),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Messaging supervisor...")),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.blue),
              title: Text("Leave Premises Safely"),
              onTap: () {
                Navigator.pop(context);
                completeWork();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Please leave safely and contact support")),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          "Work Confirmation",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF2C3E50),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isTimerRunning) ...[
                Container(
                  padding: const EdgeInsets.all(20),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2C3E50).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.assignment_rounded,
                              color: Color(0xFF2C3E50),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            "Work Details",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildDetailRow("Service:", widget.workDetails["serviceName"] ?? "Service", Icons.cleaning_services_rounded),
                      const SizedBox(height: 12),
                      _buildDetailRow("Client:", widget.workDetails["clientName"] ?? "Unknown Client", Icons.person_rounded),
                      const SizedBox(height: 12),
                      _buildDetailRow("Location:", widget.workDetails["location"] ?? "Unknown Location", Icons.location_on_rounded),
                      const SizedBox(height: 12),
                      _buildDetailRow("Date:", widget.workDetails["date"] ?? "Unknown Date", Icons.calendar_today_rounded),
                      const SizedBox(height: 12),
                      _buildDetailRow("Time:", widget.workDetails["time"] ?? "Unknown Time", Icons.access_time_rounded),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                if (estimatedDuration == null) ...[
                  Container(
                    padding: const EdgeInsets.all(20),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF5DADE2).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.access_time_rounded,
                                color: Color(0xFF5DADE2),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "Estimated Work Duration",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2C3E50),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8F9FA),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: DropdownButtonFormField<int>(
                                  value: 1,
                                  items: List.generate(8, (index) => index + 1)
                                      .map((hours) => DropdownMenuItem(
                                    value: hours,
                                    child: Text("$hours hour${hours > 1 ? 's' : ''}"),
                                  ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      estimatedDuration = Duration(hours: value!);
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    labelText: "Hours",
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8F9FA),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: DropdownButtonFormField<int>(
                                  value: 0,
                                  items: List.generate(60, (index) => index)
                                      .map((minutes) => DropdownMenuItem(
                                    value: minutes,
                                    child: Text("$minutes min"),
                                  ))
                                      .toList(),
                                  onChanged: (value) {
                                    if (estimatedDuration == null) {
                                      estimatedDuration = Duration(minutes: value!);
                                    } else {
                                      setState(() {
                                        estimatedDuration = Duration(
                                          hours: estimatedDuration!.inHours,
                                          minutes: value!,
                                        );
                                      });
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    labelText: "Minutes",
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF5DADE2).withOpacity(0.1),
                          const Color(0xFF48C9B0).withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF5DADE2).withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.schedule_rounded,
                            color: Color(0xFF5DADE2),
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Estimated Duration",
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF7F8C8D),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${estimatedDuration!.inHours}h ${estimatedDuration!.inMinutes.remainder(60)}m",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2C3E50),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Pre-Work Checklist",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildCheckboxTile(
                          value: hasTools,
                          onChanged: (val) {
                            setState(() {
                              hasTools = val ?? false;
                            });
                          },
                          icon: Icons.handyman_rounded,
                          text: "I have all necessary tools/equipment",
                        ),
                        const SizedBox(height: 12),
                        _buildCheckboxTile(
                          value: understandsRequirements,
                          onChanged: (val) {
                            setState(() {
                              understandsRequirements = val ?? false;
                            });
                          },
                          icon: Icons.checklist_rounded,
                          text: "I understand the work requirements",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: hasTools && understandsRequirements
                            ? [const Color(0xFF48C9B0), const Color(0xFF16A085)]
                            : [Colors.grey.shade300, Colors.grey.shade400],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: hasTools && understandsRequirements
                          ? [
                              BoxShadow(
                                color: const Color(0xFF48C9B0).withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ]
                          : null,
                    ),
                    child: ElevatedButton(
                      onPressed: hasTools && understandsRequirements ? startWork : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_circle_rounded, size: 24),
                          SizedBox(width: 12),
                          Text(
                            "Start Work",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ] else ...[
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF5DADE2).withOpacity(0.2),
                                  const Color(0xFF48C9B0).withOpacity(0.2),
                                ],
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.work_history_rounded,
                              size: 48,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Work in Progress",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Keep up the great work!",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  remainingTime!.inMinutes < 15
                                      ? const Color(0xFFE74C3C).withOpacity(0.1)
                                      : const Color(0xFF48C9B0).withOpacity(0.1),
                                  remainingTime!.inMinutes < 15
                                      ? const Color(0xFFC0392B).withOpacity(0.1)
                                      : const Color(0xFF16A085).withOpacity(0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "Time Remaining",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "${remainingTime!.inHours}h ${remainingTime!.inMinutes.remainder(60)}m ${remainingTime!.inSeconds.remainder(60)}s",
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: remainingTime!.inMinutes < 15
                                        ? const Color(0xFFE74C3C)
                                        : const Color(0xFF16A085),
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFFFB74D).withOpacity(0.3)),
                      ),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.warning_amber_rounded, size: 22),
                        label: const Text(
                          "Safety Alert",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: const Color(0xFFE67E22),
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: showSafetyAlert,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF48C9B0), Color(0xFF16A085)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF48C9B0).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.check_circle_rounded, size: 22),
                        label: const Text(
                          "Complete Work",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: completeWork,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF5DADE2).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF5DADE2),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxTile({
    required bool value,
    required Function(bool?) onChanged,
    required IconData icon,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: value ? const Color(0xFF48C9B0).withOpacity(0.1) : const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value ? const Color(0xFF48C9B0) : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: value ? const Color(0xFF48C9B0) : Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: value ? const Color(0xFF48C9B0) : Colors.grey.shade400,
                width: 2,
              ),
            ),
            child: value
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : null,
          ),
          const SizedBox(width: 12),
          Icon(
            icon,
            color: value ? const Color(0xFF48C9B0) : Colors.grey[600],
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(!value),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: value ? FontWeight.w600 : FontWeight.w500,
                  color: value ? const Color(0xFF2C3E50) : Colors.grey[700],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TodaysWorkPage extends StatefulWidget {
  @override
  _TodaysWorkPageState createState() => _TodaysWorkPageState();
}

class _TodaysWorkPageState extends State<TodaysWorkPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  bool showRequestedWork = true;

  /// Accept a work request
  Future<void> acceptWork(String requestId) async {
    if (currentUser == null) return;
    await _firestore.collection("bookings").doc(requestId).update({
      "status": "accepted",
      "workerId": currentUser!.uid,
    });
  }

  /// Ignore a work request
  Future<void> ignoreWork(String requestId) async {
    await _firestore.collection("bookings").doc(requestId).update({
      "status": "ignored",
    });
  }

  /// Mark work as started
  Future<void> startWork(String requestId) async {
    await _firestore.collection("bookings").doc(requestId).update({
      "status": "in_progress",
    });
  }

  /// Transfer work back to requested work
  Future<void> transferWork(String requestId) async {
    await _firestore.collection("bookings").doc(requestId).update({
      "status": "pending",
      "workerId": null,
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Work transferred back to requested work"),
        backgroundColor: Colors.green,
      ),
    );
  }

  Color _getWorkTypeColor(String type) {
    switch (type) {
      case "Housekeeping":
        return const Color(0xFF5DADE2); // Soft blue
      case "Care Taking":
        return const Color(0xFF9B59B6); // Soft purple
      case "Cooking":
        return const Color(0xFFE67E22); // Soft orange
      case "Dish Washing":
        return const Color(0xFF16A085); // Soft teal
      default:
        return const Color(0xFF95A5A6); // Soft grey
    }
  }

  Widget _buildFooterIcon({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF2C3E50).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: 26,
          color: const Color(0xFF2C3E50),
        ),
      ),
    );
  }

  Widget _buildWorkItem(Map<String, dynamic> item, String docId, bool isCompleted, int index, String section) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200, width: 1.5),
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isCompleted)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_rounded,
                                  size: 12,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    item["date"] ?? "Unknown Date",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[700],
                                      fontSize: 11,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  _getWorkTypeColor(item["serviceName"] ?? "Service"),
                                  _getWorkTypeColor(item["serviceName"] ?? "Service").withOpacity(0.8),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              item["serviceName"] ?? "Service",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF48C9B0).withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.circle, color: Color(0xFF48C9B0), size: 10),
                          ),
                          Container(
                            height: 16,
                            width: 2,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  const Color(0xFF48C9B0).withOpacity(0.5),
                                  const Color(0xFFE67E22).withOpacity(0.5),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE67E22).withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.location_on, color: Color(0xFFE67E22), size: 10),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item["location"] ?? "Unknown Location",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Color(0xFF2C3E50),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                Icon(Icons.access_time_rounded, size: 12, color: Colors.grey[600]),
                                const SizedBox(width: 3),
                                Flexible(
                                  child: Text(
                                    item["time"] ?? "Unknown Time",
                                    style: TextStyle(color: Colors.grey[700], fontSize: 11),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            if (!isCompleted) ...[
                              const SizedBox(height: 3),
                              Row(
                                children: [
                                  Icon(Icons.calendar_month_rounded, size: 12, color: Colors.grey[600]),
                                  const SizedBox(width: 3),
                                  Flexible(
                                    child: Text(
                                      item["date"] ?? "Unknown Date",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11,
                                        color: Colors.grey[700],
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF5DADE2).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.cleaning_services_rounded,
                                  size: 18,
                                  color: Color(0xFF5DADE2),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      item["clientName"] ?? "Unknown Client",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Color(0xFF2C3E50),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.star_rounded, color: Color(0xFFF39C12), size: 14),
                                        const SizedBox(width: 2),
                                        Text(
                                          "4.9",
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF48C9B0), Color(0xFF16A085)],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Price",
                                style: TextStyle(
                                  fontSize: 9,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "₹${item["price"] ?? "0"}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isCompleted)
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF48C9B0).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF48C9B0).withOpacity(0.3)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle_rounded, color: Color(0xFF48C9B0), size: 16),
                            SizedBox(width: 4),
                            Text(
                              "Completed",
                              style: TextStyle(
                                color: Color(0xFF16A085),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (!isCompleted && section == "requested")
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Container(
                              height: 36,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF48C9B0), Color(0xFF16A085)],
                                ),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF48C9B0).withOpacity(0.25),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.check_rounded, size: 16),
                                label: const Text(
                                  "Accept",
                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () => acceptWork(docId),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Container(
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF3E0),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color(0xFFE67E22).withOpacity(0.3)),
                              ),
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.close_rounded, size: 16),
                                label: const Text(
                                  "Reject",
                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: const Color(0xFFE67E22),
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () => ignoreWork(docId),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (!isCompleted && section == "today")
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Container(
                              height: 36,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF48C9B0), Color(0xFF16A085)],
                                ),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF48C9B0).withOpacity(0.25),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.play_circle_rounded, size: 16),
                                label: const Text(
                                  "Start",
                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WorkConfirmationPage(
                                      workDetails: item,
                                      requestId: docId,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Container(
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF3E0),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color(0xFFE67E22).withOpacity(0.3)),
                              ),
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.swap_horiz_rounded, size: 16),
                                label: const Text(
                                  "Transfer",
                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: const Color(0xFFE67E22),
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () => transferWork(docId),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2C3E50), Color(0xFF34495E)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2C3E50).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  "${index + 1}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 8,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildFooterIcon(
                icon: Icons.calendar_today_rounded,
                onTap: () {
                  // Already on this page
                },
              ),
              _buildFooterIcon(
                icon: Icons.home_rounded,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => data.DashboardScreen()),
                  );
                },
              ),
              _buildFooterIcon(
                icon: Icons.settings_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => settings.SettingsPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF2C3E50), Color(0xFF34495E)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  "SEIVAR",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Requested Work Section
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showRequestedWork = !showRequestedWork;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF5DADE2), Color(0xFF3498DB)],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.work_outline_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "Requested Work",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2C3E50),
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              showRequestedWork ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                              color: const Color(0xFF5DADE2),
                              size: 28,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
              if (showRequestedWork)
                    StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection("bookings")
                      .where("status", isEqualTo: "pending")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    var requests = snapshot.data!.docs;
                    if (requests.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text("No requested work available."),
                      );
                    }
                    return Container(
                      height: 220,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: requests.length,
                        itemBuilder: (context, index) {
                          var doc = requests[index];
                          var request = doc.data() as Map<String, dynamic>;

                          // Get client name
                          return FutureBuilder<DocumentSnapshot>(
                            future: _firestore
                                .collection("users")
                                .doc(request["userId"])
                                .get(),
                            builder: (context, userSnapshot) {
                              String userName = "Unknown User";
                              if (userSnapshot.hasData && userSnapshot.data!.exists) {
                                var userData = userSnapshot.data!.data() as Map<String, dynamic>;
                                userName = userData["name"] ?? "Unknown User";
                              }

                              var workItem = {
                                ...request,
                                "clientName": userName,
                              };

                              return Container(
                                width: 300,
                                margin: EdgeInsets.only(right: 16),
                                child: _buildWorkItem(workItem, doc.id, false, index, "requested"),
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
                    const SizedBox(height: 24),

                    // Today's Work Section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF48C9B0), Color(0xFF16A085)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.today_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            "Today's Work",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    StreamBuilder<QuerySnapshot>(
                      stream: _firestore
                          .collection("bookings")
                          .where("status", whereIn: ["accepted", "in_progress"])
                          .where("workerId", isEqualTo: currentUser?.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    var requests = snapshot.data!.docs;
                    if (requests.isEmpty) {
                      return Center(child: const Text("No work scheduled for today."));
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        var doc = requests[index];
                        var request = doc.data() as Map<String, dynamic>;

                        // Get client name
                        return FutureBuilder<DocumentSnapshot>(
                          future: _firestore
                              .collection("users")
                              .doc(request["userId"])
                              .get(),
                          builder: (context, userSnapshot) {
                            String userName = "Unknown User";
                            if (userSnapshot.hasData && userSnapshot.data!.exists) {
                              var userData = userSnapshot.data!.data() as Map<String, dynamic>;
                              userName = userData["name"] ?? "Unknown User";
                            }

                            var workItem = {
                              ...request,
                              "clientName": userName,
                            };

                            return _buildWorkItem(workItem, doc.id, false, index, "today");
                          },
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Completed Work Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFF39C12), Color(0xFFE67E22)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.check_circle_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "Completed Work",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection("bookings")
                      .where("status", isEqualTo: "completed")
                      .where("workerId", isEqualTo: currentUser?.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    var requests = snapshot.data!.docs;
                    if (requests.isEmpty) {
                      return const Center(child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text("No completed work."),
                      ));
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        var doc = requests[index];
                        var request = doc.data() as Map<String, dynamic>;

                        // Get client name
                        return FutureBuilder<DocumentSnapshot>(
                          future: _firestore
                              .collection("users")
                              .doc(request["userId"])
                              .get(),
                          builder: (context, userSnapshot) {
                            String userName = "Unknown User";
                            if (userSnapshot.hasData && userSnapshot.data!.exists) {
                              var userData = userSnapshot.data!.data() as Map<String, dynamic>;
                              userName = userData["name"] ?? "Unknown User";
                            }

                            var workItem = {
                              ...request,
                              "clientName": userName,
                            };

                            return _buildWorkItem(workItem, doc.id, true, index, "completed");
                          },
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    ),
      ),
    );
  }
}