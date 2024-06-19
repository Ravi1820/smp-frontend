import 'package:flutter/material.dart';

class Strings {
  static const ENTER_PINCODE_TEXT = 'Enter PinCode';
  static const ENTER_STATE_TEXT = 'Enter State';
  static const ENTER_EMAIL_TEXT = 'Enter Email Address';
  static const ENTER_AGE_TEXT = 'Enter Age';
  static const APP_NAME_TEXT = "Care O Care";
  static const COMING_SOON = "Coming soon";
  static const RUPEE_SYMBOL = "\u20B9";
  static const SUBMIT_TEXT = "Submit";
  static const CANCEL_TEXT = "Cancel";
  static const YES_TEXT = "Yes";
  static const NO_TEXT = "No";
  static const FROM_TEXT = "From";
  static const TO_TEXT = "To";
  static const Exit_TEXT = "EXIT";
  static const SKIP_BTN_TEXT = "SKIP";
  static const SIGN_OUT_TEXT = "LOGOUT";
  static const SAVE_BTN_TEXT = "SAVE";
  static const NEXT_TEXT = "NEXT";
  static const ENTER_BTN_TEXT = 'ENTER';
  static const API_ERROR_MSG_TEXT =
      "Request is not successful. Please try again later!";
  static const BLOCK_CALENDER_TEXT = "BLOCK CALENDER";

  //Login Screen
  static const ENTER_PHONE_NUMBER_TEXT = 'Enter Phone Number';
  static const ENTER_NAME_TEXT = "Enter Name";
  static const ENTER_NUMBER_TEXT = "Enter number";
  static const REGISTRATION_NUMBER_TEXT = "Registration number";
  static const PRIMARY_NUMBER_TEXT = "Primary number";
  static const ENTER_OTP_TEXT = "Enter verification code";
  static const ENTER_REGISTRATION_TEXT = "MR NO./CR NO./Drug License No.";
  static const ENTER_VALID_USER_NAME = "Please enter user name";
  static const ENTER_VALID_PHONE_NUMBER = "Please enter valid mobile number";
  static const GET_OTP_TEXT = "Get OTP";
  static const CONTINUE_TEXT = "CONTINUE";
  static const LOCATION_ERROR_MSG_TEXT =
      "Your Location on Device is not ON please on to use MAP.";
  static const LOCATION_TEXT = "Location";
  static const OTP_SENT_TEXT1 =
      "To complete verification, please enter the code received by SMS on ";
  static const OTP_SENT_TEXT = "OTP is sent to +91 ";
  static const OTP_NOT_RECEIVED_TEXT = "Haven't received OTP yet?";
  static const RESEND_BTN_TEXT = "RESEND";
  static const WELCOME_APP_TEXT = "Take a moment to review your profile";
  static const PROVIDE_SOME_DETAILS_TEXT =
      "A completed profile will increase credibility amongst your peers and patients.";
  static const SIGN_UP_BTN_TEXT = "Complete sign-up";
  static const REFERRAL_CODE_TITLE_TEXT = "Enter referral code";
  static const OPTIONAL_TEXT = "(optional)";
  static const CHEERS_SIGNUP_TITLE_TEXT = "Cheers on signing up with us!";
  static const INVITED_TEXT_TITLE_TEXT =
      "Invited to EasyBrezy by a friend? Enter your friend's referral code to get EasyBrezy points.";
  static const ENTER_CODE_HERE = "Enter code here";
  static const ENTER_REFERRAL_CODE_ERROR_TEXT =
      "Please enter a valid referral code.";
  static const LOGIN_OTP_INFO_TEXT =
      "You will receive an SMS to verify your phone identity";
  static const TERMS_SERVICE_TEXT_ONE =
      'By clicking Sign Up, you agree to our ';
  static const TERMS_SERVICE_TEXT_TWO = 'Terms of Service';
  static const PRIVACY_POLICY_TEXT = 'Privacy Policy';
  static const MEDICAL_PROFESSIONAL_BTN_TEXT = "For Medical Professionals";
  static const COUNTRY_CODE_TEXT = '+91';
  static const ENTER_REASON_ERROR_TEXT = "Please enter reason to cancel.";
  static const REASON_CANCEL_TITLE_TEXT = "Reason for Cancelation";
  static const ANSWER_TITLE_TEXT = "Answer";

//Home Screen
  static const NAME_TEXT = "Name: ";
  static const NUMBER_TEXT = "Mobile Number: ";
  static const BALANCE_TEXT = "Wallet Balance :";
  static const ENTER_PICKUP_LOCATION = "Enter pickup location";
  static const ENTER_DROP_LOCATION = "Enter your drop location";
  static const LUGGAGE_INFORMATION =
      "No of luggage should be 5 bags and the total weight should not exceed 80 kg  ";
  static const PICKUP_LOCATION = "Please enter your  pickup location";
  static const DROP_LOCATION = "Please enter your  drop location";
  static const K_M = "Km";
  static const RS_TEXT = "Rs.";
  static const PER_KM = "/- per km";

  //Drawer List
  static const ARE_YOU_SURE_TEXT = "Are you sure?";
  static const DO_YOU_WANT_EXIT_TEXT = "Do you want to exit from the App?";
  static const List drawerItems = [
    {
      "icon": Icons.home,
      "name": "Home",
    },
    {
      "icon": Icons.person,
      "name": "My Rides",
    },
    {
      "icon": Icons.help,
      "name": "Help",
    },
    {
      "icon": Icons.power_settings_new,
      "name": "Logout",
    },
  ];

//RideDetails.
  static const DISTANCE_COVERED = "Distance to be covered";
  static const VEHICLE_NAME = "Vehicle";
  static const PICK_UP_DATE = "Pick up date";
  static const pick_up_TIME = "Pick up time";
  static const TRAVEL_TIME = "Estimated travel time";
  static const AMOUNT = "Total amount";

  static const COLON_STRING = ": ";
  static const BOOKING_CONFIRMED = "Booking Confirmed";

//HelpScreen
  static const CALL_THE_BELOW_NUMBER =
      "Please call the below phone number if you have any queries ";
  static const CONTACT_NUMBER = "Contact No:+8670456587838, +9188878718514398";
  static const ASKED_QUESTIONS = "Frequently asked questions:";
  static const List questionList = [
    {"name": "Excepteur sint occoecat cupidata non"},
    {"name": "Excepteur sint occoecat cupidata non"},
    {"name": "Excepteur sint occoecat cupidata non"},
    {"name": "Excepteur sint occoecat cupidata non"},
    {"name": "Excepteur sint occoecat cupidata non"},
    {"name": "Excepteur sint occoecat cupidata non"}
  ];

//Dashboard
  static const IS_USER_LOGGED_OUT = "is_user_logged_out";

//driverscreen RegistrationScreen
  static const DRIVER_NAME = "Driver name";
  static const DRIVER_NUMBER = "Driver mobile number";
  static const REGISTRATION_SUBMITED =
      "Your profile is under verification we will send you verification message to your registered mobile number";
  static const REGISTER = "Registration Submited";
  static const REGISTRATION_VERIFICATION =
      "Registered & Verification successfully";
  static const LOGOUT_ALERT_MESSAGE_TEXT = "Are you sure you want to logout?";
  static const USER_REGISTERED = "user_registered";
  static const SWIPE = "Swipe to start ride";
  static const SWIPE_TEXT = "Swipe to finish ride";
  static const UPLODE_AADHAR_IMAGE = "Uplode aadhar card ";
  static const UPLODE_DRIVING_LISENCE = "Uplode driving lisence";
  static const ENTER_YOUR_ADDRESS = "Enter your address";
  static const ENTER_PINCODE = "Enter your pin code";
  static const ENTER_CORRECT_PINCODE = "Pin code should not be empty";
  static const PINCODE_IS_SIX_DIGIT = "Pin code must be six digit";
  static const ENTER_PASSWORD = "Enter password";
  static const PASSWORD_IS_SIX_DIGIT = "Password should be six digit and above";
  static const PASSWORD_NOT_MATCH =
      "Password and conformpassword are not match";
  static const TYPE_SOMETHING = "Type Something";
  static const SEARCH_NAME_MOBILE_NUMBER = "Search name or mobile number";
  static const CUSTOMER_RIDE_HISTORY = "Customer ride history";
  static const VEHICLE_TYPE = "Vehicle Type:";
  static const SELECT_DRIVER = "Select Driver name";
  static const ASSIGN_DRIVER = "Assign Drivers";
  static const REJECT_TEXT = "Reject";
  static const MINI_CAB = 'Mini';
  static const SUV_CAB = 'SUV';
  static const SEDAN_CAB = 'Sedan';
  static const VEHICLE_NUMBER1 = "KA 04AD 1234";
  static const ENTER_OTP = "Enter Otp";
  static const SAY_SOMETHING = "Say something";
  static const WHATSAPP = "whatsapp";
  static const CALL = "Call ";
  static const PASSENGER_DETAILS = "Passenger Details:";
  static const TIME = "12:33PM";
  static const ACCEPT = "Accept";
  static const YOU_HAVE = "You have";
  static const NEW_REQUESTS = "new requests";
  static const List adminItems = [
    {
      "icon": Icons.home,
      "name": "Dashboard",
    },
    {
      "icon": Icons.person,
      "name": "Registration",
    },
    {
      "icon": Icons.add,
      "name": "Add And Remove Driver/Vehicle",
    },
    {
      "icon": Icons.person_add,
      "name": "Assign Drivers",
    },
    {"icon": Icons.insert_drive_file, "name": "Verify Driver"},
    {
      "icon": Icons.person_pin,
      "name": "Customers",
    },
    {
      "icon": Icons.payment,
      "name": "Payments to drivers",
    },
    {
      "icon": Icons.comment,
      "name": "Complaints",
    },
    {
      "icon": Icons.history,
      "name": "Ride History",
    },
    {
      "icon": Icons.search,
      "name": "Search History",
    },
    {"icon": Icons.power_settings_new, "name": "Log out"},
  ];

  //BookingAccepted
  static const List<String> reasonList = [
    'Unable to contact passenger',
    'Expected shorter distance',
    'Vehicle issues',
    'Other'
  ];

  //BillDetails Screen
  static const List paymentList = [
    {
      "name": "Cash",
      "icon": Icons.attach_money,
    },
    {
      "name": "Wallet Money",
      "icon": Icons.account_balance_wallet,
    }
  ];

  static const List<String> userList = [
    'Admin',
    'Driver',
  ];
  static const DRIVER = 'Driver';
  static const VEHICLE = 'Vehicle';
  static const ADD = "Add";
  static const REMOVE = "Remove";
  static const DRIVERS = "Drivers";
  static const TRIP_ID = "Trip id";
  static const CUSTOMER = "Customer";
  static const CURRENT_LOCATION = "Current Location";
  static const TRIP_LOCATION = "Trip location";
  static const BOOKING_ID = "Search booking id";

//Admin screen
  static const ADMIN_NAME = "Admin Name";

//Admin package/ DashboardScreen

//Customers
  static const Emergency_NUMBER = "Enter emergency contact number";
  static const TRIP_COMPLETED = "Trip completed:";
  static const WALLET_AMOUNT = "Wallet amount:";
  static const RUPEES_SYMBOL = "/-";
  static const HOME_LOCATION = "Home location:";
  static const VEHICLE_NUMBER = "Enter Vehicle No.:";
  static const USER_ADMIN = "ADMIN";
  static const USER_DRIVER = "DRIVER";
  static const USER_TYPE = "User_Type";
  static const USER_ID = "User Id";
  static const HOME = "Home";
  static const ADMIN_ID = "ADMIN ID";
  static const NETWORK_CONNECTION_ERROR =
      "Network is not available please check connection";

  static const CUSTOMER_NAME = "Customer Name :";
  static const ENTER_CAB_NAME = "Enter can name";
  static const ENTER_CAB_NUMBER = "Enter cab number";
  static const ENTER_CAB_SEATER = "Enter cab seater";
  static const ENTER_CHARGE = "Enter charge per km";
  static const ENTER_LUGGAGE = "Enter luggage";
  static const VEHICLE_ADD_SUCCESS = "Vehicle addede successfully";
  static const VEHICLE_REMOVED = "Vehicle Removed";
  static const DRIVER_REMOVE = "Driver remove";
  static const REMOVE_VEHICLE = "Do you want remove vehicle";
  static const REMOVE_DEIVER = "Do you want to remove driver";
  static const TIME_SYMBOL = "Hr";
  static const INCOMING_RIDE = "Incoming request";
  static const ENTER_OTP_NUMBER = "Enter otp";
  static const COMPLAINTS = "Complaint message:";
  static const REPLAY = "Reply";
  static const FULL_NAME = "Full Name:";
  static const MOBILE_NUMBER = "Mobile Number:";

  static const AADHAR_CARD = "Aadhar Card:";
  static const D_L = "Driving Lisence:";
  static const APPROVE = "Aprove";
  static const MODIFY = "Modify";
  static const REJECT = "Reject";
  static const PAY_NOW = "Pay Now";
  static const PAYMENT_TO_DRIVER = "Payment to Driver";
  static const SELECT_DRIVER_NAME = "Select driver name";
  static const TOTAL_WORKING_DAY = "Total working days";
  static const VHICLE_NUMBER2 = "Vehicle Number";
  static const DAYS_ON_LEAVE = "Days on leave";
  static const TOTAL_TRIPS = "Total trips";
  static const AMOUNT_TO_BE_PAID = "Amount to be paid";
  static const DAYS = "20 days";
  static const DAYS1 = "3 days";
  static const TRIPS = "25 Trips";
  static const SALARY = "8200/-";
  static const SUBMIT_AND_PAY = "Submit & Pay";
  static const TRIPS_COUNT = "25 ";
  static const ONGOING_TRIP = "Ongoing trips";

//static const NEW_REQUESTS =  "New requests";
  static const CURRENT_BOOKINGS = "Current bookings";
  static const AVAILABLE_DRIVERS = "Available drivers";
  static const BILL_DETAILS = "Bill Details";
  static const MY_PROFILE = "My profile";
  static const YOUR_NAME = "Your Name";

  //Image
  static const MASK_IMAGE = "assets/Mask Group-1.png";
  static const MINI_IMAGE = "assets/mini_image.jpg";
  static const AVTAR_IMAGE = "assets/Avtar_image.jpg";
  static const CAMERA_IMAGE = "assets/camera_image.png";
  static const UPLODE_IMAGE = "assets/upload_image.png";

  static const APPARTMENT_NAME = "appartment name";
  static const BLOCK_NAME = "block name";
  static const FLOOR_NAME = "floor name";
  static const FLAT_NAME = "flat name";
  static const APPARTMENT_DATA_TYPE = "APPARTMENT_TYPE";
  static const FLAT_LABEL = "Select Flat";
  static const BLOCK_LABEL = "Select Block";
  static const FLOOR_LABEL = "Select Flat";

  static const SELECTED_USER_LABEL = "Not Occupied";

  static const RESIDENT_NOT_AVAILBLE =
      "No resident available for the selected flat. \nPlease select some other flats";

  static const SCAN_USER_PROFILE = "Scan user profile";

  static const STATUS_INACATIVE = 'inactive';
  static const STATUS_SUCCESS = 'success';
  static const STATUS_NOT_APPROVED = 'not_approved';
  static const STATUS_ERROR = 'error';
  static const STATUS_LOGGED_IN = 'logged_in';
  static const STATUS_REJECTED = 'rejected';

  static const NEW_OWMER_TENNANT_ID = "newOwnerTenantId";
  static const CURRENT_DATE_TIME = "currentDateTime";
  static const REJECTED_REASON = "rejectedReason";
  static const REJECTED_MESSAGE = "rejectedMessage";

  static const WRONG_LOGIN_MESSAGE =
      "Email or password is wrong\nPlease use correct credentials";

  /* Shared Preference */

  static const ISLOGGEDIN = 'isLoggedIn';
  static const TOKEN = 'token';
  static const PROFILEPICTURE = 'profilePicture';
  static const EMAIL = 'email';
  static const BLOCKNAME = 'blockName';
  static const FLATNAME = 'flatName';
  static const ROLES = 'roles';
  static const FLATID = 'flatId';
  static const USERNAME = 'userName';
  static const APARTMENTNAME = 'apartmentName';
  static const MOBILE = 'mobile';
  static const AGE = 'age';
  static const ADDRESS = 'address';
  static const GENDER = 'gender';
  static const PINCODE = 'pinCode';
  static const STATE = 'state';
  static const SOSPIN = 'sosPin';
  static const ADDGUESTALLOWED = 'addGuestAllowed';

  static const APARTMENTID = 'apartmentId';
  static const BLOCKCOUNT = 'blockCount';
  static const ID = 'id';

  static const ENTER_PASSWORD_TEXT = 'Enter Password';
  static const ENTER_ADDRESS_TEXT = "Enter Address";
  static const NOTICE_FILE_NAME = "noticeFile";
  static const DEVICE_ID_FILE_NAME = "deviceIdFile";
  static const ISSUE_COUNT_FILE_NAME = "issueCountFile";

  static const TIME_OUT_MESSAGE = "Connection time out";
  static const COMMON_RED_COLOURS = "";

  static const EMAIL_OTP = "Email OTP";

  //----Pooji-----------
  static const DASHBOARD_SCREEN = 'dashBoard';
  static const ADMIN_BLOCK_SCREEN = 'adminBlock';
  static const MESSAGE_SCRREN = 'message';
  static const SUBJECT = 'Subject';
  static const UPDATE_TEXT = 'Update';
  static const SUBJECT_HINT_TEXT = ' Enter Subject';
  static const SUBJECT_ERROR_TEXT = "Please enter a subject.";
  static const MESSAGE = 'Message';
  static const MESSAGE_HINT_TEXT = ' Enter message';
  static const MESSAGE_ERROR_TEXT = "Please enter message.";
  static const MANDATORY_FIELD_TEXT = "Please fill all mandatory fields";
  static const UPDATE_POLL_ERROR_TEXT =
      "No changes detected. Please make modifications before updating the notice.";

// labelText .....
  static const FULL_LABEL_TEXT = "Full name";
  static const MOBILE_LABEL_TEXT = "Mobile";
  static const GENDER_LABEL_TEXT = "Gender";
  static const PINCODE_LABEL_TEXT = "Pin code";
  static const ADDRESS_LABEL_TEXT = "Address";
  static const STATE_LABEL_TEXT = "State";
  static const AGE_LABEL_TEXT = 'Age';
  static const EMAIL_LABEL_TEXT = 'Email';
  static const EDIT_PROFILE_UPDATE_ERROR_TEXT =
      "No changes detected in user profile";
  static const VALID_USER_DETAILS_ERROR_TEXT =
      "Please enter valid user details";
  static const FULLNAME_REQUIRED_TEXT = "Full name is required";
  static const EMAIL_CANT_BE_EMPTY = 'Email cannot be empty';
  static const EMAIL_INVALID_MESSAGE = 'Invalid email';
  static const MOB_CANT_BE_EMPTY = 'Phone number cannot be empty';
  static const MOB_INVALID_MESSAGE = 'Invalid phone number';
  static const ADDRESS_CANT_BE_EMPTY = 'Address name cannot be empty';
  static const ADDRESS_CANT_SPL_CHAR =
      'Address name cannot contain special characters';
  static const STATE_CANT_BE_EMPTY = 'State name cannot be empty';
  static const STATE_CANT_SPL_CHAR =
      'State name cannot contain special characters';
  static const PINCODE_CANT_BE_EMPTY = 'PinCode cannot be empty';
  static const PINCODE_INVALID_MES = 'Invalid pincode';
  static const SECURITY_NAME = 'Security Name';
  static const SECURITY = 'Security';
  static const OWNER = 'Owner';
  static const ADMIN = 'Admin';
  static const TENANT = 'Tenant';
  static const ADD_FAMILY = 'Add Family';
  static const VIEW_FAMILY = 'View Family';
  static const EDIT_PRE_APPROVE_GUEST_HEADER = "Edit Pre-Approved Guest";
  static const SHIFT_START_TIME = 'Shift Start Time';
  static const SHIFT_END_TIME = ' "Shift End Time"';
  static const NAME_CANT_EMPTY = 'Name cannot be empty';
  static const NAME_SHU_VALID = 'Name should be valid';
  static const PHN_CANT_BE_EMPTY = 'Phone number cannot be Null';
  static const INVALID_MOB_NUM = 'Invalid mobile number';
  static const AGE_INVALID_TXT = 'Age cannot be null';
  static const AGE_MUST_18 = 'Invalid Age. Must be above 18 years';
  static const GUEST_NAME_LABEL_TEXT = 'Guest Name';
  static const GUEST_NAME_HINT_TEXT = 'Enter Guest Name';
  static const NAME_REQU_TEXT = 'Name is required';
  static const MOB_NUM_REQ = 'Mobile number is required';
  static const MOBILE_HINT_TXT = 'Enter Mobile Number';
  static const FROM_DATE_LABEL_TEXT = 'From Date';
  static const TO_DATE_LABEL_TEXT = 'To Date';
  static const FROM_DATE_HIN_TEXT = ' Enter From Date';
  static const TO_DATE_HIN_TEXT = ' Enter To Date';
  static const DATE_REQ_TEXT = ' date is required';
  static const PUR_TO_MEET = "Purpose To Meet";
  static const SEL_PUR = "Select Purpose";
  static const PUR_HIN_TXT = 'Enter your purpose';
  static const PUR_REQ_TXT = 'Purpose is required';
  static const OTH_PUR = "Other Purpose";
  static const OTHERS = 'Others';
  static const NUM_GUEST_LABEL_TXT = 'Number of guest';
  static const INVITE_BUT_TXT = "Invite";
  static const END_TIME_MESS = "End time should be after Start time.";
  static const ALLOWED_BY = "Allowed by";
  static const ACTIVE_TEXT = "active";
  static const OCC_TEXT = "Occupied";
  static const VAC_TXT = "Vacant";
  static const SEARCH_BY_N_P_PU = "Search by Name, Phone, Purpose...";
  static const WAITING_TXT = "Waiting";
  static const EXPECTED_TXT = "Expected";
  static const IN_OUT_TEXT = "In/Out";
  static const REJECTED_TXT = "Rejected";

  static const SECURITYONLINE = "Online";
  static const SECURITYOFFLINE = "Offline";

  static const INVENTORYOUTGOING = "Outgoing";
  static const INVENTOR_HEADER = "Goods And Inventory List";
  static const NO_INVENTORARY = "There are no goods";
  static const START_DATE = "Start Date";
  static const START_DATE_ERROR_TEXT = "Start date should be before end date";
  static const START_DATE_ERROR_TEXT_1 = "Goods start date can't be empty.";

  static const END_DATE_ERROR_TEXT = "End date should be after start date";
  static const END_DATE_ERROR_TEXT_1 = "Goods End date can't be empty.";

  static const END_DATE = "End Date";
  static const END_DATE_HINT_TEXT = "Goods End Time";

  static const START_DATE_HINT_TEXT = "Goods Start Time";

  //User ROLE
  static const ROLETENANT = "ROLE_FLAT_TENANT";
  static const ROLEOWNER = "ROLE_FLAT_OWNER";
  static const ROLEADMIN = "ROLE_FLAT_ADMIN";
  static const ROLESECURITY = "ROLE_FLAT_SECURITY";
  static const ROLESECURITY1 = "ROLE_SECURITY";

  //User ROLE
  static const ROLETENANT_1 = "ROLE_TENANT";
  static const ROLEOWNER_1 = "ROLE_OWNER";
  static const ROLEADMIN_1 = "ROLE_ADMIN";
  static const ROLESECURITY_1 = "ROLE_SECURITY";
  static const ROLESECURITY1_1 = "ROLE_SECURITY";

  // Dashboard Card Labels
  static const MANAGE_STAFF = "Manage \nStaffs";
  static const ASSOCIATION_ADMINISTRATION = "Association \nAdministration";
  static const MANAGE_INVENTORARY = "Manage \nInventory";
  static const MANAGE_POLLS = "Manage \nPolls";
  static const MANAGE_COMPLAINTS = "Manage Complaints";
  static const MANAGE_RESIDENT = "View \nResident";

  static const VIEW_POLLS = "View Polls";
  static const BOOK_AMENITY = "Book Amenity";
  static const SECUTITY_LIST ="Security List";
  static const MANAGE_ISSUES = "Manage \nIssues";
  static const VIEW_RESIDENT = "View Residents";
  static const MY_VISITORS = "My Visitors";
  static const PRE_APPROVE_GUEST = "Pre-approve Guest";

  static const ADD_VISITOR = "Register Visitor";
  static const PENDING_APPROVAL_LIST = "Pending Approval List";
  static const CONTACT_OWNERS = "Contact Resident";
  static const VEHICLE_MANAGEMENT = "Vehicle Management";
  static const VISITORS_LIST_LABEL = "Visitors List";
  static const PRE_APPROVAL_ENTRIES = "Pre-approval Entries";

//Forgot Password

  static const FORGOT_PASSWORD_HEADER = "Forgot Password";
  static const SEND_OTP_LABEL =
      "We’ll send the OTP to your registered email address";
  static const CHOOSE_APARTMENT_LABEL = "Choose Apartment";
  static const CHOOSE_APARTMENT_LABEL1 = "Select Apartment";
  static const EMAIL_ADDRESS_ERROR_TEXT = "Please enter valid email address";
  static const ALERT_ERROR = "Please fill mandatory fields";
  static const EMAIL_ID_LABEL = "Email Id";

// Waiting Approval Screen

  static const DASHBOARD_HEADER = "Dashboard";
  static const APPROVAL_PENDING_TEXT = "Your account approval is pending.";
  static const APPROVAL_PENDING_TEXT01 =
      "You have waited for 24 hours, Please contact your admin for approval or click on re-send button for approval";

  static const String APPROVAL_PENDING_TEXT_TEMPLATE =
      "Your account will be activated once your society admin approves it. Approvals typically take {date}. If it is taking longer, please remind your admin.";

  static const APPROVAL_PENDING_TEXT1 =
      "Your account will be activated once your society admin approves it. Approvals typically take 1-2 days. If it is taking longer, please remind your admin.";
  static const REOSEND_APPROVEAL = "Re-send";

  // Logout

  static const WARNING_TEXT = "Warning !!!";
  static const CLOSE_TEXT = "Do you want to close the App?";

  //Amenity Management
  static const AMENITY_HEADER = "Register Facility";
  static const FACILITY_LABEL = "Facility Name";
  static const FACILITY_LOCATION = "Facility Location";
  static const FACILITY_CHARGES = "Per Hour Charges";

  static const FACILITY_DESCRIPTION = "Description";
  static const FACILITY_DESCRIPTION_PLACEHOLDER = "Enter Description";

  static const FACILITY_ERRORMESSAGE =
      "Please enter facility name";
  static const FACILITY_CHARGES_ERRORMESSAGE =
      "Please enter charges per hour";
  static const FACILITY_LOCATION_ERRORMESSAGE =
      "Please enter facility location";
  static const FACILITY_DESCRIPTION_ERRORMESSAGE =
      "Please enter description";
  static const FACILITY_LABEL_PLACEHOLDER = "Enter Facility Name";
  static const FACILITY_LOCATION_PLACEHOLDER = "Enter Location";
  static const FACILITY_CHARGES_PLACEHOLDER = "Enter Charges Per Hour";
  static const FACILITY_TYPE_LABEL = "Facility Type";

  //Resident Vehicle String

  static const ADD_VEHICLE_HEADER = "Add Vehicle";
  static const EDIT_VEHICLE_HEADER = "Edit Vehicle";
  static const VEHICLE_NUMBER_LABEL = "Vehicle Number";
  static const VEHICLE_NUMBER_PLACEHOLDER = "TN 29 BP 8852";
  static const VEHICLE_NUMBER_ERRORMESSAGE =
      "Please enter valid vehicle number";
  static const VEHICLE_SLOT_LABEL = "Slot";
  static const VEHICLE_SLOT_PLACEHOLDER = "Select Slot";
  static const VEHICLE_SLOT_ERROR_MESSAGE = "Please select any slot";
  static const VEHICLE_TYPE_LABEL = "Vehicle Type";
  static const VEHICLE_TYPE_PLACEHOLDER = "Select Vehicle Type";
  static const VEHICLE_TYPE_ERROR_MESSAGE = "Please select any vehicle type";
  static const VEHICLE_UPLOAD_IMAGE = "Upload Image ";
  static const VEHICLE_LIST_HEADER = "Vehicle List";
  static const NO_VEHICLE_LABEL = "There are no vehicle";
  static const ALLOCATE_SLOT_HEADER = "Allocate Vehicle slot";
  static const RENT_SLOT_HEADER = "Rent Vehicle slot";
  static const ASSIGN_SLOT_LABEL = "Assign Slot";
  static const ENTER_AMOUNT = "Amount";
  static const ENTER_AMOUNT_PLACEHOLDER = "Enter Amount";
  static const ASSIGN_SLOT_PLACEHOLDER = "Select Slot";
  static const VEHICLE_NUMBER_PLACEHOLDER1 = "Tn 29 BP 8852";
  static const VEHICLE_TYPE_PLACEHOLDER1 = "2 Wheeler";
  static const VEHICLE_SLOT_PLACEHOLDER1 = "B - 102";
  static const ADD_VEHICLE_SUBMIT_BUTTON = "Submit";
  static const ADD_VEHICLE_CANCEL_BUTTON = "Cancel";
  static const DELETE_VEHICLE_WARNING_TEXT = "Please select vehicle to delete";

  //Side Drawer Label Text

  static const VISITORS_LIST = "Visitors List";
  static const MANAGENOTICE = "Manage Notice";
  static const MESSAGES = "Messages";
  static const MY_APPROVALS = "My Approval";
  static const CHANGE_PASSWORD = "Change Password";
  static const VEHICLE_MANAGEMENT_LABEL = "Vehicle Management";
  static const AMINITY_MANAGEMENT_LABEL = "Amenity Management";
  static const PROFILE_TEXT = "Profile";
  static const CONTACT_SECURITY = "Contact Security";
  static const LOGOUT_TEXT = "Logout";

  // Issue Management
  static const ISSUE_ID = "Issue ID : ";
  static const ISSUE_REPORTED_BY = "Reported By : ";
  static const ISSUE_REPORTED_BY_1 = "Reported By";

  static const ISSUE_ASSIGNED_TO = "Assigned to";
  static const ISSUE_STATUS = "Status";
  static const ISSUE_COMMANT = "Comment";
  static const ISSUE_ACTION_PLACEHOLDER = "Enter Action";
  static const ISSUE_ACTION_ERROR_MESSAGE = "Please enter the message";
  static const ISSUE_DESCRIPTION_TEXT = "Description";
  static const ISSUE_REPORTED_TIME = "Reported time";
  static const SELECT_ISSUE_STATUS_TEXT = "Select Status";
  static const SELECT_ISSUE_ROLE_TEXT = "Select Role";

  static const SELECT_ISSUE_STATUS_TEXT1 = "Please select any status";
  static const SELECT_ISSUE_TEAM_TEXT = "Please choose a team to assign";

  static const ISSUE_CATAGORY = "Category : ";
  static const ISSUE_PRIORITY = "Priority : ";
  static const ISSUE_DESCRIPTION = "Description : ";
  static const ISSUE_PRIORITY_LOW = "ISSUE_PRIORITY_LOW";
  static const ISSUE_PRIORITY_MEDIUM = "ISSUE_PRIORITY_MEDIUM";
  static const ISSUE_PRIORITY_HIGH = "ISSUE_PRIORITY_HIGH";

  // Pending Approval list

  static const FLAT_NUMBER_LABEL = "Flat Number";
  static const FLOOR_NUMBER_LABEL = "Floor Number";
  static const BLOCK_NUMBER_LABEL = "Block Name";
  static const RESIDENT_NAME_LABEL = "Resident Name";
  static const PROOF_DETAILS_LABEL = "Proof Details";
  static const PROOF_TYPE_LABEL = "Proof Type";
  static const VISITOR_NAME_LABEL = "Visitor Name";
  static const MOBILE_LABEL = "Mobile";
  static const VISTOR_DETAILS_LABEL = "Visitor Details";

  // Admin Issue management

  static const MANAGE_COMPLAINTS_HEADER = "Manage Complaints";
  static const TAB_HEADER_01 = "Pending";
  static const TAB_HEADER_02 = "In Progress";
  static const TAB_HEADER_03 = "Resolved";
  static const NO_INPROGRESS_ISSUE_TEXT = "There are no in-progress issues";
  static const NO_RESOLVED_ISSUE_TEXT = "There are no resolved issues";
  static const NO_ISSUE_TEXT = "There are no issues";
  static const SEARCH_ISSUE_TICKET_LABEL = "Search by ticket name...";
  static const SELECT_ISSUE_WARNING_TEXT = "Please select the issue";
  static const EDIT_BUTTON_TEXT = "Edit";
  static const SEARCH_TICKET_HEADER = "Search Ticket";
  static const VIEW_ISSUE_HEADER = "View Issue";

  //Association Member
  static const WARNING_TEXT1 = "Confirm Deletion!";
  static const CONFIRMAION_TEXT =
      "Are you sure, you want to delete the member(s)?";
  static const ASSOCIATION_MEMEBER_HEADER = "Association Members";

//My Approval

  static const APPROVAL_REJECT_TEXT = "Reject";
  static const APPROVAL_APPROVE_TEXT = "Approve";
  static const NO_NEW_OWNER_TEXT = "No new request from owner/tenant";
  static const NO_NOTICE_AVAILABLE_TEXT =
      "No notice available, \nplease create a notice";
  static const DELETE_NOTICE_TEXT =
      "Are you sure, you want to delete the notice(s)?";
  static const PURPOSE_FOR_REJECT_TEXT = "Purpose for reject";

  static const PURPOSE_FOR_REJECT_PLACEHOLDER =
      "Enter the purpose for rejection";

  // Admin Block List

  static const NO_BLOCK_TEXT = "No Resident, Flat, Block… Found";

  // Resident List

  static const RESIDENT_LIST_HEADER = "Select Contact";
  static const NO_RESIDENT_TEXT = "No residents available";
  static const NO_OWNER_INFORMATION_AVAILABLE =
      "Owner information not available";
  static const NO_USER_AVAILABLE = "User is not available";
  static const NOT_OCCUPIED_TEXT = "Not Occupied";
  static const NO_RESIDNT_AVAILABLE = "No Resident, Flat, Block… Found";
  static const NO_OWNER_AVAILABLE = "No Owner, Flat, Block… Found";

  static const SELECT_ANY_BLOCK_TEXT = "Please select a block";
  static const ENTER_MESSAGE_TEXT = "Enter Message";
  static const ENTER_MESSAGE_ERROR_TEXT = "Please enter the message";
  static const MESSAGE_SEND_TEXT = "Send";
  static const LONG_PRESS_MESSAGE_TEXT =
      "Please long-press on any resident to send message";

// Edit Security

  static const EDIT_SECURITY_HEADER = "Security Details";
  static const NO_CHANGES_TEXT = "No changes...";
  static const DELETE_CONFIRM_TEXT = "Are you sure, you want to delete?";
  static const VIEW_SECURITY_HEADER = "Security Details";
  static const SECURITY_NAME_LABEL = "Security Name";
  static const SECURITY_MOBILE_LABEL = "Mobile";
  static const SECURITY_EMAIL_ID_LABEL = "Email Id";
  static const SECURITY_AGE_LABEL = "Age";
  static const SECURITY_STATE_LABEL = "State";
  static const SECURITY_PINCODE_LABEL = "Pin code";
  static const SECURITY_STATUS_LABEL = "Status";
  static const SECURITY_ADDRESS_LABEL = "Address";
  static const ADJUCT_DURATION_LABEL = "Adjust Duration(Hrs)";
  static const SHIFT_DURATION_LESS_ERROR_LABEL =
      "Shift time cannot be less than 1 hours";
  static const SELECT_SHIFT_TIME_WARNING = "Please edit shift time to update";

  static const SHIFT_DURATION_MORE_ERROR_LABEL =
      "Shift time cannot be more than 12 hours";

  static const FILE_DOWNLOAD_SUCCESS = "Pdf downloaded successfully";
  static const FILE_DOWNLOAD_PATH_ERROR = "Error getting download path";

  static const FILE_DOWNLOAD_PERMISSION_ERROR =
      "Storage permission not granted";

//Apartment List

  static const APARTMENT_LIST = "Search apartment";
  static const BLOCK_LIST_SEARCH_PLACEHOLDER = "Search block";
  static const FLAT_SEARCH_PLACEHOLDER = "Search by flatnumber";
  static const NO_FLATS_TEXT = "No active flats in this floor";
  static const FLOOR_SEARCH_PLACEHOLDER = "Search floor";

  static const EDIT_PROFILE_BTN_TEXT = "Edit profile";
  static const SHIFT_END_TIME_TEXT = "Shift Start Time";
  static const SHIFT_END_TIME_LABEL = "Shift End Time";

  //Society Dues

  static const UPLOAD_SOCIETY_DUES_HEADER = "Upload Society Dues";
  static const NO_FILES_SELECTED_TEXT = "No File Selected";
  static const SELECT_DUE_TYPE_TEXT = "Select due type";
  static const SELECT_USER_GROUP_TEXT = "Select user group";
  static const SOCIETY_DESCRIPTION = "Description";
  static const SOCIETY_DESCRIPTION_HINT = "Enter description";
  static const SOCIETY_DESCRIPTION_ERROR_TEXT = "Please enter the description";
  static const UPLOAD_EXCEL_TEXT = "Click here to import excel";
  static const SELECT_FILE_TEXT = "Selected File";
  static const MANDATORY_FIELD_WARNING_TEXT = "Please fill mandatory fields";
  static const UPLOAD_SOCIETY_DUES_ERROR = "Please upload society dues";
  static const SELECT_FEES_TYPE_ERROR_TEXT = "Please select fees type";
  static const UPLOAD_SOCIETY_DUES_BTN_TEXT = "Submit";

  // Manage Notice

  static const NOTICE_HEADER_TEXT = "Manage Noticeboard";

// My Visitors
  static const MY_VISITORS_HEADER = "My Visitors";
  static const NO_VISITORS_TEXT = "There are no visitors";

// Society Dues
  static const SOCIETY_DUES_HEADER = "Society Dues";

  //Admin Vehicle management

  static const DELETE_VEHICLE_CONFIRM_TEXT =
      "Are you sure, you want to delete the vehicle(s)?";
  static const DELETE_VEHICLE_OK_TEXT = "Ok";

  // Adimn VotePoll
  static const ADMIN_POLL_HEADER_TEXT = "Polls";

  static const ADMIN_SCHEDULED_POLL_HEADER_TEXT = "Scheduled";
  static const ADMIN_ACTIVE_POLL_HEADER_TEXT = "Active";
  static const ADMIN_HISTORICAL_POLL_HEADER_TEXT = "Historical";

  static const NO_HISTORICAL_POLL_TEXT = "There are no historical polls";
  static const DELETE_POLL_CONFIRM_TEXT = "Are you sure, you want to delete?";
  static const NO_SCHEDULED_POLL_TEXT = "There are scheduled no polls";
  static const SELECT_POLL_WARNING_TEXT = "Please select a polls";
  static const POLL_DELETE_BUTTON_TEXT = "Delete";
  static const POLL_EDIT_BUTTON_TEXT = "Edit";
  static const POLL_UPDATE_BUTTON_TEXT = "Update";
  static const DELETE_POLL_OK_TEXT = "Ok";
  static const DELETE_POLL_CANCEL_TEXT = "Cancel";

  static const CREATE_POLL_HEADER = "Create Poll";
  static const CREATE_POLL_BUTTON_TEXT = "Create Poll";
  static const POLLONS_OPTIONS_LABEL_TEXT = "Polling Options";
  static const SELECT_DATE_WARNING_TEXT = "Please select date.";
  static const PURPOSE_LABEL_TEXT = "Purpose for poll";
  static const PURPOSE_HINT_TEXT = "Enter Purpose for this poll";
  static const POLL_PURPOSE_ERROR_TEXT =
      "Please enter the purpose for the poll";
  static const POLL_END_TIME_HINT_TEXT = "Poll End Time";
  static const VALIED_POLL_DATE = "Please select valid poll date";

  static const POLL_START_TIME_HINT_TEXT = "Poll Start Time";
  static const POLL_START_TIME_ERROR_TEXT1 = "Poll Start Time can't be empty.";
  static const POLL_START_TIME_ERROR_TEXT =
      "Poll Start Time should be before Poll End Time.";
  static const POLL_END_TIME_ERROR_TEXT1 = "Poll End Time can't be empty.";
  static const POLL_END_TIME_ERROR_TEXT =
      "Poll End Time should be after Poll Start Time.";
  static const MANDATORY_WARNING_TEXT = "Please fill all mandatory fields";
  static const MINIMUM_TWO_POLL_WARNING_TEXT =
      "Please add minimum two options \nto create a poll";
  static const EDIT_MINIMUM_TWO_POLL_TEXT =
      "Poll must have atleast two options";
  static const DELETE_MINIMUM_TWO_POLL_TEXT =
      "Poll must have at least 2 options. Create a new option before deleting.";

  // static const END_DATE = "End Date";
  static const EDIT_POLL_HEADER = "Edit Poll";

  // Verify Password

  static const VERIFY_PASSWORD_HEADER = "Change Password";
  static const CURRENT_PASSWORD_TEXT = "Enter Current Password";
  static const CURRENT_PASSWORD_HINT = "Current Password";
  static const CURRENT_PASSWORD_ERROR = "Password cannot be empty";
  static const CURRENT_PASSWORD_ERROR_1 = "Please enter current password";

  static const NEW_PASSWORD_TEXT = "Enter New Password";
  static const NEW_PASSWORD_HINT = "New Password";
  static const NEW_PASSWORD_ERROR = "Password cannot be empty";
  static const NEW_PASSWORD_LENGTH_ERROR =
      "Password should contain minimum 6 characters";
  static const NEW_PASSWORD_ERROR_1 = "Please enter new password";

  static const CONFIRM_PASSWORD_TEXT = "Enter Confirm Password";
  static const CONFIRM_PASSWORD_HINT = "Confirm Password";

  // static const CONFIRM_PASSWORD_ERROR ="password cannot be empty";
  static const CONFIRM_PASSWORD_LENGTH_ERROR = "Must be matched with password";

// Add Family Member

  static const ADD_FAMILY_HEADER = "Add Family Member";
  static const FAMILY_NAME_TEXT = "Name";
  static const FAMILY_NAME_ERROR_TEXT = "Name is required";
  static const FAMILY_NAME_ERROR_TEXT_1 = "Should be valid name";

  static const FAMILY_AGE_TEXT = "Age";
  static const FAMILY_AGE_ERROR_TEXT = "Age is required";

  static const FAMILY_RELATION_TEXT = "Relation";
  static const SELECT_RELATION_TEXT = "Select Relation";

  static const FAMILY_GENDER_TEXT = "Gender";
  static const SELECT_GENDER_TEXT = "Select Gender";

  static const FAMILY_MOBILE_TEXT = "Mobile";
  static const FAMILE_MOBILE_ERROR_TEXT = "Invalid mobile number";

  static const FAMILY_EMAIL_TEXT = "Email";
  static const FAMILE_EMAIL_ERROR_TEXT = "Please enter valid email";
  static const SUBMIT_FAMILY_BUTTON_TEXT = "Add Family Member";

  static const NO_FAMILY_CHANGE_DETECTED =
      "No changes detected in family member profile";
  static const UPDATE_FAMIILY_BUTTON_TEXT = "Update";
  static const CANCEL_FAMIILY_BUTTON_TEXT = "Cancel";
  static const EDIT_FAMILY_HEADER = "Edit Family Member";

  static const VIEW_FAMILY_MEMBER_HEADER = "View Family Member";
  static const FAMILY_EDIT_BUTTON_TEXT = "Edit";
  static const NO_FMAILY_MEMBER_TEXT = "There are no family member";

  static const SELECT_FAMILY_MEMBER_TEXT =
      "Please select family members to delete";
  static const DELETE_FAMILY_MEMBER_TEXT =
      "Are you sure, you want to delete the family member(s)?";

  //Share OTP

  static const SHARE_OTP_HEADER = "Share OTP";
  static const SHARE_BUTTION_TEXT = "Share";
  static const SHARTE_TO_SECURITY_TEXT = "Show this OTP to Security at gate";
  static const SHARE_OTP_OR_TEXT = "──── OR ─────";

// MESSAGE LIST

  static const MESSAGE_LIST_HEADER = "Messages";
  static const NO_MESSAGES_TEXT = "No messages";

  static const REJECT_WARNING_TEXT =
      "Are you sure, Do you want to reject the guest?";

  //Resident Book Amenity

  static const BOOK_AMENITY_HEADER = "Book Facility";
  static const FACILITY_TYPE_HINT_TEXT = "Select facility type";
  static const FACILITY_START_TIME_HINT_TEXT = "Facility Start Time";
  static const FACILITY_END_TIME_HINT_TEXT = "Facility End Time";
  static const CALCULATED_TEXT = "Calculated Price";
  static const CALCULATED_TEXT_HINT_TEXT = "Calculated price";
  static const FACILITY_START_TIME_ERROR_TEXT =
      "Facility Start Time should be before Facility End Time.";
  static const FACILITY_SUBIMT_BUTTON_TEXT ="Save";
  static const FACILITY_TYPE_ERROR_TEXT = "Please select any facility type";

  // Issues

  static const RAISE_ISSUE_HEADER = "Raise Issue";
  static const ISSUE_CATAGORY_LABEL = "Category";
  static const ISSUE_SELECT_CATAGORY_TEXT = "Select Category";

  static const ISSUE_SELECT_PRIORITY_TEXT = "Select Priority";
  static const SELECT_CATAGORY_ERROR_TEXT = "Please select any category";

  static const SELECT_PRIORITY_ERROR_TEXT = "Please select any priority";
  static const ISSUE_PRIORITY_TEXT = "Priority";

  static const ISSSUE_DESCRIPTION_TEXT = "Description";
  static const ISSUE_DESCRIPTION_PLASCEHOLDER = "Enter Issue Description";
  static const ISSUE_DESCRIPTION_ERROR_TEXT =
      "Description name cannot be empty";
  static const UPLOAD_ISSUE_IMAGE_TEXT = "Upload Image ";
  static const REOPEN_ISSUE_BUTTON_TEXT = "Reopen";

  static const REOPEN_ISSUE_POP_UP_TEXT = "Reopen Issue";
  static const ISSUE_DESCRIPTION_ERROR_TEXT1 =
      "Description should be at-least 5 letters";
  static const ISSUE_SUBMIT_BUTTON_TEXT = "Submit";

  //
  static const PRE_APPROVE_GUEST_HEADER = "Pre-approve Guest";

//Security Visitor list

  static const CURRENT_VISITOR_TAB = "Current";
  static const PAST_VISITOR_TAB = "Past";
  static const REJECTED_VISITOR_TAB = "Rejected";
  static const PPR_APPROVE_ENTRIES_HEADER = "Pre-approval Entries";

  static const SCAN_QR_TEXT = "Scan QR code";
  static const VERIFY_QR_TEXT = "Verify";
  static const VERIFY_QR_ERROR_TEXT = "Entered passcode must contain 5 digits";

// Register Visitor

  static const REGISTER_VISITOR_HEADER = "Register Visitor";
  static const VISITOR_MOBILE = "Mobile";
  static const VISITOR_MOBILE_HINT = "Enter Mobile Number";
  static const VISITOR_MOBILE_ERROR_TEXT = "Invalid mobile number";
  static const VISITOR_MOBILE_ERROR_TEXT1 = "Mobile number is required";

  static const VISITOR_NAME_TEXT = "Visitor Name";
  static const VISITOR_NAME_HINT = " Enter Visitor Name";
  static const VISITOR_NAME_ERROR_TEXT = "Should be Valid Name";

  static const VISITOR_PURPOSE_TEXT = "Purpose to Meet";
  static const VISITOR_PURPOSE_HINT = "Select Purpose";

  static const OTHER_PURPOSE = "Others";
  static const OTHER_PURPOSE_TEXT = "Other Purpose";
  static const OTHER_PURPOSE_HINT = " Enter the purpose";
  static const BLOCK_TEXT = "Block Name";
  static const BLOCK_TEXT_PLACEHOLDER = "Select Block";
  static const FLAT_TEXT = "Flat Number";
  static const FLAT_TEXT_PLACEHOLDER = "Select Flat";
  static const RESIDENT_NAME = "Resident Name";
  static const NUMBER_OF_GUEST_TEXT = "Number of guest";
  static const REGISTER_VISITOR_BUTTON_TEXT = "Notify To Resident";

  static const CHECK_OUT_SEARCH_HEADER = "Search by Name, Phone, Purpose...";
  static const SCAN_VEHILCE_HEADER = "Get Vehicle Details";
  static const SCAN_VEHICLE_TITLE = "Click here to scan vehicle";
  static const VEHICLE_ALLOW_TEXT = "Allow";

  static const PROFILE_HEADER = "Profile";
  static const MY_FAMALY_HEADER = "My family members";
  static const MY_VEHICLE_HEADER = "My vehicle details";

  //Login
  static const EMAIL_PLACEHOLDER = "Your Email address";
  static const EMAIL_ERROR_TEXT = "Email id is required";
  static const PASSWORD_ERROR_TEXT = "Password is required";
  static const LOGOUT_CONFIRM = "Confirm";
  static const LOGIN_TEXT = "Login";
  static const FIRST_TIME_USER_TEXT = "First time User, please click";
  static const DROPDOWN_RESIDENT_NAME = "Resident";

// Verify Email

  static const VERIFY_ACCPUNT_TEXT = "Verify your Account";
  static const CHOOSE_APARTMENT_TEXT = " Choose Apartment ";
  static const CHOOSE_APARTMENT_PLACEHOLDER = "Select Apartment";
  static const VERIFY_EMAIL_TEXT = "Verify";
  static const NOT_VALID_USER_TEXT =
      "You are not a valid user,\ndo you want to register?";
  static const ENTER_OTP_CODE = "Please enter the OTP code";

  // Forgot password
  static const RESET_PASSWORD_LABEL_TEXT = "Reset Password";
  static const VERIFY_TEXT = "Verify";
  static const PASSWORD_NOT_MATCHED = "Password does not match";
  static const CONFIRM_PASSWORD_ERROR_TEXT = "Must be Matched With Password.";
  static const OTP_ERROR_MESSAGE = "Please enter otp";

  static const GLOBAL_SEARCH_NAME_LABEL = "Name : ";
  static const GLOBAL_SEARCH_BLOCK_LABEL = "Block : ";
  static const GLOBAL_SEARCH_FLOOR_LABEL = "Floor : ";
  static const GLOBAL_SEARCH_FLAT_LABEL = "Flat : ";

  //regex
  static final EMOJI_DENY_REGEX = RegExp(
      r'[\u{1F600}-\u{1F64F}]'
      r'|[\u{1F300}-\u{1F5FF}]' // Misc Symbols and Pictographs
      r'|[\u{1F680}-\u{1F6FF}]' // Transport and Map
      r'|[\u{1F700}-\u{1F77F}]' // Alchemical Symbols
      r'|[\u{1F780}-\u{1F7FF}]' // Geometric Shapes Extended
      r'|[\u{1F800}-\u{1F8FF}]' // Supplemental Arrows-C
      r'|[\u{1F900}-\u{1F9FF}]' // Supplemental Symbols and Pictographs
      r'|[\u{1FA00}-\u{1FA6F}]' // Chess Symbols
      r'|[\u{1FA70}-\u{1FAFF}]' // Symbols and Pictographs Extended-A
      r'|[\u{2600}-\u{26FF}]' // Miscellaneous Symbols
      r'|[\u{2700}-\u{27BF}]' // Dingbats
      r'|[\u{1F900}-\u{1F9FF}]' // Supplemental Symbols and Pictographs
      r'|[\u{1FA70}-\u{1FAFF}]' // Symbols and Pictographs Extended-A
      r'|[\u{1F000}-\u{1F02F}]', // Mahjong Tiles
      unicode: true,
      caseSensitive: false);

// Drawer
}
