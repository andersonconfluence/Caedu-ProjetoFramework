Class FrameworkCaedu.core.util.LookUp Extends (Ens.Rule.FunctionSet, %RegisteredObject)
{

// Chamada Exemplo: Set valor = ##class(FrameworkCaedu.core.util.LookUp).GetFromTo("1","1.1.5","Teste")

ClassMethod GetFromTo(pTable As %String, pKey As %String, pDefaultValue As %String) As %String
{
    Set tSC = $System.Status.OK()
    Set retVaue = ""
    If (pDefaultValue '="") 
    {
        Set retVaue = pDefaultValue
    }

    Set tSQL = "SELECT Value FROM confluence_linker_core_data.FromTo "
    Set tSQL = tSQL _"WHERE ReferenceFromToCode='" _pTable _"' AND Key='" _pKey _"' "
    Set tRS = ##Class(%ResultSet).%New()
    Set tSC = tRS.Prepare(tSQL)
    If ($System.Status.IsOK(tSC))
    {
        Set tSC = tRS.Execute()
    }
    If ($System.Status.IsOK(tSC))
    {
        While tRS.%Next() {
            Set retVaue = tRS.%Get("Value")
        }
    }
    
    Return retVaue
}

}
