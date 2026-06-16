class AppLanguage {
  static bool isTamil = false;

  // Dashboard
  static String get dashboard =>
      isTamil ? "செலவு மேலாளர்" : "Expense Manager";

  static String get today =>
      isTamil ? "இன்றைய செயல்பாடு" : "Today's Activity";

  static String get week =>
      isTamil ? "இந்த வாரம்" : "This Week";

  static String get month =>
      isTamil ? "இந்த மாதம்" : "This Month";

  static String get spent =>
      isTamil ? "மொத்த செலவு" : "Total Spent";

  static String get received =>
      isTamil ? "மொத்த வரவு" : "Total Received";

  static String get balance =>
      isTamil ? "இருப்பு" : "Balance";

  // Person Screens
  static String get addPerson =>
      isTamil ? "நபரை சேர்" : "Add Person";

  static String get viewPersons =>
      isTamil ? "நபர்களை காண்க" : "View Persons";

  // Expense Screens
  static String get addExpense =>
      isTamil ? "செலவு சேர்" : "Add Expense";

  static String get viewExpenses =>
      isTamil ? "செலவுகளை காண்க" : "View Expenses";

  static String get expenses =>
      isTamil ? "செலவுகள்" : "Expenses";

  // Add Expense
  static String get selectPerson =>
      isTamil ? "நபரை தேர்வு செய்க" : "Select Person";

  static String get amount =>
      isTamil ? "தொகை" : "Amount";

  static String get category =>
      isTamil ? "வகை" : "Category";

  static String get note =>
      isTamil ? "குறிப்பு" : "Note";

  static String get saveExpense =>
      isTamil ? "செலவை சேமி" : "Save Expense";

  static String get type =>
      isTamil ? "வகை" : "Type";

  static String get spentType =>
      isTamil ? "செலவு" : "Spent";

  static String get receivedType =>
      isTamil ? "பெற்றது" : "Received";

  // Expense List
  static String get filterPerson =>
      isTamil ? "நபர் மூலம் வடிகட்டு" : "Filter By Person";

  static String get filterMonth =>
      isTamil ? "மாதம் மூலம் வடிகட்டு" : "Filter By Month";

  static String get allPersons =>
      isTamil ? "அனைத்து நபர்கள்" : "All Persons";

  static String get allMonths =>
      isTamil ? "அனைத்து மாதங்கள்" : "All Months";

  static String get selectDate =>
      isTamil ? "தேதியை தேர்வு செய்க" : "Select Date";

  static String get clearFilters =>
      isTamil ? "வடிகட்டிகளை நீக்கு" : "Clear Filters";

  static String get filteredTotal =>
      isTamil ? "வடிகட்டப்பட்ட மொத்தம்" : "Filtered Total";

  static String get categoryLabel =>
      isTamil ? "வகை" : "Category";

  static String get noteLabel =>
      isTamil ? "குறிப்பு" : "Note";

  static String get date =>
      isTamil ? "தேதி" : "Date";

  static String get noExpenses =>
      isTamil ? "செலவுகள் இல்லை" : "No Expenses Added";

  static String get unknown =>
      isTamil ? "தெரியவில்லை" : "Unknown";

  // Edit / Delete
  static String get edit =>
      isTamil ? "திருத்து" : "Edit";

  static String get delete =>
      isTamil ? "நீக்கு" : "Delete";

  static String get deleteExpense =>
      isTamil ? "செலவை நீக்கு" : "Delete Expense";

  static String get deleteConfirm =>
      isTamil
          ? "இந்த செலவை நீக்க விரும்புகிறீர்களா?"
          : "Are you sure you want to delete this expense?";

  static String get cancel =>
      isTamil ? "ரத்து" : "Cancel";

  static String get updateExpense =>
      isTamil ? "செலவு புதுப்பி" : "Update Expense";

  static String get expenseUpdated =>
      isTamil
          ? "செலவு வெற்றிகரமாக புதுப்பிக்கப்பட்டது"
          : "Expense Updated Successfully";
}