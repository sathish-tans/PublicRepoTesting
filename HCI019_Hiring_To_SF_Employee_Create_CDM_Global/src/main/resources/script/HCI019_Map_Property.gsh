import com.sap.it.api.mapping.*

def String getProperty(String property,MappingContext context)
 {
 	String propVal = context.getProperty(property);
  	propVal = propVal.toString();
  	return propVal;
 } 