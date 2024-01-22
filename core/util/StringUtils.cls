Class FrameworkCaedu.core.util.StringUtils Extends %RegisteredObject
{

/// Normalizes the string leaving the first character of each word in uppercase and the rest in lowercase	
ClassMethod NormalizeString(value As %String) As %String
{
	Set nomalizedString = ""
	For x=1:1:$Length(value," ")
	{
		Set word = $Piece(value," ",x)
		Set firstChar = $ZConvert($Extract(word,1,1),"U")
		Set restChars = $ZConvert($Extract(word,2,),"L")
		
		Set nomalizedString = nomalizedString_" "_firstChar_restChars
	}	
	
	Return nomalizedString
}

}
