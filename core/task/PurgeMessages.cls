Include Ensemble

Class FrameworkCaedu.core.task.PurgeMessages Extends %SYS.Task.Definition
{

Parameter TaskName = "Purge Linker Messages";

/// Unit of period to purge
Property PeriodToKeep As %String(DISPLAYLIST = ",Second,Minute,Hour,Day,Weeks,Month,Year", VALUELIST = ",s,mi,hh,d,wk,mm,yy") [ InitialExpression = "mm" ];

/// Amount of period to purge
Property LengthOfPeriodToKeep As %Integer(MINVAL = 0) [ InitialExpression = 3 ];

Method OnTask() As %Status
{
	Set status = $$$OK
	Set tCount = 0
	
	Try
	{
	
		If (..PeriodToKeep = "")
		{
			Set status = $$$ERROR($$$GeneralError,"Incorrect Period for purging Linker Messages task")
			Throw ##class(%Exception.StatusException).CreateFromStatus(status)
		}
		
		Set tNowUTC = $ZDateTime($ZTIMESTAMP,3)	
		Set tAmount = +..LengthOfPeriodToKeep
		
		Set tCutOffDate = $SYSTEM.SQL.DATEADD(..PeriodToKeep,-tAmount,tNowUTC)
		
		Set query = "SELECT Id FROM confluence_linker_core_data.Repository WHERE TimeCreated <= ?"	
		
		Set statement = ##class(%SQL.Statement).%New()
		Set status = statement.%Prepare(query)
		
		If $System.Status.IsError(status)
		{
			Throw ##class(%Exception.StatusException).CreateFromStatus(status)
		}
		
		Set resultStatement = statement.%Execute(tCutOffDate)
		
		While resultStatement.%Next()
		{
			Set status = ##class(FrameworkCaedu.core.data.Repository).%DeleteId(resultStatement.%Get("id"))
			
			If $System.Status.IsError(status)
			{
				Throw ##class(%Exception.StatusException).CreateFromStatus(status)	
			}
			
			Set tCount = tCount + 1
		}
		
		$$$LOGINFO(tCount_" entries purged from Linker Repository Table by purge task")
	}
	Catch(exception)
	{
		If $System.Status.IsOK(status)
		{
			Set status = exception.AsStatus()
		}
				
		$$$LOGERROR("Error purging Linker Messages "_ $$$StatusDisplayString(status))
	}	
	
	Quit status
}

}
