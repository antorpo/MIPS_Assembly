//**************************************
// Name: _String Replace (for real)
// Description:Replaces all occurances of a given substring with another substring in a String object. I looked for a good string replacer and all of them broke (replaced things multiple times, infinitely looped, etc), so I made one. Please let me know if this doesn't work, because if it doesn't work for you then it doesn't work for me! Thanks.
// By: Atul Brad Buono (from psc cd)
//
// Inputs:aSearch=The String to search
//aFind=The String to find
//aReplace=The String to replace aFind with
//
// Returns:Returns aSearch with all occurances of aFind replaced with aReplace
//**************************************

public static String replaceString(String aSearch, String aFind, String aReplace)
{
 String result = aSearch;
 if (result != null && result.length() > 0)
 {
int a = 0;
int b = 0;
while (true)
{
 a = result.indexOf(aFind, b);
 if (a != -1)
 {
result = result.substring(0, a) + aReplace + result.substring(a + aFind.length());
b = a + aReplace.length();
 }
 else
break;
}
 }
 return result;
}