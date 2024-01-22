Class FrameworkCaedu.core.bo.mail.sendMail.Request Extends Ens.Request
{

/// Values separeted by comma (,)
Property Recipients As %String(MAXLEN = "");

Property IsHtml As %Boolean [ InitialExpression = 0 ];

Property IsBinary As %Boolean [ InitialExpression = 0 ];

Property Subject As %String(MAXLEN = 100);

Property Text As %String(MAXLEN = "");

Storage Default
{
<Data name="RequestDefaultData">
<Subscript>"Request"</Subscript>
<Value name="1">
<Value>Recipients</Value>
</Value>
<Value name="2">
<Value>IsHtml</Value>
</Value>
<Value name="3">
<Value>IsBinary</Value>
</Value>
<Value name="4">
<Value>Subject</Value>
</Value>
<Value name="5">
<Value>Text</Value>
</Value>
</Data>
<DefaultData>RequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
