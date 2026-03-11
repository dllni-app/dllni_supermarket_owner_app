import 'package:common_package/common_package.dart';
import 'package:dllni_supermarket_owner_app/core/widgets/app_app_bars.dart';
import 'package:flutter/material.dart';

@AutoRoutePage(path: "/profile/employees")
class EmployeeManagementScreen extends StatelessWidget {
  const EmployeeManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          AppSimpleAppBar(title: "إدارة الموظفين"),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.add_circle_outline,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "إضافة موظف جديد",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          hintText: "ابحث عن موظف...",
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF9F9F9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _buildFilterButton(
                              "حسب الحالة",
                              Icons.filter_alt_outlined,
                              Colors.orange,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildFilterButton(
                              "ترتيب",
                              Icons.unfold_more,
                              Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                _buildEmployeeCard(
                  name: "أحمد محمد العلي",
                  phone: "09512345678",
                  joinDate: "15 يناير 2023",
                  permissions: ["كاملة"],
                  imageUrl: "https://i.pravatar.cc/150?u=1",
                ),
                _buildEmployeeCard(
                  name: "فاطمة أحمد السعد",
                  phone: "0958765432",
                  joinDate: "3 فبراير 2023",
                  permissions: ["إدارة المنتجات"],
                  imageUrl: "https://i.pravatar.cc/150?u=2",
                ),
                _buildEmployeeCard(
                  name: "خالد سعيد",
                  phone: "0501234567",
                  joinDate: "20 مارس 2023",
                  permissions: [
                    "إدارة الطلبات",
                    "متابعة الإحصائيات",
                    "إدارة المخزون",
                  ],
                  imageUrl: "https://i.pravatar.cc/150?u=3",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 5),
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildEmployeeCard({
    required String name,
    required String phone,
    required String joinDate,
    required List<String> permissions,
    required String imageUrl,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.more_vert, color: Colors.grey),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              phone,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Icon(
                              Icons.phone_outlined,
                              size: 14,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            "نشط",
                            style: TextStyle(color: Colors.green, fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(imageUrl),
                    ),
                  ],
                ),
                const Divider(height: 25),
                _buildInfoRow("تاريخ الانضمام", joinDate),
                const SizedBox(height: 8),
                _buildPermissionRow("الصلاحيات", permissions),
              ],
            ),
          ),
          // --- Show Details Button ---
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF1E2E7D),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
            ),
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.visibility_outlined,
                color: Colors.white,
                size: 18,
              ),
              label: const Text(
                "عرض التفاصيل",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildPermissionRow(String label, List<String> permissions) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: permissions
                .map(
                  (p) => Text(
                    p,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFF1E2E7D),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}
