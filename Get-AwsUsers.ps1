Function Get-AwsUsers {

    [cmdletBinding()]
    param(
                
        [Parameter(Mandatory=$true)]
        [string]$ticket=''

    )
<#
.SYNOPSIS
    Creats an AD group and adds AWS users found in a specified CSN ticket.

.PARAMETER ticket

    Name of ticket with user info

.EXAMPLE
    Add-Acl -name Existing_ACL_Name -action allow -dstStartPort 80 -dstEndPort 80 -dstSubnet 192.168.1.1/24

#>

#big ticketCSN-27846  -24888 doesn't work

$desc = Get-JiraIssue -Key $ticket

#split large description string by return lines
$desc = $desc.Description -split "`n"
#match username text lines
$users = ($desc | Select-String -Pattern "\[\d*][a-zA-Z0-9]*,\s**[a-zA-Z]")

$newusers =  @( [PSCustomObject]@{'first' = ""; 'last' = ""; 'email' = "";} )

$usernames = @()
$email = @()

#store only first, last names in an array
foreach ($user in $users){
    $user -match "[a-zA-Z0-9]*,\s*[a-zA-Z]*" | Out-Null
    #$user = ($Matches[0] -split ",")
    
    $usernames += $Matches[0]
   
}
    
    #whole email line match with [3] numbers
    $mail = ($desc -match "[a-zA-Z0-9.!£#$%&'^_`{}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z09-]+)*")

 foreach($address in $mail) {
     $address -match "[a-zA-Z0-9.!£#$%&'^_`{}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z09-]+)*" | Out-Null
        
     if($Matches[0] -notlike "CloudServicesSupport@bah.com"){
         $email += $Matches[0]
     }
 }

 if ($email.Length -eq $usernames.Length){

    for($i=0; $i -lt $usernames.Length ; $i++){

          $firstAndLast = ($usernames[$i] -split ",")
          $last = $firstAndLast[0]
          $first = ($firstAndLast[1]).trimstart()
          
          $newusers += [PSCustomObject]@{'first' = "$first"; 'last' = "$last"; 'email' = $email[$i];}
        
    }#endfor
 }#endif

 $newusers | Sort-Object email | Get-Unique -AsString

}#end function
    