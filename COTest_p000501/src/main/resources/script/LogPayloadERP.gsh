import com.sap.gateway.ip.core.customdev.util.Message;
import java.util.HashMap;
import java.lang.Exception;

def Message processData(Message message) {

	def pmap = message.getProperties();
	String enableLogging = pmap.get("ENABLE_LOGGING");
	String processVariant = pmap.get("PROCESS_VARIANT");
	
	if(enableLogging != null && enableLogging.toUpperCase().equals("TRUE")){
		def body = message.getBody(java.lang.String) as String;
		def messageLog = messageLogFactory.getMessageLog(message);
		if(messageLog != null){
			if(processVariant != null && processVariant.equals("1")){
				messageLog.addAttachmentAsString("ERP Inbound (Last Modified Date)", body, "text/xml");
			}else if(processVariant != null && processVariant.equals("2")){
				messageLog.addAttachmentAsString("ERP Inbound (Monitor)", body, "text/xml");
			}else{
				throw new Exception("process_variant property undefined");
			}
		}
	}
       
	return message;
}