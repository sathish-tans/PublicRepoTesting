/*
 * The integration developer needs to create the method processData 
 * This method takes Message object of package com.sap.gateway.ip.core.customdev.util
 * which includes helper methods useful for the content developer:
 * 
 * The methods available are:
    public java.lang.Object getBody()

    //This method helps User to retrieve message body as specific type ( InputStream , String , byte[] ) - e.g. message.getBody(java.io.InputStream)
    public java.lang.Object getBody(java.lang.String fullyQualifiedClassName)

    public void setBody(java.lang.Object exchangeBody)

    public java.util.Map<java.lang.String,java.lang.Object> getHeaders()

    public void setHeaders(java.util.Map<java.lang.String,java.lang.Object> exchangeHeaders)

    public void setHeader(java.lang.String name, java.lang.Object value)

    public java.util.Map<java.lang.String,java.lang.Object> getProperties()

    public void setProperties(java.util.Map<java.lang.String,java.lang.Object> exchangeProperties) 

	public void setProperty(java.lang.String name, java.lang.Object value)
 * 
 */
import com.sap.gateway.ip.core.customdev.util.Message;
import org.jdom.Element;
import java.util.HashMap;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import groovy.xml.StreamingMarkupBuilder
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat
import java.util.HashMap;
import java.util.List;
import java.util.Scanner;
import org.jdom.Content;
import org.jdom.Document;
import org.jdom.Element
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;
import org.jdom.output.XMLOutputter
import org.jdom.output.Format
import org.jaxen.JaxenException;
import org.jaxen.SimpleNamespaceContext;
import org.jaxen.XPath;
import org.jaxen.jdom.JDOMXPath
import org.jdom.Namespace;

def Message processData(Message message) {

def picklist = message.getBody(String.class); // get the body which we need to parse

def map = message.getProperties();
def dataContext = message.getProperty("body");

// Build XML Document for picklist
SAXBuilder builderPicklist = new SAXBuilder();

// input Picklist xml doc
Document inputDocPicklist = builderPicklist.build(new StringReader(picklist));


// Build XML Document
SAXBuilder builder = new SAXBuilder();

// input xml doc
Document inputDoc = builder.build(new StringReader(dataContext));

String error = "X";

//select all emailInfo nodes
XPath xPathEmail = new JDOMXPath("//emailInfo/emailType");
List emailEntries =  xPathEmail.selectNodes(inputDoc);

// main loop over Email entries
for (Element emailEntry : emailEntries)
{

String externalCode = emailEntry.getText();

//select all Picklist nodes
XPath xPathPicklist = new JDOMXPath("//PicklistOption/PicklistOption/picklist/Picklist/picklistId");
List picklistEntries =  xPathPicklist.selectNodes(inputDocPicklist);
// Loop to compare the values
for (Element picklistEntry : picklistEntries)
{

// Check whether this is correct Picklist id
if (picklistEntry.getText() == 'ecEmailType')
{

// go to the parent node to get the picklist ids
Element parent = picklistEntry.getParent(); //Father = Picklist
Element parent1 = parent.getParent();       //GrandFather = picklist
Element parent2 = parent1.getParent();      //GGFather = PicklistOption
Element externalCodePicklist = parent2.getChild("externalCode");
String ec_picklist = externalCodePicklist.getText();
if ( externalCode == ec_picklist )
{
error = "";
emailEntry.setText(parent2.getChild("id").getText());
}
}
}

if (error != "")
{

message.setProperty("Status", "ERROR");
message.setHeader("Status", "ERROR");
String message2 = "The value" + " " + "'" + externalCode + "'" + " " + "for the picklist ecEmailType not found";
message.setProperty("Message", message2);
}
}

if (error != "")
{
// Do not process the rest of the nodes
}
else{

//select all phoneInfo nodes
XPath xPathPhone = new JDOMXPath("//phoneInfo/phoneType");
List phoneEntries =  xPathPhone.selectNodes(inputDoc);

// main loop over Phone entries
for (Element phoneEntry : phoneEntries)
{

String externalCodePhone = phoneEntry.getText();

//select all Picklist nodes
XPath xPathPicklist = new JDOMXPath("//PicklistOption/PicklistOption/picklist/Picklist/picklistId");
List picklistEntries =  xPathPicklist.selectNodes(inputDocPicklist);
error = "X";
// Loop to compare the values
for (Element picklistEntry : picklistEntries)
{
// Check whether this is correct Picklist id
if (picklistEntry.getText() == 'ecPhoneType')
{

// go to the parent node to get the picklist ids
Element parent = picklistEntry.getParent(); //Father = Picklist
Element parent1 = parent.getParent();       //GrandFather = picklist
Element parent2 = parent1.getParent();      //GGFather = PicklistOption
String ec_picklist = parent2.getChild("externalCode").getText();
if ( externalCodePhone == ec_picklist )
{
error = "";
phoneEntry.setText(parent2.getChild("id").getText());
}
}
}

if (error != "")
{
message.setProperty("Status", "ERROR");
message.setHeader("Status", "ERROR");
String message3 = "The value" + " " + "'" + externalCodePhone + "'" + " " + "for the picklist ecPhoneType not found";
message.setProperty("Message", message3);

}

}
}

if (error != "")
{
// Do not process the rest of the nodes
}
else{

//select personalInfo marital Status node
XPath xPathPersonalInfo = new JDOMXPath("//personalInfo/maritalStatus");
List personaInfoEntries =  xPathPersonalInfo.selectNodes(inputDoc);

// main loop over Personal Info entries
for (Element personaInfoEntry : personaInfoEntries)
{

String externalCodePerInfo = personaInfoEntry.getText();

//select all Picklist nodes
XPath xPathPicklist = new JDOMXPath("//PicklistOption/PicklistOption/picklist/Picklist/picklistId");
List picklistEntries =  xPathPicklist.selectNodes(inputDocPicklist);
error = "X";
// Loop to compare the values
for (Element picklistEntry : picklistEntries)
{
// Check whether this is correct Picklist id
if (picklistEntry.getText() == 'ecMaritalStatus')
{

// go to the parent node to get the picklist ids
Element parent = picklistEntry.getParent(); //Father = Picklist
Element parent1 = parent.getParent();       //GrandFather = picklist
Element parent2 = parent1.getParent();      //GGFather = PicklistOption
String ec_picklist = parent2.getChild("externalCode").getText();
if ( externalCodePerInfo == ec_picklist )
{
error = "";
personaInfoEntry.setText(parent2.getChild("id").getText());
}
}
}

if (error != "")
{
message.setProperty("Status", "ERROR");
message.setHeader("Status", "ERROR");
String message3 = "The value" + " " + "'" + externalCodePerInfo + "'" + " " + "for the picklist ecMaritalStatus not found";
message.setProperty("Message", message3);

}

}
}


if (error != "")
{
// Do not process the rest of the nodes
}
else{

//select personalInfo node nationality
XPath xPathPersonalInfo = new JDOMXPath("//personalInfo/nationality");
List personaInfoEntries =  xPathPersonalInfo.selectNodes(inputDoc);

// main loop over Personal Info entries
for (Element personaInfoEntry : personaInfoEntries)
{

String externalCodePerInfo = personaInfoEntry.getText();

//select all Picklist nodes
XPath xPathPicklist = new JDOMXPath("//PicklistOption/PicklistOption/picklist/Picklist/picklistId");
List picklistEntries =  xPathPicklist.selectNodes(inputDocPicklist);
error = "X";
// Loop to compare the values
for (Element picklistEntry : picklistEntries)
{
// Check whether this is correct Picklist id
if (picklistEntry.getText() == 'ISOCountryList')
{

// go to the parent node to get the picklist ids
Element parent = picklistEntry.getParent(); //Father = Picklist
Element parent1 = parent.getParent();       //GrandFather = picklist
Element parent2 = parent1.getParent();      //GGFather = PicklistOption
String ec_picklist = parent2.getChild("externalCode").getText();
if ( externalCodePerInfo == ec_picklist )
{
error = "";
//personaInfoEntry.setText(parent2.getChild("id").getText());
}
}
}

if (error != "")
{
message.setProperty("Status", "ERROR");
message.setHeader("Status", "ERROR");
String message3 = "The value" + " " + "'" + externalCodePerInfo + "'" + " " + "for the picklist ISOCountryList not found";
message.setProperty("Message", message3);

}

}
}

if (error != "")
{
// Do not process the rest of the nodes
}
else{
//select personalInfo node second nationality
XPath xPathPersonalInfo = new JDOMXPath("//personalInfo/secondNationality");
List personaInfoEntries =  xPathPersonalInfo.selectNodes(inputDoc);

// main loop over Personal Info entries
for (Element personaInfoEntry : personaInfoEntries)
{

String externalCodePerInfo = personaInfoEntry.getText();

//select all Picklist nodes
XPath xPathPicklist = new JDOMXPath("//PicklistOption/PicklistOption/picklist/Picklist/picklistId");
List picklistEntries =  xPathPicklist.selectNodes(inputDocPicklist);
error = "X";
// Loop to compare the values
for (Element picklistEntry : picklistEntries)
{
// Check whether this is correct Picklist id
if (picklistEntry.getText() == 'ISOCountryList')
{

// go to the parent node to get the picklist ids
Element parent = picklistEntry.getParent(); //Father = Picklist
Element parent1 = parent.getParent();       //GrandFather = picklist
Element parent2 = parent1.getParent();      //GGFather = PicklistOption
String ec_picklist = parent2.getChild("externalCode").getText();
if ( externalCodePerInfo == ec_picklist )
{
error = "";
//personaInfoEntry.setText(parent2.getChild("id").getText());
}
}
}

if (error != "")
{
message.setProperty("Status", "ERROR");
message.setHeader("Status", "ERROR");
String message3 = "The value" + " " + "'" + externalCodePerInfo + "'" + " " + "for the picklist ISOCountryList not found";
message.setProperty("Message", message3);

}

}
}



if (error != "")
{
// Do not process the rest of the nodes
}
else{

//select personalInfo node nativePreferredLang
XPath xPathPersonalInfo = new JDOMXPath("//personalInfo/nativePreferredLang");
List personaInfoEntries =  xPathPersonalInfo.selectNodes(inputDoc);

// main loop over Personal Info entries
for (Element personaInfoEntry : personaInfoEntries)
{

String externalCodePerInfo = personaInfoEntry.getText();

//select all Picklist nodes
XPath xPathPicklist = new JDOMXPath("//PicklistOption/PicklistOption/picklist/Picklist/picklistId");
List picklistEntries =  xPathPicklist.selectNodes(inputDocPicklist);
error = "X";
// Loop to compare the values
for (Element picklistEntry : picklistEntries)
{
// Check whether this is correct Picklist id
if (picklistEntry.getText() == 'language')
{

// go to the parent node to get the picklist ids
Element parent = picklistEntry.getParent(); //Father = Picklist
Element parent1 = parent.getParent();       //GrandFather = picklist
Element parent2 = parent1.getParent();      //GGFather = PicklistOption
String ec_picklist = parent2.getChild("externalCode").getText();
if ( externalCodePerInfo == ec_picklist )
{
error = "";
personaInfoEntry.setText(parent2.getChild("id").getText());
}
}
}

if (error != "")
{
message.setProperty("Status", "ERROR");
message.setHeader("Status", "ERROR");
String message3 = "The value" + " " + "'" + externalCodePerInfo + "'" + " " + "for the picklist language not found";
message.setProperty("Message", message3);

}

}
}


if (error != "")
{
// Do not process the rest of the nodes
}
else{

//select personalInfo node salutation
XPath xPathPersonalInfo = new JDOMXPath("//personalInfo/salutation");
List personaInfoEntries =  xPathPersonalInfo.selectNodes(inputDoc);

// main loop over Personal Info entries
for (Element personaInfoEntry : personaInfoEntries)
{

String externalCodePerInfo = personaInfoEntry.getText();

//select all Picklist nodes
XPath xPathPicklist = new JDOMXPath("//PicklistOption/PicklistOption/picklist/Picklist/picklistId");
List picklistEntries =  xPathPicklist.selectNodes(inputDocPicklist);
error = "X";
// Loop to compare the values
for (Element picklistEntry : picklistEntries)
{
// Check whether this is correct Picklist id
if (picklistEntry.getText() == 'salutation')
{

// go to the parent node to get the picklist ids
Element parent = picklistEntry.getParent(); //Father = Picklist
Element parent1 = parent.getParent();       //GrandFather = picklist
Element parent2 = parent1.getParent();      //GGFather = PicklistOption
String ec_picklist = parent2.getChild("externalCode").getText();
if ( externalCodePerInfo == ec_picklist )
{
error = "";
personaInfoEntry.setText(parent2.getChild("id").getText());
}
}
}

if (error != "")
{
message.setProperty("Status", "ERROR");
message.setHeader("Status", "ERROR");
String message3 = "The value" + " " + "'" + externalCodePerInfo + "'" + " " + "for the picklist salutation not found";
message.setProperty("Message", message3);

}

}
}



if (error != "")
{
// Do not process the rest of the nodes
}
else{

//select addressInfo node addressType
XPath xPathAddressInfo = new JDOMXPath("//addressInfo/addressType");
List addressInfoEntries =  xPathAddressInfo.selectNodes(inputDoc);

// main loop over Address Info entries
for (Element addressInfoEntry : addressInfoEntries)
{

String externalCodeAddInfo = addressInfoEntry.getText();

//select all Picklist nodes
XPath xPathPicklist = new JDOMXPath("//PicklistOption/PicklistOption/picklist/Picklist/picklistId");
List picklistEntries =  xPathPicklist.selectNodes(inputDocPicklist);
error = "X";
// Loop to compare the values
for (Element picklistEntry : picklistEntries)
{
// Check whether this is correct Picklist id
if (picklistEntry.getText() == 'addressType')
{

// go to the parent node to get the picklist ids
Element parent = picklistEntry.getParent(); //Father = Picklist
Element parent1 = parent.getParent();       //GrandFather = picklist
Element parent2 = parent1.getParent();      //GGFather = PicklistOption
String ec_picklist = parent2.getChild("externalCode").getText();
if ( externalCodeAddInfo == ec_picklist )
{
error = "";
addressInfoEntry.setText(parent2.getChild("id").getText());
}
}
}

if (error != "")
{
message.setProperty("Status", "ERROR");
message.setHeader("Status", "ERROR");
String message3 = "The value" + " " + "'" + externalCodeAddInfo + "'" + " " + "for the picklist addressType not found";
message.setProperty("Message", message3);

}

}
}



if (error != "")
{
// Do not process the rest of the nodes
}
else{

//select emergencyContactInfo node relationship
XPath xPathEmergencyContactInfo = new JDOMXPath("//emergencyContactInfo/relationship");
List emergencyContactInfoEntries =  xPathEmergencyContactInfo.selectNodes(inputDoc);

// main loop over Personal Info entries
for (Element emergencyContactInfoEntry : emergencyContactInfoEntries)
{

String externalCodeEmergencyContactInfo = emergencyContactInfoEntry.getText();

//select all Picklist nodes
XPath xPathPicklist = new JDOMXPath("//PicklistOption/PicklistOption/picklist/Picklist/picklistId");
List picklistEntries =  xPathPicklist.selectNodes(inputDocPicklist);
error = "X";
// Loop to compare the values
for (Element picklistEntry : picklistEntries)
{
// Check whether this is correct Picklist id
if (picklistEntry.getText() == 'RelationshipType')
{

// go to the parent node to get the picklist ids
Element parent = picklistEntry.getParent(); //Father = Picklist
Element parent1 = parent.getParent();       //GrandFather = picklist
Element parent2 = parent1.getParent();      //GGFather = PicklistOption
String ec_picklist = parent2.getChild("externalCode").getText();
if ( externalCodeEmergencyContactInfo == ec_picklist )
{
error = "";
emergencyContactInfoEntry.setText(parent2.getChild("id").getText());
}
}
}

if (error != "")
{
message.setProperty("Status", "ERROR");
message.setHeader("Status", "ERROR");
String message3 = "The value" + " " + "'" + externalCodeEmergencyContactInfo + "'" + " " + "for the picklist RelationshipType not found";
message.setProperty("Message", message3);

}

}
}



if (error != "")
{
// Do not process the rest of the nodes
}
else{

//select jobInfo node employeeNoticePeriod
XPath xPathJobInfo = new JDOMXPath("//jobInfo/employeeNoticePeriod");
List jobInfoEntries =  xPathJobInfo.selectNodes(inputDoc);

// main loop over Job Info entries
for (Element jobInfoEntry : jobInfoEntries)
{

String externalCodeJobInfo = jobInfoEntry.getText();

//select all Picklist nodes
XPath xPathPicklist = new JDOMXPath("//PicklistOption/PicklistOption/picklist/Picklist/picklistId");
List picklistEntries =  xPathPicklist.selectNodes(inputDocPicklist);
error = "X";
// Loop to compare the values
for (Element picklistEntry : picklistEntries)
{
// Check whether this is correct Picklist id
if (picklistEntry.getText() == 'Employee_Notice_Period')
{

// go to the parent node to get the picklist ids
Element parent = picklistEntry.getParent(); //Father = Picklist
Element parent1 = parent.getParent();       //GrandFather = picklist
Element parent2 = parent1.getParent();      //GGFather = PicklistOption
String ec_picklist = parent2.getChild("externalCode").getText();
if ( externalCodeJobInfo == ec_picklist )
{
error = "";
jobInfoEntry.setText(parent2.getChild("id").getText());
}
}
}

if (error != "")
{
message.setProperty("Status", "ERROR");
message.setHeader("Status", "ERROR");
String message3 = "The value" + " " + "'" + externalCodeJobInfo + "'" + " " + "for the picklist Employee_Notice_Period not found";
message.setProperty("Message", message3);

}

}
}



if (error != "")
{
// Do not process the rest of the nodes
}
else{

//select jobInfo node Event
XPath xPathJobInfo = new JDOMXPath("//jobInfo/event");
List jobInfoEntries =  xPathJobInfo.selectNodes(inputDoc);

// main loop over Job Info entries
for (Element jobInfoEntry : jobInfoEntries)
{

String externalCodeJobInfo = jobInfoEntry.getText();

//select all Picklist nodes
XPath xPathPicklist = new JDOMXPath("//PicklistOption/PicklistOption/picklist/Picklist/picklistId");
List picklistEntries =  xPathPicklist.selectNodes(inputDocPicklist);
error = "X";
// Loop to compare the values
for (Element picklistEntry : picklistEntries)
{
// Check whether this is correct Picklist id
if (picklistEntry.getText() == 'event')
{

// go to the parent node to get the picklist ids
Element parent = picklistEntry.getParent(); //Father = Picklist
Element parent1 = parent.getParent();       //GrandFather = picklist
Element parent2 = parent1.getParent();      //GGFather = PicklistOption
String ec_picklist = parent2.getChild("externalCode").getText();
if ( externalCodeJobInfo == ec_picklist )
{
error = "";
jobInfoEntry.setText(parent2.getChild("id").getText());
}
}
}

if (error != "")
{
message.setProperty("Status", "ERROR");
message.setHeader("Status", "ERROR");
String message3 = "The value" + " " + "'" + externalCodeJobInfo + "'" + " " + "for the picklist event not found";
message.setProperty("Message", message3);

}

}
}



if (error != "")
{
// Do not process the rest of the nodes
}
else{

//select jobInfo node leadershipType
XPath xPathJobInfo = new JDOMXPath("//jobInfo/leadershipType");
List jobInfoEntries =  xPathJobInfo.selectNodes(inputDoc);

// main loop over Job Info entries
for (Element jobInfoEntry : jobInfoEntries)
{

String externalCodeJobInfo = jobInfoEntry.getText();

//select all Picklist nodes
XPath xPathPicklist = new JDOMXPath("//PicklistOption/PicklistOption/picklist/Picklist/picklistId");
List picklistEntries =  xPathPicklist.selectNodes(inputDocPicklist);
error = "X";
// Loop to compare the values
for (Element picklistEntry : picklistEntries)
{
// Check whether this is correct Picklist id
if (picklistEntry.getText() == 'LeadershipType')
{

// go to the parent node to get the picklist ids
Element parent = picklistEntry.getParent(); //Father = Picklist
Element parent1 = parent.getParent();       //GrandFather = picklist
Element parent2 = parent1.getParent();      //GGFather = PicklistOption
String ec_picklist = parent2.getChild("externalCode").getText();
if ( externalCodeJobInfo == ec_picklist )
{
error = "";
jobInfoEntry.setText(parent2.getChild("id").getText());
}
}
}

if (error != "")
{
message.setProperty("Status", "ERROR");
message.setHeader("Status", "ERROR");
String message3 = "The value" + " " + "'" + externalCodeJobInfo + "'" + " " + "for the picklist LeadershipType not found";
message.setProperty("Message", message3);

}

}
}



if (error != "")

{

// Do not process the rest of the nodes

}

else
{


//select jobInfo node contractType

XPath xPathJobInfo = new JDOMXPath("//jobInfo/contractType");

List jobInfoEntries =  xPathJobInfo.selectNodes(inputDoc);


// main loop over Job Info entries

for (Element jobInfoEntry : jobInfoEntries)

{


String externalCodeJobInfo = jobInfoEntry.getText();


//select all Picklist nodes

XPath xPathPicklist = new JDOMXPath("//PicklistOption/PicklistOption/picklist/Picklist/picklistId");

List picklistEntries =  xPathPicklist.selectNodes(inputDocPicklist);

error = "X";

// Loop to compare the values

for (Element picklistEntry : picklistEntries)

{

// Check whether this is correct Picklist id

if (picklistEntry.getText() == 'contractType')

{


// go to the parent node to get the picklist ids

Element parent = picklistEntry.getParent(); //Father = Picklist

Element parent1 = parent.getParent();       //GrandFather = picklist

Element parent2 = parent1.getParent();      //GGFather = PicklistOption

String ec_picklist = parent2.getChild("externalCode").getText();

if ( externalCodeJobInfo == ec_picklist )

{

error = "";

// jobInfoEntry.setText(parent2.getChild("id").getText());


// Get the label and pass it on to a property

Element picklistLabels = parent2.getChild("picklistLabels");
Element PicklistLabel = picklistLabels.getChild("PicklistLabel");

String label = PicklistLabel.getChild("label").getText();

message.setProperty("jobInfo_contractType_GB", label);

}

}

}



if (error != "")

{

message.setProperty("Status", "ERROR");

message.setHeader("Status", "ERROR");

String message3 = "The value" + " " + "'" + externalCodeJobInfo + "'" + " " + "for the picklist contractType not found";

message.setProperty("Message", message3);


}

}

}



if (error != "")
{
// Do not process the rest of the nodes
}
else{

//select jobInfo node employerNoticePeriod
XPath xPathJobInfo = new JDOMXPath("//jobInfo/employerNoticePeriod");
List jobInfoEntries =  xPathJobInfo.selectNodes(inputDoc);

// main loop over Job Info entries
for (Element jobInfoEntry : jobInfoEntries)
{

String externalCodeJobInfo = jobInfoEntry.getText();

//select all Picklist nodes
XPath xPathPicklist = new JDOMXPath("//PicklistOption/PicklistOption/picklist/Picklist/picklistId");
List picklistEntries =  xPathPicklist.selectNodes(inputDocPicklist);
error = "X";
// Loop to compare the values
for (Element picklistEntry : picklistEntries)
{
// Check whether this is correct Picklist id
if (picklistEntry.getText() == 'Employer_Notice_Period')
{

// go to the parent node to get the picklist ids
Element parent = picklistEntry.getParent(); //Father = Picklist
Element parent1 = parent.getParent();       //GrandFather = picklist
Element parent2 = parent1.getParent();      //GGFather = PicklistOption
String ec_picklist = parent2.getChild("externalCode").getText();
if ( externalCodeJobInfo == ec_picklist )
{
error = "";
jobInfoEntry.setText(parent2.getChild("id").getText());
// Get the label and pass it on to a property
Element picklistLabel = parent2.getChild("PicklistLabel");
String label = picklistLabel.getChild("label").getText();
message.setProperty("jobInfo_contractType_GB", label);
}
}
}

if (error != "")
{
message.setProperty("Status", "ERROR");
message.setHeader("Status", "ERROR");
String message3 = "The value" + " " + "'" + externalCodeJobInfo + "'" + " " + "for the picklist Employer_Notice_Period not found";
message.setProperty("Message", message3);

}

}
}





if (error != "")
{
// Do not process the rest of the nodes
}
else{

//select jobInfo node countryOfCompany
XPath xPathJobInfo = new JDOMXPath("//jobInfo/countryOfCompany");
List jobInfoEntries =  xPathJobInfo.selectNodes(inputDoc);

// main loop over Job Info entries
for (Element jobInfoEntry : jobInfoEntries)
{

String externalCodeJobInfo = jobInfoEntry.getText();

//select all Picklist nodes
XPath xPathPicklist = new JDOMXPath("//PicklistOption/PicklistOption/picklist/Picklist/picklistId");
List picklistEntries =  xPathPicklist.selectNodes(inputDocPicklist);
error = "X";
// Loop to compare the values
for (Element picklistEntry : picklistEntries)
{
// Check whether this is correct Picklist id
if (picklistEntry.getText() == 'ISOCountryList')
{

// go to the parent node to get the picklist ids
Element parent = picklistEntry.getParent(); //Father = Picklist
Element parent1 = parent.getParent();       //GrandFather = picklist
Element parent2 = parent1.getParent();      //GGFather = PicklistOption
String ec_picklist = parent2.getChild("externalCode").getText();
if ( externalCodeJobInfo == ec_picklist )
{
error = "";
//jobInfoEntry.setText(parent2.getChild("id").getText());
}
}
}

if (error != "")
{
message.setProperty("Status", "ERROR");
message.setHeader("Status", "ERROR");
String message3 = "The value" + " " + "'" + externalCodeJobInfo + "'" + " " + "for the picklist ISOCountryList not found";
message.setProperty("Message", message3);

}

}
}



if (error != "")
{
// Do not process the rest of the nodes
}
else{

//select jobInfo node Supported_Business_Structure
XPath xPathJobInfo = new JDOMXPath("//jobInfo/SBBS");
List jobInfoEntries =  xPathJobInfo.selectNodes(inputDoc);

// main loop over Job Info entries
for (Element jobInfoEntry : jobInfoEntries)
{

String externalCodeJobInfo = jobInfoEntry.getText();

//select all Picklist nodes
XPath xPathPicklist = new JDOMXPath("//PicklistOption/PicklistOption/picklist/Picklist/picklistId");
List picklistEntries =  xPathPicklist.selectNodes(inputDocPicklist);
error = "X";
// Loop to compare the values
for (Element picklistEntry : picklistEntries)
{
// Check whether this is correct Picklist id
if (picklistEntry.getText() == 'Supported_Business_Structure')
{

// go to the parent node to get the picklist ids
Element parent = picklistEntry.getParent(); //Father = Picklist
Element parent1 = parent.getParent();       //GrandFather = picklist
Element parent2 = parent1.getParent();      //GGFather = PicklistOption
String ec_picklist = parent2.getChild("externalCode").getText();
if ( externalCodeJobInfo == ec_picklist )
{
error = "";
//jobInfoEntry.setText(parent2.getChild("id").getText());
}
}
}

if (error != "")
{
message.setProperty("Status", "ERROR");
message.setHeader("Status", "ERROR");
String message3 = "The value" + " " + "'" + externalCodeJobInfo + "'" + " " + "for the picklist Supported_Business_Structure not found";
message.setProperty("Message", message3);

}

}
}


if (error != "")
{
// Do not process the rest of the nodes
}
else{

//select personalDocumentsInfo node Country
XPath xPathPersonalDocumentsInfo = new JDOMXPath("//personalDocumentsInfo/Country");
List personalDocumentsInfoEntries =  xPathPersonalDocumentsInfo.selectNodes(inputDoc);

// main loop over Personal Documents Info entries
for (Element personalDocumentsInfoEntry : personalDocumentsInfoEntries)
{

String externalCodePersonalDocumentsInfo = personalDocumentsInfoEntry.getText();

//select all Picklist nodes
XPath xPathPicklist = new JDOMXPath("//PicklistOption/PicklistOption/picklist/Picklist/picklistId");
List picklistEntries =  xPathPicklist.selectNodes(inputDocPicklist);
error = "X";
// Loop to compare the values
for (Element picklistEntry : picklistEntries)
{
// Check whether this is correct Picklist id
if (picklistEntry.getText() == 'ISOCountryList')
{

// go to the parent node to get the picklist ids
Element parent = picklistEntry.getParent(); //Father = Picklist
Element parent1 = parent.getParent();       //GrandFather = picklist
Element parent2 = parent1.getParent();      //GGFather = PicklistOption
String ec_picklist = parent2.getChild("externalCode").getText();
if ( externalCodePersonalDocumentsInfo == ec_picklist )
{
error = "";
// personalDocumentsInfoEntry.setText(parent2.getChild("id").getText());
}
}
}

if (error != "")
{
message.setProperty("Status", "ERROR");
message.setHeader("Status", "ERROR");
String message3 = "The value" + " " + "'" + externalCodeJobInfo + "'" + " " + "for the picklist ISOCountryList not found";
message.setProperty("Message", message3);

}

}
}



if (error != "")
{
// Do not process the rest of the nodes
}
else{

//select personalDocumentsInfo node documentType
XPath xPathPersonalDocumentsInfo = new JDOMXPath("//personalDocumentsInfo/documentType");
List personalDocumentsInfoEntries =  xPathPersonalDocumentsInfo.selectNodes(inputDoc);

// main loop over Personal Documents Info entries
for (Element personalDocumentsInfoEntry : personalDocumentsInfoEntries)
{

String externalCodePersonalDocumentsInfo = personalDocumentsInfoEntry.getText();

//select all Picklist nodes
XPath xPathPicklist = new JDOMXPath("//PicklistOption/PicklistOption/picklist/Picklist/picklistId");
List picklistEntries =  xPathPicklist.selectNodes(inputDocPicklist);
error = "X";
// Loop to compare the values
for (Element picklistEntry : picklistEntries)
{
// Check whether this is correct Picklist id
if (picklistEntry.getText() == 'permitdoctype')
{

// go to the parent node to get the picklist ids
Element parent = picklistEntry.getParent(); //Father = Picklist
Element parent1 = parent.getParent();       //GrandFather = picklist
Element parent2 = parent1.getParent();      //GGFather = PicklistOption
String ec_picklist = parent2.getChild("externalCode").getText();
if ( externalCodePersonalDocumentsInfo == ec_picklist )
{
error = "";
personalDocumentsInfoEntry.setText(parent2.getChild("id").getText());
}
}
}

if (error != "")
{
message.setProperty("Status", "ERROR");
message.setHeader("Status", "ERROR");
String message3 = "The value" + " " + "'" + externalCodeJobInfo + "'" + " " + "for the picklist permitdoctype not found";
message.setProperty("Message", message3);

}

}
}





if (error != "")
{
// Do not process the rest of the nodes
}
else{

//select paymentInformationDetail node paymentType
XPath xPathPaymentInfo = new JDOMXPath("//paymentInformationDetail/paymentType");
List paymentInfoEntries =  xPathPaymentInfo.selectNodes(inputDoc);

// main loop over Personal Documents Info entries
for (Element paymentInfoEntry : paymentInfoEntries)
{

String externalCodePaymentInfo = paymentInfoEntry.getText();

//select all Picklist nodes
XPath xPathPicklist = new JDOMXPath("//PicklistOption/PicklistOption/picklist/Picklist/picklistId");
List picklistEntries =  xPathPicklist.selectNodes(inputDocPicklist);
error = "X";
// Loop to compare the values
for (Element picklistEntry : picklistEntries)
{
// Check whether this is correct Picklist id
if (picklistEntry.getText() == 'PaymentMethod')
{

// go to the parent node to get the picklist ids
Element parent = picklistEntry.getParent(); //Father = Picklist
Element parent1 = parent.getParent();       //GrandFather = picklist
Element parent2 = parent1.getParent();      //GGFather = PicklistOption
String ec_picklist = parent2.getChild("externalCode").getText();
if ( externalCodePaymentInfo == ec_picklist )
{
error = "";
paymentInfoEntry.setText(parent2.getChild("id").getText());
}
}
}

if (error != "")
{
message.setProperty("Status", "ERROR");
message.setHeader("Status", "ERROR");
String message3 = "The value" + " " + "'" + externalCodeJobInfo + "'" + " " + "for the picklist PaymentMethod not found";
message.setProperty("Message", message3);

}

}
}



if (error != "")
{
// Do not process the rest of the nodes
}
else{

//select paymentInformationDetail node paymentType
XPath xPathPaymentInfo = new JDOMXPath("//paymentInformationDetail/payType");
List paymentInfoEntries =  xPathPaymentInfo.selectNodes(inputDoc);

// main loop over Personal Documents Info entries
for (Element paymentInfoEntry : paymentInfoEntries)
{

String externalCodePaymentInfo = paymentInfoEntry.getText();

//select all Picklist nodes
XPath xPathPicklist = new JDOMXPath("//PicklistOption/PicklistOption/picklist/Picklist/picklistId");
List picklistEntries =  xPathPicklist.selectNodes(inputDocPicklist);
error = "X";
// Loop to compare the values
for (Element picklistEntry : picklistEntries)
{
// Check whether this is correct Picklist id
if (picklistEntry.getText() == 'PaymentType')
{

// go to the parent node to get the picklist ids
Element parent = picklistEntry.getParent(); //Father = Picklist
Element parent1 = parent.getParent();       //GrandFather = picklist
Element parent2 = parent1.getParent();      //GGFather = PicklistOption
String ec_picklist = parent2.getChild("externalCode").getText();
if ( externalCodePaymentInfo == ec_picklist )
{
error = "";
paymentInfoEntry.setText(parent2.getChild("id").getText());
}
}
}

if (error != "")
{
message.setProperty("Status", "ERROR");
message.setHeader("Status", "ERROR");
String message3 = "The value" + " " + "'" + externalCodePaymentInfo + "'" + " " + "for the picklist PaymentType not found";
message.setProperty("Message", message3);

}

}
}





ByteArrayOutputStream bo = new ByteArrayOutputStream(); //create a byte ARRAY stream to store the data
Format format = Format.getPrettyFormat();     // format the data to UTF-8 as this is a new document
format.setEncoding("UTF-8");
 XMLOutputter xmlout = new XMLOutputter(format);
 xmlout.output(inputDoc, bo); //output the global doc
message.setBody(bo.toString()) //set the body as XML string to be passed to the next step
return message;
}