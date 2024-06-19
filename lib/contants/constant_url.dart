class Constant {
  //Local Server
 static const String baseUrl = "https://13.200.195.199:8082/";

   // static const String baseUrl = "https://192.168.1.10:8082/";



  //AWS Server
  // static const String baseUrl =
  //     "https://ec2-13-235-242-118.ap-south-1.compute.amazonaws.com:8082/";

  // //AWS Server new
  // static const String baseUrl =
  //     "https://ec2-13-234-113-151.ap-south-1.compute.amazonaws.com:8082/";
  //Aws Server new
  // static const String baseUrl =
  //    "https://ec2-3-6-91-225.ap-south-1.compute.amazonaws.com:8082/";

  static const String loginURL = "smp/auth/login";
  static const String verifyEmailURL = "smp/auth/sendOtpThroughEmail";
  static const String verifyEmailOtpURL = "smp/auth/sendOtpForForgotPassword";
  static const String verifyForgetURL = "smp/auth/forgotPassword";
  static const String verifyOtpURL = "smp/auth/otpValidationForRegistration";
  static const String verifyResidentURL =
      "smp/auth/verifyTheUserByOtpValidation";

  static const String resetPasswordURL = "smp/auth/resetPassword";

  static const String apartmentListURL =
      "smp/appartment/getAllApartmentByAdmin";
  static const String getAllFeesTypeURL = "smp/admin/getAllFeesType";
  static const String apartmentURL = "smp/appartment/getallappartment";
  static const String logOutURL = "smp/auth/logout";

  static const String logingLogOutURL =
      "smp/auth/allowLoginWithNewDeviceAndLogoutFromOtherDevices";

  static const String goodInventoryURL = 'smp/admin/findGoodsBetweenDate';
  static const String getAllGoodsByAdmin = 'smp/admin/getAllGoodsByAdmin';
  static const String addInventory = "smp/admin/addGoodsInInventry";
  static const String globalSearchURL = "smp/admin/globalSearchForApartment";
  static const String teamMemberURL = "smp/user/getAllTheManagmentTeam";
  static const String waitingVisitorsURL =
      "smp/security/getAllTheWaitVisitorList";
  static const String allOwnerURL = "smp/user/allUserByRole?role=Owner";

  static const String allFlatOwnerURL = "smp/user/getAllFlatOfApartment";

  static const String allOwnerForApartmentURL = "smp/user/getAllTheOwnerForApartment";
  static const String  updatePreApproveGuestURL = "smp/resident/editPreapprovedGuest?";




  static const String visitorsListURL =
      "smp/security/getAllApprovedVisitorAndGuestBySecurity";

  static const String updateCheckedURL = "smp/security/updateCheckedOut";

  static const String blockListURL = "smp/admin/allBlockByApartmentId";
  static const String allFloorAndFlatsByBlockIdUrl =
      "smp/backend/AllFloorsByApartmentIdAndBlockId";
  static const String flatListURL = "smp/backend/backendAllFlats";
  static const String notificationURL = "smp/user/getAllValidNotice";

  static const String getAllResidentPaymentURL =
      "smp/resident/getAllThePaymentDetailsOfResident";
  static const String uploadMonthlyMaintenanceURL =
      "smp/admin/uploadMonthlyMaintenanceFee";

  static const String createNoticesURL = "smp/admin/sendNoticeToAllUser";
  static const String editNoticesURL = "smp/admin/editExistingNotice";
  static const String deleteNoticesURL = "smp/admin/deleteMultipleNotices";
  static const String securityListURL = "smp/admin/getAllSecurity";

  static const String resolvedIssueURL =
      "smp/resident/getAllTheIssuesByStatusAndPriority";
  static const String getAllIssueByURL = "smp/admin/getAllIssueReport";
  static const String getAllIssueByAdminURL =
      "smp/admin/getAllIssueUsingStatusByAdmin";
  static const String updateIssueStatueURL = "smp/admin/updateIssueStatus";
  static const String exportIssueURL = "smp/admin/ExportComplainExcel";
  static const String getAllIssueURL = "smp/admin/getAllIssueReport";
  static const String getAllIssueByResidentURL =
      "smp/resident/allIssueByResident";
  static const String getAllIssueByStatusURL =
      "smp/admin/getAllIssueUsingStatusByAdmin";
  static const String raiseIssueURL = "smp/resident/RegisterIssue";


  static const String addVehicleURL = "smp/vehicle/addVehicleByResident";
  // https://localhost:8082/smp/vehicle/addVehicleByResident?apartmentId=6
  static const String editVehicleURL = "smp/vehicle/updateVehicleByresident";
  // https://localhost:8082/smp/vehicle/updateVehicleByresident?vehicleId=1
  static const String deleteVehicleURL = "smp/vehicle/deleteMultipleVehicle";

  // https://localhost:8082/smp/vehicle/deleteMultipleVehicle?vehicleIdList=1,2

  static const String getVehicleListURL = "smp/vehicle/getAllVehiclesOfUser";





  // https://localhost:8082/smp/vehicle/addVehicleByResident?apartmentId=6



  static const String residentPendingIssueURL =
      "smp/resident/allIssueByResident";
  static const String issuesCountURL = "smp/admin/countOpenIssueByAdmin";


  static const String residentActivePollURL = "smp/resident/getAllActiveVotePoll";

  static const String historicalPollURL = "smp/admin/historicalVotePollByAdmin";
  static const String scheduledPollURL = "smp/admin/getAllScheduleVotePoll";

  static const String activeAdminPollURL = "smp/admin/allActiveVotePollByAdmin";

  static const String catagoryListURL = "smp/user/getAllCategory";
  static const String priorityListURL = "smp/user/getAllPriority";
  static const String allDeviceIdURL = "smp/user/getAllTokenByApartmentId";

  static const String allwaitingVisitorsURL =
      "smp/resident/getAllWaitingVisitorByUserId";



  static const String approveRejectVisitorFromPushURL =
      "smp/resident/changeStatusForVisitor";

  static const String approveRejectVisitorURL =
      "smp/resident/changeStatusForVisitor";

  static const String allTypeOfVisitorsURL =
      "smp/resident/getAllTypeOfVisitorByStatus";

  static const String allWrongEntryURL = "smp/security/getAllWrongEntryUser";

  static const String allApprovedEntryURL =
      "smp/security/getAllApprovedVisitorAndGuestBySecurity";
  static const String allInOutEntryURL =
      "smp/resident/getAllInOutVisitorOfFlat";

  static const String allCheckOutVisitorsURL =
      "smp/security/getAllCheckedOutUser";


  static const String allRejectedVisitorsURL =
      "smp/security/getAllRejectUserForSecurity";

  static const String waitingUserForApprovalURL =
      "smp/admin/waitingUserForApproval";
  static const String pastApprovalURL =
      "smp/admin/getAllTheApprovalListOfApartment";


  static const String approvedRejectURL =
      "smp/admin/approveTheResidentOrTanent";

  static const String wrongEntryURL = "smp/resident/addVisitorToWrongEntry";
  static const String cancelEntryURL = "smp/resident/cancleThePreApprovedGuest";

  static const String reOpenIssueURL = "smp/resident/reopenTheIssue";

  static const String getAllManagementRoleURL =
      "smp/user/getAllSocietManagementRole";
 static const String getSlotNumberURL =
     "smp/parkinglots/getSlotNumbersByApartmentId";
  static const String getAllPriorityRoleURL =
      "smp/user/getAllPriority";
  static const String getAllStaffRoleURL = "smp/admin/getAllStaffTeamByAdmin";
  static const String viewFamilyURL = "smp/user/profileDetailsOfUser";

  static const String updateShiftTimeURL = "smp/admin/updateShift";
  static const String deleteSecurityURL = "smp/admin/deleteSecurity";
  static const String deleteMultipleSecurityURL =
      "smp/admin/deleteMultipleSecurityByAdmin";

  static const String deleteMemberURL = "smp/user/deleteMultipleMember";

  static const String getAllGuestURL = "smp/admin/allGusetListByAdmin";
  static const String addTeamMemberCountURL = "smp/user/addMangmentTeamByAdmin";

  static const String assingTaskToStaffURL =
      "smp/admin/assignTheTaskToStaffTeam";

  static const String sendNotificationForApprovalUrl =
      "smp/auth/sendNotificationToAdminForApproval";

  static const String getChatMessageURL = "smp/user/getMessagesForUserEndToEnd";
  static const String postChatMessageURL = "smp/user/sendMessage";

  static const String getWaitingVisitorsURL =
      "smp/security/getAllTheWaitVisitorList";
  static const String getWaitingVisitorsURL1 =
      "smp/security/getAllWaitingVisitors";
  static const String getWaitingVisitorsByIdURL =
      "smp/resident/getAllWaitingVisitorByUserId";
  static const String getActivePollsURL = "smp/resident/getAllActiveVotePoll";
  static const String getAdminActivePollsURL =
      "smp/admin/allActiveVotePollByAdmin";
  static const String getSchrduldPollsURL = "smp/admin/getAllScheduleVotePoll";
  static const String getPercentageURL = "smp/resident/getPercentageOfVote";

  static const String getVotingPollsURL = "smp/admin/getAllVotingPoll";
  static const String getAdminHistoricalPollsURL =
      "smp/admin/historicalVotePollByAdmin";
  static const String getUserURL = "smp/user/allOwner";
  static const String findGoodsURL = "smp/admin/findGoodsBetweenDate";
  static const String getAllFlatsURL = "smp/backend/backendAllFlats";
  static const String getAllFloorsURL = "smp/backend/backendAllFloors";
  static const String getAllInactiveflatURL = "smp/admin/getAllInactiveflat";
  static const String getAllBlockByApartmentURL =
      "smp/admin/allBlockByApartmentId";
  static const String getUserProfileURL = "smp/user/getUserById";
  static const String getChatMessageURL1 = "smp/user/getAllSenderDetails";

  static const String addGuestURL = "smp/resident/addGuestByResident";
  static const String addSecurityURL = "smp/admin/securityRegister";
  static const String registerTenantURL = "smp/auth/residentAndTenantSignUp";
  static const String updateUserURL = "smp/user/updateprofile";
  static const String updateSecurityURL = "smp/admin/updateSecurity";

  static const String excelUploadUrl = "smp/user/excelUpload";

  static const String qrUploadUrl = "smp/admin/updatePaymentdetailsOfApartment";

  static const String addVoteByOwnerURL = "smp/resident/addVoteByOwner";
  static const String editVoteByOwnerURL = "smp/resident/editVoteByResident";

  static const String addFamilyURL = "smp/resident/addMemberByResident";

  static const String updateFamilyURL = "smp/resident/updateFamilyMamberByResident";

  static const String deleteFamilyURL = "smp/resident/deleteMultipleFamilyMember";

  static const String deleteFamilyMember='smp/resident/deleteMultipleFamilyMember';

  static const String addVisitorURL = "smp/security/registerVisitorBySecurity";

  static const String pushNotificationURL =
      "smp/auth/sentSOSToAllUser";

  static const String approveBySecurityURL = "smp/security/approvedBySecurity";

  static const String addVotePollURL = "smp/admin/addVotePoll";
  static const String editVotePollURL = "smp/admin/updateScheduledVotePoll";

  static const String deletePollOptionURL = "smp/admin/deleteVotePollOptionByAdmin";

  static const String deletePollURL = "smp/admin/deleteScheduleVotePoll";
  static const String deleteMultiplePollURL =
      "smp/admin/deleteSelectedVotePolls";
}
