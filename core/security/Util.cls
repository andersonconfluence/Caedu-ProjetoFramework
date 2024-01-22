Class FrameworkCaedu.core.security.Util Extends %RegisteredObject
{

/// Método responsável por retorna um token JWT no formato HS256 para o usuário enviado
ClassMethod GetJWTAuth(username As %String, password As %String, ByRef jwtAuth As %String) As %Status
{
	Try
	{
		Set status = $SYSTEM.Status.OK()

		If (username = "") || (password = "")
		{
			Throw ##Class(%Exception.General).%New("Invalid Credentials Error", , , "Username and Password are required!")
		}

		Set jwtCredentials = ##class(FrameworkCaedu.core.data.JWTCredential).UsernameIndexOpen(username)

		If ('$IsObject(jwtCredentials)) || (jwtCredentials.Password '= password)
		{
			Throw ##Class(%Exception.General).%New("Access Denied", , , "Invalid Username or Password!")
		}

		Set jwtToken = ..GenerateHS256JWTToken(jwtCredentials.ISS, jwtCredentials.Username, jwtCredentials.PrivateKey, jwtCredentials.ExpirationTime)

		Set jsonReturn = {}
		Set jsonReturn.message = "Login efetuado com sucesso"
		Set jsonReturn.statusCode = 200
		Do jsonReturn.%Set("success",1,"boolean") 
		Set jsonReturn.jwtHeaderKey = "Authorization"
		Set jsonReturn.jwtToken = jwtToken
		Set jsonReturn.jwtType = "Baerer"
		Set jsonReturn.name = jwtCredentials.ISS
		Set jsonReturn.username = username
	}
	Catch (exception)
	{
		Set status = exception.AsStatus()

		Set jsonReturn = {}
		Set jsonReturn.message = exception.DisplayString()
		Set jsonReturn.statusCode = 401
		Do jsonReturn.%Set("success",0,"boolean") 
		Set jsonReturn.jwtHeaderKey = "Authorization"
		Set jsonReturn.jwtToken = ""
		Set jsonReturn.jwtType = "Baerer"
		Set jsonReturn.name = ""
		Set jsonReturn.username = ""
	}

	Set jwtAuth = jsonReturn.%ToJSON()

	Return status
}

/// Método responsável por gerar um token JWT no formato HS256
ClassMethod GenerateHS256JWTToken(pIss As %String, pName As %String, privateKey As %String, pExpiration As %Integer = 3600) As %String
{
	Set tCabecalho = {"alg":"HS256","typ":"JWT"}.%ToJSON()
	Set tCabecalhoBase64 = $System.Encryption.Base64Encode(tCabecalho)
	
	Set tCabecalhoBase64Url = ##class(%OAuth2.Utils).Base64UrlEncode(tCabecalho)
	
	Set tIat = $System.SQL.DATEDIFF("ss","1969-12-31 21:00:00",$ZDATETIME($HOROLOG,3))
	Set tExp = tIat + pExpiration
	
	Set tPayload = {
					"iss": (pIss),
					"name": (pName),
					"iat": (tIat),
					"exp": (tExp) 
					}.%ToJSON()

	Set tPayloadBase64 = $System.Encryption.Base64Encode(tPayload)
	
	Set tPayloadBase64Url = ##class(%OAuth2.Utils).Base64UrlEncode(tPayload)
	
	Set tToken = tCabecalhoBase64Url_"."_tPayloadBase64Url
	
	Set tSignature = $System.Encryption.HMACSHA(256,tToken,privateKey)

	Set tSignatureBase64Url = ##class(%OAuth2.Utils).Base64UrlEncode(tSignature)
	
	Set tToken = tCabecalhoBase64Url_"."_tPayloadBase64Url_"."_tSignatureBase64Url

	Return tToken
}

}
