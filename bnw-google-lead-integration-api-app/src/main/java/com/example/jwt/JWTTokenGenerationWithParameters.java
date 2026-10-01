package com.example.jwt;


	import java.nio.charset.StandardCharsets;
	import java.security.KeyFactory;
	import java.security.PrivateKey;
	import java.security.Signature;
	import java.security.spec.PKCS8EncodedKeySpec;
	import java.util.Base64;

	public final class JWTTokenGenerationWithParameters {

	    private JWTTokenGenerationWithParameters() {
	    }

	    public static String generateJwt(
	            String privateKeyId,
	            String privateKeyPem,
	            String clientEmail,
	            String tokenUri,
	            String scope) throws Exception {
	    	
	//    	System.out.println("AAAAAAAAAAAAAAAAAAAAA" + privateKeyId + " "+ privateKeyPem + " "+clientEmail+ " "+tokenUri+ " "+scope);

	        /*
	         * JWT Header
	         *
	         * alg = RS256
	         * typ = JWT
	         * kid = Google service account private key ID
	         */
	        String header = "{"
	                + "\"alg\":\"RS256\","
	                + "\"typ\":\"JWT\","
	                + "\"kid\":\"" + escapeJson(privateKeyId) + "\""
	                + "}";

	        /*
	         * Current time in seconds.
	         */
	        long issuedAt = System.currentTimeMillis() / 1000;

	        /*
	         * Google OAuth service-account JWTs are normally short lived.
	         * Here we use 1 hour.
	         */
	        long expiration = issuedAt + 3600;

	        /*
	         * JWT Payload
	         */
	        String payload = "{"
	                + "\"iss\":\"" + escapeJson(clientEmail) + "\","
	                + "\"scope\":\"" + escapeJson(scope) + "\","
	                + "\"aud\":\"" + escapeJson(tokenUri) + "\","
	                + "\"iat\":" + issuedAt + ","
	                + "\"exp\":" + expiration
	                + "}";

	        /*
	         * Base64URL encode header and payload.
	         */
	        String encodedHeader =
	                base64Url(header.getBytes(StandardCharsets.UTF_8));

	        String encodedPayload =
	                base64Url(payload.getBytes(StandardCharsets.UTF_8));

	        /*
	         * Data that must be signed.
	         */
	        String signingInput =
	                encodedHeader + "." + encodedPayload;

	        /*
	         * Load RSA private key.
	         */
	        PrivateKey privateKey =
	                loadPrivateKey(privateKeyPem);

	        /*
	         * Sign using RSA SHA-256.
	         */
	        Signature signature =
	                Signature.getInstance("SHA256withRSA");

	        signature.initSign(privateKey);

	        signature.update(
	                signingInput.getBytes(StandardCharsets.UTF_8)
	        );

	        byte[] signedBytes = signature.sign();

	        /*
	         * Encode signature using Base64URL.
	         */
	        String encodedSignature =
	                base64Url(signedBytes);

	        /*
	         * Final JWT:
	         *
	         * header.payload.signature
	         */
	        return signingInput + "." + encodedSignature;
	    }

	    /**
	     * Loads an RSA private key in PKCS#8 PEM format.
	     *
	     * Expected:
	     *
	     * -----BEGIN PRIVATE KEY-----
	     * ...
	     * -----END PRIVATE KEY-----
	     */
	    private static PrivateKey loadPrivateKey(
	            String privateKeyPem) throws Exception {

	        String privateKey = privateKeyPem
	                .replace("-----BEGIN PRIVATE KEY-----", "")
	                .replace("-----END PRIVATE KEY-----", "")
	                .replaceAll("\\s+", "");

	        byte[] keyBytes =
	                Base64.getDecoder().decode(privateKey);

	        PKCS8EncodedKeySpec keySpec =
	                new PKCS8EncodedKeySpec(keyBytes);

	        KeyFactory keyFactory =
	                KeyFactory.getInstance("RSA");

	        return keyFactory.generatePrivate(keySpec);
	    }

	    /**
	     * Base64 URL encoding without padding.
	     */
	    private static String base64Url(byte[] value) {

	        return Base64
	                .getUrlEncoder()
	                .withoutPadding()
	                .encodeToString(value);
	    }

	    /**
	     * Basic JSON escaping.
	     */
	    private static String escapeJson(String value) {

	        if (value == null) {
	            return "";
	        }

	        return value
	                .replace("\\", "\\\\")
	                .replace("\"", "\\\"");
	    }
	}

