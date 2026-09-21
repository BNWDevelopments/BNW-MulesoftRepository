import * from dw::test::Asserts
---
payload must equalTo({
  "success": false,
  "status": "400",
  "message": "Lead creation failed",
  "errorType": "BAD_REQUEST"
})