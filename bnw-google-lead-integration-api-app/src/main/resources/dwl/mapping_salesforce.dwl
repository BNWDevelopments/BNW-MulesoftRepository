%dw 2.0
import mergeWith from dw::core::Objects
import * from dw::core::Strings
output application/java

// Normalize Meta fields into a map
var normalizedFields =
    (vars.meta_data.user_column_data default [])
        reduce ((item, acc = {}) ->
            acc ++ {
                (lower(item.column_id)):
                    // Handle both string and array safely
                    if (item.string_value is Array)
                        item.string_value[0]
                    else
                        item.string_value
            }
        )
        
// Normalize Meta fields into a map
var userColumnDataFullNameArray = vars.meta_data.user_column_data filter ((item) ->
    item.column_id == "FULL_NAME" ) 

var firstName = if(sizeOf(userColumnDataFullNameArray) >0)
(((userColumnDataFullNameArray )[0]).first_name)
else ""

var lastName = if(sizeOf(userColumnDataFullNameArray) >0)
(((userColumnDataFullNameArray )[0]).last_name)
else ""
        

// Extract values using aliases
//var fullName =
 //   normalizedFields.full_name
  //  default normalizedFields.fullname
    //default normalizedFields.fullname
    //default normalizedFields.name
    //default ""

var email =
    normalizedFields.email
    default normalizedFields.email_address
    default null

var phone =
    normalizedFields.phone_number
    default normalizedFields.phone
    default normalizedFields.mobile
    default null

// Name split
//var nameParts = fullName splitBy " "
//var firstName = if (sizeOf(nameParts) > 1) nameParts[0] else fullName
//var lastName =
 //   if (sizeOf(nameParts) > 1)
  //      (nameParts[1 to -1] joinBy " ")
  //  else
   //     "" //changed to empty from "unknown" as per the discussion with deepak,vishvajeet on 21-08-2026

---
[{
    FirstName: if (sizeOf(firstName) > 40) (substring(firstName, 0, 40) ) else firstName, //changed from firstName to fullName. based on discussion with deepak & navdeep & vishvajeet in UAT call
    LastName: if (sizeOf(lastName) > 80) (substring(lastName, 0, 80) ) else lastName ,//changed lastName to space, based on discussion with deepak & navdeep & vishvajeet in UAT call 
    Email: if (email == "") null else email,
    MobilePhone: if (phone == "") null else phone,
    LeadSource: 'Digital',
    Interested_Project__c : vars.vProjectVar
    } mergeWith 
    (if(vars.vAttributesVal.utm_source == "google") {
    Platform_Source__c: 'Google',
	Google_Lead_Id__c: vars.meta_data.lead_id,
	UTM_Source__c : vars.vAttributesVal.utm_source, 
    UTM_Medium__c : vars.vAttributesVal.utm_medium, 
    Utm_term__c : vars.vAttributesVal.utm_term, 
    Ad_Name__c : vars.vAttributesVal.utm_ad, 
    Adgroup_ID__c : vars.vAttributesVal.utm_adgroup_id, 
    Gclid__c : vars.vAttributesVal.gclid, 
    Device__c : vars.vAttributesVal.device, 
    Placement__c : vars.vAttributesVal.placement, 
    Network__c  : vars.vAttributesVal.network, 
    gad_source__c  : vars.vAttributesVal.gad_source, 
    gad_campaignid__c  : vars.vAttributesVal.gad_campaignid, 
    Adgroup_Name__c : vars.vAttributesVal.utm_adgroup,
    UTM_Campaign__c:  vars.vAttributesVal.utm_campaign, 
    UTM_CampaignId__c :   vars.vAttributesVal.utm_id,
    UTM_Content__c : vars.vAttributesVal.utm_content
    } 
    else
     {
    	Platform_Source__c: "Facebook" ,
    	Google_Lead_Id__c: vars.meta_data.lead_id,
    	Ad_Id__c: if(vars.vAttributesVal !=null) ( vars.vAttributesVal.ad_id) else null,
		Adgroup_ID__c: if(vars.vAttributesVal !=null) vars.vAttributesVal.adset_id else null,
		Ad_Name__c: if(vars.vAttributesVal !=null) vars.vAttributesVal.utm_ad else null,
		UTM_Campaign__c: if(vars.vAttributesVal !=null) ( vars.vAttributesVal.utm_campaign) else null,
		UTM_Source__c: if(vars.vAttributesVal !=null) vars.vAttributesVal.utm_source else null,
		Fbclid__c: if(vars.vAttributesVal !=null) vars.vAttributesVal.fbclid else null,
		UTM_Medium__c: if(vars.vAttributesVal !=null) ( vars.vAttributesVal.utm_medium) else null,
		Device__c: if(vars.vAttributesVal !=null) vars.vAttributesVal.device else null,
		Network__c: if(vars.vAttributesVal !=null) vars.vAttributesVal.network else null,
		Placement__c: if(vars.vAttributesVal !=null) vars.vAttributesVal.utm_placement else null,
		Utm_term__c: if(vars.vAttributesVal !=null) vars.vAttributesVal.utm_term else null,
		UTM_Content__c :  if(vars.vAttributesVal !=null) vars.vAttributesVal.utm_content else null,
		Adgroup_Name__c : if(vars.vAttributesVal !=null) vars.vAttributesVal.utm_adset else null,
		UTM_CampaignId__c :  if(vars.vAttributesVal !=null) vars.vAttributesVal.utm_id else null 
	
    }
    
    )

]