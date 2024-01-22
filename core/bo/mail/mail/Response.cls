Class FrameworkCaedu.core.bo.mail.sendMail.Response Extends Ens.Response
{

Property StatusCode As %Status;

Property StatusMessage As %String;

Storage Default
{
<Data name="ResponseDefaultData">
<Subscript>"Response"</Subscript>
<Value name="1">
<Value>StatusCode</Value>
</Value>
<Value name="2">
<Value>StatusMessage</Value>
</Value>
</Data>
<DefaultData>ResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
