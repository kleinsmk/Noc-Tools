#big ticketCSN-23291

New-JiraSession

$desc = Get-JiraIssue -Key CSN-23291

#split large description string by return lines
$desc = $desc.Description -split "`n"
#match username text lines
$users = ($desc | Select-String -Pattern "\[\d*][a-zA-Z0-9]*,\s*[a-zA-Z]*")

$newusers =  @( [PSCustomObject]@{'first' = ""; 'last' = ""; 'email' = "";} )

$usernames = @()
$email = @()

#store only first, last names in an array
foreach ($user in $users){
    $user -match "[a-zA-Z0-9]*,\s*[a-zA-Z]*"
    #$user = ($Matches[0] -split ",")
    
    $usernames += $Matches[0]
   
}
    
    #whole email line match with [3] numbers
    $mail = ($desc -match "[a-zA-Z0-9.!£#$%&'^_`{}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z09-]+)*$")

 foreach($address in $mail) {
     $address -match "[a-zA-Z0-9.!£#$%&'^_`{}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z09-]+)*$"
        
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
        
    }


}