$session = New-Object Microsoft.Powershell.Commands.WebRequestSession
$cookie = New-Object System.Net.Cookie
$cookie.Name = "session"
$cookie.Value = Get-Content -Path ".\cookie.txt"
$cookie.Domain = ".adventofcode.com"
$session.Cookies.Add($cookie)

$response = Invoke-WebRequest -Uri "https://adventofcode.com/2021/day/9/input" -WebSession $session -UseBasicParsing
$content = $response.Content.split()

$BassinSizes = New-Object System.Collections.Generic.List[System.Object]
$done = New-Object System.Collections.Generic.List[System.Object]
$i = 0

for ($row = 0; $row -lt 100; $row++) {
    for ($column = 0; $column -lt 100; $column++) {
        if ($content[$row][$column] -like 9) { continue }
        if ($done.Contains("$row,$column")) { continue }

        $stack = New-Object System.Collections.Generic.List[System.Object]
        $stack.Add(@($row,$column))
        $BassinSizes.Add(0);

        while ($stack.Count -ne 0) {
            $loc = $stack[0]
            $stack.RemoveAt(0)
            if ($BassinSizes -ge 1000) {
                Out-Host "test"
            }
            if ($content[$loc[0]][$loc[1]] -like 9) { continue }
            if ($done.Contains("$($loc[0]),$($loc[1])")) { continue }
            $BassinSizes[$i]++
            $done.Add("$($loc[0]),$($loc[1])")
            if ($loc[0] -ne 0) { $stack.Add(@(($loc[0]-1),$loc[1])) }
            if ($loc[0] -ne 99) { $stack.Add(@(($loc[0]+1),$loc[1])) }
            if ($loc[1] -ne 0) { $stack.Add(@($loc[0],($loc[1]-1))) }
            if ($loc[1] -ne 99) { $stack.Add(@(($loc[0]),($loc[1]+1))) }
        }
        $i++
    }
}