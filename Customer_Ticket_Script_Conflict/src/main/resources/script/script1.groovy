package script

/* Refer the link below to learn more about the use cases of script.
https://help.sap.com/viewer/368c481cd6954bdfa5d0435479fd4eaf/Cloud/en-US/148851bf8192412cba1f9d2c17f4bd25.html

If you want to know more about the SCRIPT APIs, refer the link below
https://help.sap.com/doc/a56f52e1a58e4e2bac7f7adbf45b2e26/Cloud/en-US/index.html */
import com.sap.gateway.ip.core.customdev.util.Message;

def Message processCustomerDataOData(Message message) {
    def inputBody = message.getBody(java.io.Reader)
    def data = new groovy.json.JsonSlurper().parse(inputBody)
    def coreData = data.d.results

    def customerIDs = message.getProperty('customerIDs')
    def customerDataMap = message.getProperty('customerDataMap')
    def lprIDSet = new HashSet()

    for (def entry : coreData) {
        if (!entry.Wave_Scope_ID) { continue }
        lprIDSet.add(entry.Wave_Scope_ID)

        // Use Customer_ERP_ID if available, otherwise fallback to Customer_CRM_ID
        String customerID = entry.Customer_ERP_ID ?: entry.Customer_CRM_ID
        if (!customerID) { continue }
        // Capture CRM ID separately for the Business Partner Number in the CQC reason text
        String customerCrmID = entry.Customer_CRM_ID ?: ''

        // Normalize Go-Live date from /Date(ms)/ to yyyy-MM-dd
        String goLiveDate = normalizeODataDate(entry.Calculated_Go_Live_Date ?: '')
        if (!goLiveDate || goLiveDate.trim().isEmpty()) { continue }

        String customerName = entry.Customer ?: "Unknown (CRM: ${entry.Customer_CRM_ID})"
        String waveID = entry.Wave_ID?.toString() ?: ''
        String solutionArea = entry.Solution_Area ?: ''

        String compString = customerID + waveID
        def technicalKey = java.util.UUID.nameUUIDFromBytes(compString.getBytes()).toString()

        if (customerDataMap.get(technicalKey) != null) {
            def existingEntry = customerDataMap.get(technicalKey)
            existingEntry.information.lpr_id += ',' + entry.Wave_Scope_ID
            existingEntry.information.lpr_name += ',' + (entry.Wave_Scope_Name ?: '')
            existingEntry.information.solution_area += ',' + solutionArea
            if (!existingEntry.information.customer_crm_id && customerCrmID) {
                existingEntry.information.customer_crm_id = customerCrmID
            }
            customerDataMap.put(technicalKey, existingEntry)
        } else {
            customerIDs.add(customerID)
            customerDataMap.put(technicalKey, [
                'comparisonKey': '',
                'category': 'PCRM-GL CQC',
                'isRisk': false,
                'message': "For customer ${customerName} a go live has been identified as being at risk.",
                'reason': '',
                'severity': '',
                'customer_number': customerID,
                'customer_name': customerName,
                'solutionArea': solutionArea,
                'goLiveDate': goLiveDate,
                'region': entry.Customer_Region ?: '',
                'country': entry.Customer_Country ?: '',
                'node': customerID,
                'source': 'HPI',
                'eventSource': 'HPI',
                'eventKey': '',
                'information': [
                    'go_live_date': goLiveDate,
                    'product': solutionArea,
                    'action': '',
                    'mitigation_plan': '',
                    'message': "For customer ${customerName} a go live has been identified as being at risk.",
                    'reason': '',
                    'case_payload': '',
                    'customer_number': customerID,
                    'customer_name': customerName,
                    'customer_crm_id': customerCrmID,
                    'escalation_id': '',
                    'escalation_sys_id': '',
                    'u_escalation_type': '5',
                    'u_assignment_group': 'MCC Polymath',
                    'u_type': 'MCCSOS: Standard Account Escalation',
                    'req_reason': '20',
                    'req_title': 'PCRM CCM Request',
                    'solution_area': solutionArea,
                    'lpr_id': entry.Wave_Scope_ID,
                    'lpr_name': entry.Wave_Scope_Name ?: ''
                ]
            ])
        }
    }

    String lprQueryPart = ("BUCKET_ID%20eq%20'" + lprIDSet.join("'%20or%20BUCKET_ID%20eq%20'") + "'")
    message.setProperty('lprQueryPart', lprQueryPart)
    message.setProperty('lprIDCount', lprIDSet.size())
    message.setProperty('customerIDs', customerIDs.unique())
    message.setProperty('customerDataMap', customerDataMap)
    return message
}

// Normalizes OData v2 /Date(milliseconds)/ to yyyy-MM-dd
def String normalizeODataDate(String value) {
    if (!value) return ''
    def matcher = value =~ /\/Date\((\d+)\)\//
    if (matcher.matches()) {
        return new java.util.Date(matcher[0][1].toLong()).format('yyyy-MM-dd', TimeZone.getTimeZone('UTC'))
    }
    return value
}

