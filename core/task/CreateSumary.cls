Include Ensemble

Class FrameworkCaedu.core.task.CreateSumary Extends %SYS.Task.Definition
{

Parameter TaskName = "Create Linker Processing Sumary";

/// Unit of period to purge
Property PeriodToSumary As %String(DISPLAYLIST = ",Day,Weeks,Month,Year", VALUELIST = ",d,wk,mm,yy") [ InitialExpression = "mm" ];

/// Amount of period to purge
Property LengthOfPeriodToSumary As %Integer(MINVAL = 0) [ InitialExpression = 3 ];

Method OnTask() As %Status
{
	Set status = $$$OK
	Set tCount = 0
	
	Try
	{
	
		If (..PeriodToSumary = "")
		{
			Set status = $$$ERROR($$$GeneralError,"Incorrect Period for sumary Linker Messages task")
			Throw ##class(%Exception.StatusException).CreateFromStatus(status)
		}
		
		Set tNowUTC = $ZDate($ZTIMESTAMP,3)_" 00:00:00"
		Set tAmount = +..LengthOfPeriodToSumary		
		Set tCutOffDate = $SYSTEM.SQL.DATEADD(..PeriodToSumary,-tAmount,tNowUTC)
		
		Set query = "SELECT ProcessService As Service, Status , TO_CHAR(TimeCreated,'dd/mm/yyyy') As SumaryDate, count(*) As Quantity, SUM(DATALENGTH(Payload)) As SumarySize "_
					"FROM confluence_linker_core_data.Repository "_
					"Where TimeCreated >= ? "_
					"Group by ProcessService,Status,TO_CHAR(TimeCreated,'dd/mm/yyyy') "_
					"Order by Service,Status, SumaryDate"
		
		Set statement = ##class(%SQL.Statement).%New()
		Set status = statement.%Prepare(query)
		
		If $System.Status.IsError(status)
		{
			Throw ##class(%Exception.StatusException).CreateFromStatus(status)
		}
		
		Set resultStatement = statement.%Execute(tCutOffDate)
		
		While resultStatement.%Next()
		{
			Set service =  resultStatement.%Get("Service")
			Set statusSumary = resultStatement.%Get("Status")
			Set sumaryDate = $ZDateH(resultStatement.%Get("SumaryDate"),4)
			Set quantity = resultStatement.%Get("Quantity")
			Set sumarySize = resultStatement.%Get("SumarySize")
			Set service = ##class(FrameworkCaedu.core.data.Service).%OpenId(service)
			Set sumaryName = service.Instance.Name_" - "_service.Name
			
			Set sumaryLine = ##class(FrameworkCaedu.core.data.ProcessingSumary).UniqueIdxOpen(sumaryDate,sumaryName,statusSumary)
			
			If '$IsObject(sumaryLine) Set sumaryLine = ##class(FrameworkCaedu.core.data.ProcessingSumary).%New()
			
			Set sumaryLine.SumaryDate = sumaryDate
			Set sumaryLine.SumaryName = sumaryName
			Set sumaryLine.Service = service
			Set sumaryLine.Status = statusSumary
			Set sumaryLine.Quantity = quantity
			Set sumaryLine.Size = sumarySize
			
			Set status = sumaryLine.%Save()
			
			If $System.Status.IsError(status)
			{
				Throw ##class(%Exception.StatusException).CreateFromStatus(status)	
			}
			
			Set tCount = tCount + 1
		}
		
		$$$LOGINFO(tCount_" entries created from Linker Repository Table by Sumary Task")
	}
	Catch(exception)
	{
		If $System.Status.IsOK(status)
		{
			Set status = exception.AsStatus()
		}
				
		$$$LOGERROR("Error sumarizing Linker Messages "_ $$$StatusDisplayString(status))
	}	
	
	Quit status
}

}
