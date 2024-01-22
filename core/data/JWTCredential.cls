Class FrameworkCaedu.core.data.JWTCredential Extends (%Persistent, %XML.Adaptor, %JSON.Adaptor)
{

Property Username As %String [ SqlColumnNumber = 2 ];

Property Password As %String [ SqlColumnNumber = 3 ];

Property ISS As %String [ SqlColumnNumber = 4 ];

Property PrivateKey As %String [ SqlColumnNumber = 5 ];

Property ExpirationTime As %Integer [ InitialExpression = 3600, SqlColumnNumber = 6 ];

Index UsernameIndex On Username [ Unique ];

Storage Default
{
<Data name="JWTCredentialDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Username</Value>
</Value>
<Value name="3">
<Value>Password</Value>
</Value>
<Value name="4">
<Value>ISS</Value>
</Value>
<Value name="5">
<Value>PrivateKey</Value>
</Value>
<Value name="6">
<Value>ExpirationTime</Value>
</Value>
</Data>
<DataLocation>^FrameworkCaed1C9.JWTCredentialD</DataLocation>
<DefaultData>JWTCredentialDefaultData</DefaultData>
<IdLocation>^FrameworkCaed1C9.JWTCredentialD</IdLocation>
<IndexLocation>^FrameworkCaed1C9.JWTCredentialI</IndexLocation>
<StreamLocation>^FrameworkCaed1C9.JWTCredentialS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
