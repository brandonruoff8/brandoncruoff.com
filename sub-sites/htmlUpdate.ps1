# This is a program that scrapes a website for Rocket League ranks and 
# Overwatch ranks and updates brandonruoff.com/gaming.html to have the most recent ranks

#Finds the ranks for Rocket League and puts them into a file
Function ConfigRLranks([REF]$outputValue)
{ 
    #initialize output file
    if(Test-Path "$activeDirectory\outputRL.txt")
    { 
        Write-Output "Clearing Rocket League output file"
        Clear-Content "$activeDirectory\outputRL.txt" 
    }
    else
    { 
        Write-Output "Creating Rocket League output file"
        New-Item "$activeDirectory\outputRL.txt"
    }
    
    #for each player in the list of players, find every RL rank
    foreach($playerSiteName in $playerSiteNameListRL)
    {
        Write-Output "Accessing Rocket League $playerSiteName ..."
        Add-Content "$activeDirectory\outputRL.txt" "$playerSiteName"
        #the url to the site that we will be scraping
        $site = "https://rocketleague.tracker.network/profile/$playerSiteName"
        #the actual contents of that site
        $websiteInfo = Invoke-WebRequest -Uri $site
        #send to file to be accessed later
        $websiteInfo | Export-Csv -NoTypeInformation -Force -Path ("$activeDirectory\scrapedRL.txt")
        #for each type of game, find the ranking associated with it
        foreach($gameType in $gameTypeList) 
        {
            try {
                #see if the site contains each rank type
                $containsString = Select-string -Pattern $gameType -Path $activeDirectory$scrapeFileRL -list
                $lineNumber = ($containsString.ToString()).split(":")[2] - 1
                $fullLine = Get-Content -Path $activeDirectory$scrapeFileRL | 
                    Select -Index $lineNumber
                $rankValue = ([string](Get-Content -Path $activeDirectory$scrapeFileRL | 
                    Select -Index ($lineNumber + 2))) + " "
                $rankValue = $rankValue.Trim(" ").Trim("]")
                if(!$rankValue) 
                {
                    $rankValue = "Unranked"
                }
                $rankValueLower = ($rankValue.toLower()) -replace " ", ""
                #Write-Output "$gametype has rank $rankValue"
                Add-Content "$activeDirectory\outputRL.txt" ("$gameType : $rankValue : $rankValueLower")
            }
            catch {
                Write-Output "Error getting $playerName profile information."
            }
        }
    }
}

#Finds the ranks for Overwatch and puts them into a file
Function ConfigOWranks()
{
    #Initialize output file
    if(Test-Path "$activeDirectory\outputOW.txt")
    { 
        Write-Output "Clearing Overwatch output file"
        Clear-Content "$activeDirectory\outputOW.txt" 
    }
    else
    { 
        Write-Output "Creating Overwatch output file"
        New-Item "$activeDirectory\outputOW.txt"
    }

    foreach($playerSiteName in $playerSiteNameListOW)
    {
        Write-Output "Accessing Overwatch $playerSiteName ..."
        Add-Content "$activeDirectory\outputOW.txt" "$playerSiteName"
        #the url to the site that we will be scraping
        try {
            $site = "https://overwatchtracker.com/profile/$playerSiteName"
            #the actual contents of that site
            $websiteInfo = Invoke-WebRequest -Uri $site
            $websiteInfo | Export-Csv -NoTypeInformation -Force -Path ("$activeDirectory\scrapedOW.txt")

            $skillString = "name: 'Skill Rating'"

            $containsString = Select-string -Pattern $skillString -Path $activeDirectory$scrapeFileOW -list
            $lineNumber = ($containsString.ToString()).split(":")[2] - 1
            $fullLine = Get-Content -Path $activeDirectory$scrapeFileOW | 
                Select -Index $lineNumber
            $rankValue = ([string](Get-Content -Path $activeDirectory$scrapeFileOW | 
                Select -Index ($lineNumber + 3))) + " "
            if($rankValue -match ',')
            {
                $rankValue = $rankValue.split(",") | Select-Object -Last 1
            }
            $rankValue = $rankValue.Trim(" ")
        }
        catch {
            $rankValue = "----"
        }
        #Write-Output "Competitive Rank: $rankValue"
        Add-Content "$activeDirectory\outputOW.txt" "$rankValue"
    }
    Add-Content "$activeDirectory\outputOW.txt" "global/xbox/daniedoodlez"
    Add-Content "$activeDirectory\outputOW.txt" "1866"
}

#Searches the html file and changes the ranks to what is listed in the output files
Function UpdateRLhtmlFile()
{
    $rl_file_path = $activeDirectory + "rocket-league.html"
    $rl_file = Get-Content -Path $rl_file_path
    $new_file_path = $activeDirectory + "newRLfile.html"
    #Initialize new file that will overide the existing file
    if(Test-Path $new_file_path)
    { 
        Clear-Content $new_file_path 
    }
    else
    { 
        New-Item $new_file_path 
    }
    $gameTypeTracker = 0;
    $gameType = $gameTypeList[$gameTypeTracker]
    $inputRankFileLineNum = 1;

    $inputRankFileLine = Get-Content -Path "$activeDirectory\outputRL.txt" | 
                Select -Index $inputRankFileLineNum
    $inputRankFileLineSplit = $inputRankFileLine.split(":")
    $playerName = $inputRankFileLineSplit[0].trim(" ")
    $rank = $inputRankFileLineSplit[1].trim(" ")
    $rankLower = $inputRankFileLineSplit[2].trim(" ")
    
    $lineNumber = 0

    foreach($line in $rl_file) 
    {
        $lineNumber++
        #Write-Output "Searching for $gameType", "html line: $line"
        if($line -match $gameType) 
        {
            Write-Output "Updating $gameType on line: $lineNumber"
            $line_new = "`t`t`t`t" +
            '<div class="rank-type" id="' +
            $gameType +
            '">' + 
            (Get-Culture).textinfo.totitlecase($gameType) + 
            '</div><div class="rank-value">' +
            $rank +
            '<img class="rank-icon" src="../pictures/rocket_league/' +
            $rankLower + 
            '_icon.png" alt="' +
            $rank +
            '"></div>'
            Add-Content $new_file_path $line_new
            #Go through each game type and change each rank for each person
            $gameTypeTracker++
            if($gameTypeTracker -gt 7)
            {
                $gameTypeTracker = 0;
                $inputRankFileLineNum++
                #Add-Content $temp_file_path $inputRankFileLine
            }
            $gameType = $gameTypeList[$gameTypeTracker]

            #move to the next rank to be updated
            $inputRankFileLineNum++
            $inputRankFileLine = Get-Content -Path "$activeDirectory\outputRL.txt" | 
                Select -Index $inputRankFileLineNum
            #Write-Output "Rank Line: $inputRankFileLine"
            if($inputRankFileLine){
                $inputRankFileLineSplit = $inputRankFileLine.split(":")
                $playerName = $inputRankFileLineSplit[0].trim(" ")
                $rank = $inputRankFileLineSplit[1].trim(" ")
                $rankLower = $inputRankFileLineSplit[2].trim(" ")
            }
        }
        else
        {
            Add-Content $new_file_path $line
        }
    }
}

Function updateOWhtmlFile()
{
    $ow_file_path = $activeDirectory + "overwatch.html"
    $ow_file = Get-Content -Path $ow_file_path
    $new_file_path = "$activeDirectory\newOWfile.html"
    #Initialize new file that will overide the existing file
    if(Test-Path $new_file_path)
    { 
        Clear-Content $new_file_path 
        Write-Output "Clearing Overwatch new file"
    }
    else
    { 
        New-Item $new_file_path 
        Write-Output "Creating Overwatch new file"
    }
    $inputRankFileLineNum = 0;

    $inputPlayerName = Get-Content -Path "$activeDirectory\outputOW.txt" | 
        Select -Index $inputRankFileLineNum
    $inputPlayerRank = Get-Content -Path "$activeDirectory\outputOW.txt" | 
        Select -Index ($inputRankFileLineNum + 1)
    
    $lineNumber = 0
    $stringOfInterest = 'sr-headline'

    foreach($line in $ow_file) 
    {
        $lineNumber++
        #Write-Output "Searching for ", "html line: $line"
        if($line -match $stringOfInterest) 
        {
            Write-Output "Updating $stringOfInterest on line: $lineNumber"
            $lineSplit = $line.split('>')
            $line_new = $lineSplit[0] + '> ' +
            $inputPlayerRank + ' SR </div>'
            Add-Content $new_file_path $line_new
            #Write-Output "Replacing line with: $line_new"

            #move to the next rank to be updated
            $inputRankFileLineNum = $inputRankFileLineNum + 2
            $inputPlayerName = Get-Content -Path "$activeDirectory\outputOW.txt" | 
                Select -Index $inputRankFileLineNum
            $inputPlayerRank = Get-Content -Path "$activeDirectory\outputOW.txt" | 
                Select -Index ($inputRankFileLineNum + 1)
        }
        else
        {
            Add-Content $new_file_path $line
        }
    }

}

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
(Get-Culture).textinfo.totitlecase

#Initialization section

$outputValue = @()

$activeDirectory = ($MyInvocation.MyCommand.Path)
$splitDirectory = $activeDirectory.split("\")
$endPiece = $splitDirectory[$splitDirectory.length - 1]
$activeDirectory = $activeDirectory.TrimEnd($endPiece)

$gameTypeList = "ranked standard", "ranked doubles", "ranked duel", "ranked solo standard",
    "hoops", "rumble", "dropshot", "snowday"

$playerSiteNameListRL = "xbox/the last gaymer", "xbox/rinoslayer", "xbox/jesus was ok", "xbox/whitewadewilson",
    "xbox/temporarygh0st", "xbox/smakemyakem", "steam/nauticalphasmid"

$playerSiteNameListOW = "global/xbox/the last gaymer", "global/xbox/jesus was ok", "global/xbox/whitewadewilson", 
    "global/xbox/rinoslayer", "pc/global/pippinish33-1441"#, "global/xbox/daniedoodlez"

$scrapeFileRL = "scrapedRL.txt"
$scrapeFileOW = "scrapedOW.txt"

ConfigRLranks([REF]$outputValue)
UpdateRLhtmlFile
ConfigOWranks
UpdateOWhtmlFile

#rename files so that the new files have the original names and the old 
#files get stored as "old ..."

Write-Output "Removing files used during execution..."

Remove-Item "$activeDirectory\outputRL.txt"
Remove-Item "$activeDirectory\outputOW.txt"
Remove-Item "$activeDirectory\scrapedRL.txt"
Remove-Item "$activeDirectory\scrapedOW.txt"

Write-Output "Changing names of files..."

Remove-Item "$activeDirectory\rocket-league-old.html"
Remove-Item "$activeDirectory\overwatch-old.html"

ren "$activeDirectory\rocket-league.html" "$activeDirectory\rocket-league-old.html"
ren "$activeDirectory\overwatch.html" "$activeDirectory\overwatch-old.html"
ren "$activeDirectory\newRLfile.html" "$activeDirectory\rocket-league.html"
ren "$activeDirectory\newOWfile.html" "$activeDirectory\overwatch.html"