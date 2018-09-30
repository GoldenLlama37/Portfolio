[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
[xml]$XAML = @'
<Window Name="MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Spectre" Height="320.767" Width="690.041" >
    <Grid>
        <Grid.Background>
            <LinearGradientBrush EndPoint="0.5,1" StartPoint="0.5,0">
                <GradientStop Color="#000000" Offset="1"/>
                <GradientStop Color="#0000FF"/>
            </LinearGradientBrush>
        </Grid.Background>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="211*"/>
            <ColumnDefinition Width="117*"/>
        </Grid.ColumnDefinitions>
        <TextBlock HorizontalAlignment="Left" Margin="146,12,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Height="80" Width="440" FontSize="48" FontFamily="Goudy Stout Regular" Foreground="Red" Grid.ColumnSpan="2"><Run Text="Spectre"/><Run FontFamily="Nirmala UI" Text=""/></TextBlock>
        <Image HorizontalAlignment="Left" Height="109" Margin="265,119,0,0" VerticalAlignment="Top" Width="134" Source=".\motherpic.png"/>
        <RadioButton x:Name="Radio1" Content="Choose list from external file:" IsChecked="True" Foreground="Red" HorizontalAlignment="Left" Margin="56,85,0,0" VerticalAlignment="Top"/>
        <RadioButton x:Name="Radio2" Content="Use devices below:&#xD;&#xA;" HorizontalAlignment="Left" Foreground="Red" Margin="56,103,0,0" VerticalAlignment="Top" />
        <TextBox x:Name="InputBox" HorizontalAlignment="Left" Height="99" Margin="56,119,0,0" VerticalAlignment="Top" Width="166" VerticalScrollBarVisibility="Auto" ScrollViewer.CanContentScroll="True" AcceptsReturn="True"/>
        <TextBox x:Name="InputText" HorizontalAlignment="Left" Height="23" Margin="230,82,0,0" VerticalAlignment="Top" Width="314" ScrollViewer.CanContentScroll="True" Grid.ColumnSpan="2"/>
        <Button x:Name="ButtonBrowse" Content="Browse" HorizontalAlignment="Left" Margin="120,83,0,0" VerticalAlignment="Top" Width="75"  Grid.Column="1"/>
        <Button x:Name="ButtonScan" Content="Start Scanning" HorizontalAlignment="Left" Margin="56,233,0,0" VerticalAlignment="Top" Width="568" Height="24"  Grid.ColumnSpan="2"/>
        <TextBlock HorizontalAlignment="Left" Margin="234,113,0,0" TextWrapping="Wrap" Text="Returns computer location and user information" Foreground="Red" VerticalAlignment="Top" Grid.ColumnSpan="2"/>
        <TextBlock HorizontalAlignment="Left" Margin="454,129,0,0" TextWrapping="Wrap" Text="Created by Cody Young" VerticalAlignment="Top" Foreground="Red" Grid.ColumnSpan="2"/>
        <TextBlock HorizontalAlignment="Left" Margin="454,145,0,0" TextWrapping="Wrap" Text="For Swedish/Providence Hospital" VerticalAlignment="Top" Foreground="Red" Grid.ColumnSpan="2"/>

    </Grid>
</Window>
'@


$reader=(New-Object System.Xml.XmlNodeReader $xaml) 
$Form=[Windows.Markup.XamlReader]::Load( $reader )
$xaml.SelectNodes("//*[@Name]") | %{Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name)}
$erroractionpreference = "SilentlyContinue"
write-host "Your information is being processed now. Please wait. Your time is very 

important to us. You are the most important person in the world.  Trust us, for 
we are trustworthy. 

All your base are belong 2 us.

The cake is not a lie.

Thank you.
" -ForegroundColor Yellow 


#Mapping buttons to variables
$Radio1 = $Form.FindName("Radio1")
$Radio2 = $Form.FindName("Radio2")
$InputBox = $Form.FindName("InputBox")
$InputText = $Form.FindName("InputText")
$ButtonBrowse = $Form.FindName("ButtonBrowse")
$ButtonScan = $Form.FindName("ButtonScan")

#$Browsebutton opens the file explorer and populates $InputText with result
$ButtonBrowse.Add_Click({
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.initialDirectory = $initialDirectory
    $OpenFileDialog.filter = "Text Files(*.TXT;*.CSV;*.DOC, *.XLSX)|*.TXT;*.CSV;*.DOC, *.XLSX|All files (*.*)|*.*"
    $OpenFileDialog.ShowDialog() | Out-Null
    $InputText.text = $OpenFileDialog.filename
    if ($radio2.isChecked){
        $radio1.IsChecked = $true}
})

#Autoselects radio 2 if key is pressed in $InputBox
$inputbox.Add_KeyDown({
    if ($Radio1.IsChecked) {
        $Radio2.IsChecked = $true
    }
})
$form.Controls.Add($inputbox)

#Autoselects radio 1 if key is pressed in $InputText
$inputtext.Add_KeyDown({
    if ($Radio2.IsChecked) {
        $Radio1.IsChecked = $true
    }
})

#supress error messages
#$erroractionpreference = "SilentlyContinue"
    

#Click ButtonScan and it starts scanning
$ButtonScan.Add_Click({

function last3 
    {
    [CmdletBinding()]
      param(
      [Parameter( Position=0,Mandatory=$true)]
      [string]$ComputerName
      )
if (Test-Connection -Computername $ComputerName -BufferSize 16 -Count 1 -Quiet){
    ####Retrieve Usernames
    $last3name1 = Get-Childitem "\\$ComputerName\c$\Users" | sort-object -Descending LastWriteTime | Select -ExpandProperty Name | Select-object -First 1 
    $last3name2 = Get-Childitem "\\$ComputerName\c$\Users" | sort-object -Descending LastWriteTime | Select -ExpandProperty Name | Select-Object -skip 1 | Select-Object -First 1 
    $last3name3 = Get-Childitem "\\$ComputerName\c$\Users" | sort-object -Descending LastWriteTime | Select -ExpandProperty Name | Select-Object -skip 2 | Select-Object -First 1 

    ####Retrieves write times
    $last3write1 = Get-Childitem "\\$ComputerName\c$\Users" | sort-object -Descending LastWriteTime | Select -ExpandProperty LastWriteTime | Select -First 1 
    $last3write2 = Get-Childitem "\\$ComputerName\c$\Users" | sort-object -Descending LastWriteTime | Select -ExpandProperty LastWriteTime | Select-Object -skip 1 | Select -First 1 
    $last3write3 = Get-Childitem "\\$ComputerName\c$\Users" | sort-object -Descending LastWriteTime | Select -ExpandProperty LastWriteTime | Select-Object -skip 2 | Select -First 1

#####################-----------------------------------First names------------------------------------################
    #$Currentuser 1 First Name
    $Currentuser = (Get-WmiObject -Class win32_computersystem -ComputerName $computername).UserName
    $Currentuser = $Currentuser -replace "ADI\\", ""
    $Currentuser = $Currentuser -replace "PHSWA\\", ""
    $CurrentUserInfo1 =@()
    $domains = "wa.providence.org","adi.swedish.org"
    foreach($domain in $domains){
         $Currentuser = get-aduser $currentuser -server $domain -Properties name | select Givenname
         $Currentuser = $currentuser -replace "@{Givenname=", ""
         $Currentuser = $currentuser -replace "}", ""
         $currentuser = $Currentuser -replace "; department=", ", "
         $Currentuserinfo1 = $Currentuser}


    #$Currentuser 2 First Name
    $CurrentUserInfo2 =@()
    $domains = "wa.providence.org","adi.swedish.org"
    foreach($domain in $domains){
         $Currentuser = get-aduser $last3name2 -server $domain -Properties name | select Givenname
         $Currentuser = $currentuser -replace "@{Givenname=", ""
         $Currentuser = $currentuser -replace "}", ""
         $currentuser = $Currentuser -replace "; department=", ", "
         $CurrentUserInfo2 = $Currentuser}

    #$Currentuser 3 First Name
    $Currentuser = (Get-WmiObject -Class win32_computersystem -ComputerName $computername).UserName
    $Currentuser = $Currentuser -replace "ADI\\", ""
    $Currentuser = $Currentuser -replace "PHSWA\\", ""
    $CurrentUserInfo3 =@()
    $domains = "wa.providence.org","adi.swedish.org"
    foreach($domain in $domains){
         $Currentuser = get-aduser $last3name3 -server $domain -Properties name | select Givenname
         $Currentuser = $currentuser -replace "@{Givenname=", ""
         $Currentuser = $currentuser -replace "}", ""
         $currentuser = $Currentuser -replace "; department=", ", "
         $CurrentUserInfo3 = $Currentuser}

#################------------------------------------Last names------------------------------------################
    #$Currentuser 1 Last Name
    $Currentuser = (Get-WmiObject -Class win32_computersystem -ComputerName $computername).UserName
    $Currentuser = $Currentuser -replace "ADI\\", ""
    $Currentuser = $Currentuser -replace "PHSWA\\", ""
    $CurrentUserInfo11 =@()
    $domains = "wa.providence.org","adi.swedish.org"
    foreach($domain in $domains){
         $Currentuser = get-aduser $currentuser -server $domain -Properties name | select surname
         $Currentuser = $currentuser -replace "@{surname=", ""
         $Currentuser = $currentuser -replace "}", ""
         $currentuser = $Currentuser -replace "; department=", ", "
         $Currentuserinfo11 = $Currentuser}


    #$Currentuser 2 Last Name
    $CurrentUserInfo21 =@()
    $domains = "wa.providence.org","adi.swedish.org"
    foreach($domain in $domains){
         $Currentuser = get-aduser $last3name2 -server $domain -Properties name | select surname
         $Currentuser = $currentuser -replace "@{surname=", ""
         $Currentuser = $currentuser -replace "}", ""
         $currentuser = $Currentuser -replace "; department=", ", "
         $CurrentUserInfo21 = $Currentuser}

    #$Currentuser 3 Last Name
    $Currentuser = (Get-WmiObject -Class win32_computersystem -ComputerName $computername).UserName
    $Currentuser = $Currentuser -replace "ADI\\", ""
    $Currentuser = $Currentuser -replace "PHSWA\\", ""
    $CurrentUserInfo31 =@()
    $domains = "wa.providence.org","adi.swedish.org"
    foreach($domain in $domains){
         $Currentuser = get-aduser $last3name3 -server $domain -Properties name | select surname
         $Currentuser = $currentuser -replace "@{surname=", ""
         $Currentuser = $currentuser -replace "}", ""
         $currentuser = $Currentuser -replace "; department=", ", "
         $CurrentUserInfo31 = $Currentuser}
#####-----------------------------AD Department------------------####
    #CurrentUser 1 Department
    $Currentuser = (Get-WmiObject -Class win32_computersystem -ComputerName $computername).UserName
    $Currentuser = $Currentuser -replace "ADI\\", ""
    $Currentuser = $Currentuser -replace "PHSWA\\", ""
    $CurrentUserInfo111 =@()
    $domains = "wa.providence.org","adi.swedish.org"
    foreach($domain in $domains){
         $Currentuser = get-aduser $currentuser -server $domain -Properties department | select department
         $Currentuser = $currentuser -replace "@{department=", ""
         $Currentuser = $currentuser -replace "}", ""
         $Currentuserinfo111 = $Currentuser}

    #CurrentUser 2 Department
    $CurrentUserInfo211 =@()
    $domains = "wa.providence.org","adi.swedish.org"
    foreach($domain in $domains){
         $Currentuser = get-aduser $last3name2 -server $domain -Properties department | select department
         $Currentuser = $currentuser -replace "@{department=", ""
         $Currentuser = $currentuser -replace "}", ""
         $CurrentUserInfo211 = $Currentuser}

    #CurrentUser 3 Department
    $Currentuser = (Get-WmiObject -Class win32_computersystem -ComputerName $computername).UserName
    $Currentuser = $Currentuser -replace "ADI\\", ""
    $Currentuser = $Currentuser -replace "PHSWA\\", ""
    $CurrentUserInfo311 =@()
    $domains = "wa.providence.org","adi.swedish.org"
    foreach($domain in $domains){
         $Currentuser = get-aduser $last3name3 -server $domain -Properties department | select department
         $Currentuser = $currentuser -replace "@{department=", ""
         $Currentuser = $currentuser -replace "}", ""
         $CurrentUserInfo311 = $Currentuser}
##---------------------------User Desc-----------------------------##
    $DB = Import-Csv -path ".\TomsDB.csv"
    $lookupFirst = $DB | group-object -AsHashTable -Property FIRSTNAME 
    $lookuplast = $DB | group-object -AsHashTable -Property LASTNAME 


    #emp1
        If ($DB |?{(($_.FIRSTNAME -match "$CurrentUserInfo1") -and ($_.LASTNAME -match "$CurrentUserInfo11"))}) {
            $DeptCode1 = $DB |?{(($_.FIRSTNAME -match "$CurrentUserInfo1") -and ($_.LASTNAME -match "$CurrentUserInfo11"))} | select -Property DEPTCODE 
            $DeptCode1 = $DeptCode1 -replace "@{DEPTCODE=", ""
            $DeptCode1 = $DeptCode1 -replace "}", ""
            $DeptDesc1 = $DB |?{(($_.FIRSTNAME -match "$CurrentUserInfo1") -and ($_.LASTNAME -match "$CurrentUserInfo11"))} | select -Property DEPTDESC
            $DeptDesc1 = $DeptDesc1 -replace "@{DEPTDESC=", ""
            $DeptDesc1 = $DeptDesc1 -replace "}", ""
            $JobDesc1 = $DB |?{(($_.FIRSTNAME -match "$CurrentUserInfo1") -and ($_.LASTNAME -match "$CurrentUserInfo11"))} | select -Property JOBDESC
            $JobDesc1 = $JobDesc1 -replace "@{JOBDESC=", ""
            $JobDesc1 = $JobDesc1 -replace "}", ""
            $LOCDESC1 = $DB |?{(($_.FIRSTNAME -match "$CurrentUserInfo1") -and ($_.LASTNAME -match "$CurrentUserInfo11"))} | select -Property LOCDESC
            $LOCDESC1 = $LOCDESC1 -replace "@{LOCDESC=", ""
            $LOCDESC1 = $LOCDESC1 -replace "}", ""
            $ADDR1 = $DB |?{(($_.FIRSTNAME -match "$CurrentUserInfo1") -and ($_.LASTNAME -match "$CurrentUserInfo11"))} | select -Property ADDR1
            $ADDR1 = $ADDR1 -replace "@{ADDR1=", ""
            $ADDR1 = $ADDR1 -replace "}", ""
            $City1 = $DB |?{(($_.FIRSTNAME -match "$CurrentUserInfo1") -and ($_.LASTNAME -match "$CurrentUserInfo11"))} | select -Property CITY
            $City1 = $City1 -replace "@{CITY=", ""
            $City1 = $City1 -replace "}", ""
        } else {
            $DeptCode1 = "No users found in Lawson codes database"}


    #emp2
        If ($DB |?{(($_.FIRSTNAME -match "$CurrentUserInfo2") -and ($_.LASTNAME -match "$CurrentUserInfo21"))}) {
            $DeptCode2 = $DB |?{(($_.FIRSTNAME -match "$CurrentUserInfo2") -and ($_.LASTNAME -match "$CurrentUserInfo21"))} | select -Property DEPTCODE 
            $DeptCode2 = $DeptCode2 -replace "@{DEPTCODE=", ""
            $DeptCode2 = $DeptCode2 -replace "}", ""
            $DeptDesc2 = $DB |?{(($_.FIRSTNAME -match "$CurrentUserInfo2") -and ($_.LASTNAME -match "$CurrentUserInfo21"))} | select -Property DEPTDESC
            $DeptDesc2 = $DeptDesc2 -replace "@{DEPTDESC=", ""
            $DeptDesc2 = $DeptDesc2 -replace "}", ""
            $JobDesc2 = $DB |?{(($_.FIRSTNAME -match "$CurrentUserInfo2") -and ($_.LASTNAME -match "$CurrentUserInfo21"))} | select -Property JOBDESC
            $JobDesc2 = $JobDesc2 -replace "@{JOBDESC=", ""
            $JobDesc2 = $JobDesc2 -replace "}", ""
            $LOCDESC2 = $DB |?{(($_.FIRSTNAME -match "$CurrentUserInfo2") -and ($_.LASTNAME -match "$CurrentUserInfo21"))} | select -Property LOCDESC
            $LOCDESC2 = $LOCDESC2 -replace "@{LOCDESC=", ""
            $LOCDESC2 = $LOCDESC2 -replace "}", ""
            $ADDR2 = $DB |?{(($_.FIRSTNAME -match "$CurrentUserInfo2") -and ($_.LASTNAME -match "$CurrentUserInfo21"))} | select -Property ADDR1
            $ADDR2 = $ADDR2 -replace "@{ADDR1=", ""
            $ADDR2 = $ADDR2 -replace "}", ""
            $City2 = $DB |?{(($_.FIRSTNAME -match "$CurrentUserInfo2") -and ($_.LASTNAME -match "$CurrentUserInfo21"))} | select -Property CITY
            $City2 = $City2 -replace "@{CITY=", ""
            $City2 = $City2 -replace "}", ""
        } else {
            $DeptCode2 = "No users found in Lawson codes database"}


    #emp3
        If ($DB |?{(($_.FIRSTNAME -match "$CurrentUserInfo3") -and ($_.LASTNAME -match "$CurrentUserInfo31"))}) {
            $DeptCode3 = $DB |?{(($_.FIRSTNAME -match "$CurrentUserInfo3") -and ($_.LASTNAME -match "$CurrentUserInfo31"))} | select -Property DEPTCODE 
            $DeptCode3 = $DeptCode3 -replace "@{DEPTCODE=", ""
            $DeptCode3 = $DeptCode3 -replace "}", ""
            $DeptDesc3 = $DB |?{(($_.FIRSTNAME -match "$CurrentUserInfo3") -and ($_.LASTNAME -match "$CurrentUserInfo31"))} | select -Property DEPTDESC
            $DeptDesc3 = $DeptDesc3 -replace "@{DEPTDESC=", ""
            $DeptDesc3 = $DeptDesc3 -replace "}", ""
            $JobDesc3 = $DB |?{(($_.FIRSTNAME -match "$CurrentUserInfo3") -and ($_.LASTNAME -match "$CurrentUserInfo31"))} | select -Property JOBDESC
            $JobDesc3 = $JobDesc3 -replace "@{JOBDESC=", ""
            $JobDesc3 = $JobDesc3 -replace "}", ""
            $LOCDESC3 = $DB |?{(($_.FIRSTNAME -match "$CurrentUserInfo3") -and ($_.LASTNAME -match "$CurrentUserInfo31"))} | select -Property LOCDESC
            $LOCDESC3 = $LOCDESC3 -replace "@{LOCDESC=", ""
            $LOCDESC3 = $LOCDESC3 -replace "}", ""
            $ADDR3 = $DB |?{(($_.FIRSTNAME -match "$CurrentUserInfo3") -and ($_.LASTNAME -match "$CurrentUserInfo31"))} | select -Property ADDR1
            $ADDR3 = $ADDR3 -replace "@{ADDR1=", ""
            $ADDR3 = $ADDR3 -replace "}", ""
            $City3 = $DB |?{(($_.FIRSTNAME -match "$CurrentUserInfo3") -and ($_.LASTNAME -match "$CurrentUserInfo31"))} | select -Property CITY
            $City3 = $City3 -replace "@{CITY=", ""
            $City3 = $City3 -replace "}", ""
            } else {
            $DeptCode3 = "No users found in Lawson codes database"}



###########-------------DHCP Scope and Subnet Calculator---------------################
#$DHCPScope
    #Retrieves IP address and splits octets into an array 
    $ip = Test-Connection -ComputerName $ComputerName -Count 1
    $octets = $ip.IPV4Address.IPAddressToString 
    $octets = $octets.split('.')
       

    ##Discovers and converts ip address to proper network address
    $subnet = Get-WmiObject -ComputerName $Computername Win32_NetworkAdapterConfiguration | Where-Object { $_.IPAddress -ne $null }
    $subnet = $subnet.ipsubnet[0]
    switch ($subnet) {
        255.255.255.252 {$octets = $octets[0],$octets[1],$octets[2],($octets[3] = $octets[3] - ($octets[3] % 4))}
        255.255.255.248 {$octets = $octets[0],$octets[1],$octets[2],($octets[3] = $octets[3] - ($octets[3] % 8))}
        255.255.255.240 {$octets = $octets[0],$octets[1],$octets[2],($octets[3] = $octets[3] - ($octets[3] % 16))}
        255.255.255.224 {$octets = ($octets[0],$octets[1],$octets[2],($octets[3] = $octets[3] - ($octets[3] % 32)))}
        255.255.255.192 {$octets = ($octets[0],$octets[1],$octets[2],($octets[3] = $octets[3] - ($octets[3] % 64)))}
        255.255.255.128 {if ($octets[3] -ge 128) {
                            $octets = ($octets[0],$octets[1],$octets[2],($octets[3] = $octets[3] - ($octets[3] % 128)))
                            } else {
                            $octets = ($octets[0],$octets[1],$octets[2],($octets[3]=0))}}
        255.255.255.0 {$octets = $octets[0],$octets[1],$octets[2],($octets[3] = 0)}
        255.255.254.0 {$octets = $octets[0],$octets[1], ($octets[2] = $octets[2] - ($octets[2] % 2)),($octets[3] = 0)}
        255.255.252.0 {$octets = $octets[0],$octets[1], ($octets[2] = $octets[2] - ($octets[2] % 4)),($octets[3] = 0)}
        255.255.248.0 {$octets = $octets[0],$octets[1], ($octets[2] = $octets[2] - ($octets[2] % 8)),($octets[3] = 0)}
        255.255.240.0 {$octets = $octets[0],$octets[1], ($octets[2] = $octets[2] - ($octets[2] % 16)),($octets[3] = 0)}
        255.255.224.0 {$octets = $octets[0],$octets[1], ($octets[2] = $octets[2] - ($octets[2] % 32)),($octets[3] = 0)}
        255.255.192.0 {$octets = $octets[0],$octets[1], ($octets[2] = $octets[2] - ($octets[2] % 64)),($octets[3] = 0)}
        255.255.128.0 {if ($octets[2] -ge 128) {
                            $octets = ($octets[0],$octets[1],($octets[2] = $octets[2] - ($octets[2] % 128),($octets[3] = 0)))
                            } else {
                            $octets = ($octets[0],$octets[1],($octets[2]=0),($octets[3]=0))}}
        255.255.0.0 {$octets = $octets[0],$octets[1], ($octets[2] = 0),($octets[3] = 0)}
        255.254.0.0 {$octets = $octets[0],($octets[1] = $octets[1] - ($octets[1] % 2), ($octets[2] = 0)),($octets[3] = 0)}
        255.252.0.0 {$octets = $octets[0],($octets[1] = $octets[1] - ($octets[1] % 4), ($octets[2] = 0)),($octets[3] = 0)}
        255.248.0.0 {$octets = $octets[0],($octets[1] = $octets[1] - ($octets[1] % 8), ($octets[2] = 0)),($octets[3] = 0)}
        255.240.0.0 {$octets = $octets[0],($octets[1] = $octets[1] - ($octets[1] % 16), ($octets[2] = 0)),($octets[3] = 0)}
        255.224.0.0 {$octets = $octets[0],($octets[1] = $octets[1] - ($octets[1] % 32), ($octets[2] = 0)),($octets[3] = 0)}
        255.192.0.0 {$octets = $octets[0],($octets[1] = $octets[1] - ($octets[1] % 64), ($octets[2] = 0)),($octets[3] = 0)}
        255.128.0.0 {if ($octets[2] -ge 128) {
                            $octets = ($octets[0],($octets[1] = $octets[1] - ($octets[1] % 128),($octets[2] = 0),($octets[3] = 0)))
                            } else {
                            $octets = ($octets[0],($octets[1]=0),($octets[2]=0),($octets[3]=0))}}
        255.0.0.0 {$octets = $octets[0], ($octets[1] = 0),($octets[2] = 0), ($octets[3] = 0)}
        }
    $networkaddress = $octets -join '.'

    #Compares Network address to DHCP Scopes CSV
    $scopes = import-csv -path ".\DHCP_Scopes.csv"
    $lookup = $scopes | group-object -AsHashTable -Property subnet
    $location = $lookup.$networkaddress.description

    $DHCPScope = if ($location -eq $null) {
         "Unavailable"
         } else {
         "$location"}  ####End of DHCP Scopes section

###---------------------Build table---------------------------###

    #######Tables to be returned to csv
    $obj_list = [pscustomobject]@{
    ComputerName = $ComputerName
    Name = $last3name1
    WriteTime = $last3write1
    FirstNameUser = $CurrentuserInfo1
    LastNameUser = $CurrentUserInfo11
    AD_Dept = $Currentuserinfo111
    LawsonDept = $DEPTCODE1
    DEPTDESC = $DEPTDESC1
    JOBDESC = $JobDesc1
    LOCDESC = $LocDesc1
    ADDR1 = $Addr1
    City1 = $City1
    }
    $obj_list2 = [pscustomobject]@{
    ComputerName = ""
    Name = $last3name2
    WriteTime = $last3write2
    FirstNameUser = $CurrentUserInfo2
    LastNameUser = $CurrentUserInfo21
    AD_Dept = $Currentuserinfo211
    LawsonDept = $DEPTCODE2
    DEPTDESC = $DeptDesc2
    JOBDESC = $JobDesc2
    LOCDESC = $LocDesc2
    ADDR1 = $Addr2
    City1 = $City2
    }
    $obj_list3 = [pscustomobject]@{
    ComputerName = ""
    Name = $last3name3
    WriteTime = $last3write3
    FirstNameUser = $CurrentUserInfo3
    LastNameUser = $CurrentUserInfo31
    AD_Dept = $Currentuserinfo311
    LawsonDept = $DEPTCODE3
    DEPTDESC = $DeptDesc3
    JOBDESC = $JobDesc3
    LOCDESC = $LocDesc3
    ADDR1 = $Addr3
    City1 = $City3
    }
    $obj_list4 = [pscustomobject]@{
    ComputerName = ""
    Name = "Location by IP:"
    WriteTime = $location
    }
    $obj_list5 = [pscustomobject]@{}
    return $obj_list, $obj_list2, $obj_list3, $obj_list4,$obj_list5
    }
} else {
    $DeptDesc1 = "$Computername is offline"
    $obj_list = [pscustomobject]@{
    Computername = $DeptDesc1}
    return $obj_list
    } 

If ($Radio1.isChecked){
    $searchpath = (get-content $InputText.text).trim()
    }
else{
    $Searchpath = $Inputbox.text
    "$searchpath" | out-file .\tempcompfile.txt
    $searchpath = (get-content .\tempcompfile.txt).trim()
    }
$list = $Searchpath

$TotalCount = $list.count
$Counter = 1 

$data = @()
foreach ($item in $list) {
    write-host "[$Counter/$TotalCount] " -foreground Yellow -nonewline; Write-host "Now checking $item " -foreground White
    $data += last3 -ComputerName $item
    $Counter += 1
    }

$data | Export-Csv .\TomsScriptResults.csv -NoTypeInformation
.\TomsScriptResults.csv
})

$Form.ShowDialog() | out-null

$User

