import com.sap.gateway.ip.core.customdev.util.Message;
import java.util.HashMap;

def Message processData(Message message) {

    //get url
    def map = message.getHeaders();
    def url = map.get("CamelHttpPath");

    if (url != null) {
    //split url
        String[] vUrl;
        vUrl = url.split('/');
    //set properties
        for (int i=0; i<vUrl.length; i++) {
            message.setProperty("path_"+i, vUrl[i]);
        }
    }
    return message;
}