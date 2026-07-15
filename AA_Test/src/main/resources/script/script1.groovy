import com.sap.gateway.ip.core.customdev.util.Message
import com.sap.it.api.ITApiFactory
import com.sap.it.api.securestore.SecureStoreService
import com.sap.it.api.securestore.UserCredential
import groovy.json.JsonSlurper
import groovy.json.JsonBuilder
import java.net.URLDecoder

def Message processData(Message message) {
    def headers = message.getHeaders()
    
    // 1. Fetch the raw query parameters from the CamelHttpQuery header
    String httpQuery = headers.get("CamelHttpQuery")
    if (!httpQuery) {
        throw new Exception("Missing HTTP query parameters from GitHub callback.")
    }

    // 2. Parse the key-value pairs from the query string
    def queryParams = [:]
    httpQuery.split("&").each { param ->
        def pair = param.split("=")
        if (pair.length == 2) {
            // URL decode keys/values to handle special character encodings safely
            String key = URLDecoder.decode(pair[0], "UTF-8")
            String value = URLDecoder.decode(pair[1], "UTF-8")
            queryParams[key] = value
        }
    }

    String code = queryParams.get("code")
    String state = queryParams.get("state")

    if (!code) {
        throw new Exception("Authorization code was not found in CamelHttpQuery.")
    }

    // 3. Optional: Validate state if you passed a session state cookie earlier
    // (Helps protect your tenant endpoint from CSRF injection)

    // 4. Retrieve Client ID and Client Secret from CPI Security Material
    def secureStoreService = ITApiFactory.getService(SecureStoreService.class, null)
    UserCredential credential = secureStoreService.getUserCredential("GITHUB_APP_SECRET")
    def clientId = credential.getUsername()
    def clientSecret = new String(credential.getPassword())

    // 5. Build the JSON payload for GitHub
    def payloadMap = [
        client_id    : clientId,
        client_secret: clientSecret,
        code         : code
    ]
    def payloadJson = new JsonBuilder(payloadMap).toString()

    // 6. Send POST request to exchange provisional code for active access tokens
    URL url = new URL("https://github.com/login/oauth/access_token")
    HttpURLConnection conn = (HttpURLConnection) url.openConnection()
    conn.setRequestMethod("POST")
    conn.setDoOutput(true)
    conn.setRequestProperty("Content-Type", "application/json")
    conn.setRequestProperty("Accept", "application/json")

    conn.getOutputStream().write(payloadJson.getBytes("UTF-8"))

    // 7. Parse response and store tokens
    if (conn.getResponseCode() == 200) {
        def responseText = conn.getInputStream().getText("UTF-8")
        def json = new JsonSlurper().parseText(responseText)
        
        if (json.access_token) {
            // Write to properties so your next pipeline component (like Write Variables) can grab them
            message.setProperty("GitHub_AccessToken", json.access_token)
            message.setProperty("GitHub_RefreshToken", json.refresh_token)
            message.setProperty("GitHub_ExpiresIn", json.expires_in)
            
            message.setBody("Authentication successful! You can now close this tab.")
        } else {
            throw new Exception("GitHub returned response, but access_token was absent: " + responseText)
        }
    } else {
        def errorText = conn.getErrorStream().getText("UTF-8")
        throw new Exception("GitHub Token exchange dropped with HTTP code " + conn.getResponseCode() + ": " + errorText)
    }

    return message
}