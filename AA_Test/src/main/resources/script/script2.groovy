import com.sap.gateway.ip.core.customdev.util.Message
import com.sap.it.api.ITApiFactory
import com.sap.it.api.securestore.SecureStoreService
import com.sap.it.api.securestore.UserCredential
import groovy.json.JsonSlurper
import groovy.json.JsonBuilder

def Message processData(Message message) {
    // 1. Retrieve the existing Refresh Token (typically stored in a CPI Write Variables step or DB)
    def properties = message.getProperties()
    String currentRefreshToken = properties.get("GitHub_RefreshToken")

    if (!currentRefreshToken) {
        throw new Exception("No refresh token found. User must re-authenticate.")
    }

    // 2. Fetch Client ID & Secret
    def secureStoreService = ITApiFactory.getService(SecureStoreService.class, null)
    UserCredential credential = secureStoreService.getUserCredential("GITHUB_APP_SECRET")
    def clientId = credential.getUsername()
    def clientSecret = new String(credential.getPassword())

    // 3. Construct payload for refreshing
    def payloadMap = [
        client_id: clientId,
        client_secret: clientSecret,
        grant_type: "refresh_token",
        refresh_token: currentRefreshToken
    ]
    def payloadJson = new JsonBuilder(payloadMap).toString()

    // 4. POST to GitHub
    URL url = new URL("https://github.com/login/oauth/access_token")
    HttpURLConnection conn = (HttpURLConnection) url.openConnection()
    conn.setRequestMethod("POST")
    conn.setDoOutput(true)
    conn.setRequestProperty("Content-Type", "application/json")
    conn.setRequestProperty("Accept", "application/json")

    conn.getOutputStream().write(payloadJson.getBytes("UTF-8"))

    if (conn.getResponseCode() == 200) {
        def responseText = conn.getInputStream().getText("UTF-8")
        def json = new JsonSlurper().parseText(responseText)

        // Store NEW token pairs (Remember, the refresh token also rotates!)
        message.setProperty("GitHub_AccessToken", json.access_token)
        message.setProperty("GitHub_RefreshToken", json.refresh_token)
    } else {
        throw new Exception("Failed to refresh GitHub Token.")
    }

    return message
}