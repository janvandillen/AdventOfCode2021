$session = New-Object Microsoft.Powershell.Commands.WebRequestSession
$cookie = New-Object System.Net.Cookie
$cookie.Name = "session"
$cookie.Value = Get-Content -Path ".\cookie.txt"
$cookie.Domain = ".adventofcode.com"
$session.Cookies.Add($cookie)

$response = Invoke-WebRequest -Uri "https://adventofcode.com/2021/day/12/input" -WebSession $session -UseBasicParsing
$content = [System.Collections.ArrayList]$response.Content.split()
$content.RemoveAt($content.Count-1)

#$testContent = "start-A start-b A-c A-b b-d A-end b-end"
#$testContent = "fs-end he-DX fs-he start-DX pj-DX end-zg zg-sl zg-pj pj-he RW-he fs-DX pj-RW zg-RW start-pj he-WI zg-he pj-fs start-RW"
#$content = [System.Collections.ArrayList]$testContent.Split()

$map = @{}

for ($i = 0; $i -lt $content.Count; $i++) {
    $caves = $content[$i].Split("-")

    foreach ($cave in $caves) {
        if (!$map.ContainsKey($cave)) {
            $s = $cave -cmatch '\p{Lu}'
            $map[$cave] = @{
                "links" = @()
                "big" = $s
            }
        }
    }

    if (!$map[$caves[0]].links.Contains($caves[1])) { $map[$caves[0]].links += $caves[1] }
    if (!$map[$caves[1]].links.Contains($caves[0])) { $map[$caves[1]].links += $caves[0] }

}

#set to $true for part 1
$Vistited = $false

function get-Routes {
    param (
        [string]$fStart,
        $fMap,
        [string]$fPrevious,
        [bool]$fVistited
    )

    [string[]] $out = @()
    foreach ($link in $fMap[$fStart].links) {
        $newVistited = $fVistited
        if ($link -like "end") {
            $out += ($fPrevious + "," + $link)
            continue
        }
        if (!$fMap[$link].big -and $fPrevious -match $link) {
            if ($fVistited -or $link -like "start") { continue }
            $newVistited = $true
        }
        $r = [string[]] (get-Routes -fStart $link -fMap $fMap -fPrevious ($fPrevious + "," + $link) -fVistited $newVistited)
        if ($null -ne $r) { $out += $r }
    }
    return $out

}

$routes = get-Routes -fStart "start" -fMap $map -fPrevious @("start") -fVistited $Vistited
$routes.Count
