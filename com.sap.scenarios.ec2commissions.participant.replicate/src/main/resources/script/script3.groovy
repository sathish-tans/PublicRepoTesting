
import com.sap.gateway.ip.core.customdev.util.Message;
import java.util.HashMap;

def Message processData(Message message) {

def pmap = message.getProperties();
def messageLog = messageLogFactory.getMessageLog(message);

String lastExecutionTimestamp = pmap.get("p_LastExecutionTimestamp");
String fullTransmissionStartDate = pmap.get("p_ExecutionTimestamp");


if (lastExecutionTimestamp == null || lastExecutionTimestamp.equals("") || lastExecutionTimestamp.equals("null")){		
		lastExecutionTimestamp = fullTransmissionStartDate;
		}
	
if (lastExecutionTimestamp == null || lastExecutionTimestamp.equals("") || lastExecutionTimestamp.equals("null") || lastExecutionTimestamp.length() < 24){
	throw new Exception("Configuration Error: Please enter a valid value for P_TRANSMISSION_START_DATE in the format: yyyy-MM-dd'T'HH:mm:ss.SSS'Z'.");
}
else{
if(messageLog != null){
  				messageLog.setStringProperty("ODATA Execution Timestamp: ", lastExecutionTimestamp);
  			}
}	

message.setProperty("p_ExecutionTimestamp", lastExecutionTimestamp);
	return message;
}

