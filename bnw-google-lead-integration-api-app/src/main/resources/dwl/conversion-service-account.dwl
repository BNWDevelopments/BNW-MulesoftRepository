%dw 2.0
output application/json
---
{
	"privateKeyId" : p('conversion.googlead.privateKeyId'),
	"privateKeyPem" : p('conversion.googlead.privateKeyPem'),
	"clientEmail" : p('conversion.googlead.clientEmail'),
	"tokenUri" : p('conversion.googlead.tokenUri'),
	"tokenScope" : p('conversion.googlead.tokenScope'),
}