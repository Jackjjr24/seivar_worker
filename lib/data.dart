import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'work.dart' as data;
import 'settings.dart' as settings;

class DashboardScreen extends StatelessWidget {
  DashboardScreen({Key? key}) : super(key: key);

  final List<double> revenues = [5, 12, 10, 15, 14, 17, 22, 29, 8];

  final Color primaryColor = const Color(0xFF6A0EFF);
  final Color accentColor = const Color(0xFF3C3C74);
  final Color bgColor = const Color(0xFFF5F6FB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildTopSummaryRow(),
              const SizedBox(height: 16),
              _revenueCard(context),
              const SizedBox(height: 20),
              _savingProgressCard(),
              const SizedBox(height: 20),
              _leaderBoardCard(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildFooter(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

    );
  }

  // ---------- HEADER ----------

  Widget _buildHeader() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "SEIVAR",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: accentColor,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Partner Dashboard",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 5,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Row(
            children: const [
              Icon(Icons.star_rounded, size: 18, color: Colors.amber),
              SizedBox(width: 4),
              Text(
                "Gold Tier",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------- TOP SUMMARY (2 SMALL CARDS) ----------

  Widget _buildTopSummaryRow() {
    return Row(
      children: [
        Expanded(
          child: _smallStatCard(
            title: "This Month",
            value: "₹48,079",
            subtitle: "+14% vs last",
            icon: Icons.trending_up,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _smallStatCard(
            title: "Completed",
            value: "126",
            subtitle: "tasks done",
            icon: Icons.task_alt_rounded,
          ),
        ),
      ],
    );
  }

  Widget _smallStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: primaryColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: accentColor,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.green.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // ---------- REVENUE CARD + CHART ----------

  Widget _revenueCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Row
          Row(
            children: [
              Text(
                "Revenue Generated",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.date_range,
                        size: 14, color: Colors.grey.shade700),
                    SizedBox(width: 4),
                    Text(
                      "Last 9 months",
                      style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 11,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),

          // Revenue Amount
          Row(
            children: [
              Text(
                "₹48,079",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF3C3C74),
                ),
              ),
              SizedBox(width: 6),
              Icon(Icons.arrow_upward, color: Colors.green, size: 18),
              SizedBox(width: 2),
              Text(
                "+14% / ₹3,500",
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            "compared to previous month",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 14),

          // Chart
          SizedBox(
            height: 170,
            child: BarChart(
              BarChartData(
                gridData: FlGridData(show: false),
                alignment: BarChartAlignment.spaceAround,
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 26,
                      getTitlesWidget: (value, _) {
                        const months = [
                          'Jan', 'Feb', 'Mar', 'Apr', 'May',
                          'Jun', 'Jul', 'Aug', 'Sep'
                        ];

                        if (value.toInt() < 0 || value.toInt() >= months.length) {
                          return SizedBox.shrink();
                        }

                        return Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                            months[value.toInt()],
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.black87,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(
                  revenues.length,
                      (index) => BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: revenues[index],
                        color: Color(0xFF6A62E7), // Muted purple tone
                        width: 14,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- SAVING PROGRESS CARD ----------

  Widget _savingProgressCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9E5),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFFE59D)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Saving Progress",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                  fontSize: 15,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.emoji_events, color: Colors.amber, size: 20),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Text(
                    "₹22,980",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    "towards your goal",
                    style: TextStyle(fontSize: 11, color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Fake overall progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Container(
              height: 8,
              color: Colors.grey.shade300,
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: 0.7,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange.shade400, Colors.green.shade500],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _progressIndicator("Jun", true),
              _progressIndicator("Jul", true),
              _progressIndicator("Aug", true),
              _progressIndicator("Sep", false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _progressIndicator(String month, bool done) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: done ? Colors.green : Colors.grey.shade300,
          radius: 12,
          child: done
              ? const Icon(Icons.check, size: 14, color: Colors.white)
              : Icon(Icons.more_horiz,
              size: 14, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 4),
        Text(
          month,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  // ---------- LEADERBOARD CARD ----------

  Widget _leaderBoardCard() {
    final names = ['worker1', 'worker2', 'You', 'worker3'];
    final heights = [110.0, 90.0, 90.0, 70.0];
    final colors = [Colors.black87, Colors.purple, Colors.purple, Colors.blue];
    final earnings = ["₹52k+", "₹48k+", "₹48k+", "₹33k+"];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                "Top Earners in your city",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              Icon(Icons.info_outline, color: Colors.grey.shade500, size: 18),
              const SizedBox(width: 6),
              Text(
                "See full list",
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(4, (index) {
              final isYou = names[index].toLowerCase() == "you";
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: isYou
                            ? primaryColor.withOpacity(0.15)
                            : Colors.grey.shade200,
                        child: Icon(
                          Icons.person,
                          color: isYou ? primaryColor : Colors.grey.shade600,
                        ),
                      ),
                      if (index == 0)
                        const CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.amber,
                          child: Icon(Icons.emoji_events_outlined, size: 14, color: Colors.white),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: heights[index],
                    width: 32,
                    decoration: BoxDecoration(
                      color: colors[index],
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: 70,
                    child: Text(
                      names[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight:
                        isYou ? FontWeight.w800 : FontWeight.w600,
                        color: isYou ? primaryColor : Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    earnings[index],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  // ---------- BOTTOM NAV & FAB ----------


  Widget _buildFooterIcon({
    required IconData icon,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isActive ? primaryColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Icon(
          icon,
          size: 26,
          color: isActive ? primaryColor : const Color(0xFF3C3C74),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      color: Colors.white,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildFooterIcon(
              icon: Icons.calendar_today_rounded,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => data.TodaysWorkPage()),
                );
              },
            ),
            _buildFooterIcon(
              icon: Icons.home_rounded,
              isActive: true,
              onTap: () {
                // Already on Dashboard
              },
            ),
            _buildFooterIcon(
              icon: Icons.settings_rounded,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => settings.SettingsPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
