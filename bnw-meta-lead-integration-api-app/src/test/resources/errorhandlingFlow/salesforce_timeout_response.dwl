import * from dw::test::Asserts
---
payload must equalTo({
  "success": false,
  "status": "504",
  "message": "Lead creation failed",
  "errorType": "TIMEOUT"
})