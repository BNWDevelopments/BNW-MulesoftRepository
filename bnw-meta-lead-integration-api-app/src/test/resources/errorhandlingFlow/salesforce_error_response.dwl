import * from dw::test::Asserts
---
payload must equalTo({
  "success": false,
  "status": "500",
  "message": "Lead creation failed",
  "errorType": "CONNECTIVITY"
})