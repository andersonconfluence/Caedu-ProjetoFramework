Class FrameworkCaedu.core.bo.rest.genericoperation.Response Extends Ens.Response
{

Property RestResponseVO As FrameworkCaedu.core.vo.RestResponse;

/// Subclass responsablity
Method DoSpecifAction(pArgs...)
{
}

Storage Default
{
<Data name="ResponseDefaultData">
<Subscript>"Response"</Subscript>
<Value name="1">
<Value>RestResponseVO</Value>
</Value>
</Data>
<DefaultData>ResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
