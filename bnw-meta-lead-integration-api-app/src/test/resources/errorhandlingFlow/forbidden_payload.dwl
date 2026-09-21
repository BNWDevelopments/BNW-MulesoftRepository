import * from dw::test::Asserts
---
payload must equalTo({
	"success": false,
	"status": "403",
	"message": "Lead creation failed",
	"errorType": "FORBIDDEN"
})