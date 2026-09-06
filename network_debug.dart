// Add this to test network connectivity and API response
// You can add this as a temporary button in your session screen

Future<void> testNetworkAndAPI() async {
  try {
    // Test basic connectivity
    print("DEBUG: Testing network connectivity...");
    
    // Test API endpoint
    var response = await http.get(
      Uri.parse('https://quadsu.com/api/get-all-student-session?page=1&sessionStatus=0'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userToken',
      },
    );
    
    print("DEBUG: Response Status Code: ${response.statusCode}");
    print("DEBUG: Response Body: ${response.body}");
    
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      print("DEBUG: Parsed JSON: $jsonData");
    } else if (response.statusCode == 401) {
      print("ERROR: Unauthorized - Check user token");
    } else if (response.statusCode == 404) {
      print("ERROR: API endpoint not found");
    } else {
      print("ERROR: HTTP ${response.statusCode} - ${response.reasonPhrase}");
    }
    
  } catch (e) {
    print("ERROR: Network test failed - $e");
    if (e.toString().contains('Failed host lookup')) {
      print("ERROR: No internet connection or server unreachable");
    }
  }
}