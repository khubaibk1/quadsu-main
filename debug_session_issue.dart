// Add this debug code to your session_screen.dart initState method
// to check authentication and API response

@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback(
    (timeStamp) async {
      // Debug: Check authentication
      print("DEBUG: User Token: $userToken");
      print("DEBUG: User Type: $usertype");
      
      SessionsProvider sessionsProvider =
          Provider.of<SessionsProvider>(context, listen: false);

      // Debug: Check API URL
      String apiUrl = usertype == UserType.student
          ? ApiUrls.getSessionsStudent
          : ApiUrls.getSessionsGuide;
      print("DEBUG: API URL: $apiUrl");

      sessionsProvider.allSessionsOffset = 1;
      await sessionsProvider.getSession(sessionStatus: SessionStatus.all);
      
      // Debug: Check response
      print("DEBUG: All Sessions Count: ${sessionsProvider.allSessions.length}");
      print("DEBUG: All Sessions Model: ${sessionsProvider.allSessionsModel}");
      
      // Continue with other session types...
    },
  );
}