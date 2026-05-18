import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? _selectedCourse;
  String? _selectedYearLevel;
  String _searchQuery = '';
  _StudentRecord? _editingStudent;

  final _rfidNoController = TextEditingController();
  final _studentNumberController = TextEditingController();
  final _sectionController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _middleInitialController = TextEditingController();
  final _guardianController = TextEditingController();
  final _searchController = TextEditingController();

  final List<_StudentRecord> _studentRecords = [];

  static const List<String> _courseOptions = [
    'BS Business Administration',
    'BS Hospitality Management',
    'BS Information Technology',
    'BS Tourism Management',
  ];

  static const List<String> _yearLevelOptions = [
    '1st Year',
    '2nd Year',
    '3rd Year',
    '4th Year',
  ];

  InputDecoration _fieldDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Color(0xFF9CA3AF),
        fontSize: 14,
      ),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(color: Color(0xFF3B82F6)),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF111827),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _textField({
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label),
        TextField(
          controller: controller,
          style: const TextStyle(fontSize: 14),
          decoration: _fieldDecoration(hint: hint),
        ),
      ],
    );
  }

  List<_StudentRecord> get _filteredRecords {
    if (_searchQuery.trim().isEmpty) return _studentRecords;
    final q = _searchQuery.toLowerCase();
    return _studentRecords.where((student) {
      return student.rfidNo.toLowerCase().contains(q) ||
          student.studentNumber.toLowerCase().contains(q) ||
          student.fullName.toLowerCase().contains(q) ||
          student.course.toLowerCase().contains(q) ||
          student.yearLevel.toLowerCase().contains(q) ||
          student.section.toLowerCase().contains(q) ||
          student.guardianName.toLowerCase().contains(q);
    }).toList();
  }

  void _registerStudent() {
    final rfidNo = _rfidNoController.text.trim();
    final studentNumber = _studentNumberController.text.trim();
    final section = _sectionController.text.trim();
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final middleInitial = _middleInitialController.text.trim();
    final guardianName = _guardianController.text.trim();
    final course = _selectedCourse;
    final yearLevel = _selectedYearLevel;

    if (rfidNo.isEmpty ||
        studentNumber.isEmpty ||
        firstName.isEmpty ||
        lastName.isEmpty ||
        section.isEmpty ||
        guardianName.isEmpty ||
        course == null ||
        yearLevel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all required fields before register.'),
        ),
      );
      return;
    }

    setState(() {
      final record = _StudentRecord(
        rfidNo: rfidNo,
        studentNumber: studentNumber,
        firstName: firstName,
        middleInitial: middleInitial,
        lastName: lastName,
        course: course,
        yearLevel: yearLevel,
        section: section,
        guardianName: guardianName,
      );

      if (_editingStudent != null) {
        final index = _studentRecords.indexOf(_editingStudent!);
        if (index >= 0) {
          _studentRecords[index] = record;
        }
      } else {
        _studentRecords.insert(0, record);
      }

      _clearRegistrationFields();
      _editingStudent = null;
    });
  }

  void _deleteStudent(_StudentRecord student) {
    setState(() {
      _studentRecords.remove(student);
      if (_editingStudent == student) {
        _clearRegistrationFields();
        _editingStudent = null;
      }
    });
  }

  void _startEditStudent(_StudentRecord student) {
    setState(() {
      _editingStudent = student;
      _rfidNoController.text = student.rfidNo;
      _studentNumberController.text = student.studentNumber;
      _firstNameController.text = student.firstName;
      _middleInitialController.text = student.middleInitial;
      _lastNameController.text = student.lastName;
      _selectedCourse = student.course;
      _selectedYearLevel = student.yearLevel;
      _sectionController.text = student.section;
      _guardianController.text = student.guardianName;
    });
  }

  void _clearRegistrationFields() {
    _rfidNoController.clear();
    _studentNumberController.clear();
    _sectionController.clear();
    _firstNameController.clear();
    _lastNameController.clear();
    _middleInitialController.clear();
    _guardianController.clear();
    _selectedCourse = null;
    _selectedYearLevel = null;
  }

  @override
  void dispose() {
    _rfidNoController.dispose();
    _studentNumberController.dispose();
    _sectionController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _middleInitialController.dispose();
    _guardianController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          Container(
            height: 56,
            color: const Color(0xFF333652),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1480),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.credit_card_outlined,
                          size: 16,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'RFID Management Dashboard',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1480),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x07000000),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Register New Student',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFFD1D5DB),
                                  style: BorderStyle.solid,
                                ),
                                color: const Color(0xFFFCFCFD),
                              ),
                              child: Row(
                                children: [
                                  const Text(
                                    'RFID No:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: TextField(
                                      controller: _rfidNoController,
                                      style: const TextStyle(fontSize: 14),
                                      decoration: _fieldDecoration(
                                        hint: 'Waiting for RFID scan...',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 18),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final compact = constraints.maxWidth < 960;
                                return Column(
                                  children: [
                                    if (compact) ...[
                                      _textField(
                                        label: 'Student Number',
                                        hint: 'Enter student number',
                                        controller: _studentNumberController,
                                      ),
                                      const SizedBox(height: 12),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _label('Course'),
                                          DropdownButtonFormField<String>(
                                            value: _selectedCourse,
                                            isExpanded: true,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF111827),
                                            ),
                                            decoration: _fieldDecoration(
                                              hint: 'Select course',
                                            ),
                                            items: _courseOptions
                                                .map(
                                                  (course) =>
                                                      DropdownMenuItem<String>(
                                                    value: course,
                                                    child: Text(
                                                      course,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                            onChanged: (value) {
                                              setState(
                                                () => _selectedCourse = value,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _label('Year Level'),
                                          DropdownButtonFormField<String>(
                                            value: _selectedYearLevel,
                                            isExpanded: true,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF111827),
                                            ),
                                            decoration: _fieldDecoration(
                                              hint: 'Select year level',
                                            ),
                                            items: _yearLevelOptions
                                                .map(
                                                  (year) =>
                                                      DropdownMenuItem<String>(
                                                    value: year,
                                                    child: Text(
                                                      year,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                            onChanged: (value) {
                                              setState(
                                                () =>
                                                    _selectedYearLevel = value,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      _textField(
                                        label: 'Section',
                                        hint: 'Enter section',
                                        controller: _sectionController,
                                      ),
                                    ] else
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _textField(
                                              label: 'Student Number',
                                              hint: 'Enter student number',
                                              controller:
                                                  _studentNumberController,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _label('Course'),
                                                DropdownButtonFormField<String>(
                                                  value: _selectedCourse,
                                                  isExpanded: true,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Color(0xFF111827),
                                                  ),
                                                  decoration: _fieldDecoration(
                                                    hint: 'Select course',
                                                  ),
                                                  items: _courseOptions
                                                      .map(
                                                        (course) =>
                                                            DropdownMenuItem<
                                                                String>(
                                                          value: course,
                                                          child: Text(
                                                            course,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                      .toList(),
                                                  onChanged: (value) {
                                                    setState(
                                                      () =>
                                                          _selectedCourse =
                                                              value,
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _label('Year Level'),
                                                DropdownButtonFormField<String>(
                                                  value: _selectedYearLevel,
                                                  isExpanded: true,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Color(0xFF111827),
                                                  ),
                                                  decoration: _fieldDecoration(
                                                    hint: 'Select year level',
                                                  ),
                                                  items: _yearLevelOptions
                                                      .map(
                                                        (year) =>
                                                            DropdownMenuItem<
                                                                String>(
                                                          value: year,
                                                          child: Text(
                                                            year,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                      .toList(),
                                                  onChanged: (value) {
                                                    setState(
                                                      () => _selectedYearLevel =
                                                          value,
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: _textField(
                                              label: 'Section',
                                              hint: 'Enter section',
                                              controller: _sectionController,
                                            ),
                                          ),
                                        ],
                                      ),
                                    const SizedBox(height: 12),
                                    if (compact) ...[
                                      _textField(
                                        label: 'First Name',
                                        hint: 'Enter first name',
                                        controller: _firstNameController,
                                      ),
                                      const SizedBox(height: 12),
                                      _textField(
                                        label: 'Last Name',
                                        hint: 'Enter last name',
                                        controller: _lastNameController,
                                      ),
                                      const SizedBox(height: 12),
                                      _textField(
                                        label: 'M.I.',
                                        hint: 'M.I.',
                                        controller: _middleInitialController,
                                      ),
                                    ] else
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: _textField(
                                              label: 'First Name',
                                              hint: 'Enter first name',
                                              controller: _firstNameController,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            flex: 5,
                                            child: _textField(
                                              label: 'Last Name',
                                              hint: 'Enter last name',
                                              controller: _lastNameController,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            flex: 2,
                                            child: _textField(
                                              label: 'M.I.',
                                              hint: 'M.I.',
                                              controller:
                                                  _middleInitialController,
                                            ),
                                          ),
                                        ],
                                      ),
                                    const SizedBox(height: 12),
                                    _textField(
                                      label: 'Parent/ Guardian Name',
                                      hint: 'Enter guardian name',
                                      controller: _guardianController,
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                ElevatedButton.icon(
                                  onPressed: _registerStudent,
                                  icon: Icon(
                                    _editingStudent == null
                                        ? Icons.add
                                        : Icons.save_outlined,
                                    size: 16,
                                  ),
                                  label: Text(
                                    _editingStudent == null
                                        ? 'Register Student'
                                        : 'Save Changes',
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFF3F4F6),
                                    foregroundColor: const Color(0xFF374151),
                                    elevation: 0,
                                    textStyle: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                  ),
                                ),
                                if (_editingStudent != null) ...[
                                  const SizedBox(width: 10),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _editingStudent = null;
                                        _clearRegistrationFields();
                                      });
                                    },
                                    child: const Text('Cancel Edit'),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x07000000),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Student Records',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF111827),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 240,
                                  child: TextField(
                                    controller: _searchController,
                                    onChanged: (value) {
                                      setState(() => _searchQuery = value);
                                    },
                                    style: const TextStyle(fontSize: 14),
                                    decoration: _fieldDecoration(
                                      hint: 'Search students...',
                                    ).copyWith(
                                      prefixIcon: const Icon(
                                        Icons.search,
                                        size: 18,
                                        color: Color(0xFF9CA3AF),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            if (_filteredRecords.isEmpty)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 32),
                                child: Center(
                                  child: Text(
                                    'No students added yet. Add your first student above.',
                                    style: TextStyle(
                                      color: Color(0xFF6B7280),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              )
                            else
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        minWidth: constraints.maxWidth,
                                      ),
                                      child: DataTable(
                                        headingTextStyle: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF111827),
                                        ),
                                        dataTextStyle: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF374151),
                                        ),
                                        columns: const [
                                          DataColumn(label: Text('RFID No.')),
                                          DataColumn(
                                            label: Text('Student Number'),
                                          ),
                                          DataColumn(label: Text('Full Name')),
                                          DataColumn(label: Text('Course')),
                                          DataColumn(label: Text('Year Level')),
                                          DataColumn(label: Text('Section')),
                                          DataColumn(
                                            label: Text('Parent/ Guardian'),
                                          ),
                                          DataColumn(label: Text('Actions')),
                                        ],
                                        rows: _filteredRecords
                                            .map(
                                              (student) => DataRow(
                                                cells: [
                                                  DataCell(
                                                    Text(student.rfidNo),
                                                  ),
                                                  DataCell(
                                                    Text(student.studentNumber),
                                                  ),
                                                  DataCell(
                                                    Text(student.fullName),
                                                  ),
                                                  DataCell(
                                                    Text(student.course),
                                                  ),
                                                  DataCell(
                                                    Text(student.yearLevel),
                                                  ),
                                                  DataCell(
                                                    Text(student.section),
                                                  ),
                                                  DataCell(
                                                    Text(student.guardianName),
                                                  ),
                                                  DataCell(
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        IconButton(
                                                          tooltip:
                                                              'Edit student',
                                                          icon: const Icon(
                                                            Icons.edit_outlined,
                                                          ),
                                                          onPressed: () =>
                                                              _startEditStudent(
                                                            student,
                                                          ),
                                                        ),
                                                        IconButton(
                                                          tooltip:
                                                              'Delete student',
                                                          icon: const Icon(
                                                            Icons
                                                                .delete_outline,
                                                            color: Color(
                                                              0xFFDC2626,
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            _deleteStudent(
                                                              student,
                                                            );
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            const SizedBox(height: 20),
                            Text(
                              'Total Students: ${_studentRecords.length}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        '© 2026 RFID Management System. All rights reserved.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9CA3AF),
                        ),
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
}

class _StudentRecord {
  final String rfidNo;
  final String studentNumber;
  final String firstName;
  final String middleInitial;
  final String lastName;
  final String course;
  final String yearLevel;
  final String section;
  final String guardianName;

  const _StudentRecord({
    required this.rfidNo,
    required this.studentNumber,
    required this.firstName,
    required this.middleInitial,
    required this.lastName,
    required this.course,
    required this.yearLevel,
    required this.section,
    required this.guardianName,
  });

  String get fullName {
    final mi = middleInitial.trim();
    final middle = mi.isEmpty ? '' : ' ${mi.toUpperCase()}.';
    return '${firstName.trim()}$middle ${lastName.trim()}'.replaceAll(
      RegExp(r'\s+'),
      ' ',
    );
  }
}

