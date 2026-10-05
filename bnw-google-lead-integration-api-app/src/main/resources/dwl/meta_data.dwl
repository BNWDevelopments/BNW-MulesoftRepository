%dw 2.0

output application/json
 
import dw::Crypto
import * from dw::core::Binaries
import mergeWith from dw::core::Objects
 
// Utility function to normalize and SHA-256 hash text (Meta requirement)

fun hashSHA256(value: String) =  lower(
        toHex(
            Crypto::hashWith(
                trim(lower(value)) as Binary,
                "SHA-256"
            )
        )
    )

---

{

  data: [

    {

      event_name: if (payload.teleSalesLeadStatus == p('conversion.qualified_stage')) "Qualified" else if (payload.status == p('conversion.converted')) "Converted" else null,

      event_time: if (payload.teleSalesLeadStatus == p('conversion.qualified_stage'))( if(payload.telesalesStatusQualifiedAt != null) (payload.telesalesStatusQualifiedAt as DateTime as Number) else null )else if (payload.status == p('conversion.converted')) (if(payload.statusConvertedAt != null)(payload.statusConvertedAt as DateTime as Number) else null) else null,

      event_source_url: p('facebook.eventSourceURL'),

      action_source: "system_generated",
//Google_Lead_Id__c,FirstName,LastName,Email,MobilePhone
      user_data: (
       {  
       	lead_id: payload.metaLeadgenId, 
       fbclid: payload.fbclid default ""
       } 
      		  mergeWith (if (payload.email != null)
							{ em: [hashSHA256(payload.email as String)] }
						else
								{})
			 mergeWith (
							if (payload.mobilePhone != null)
							{ ph: [hashSHA256(payload.mobilePhone as String)] }
							else
							{})
			 mergeWith (
							if (payload.lastName != null)
							{ ln: [hashSHA256(payload.lastName as String)] }
							else
							{})
			 mergeWith (
							if (payload.firstName != null)
							{ fn: [hashSHA256(payload.firstName as String)] }
							else
							{})				
				),
    
      custom_data: {
      	         lead_status:  if (payload.teleSalesLeadStatus == p('conversion.qualified_stage')) payload.teleSalesLeadStatus else if (payload.status == p('conversion.converted')) payload.status else null,
      	         salesforce_lead_id: payload.id default "",
      	         value: if (payload.teleSalesLeadStatus == p('conversion.qualified_stage')) 10 else if (payload.status == p('conversion.converted')) 100 else null,
                 currency: "AED"

      }

   

    }

  ]

}
 