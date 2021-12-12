$session = New-Object Microsoft.Powershell.Commands.WebRequestSession
$cookie = New-Object System.Net.Cookie
$cookie.Name = "session"
$cookie.Value = Get-Content -Path ".\cookie.txt"
$cookie.Domain = ".adventofcode.com"
$session.Cookies.Add($cookie)

$response = Invoke-WebRequest -Uri "https://adventofcode.com/2021/day/11/input" -WebSession $session -UseBasicParsing
$content = [System.Collections.ArrayList]$response.Content.split()
$content.RemoveAt($content.Count-1)

#$testContent = "5483143223 2745854711 5264556173 6141336146 6357385478 4167524645 2176841721 6882881134 4846848554 5283751526"
#$content = [System.Collections.ArrayList]$testContent.Split()

$matrix = New-Object System.Collections.Generic.List[System.Object]

for ($row = 0; $row -lt $content.Count; $row++) {
    $matrix.Add((New-Object System.Collections.Generic.List[System.Object]))
    for ($col = 0; $col -lt $content[$row].Length; $col++) {
        $matrix[$row].Add([int]::Parse($content[$row][$col]))
    }
}

$flash = 0
$i = 0
$notAllFlash = $true

while ($notAllFlash) {
    $i++

    $stack = New-Object System.Collections.Generic.List[System.Object]

    for ($row = 0; $row -lt $matrix.Count; $row++) {
        #Write-Host -Object $matrix[$row]
        for ($col = 0; $col -lt $matrix[$row].Count; $col++) {
            $stack.Add(@($row,$col))
        }
    }

    #Write-Host ""

    while ($stack.Count -ne 0) {
        $loc = $stack[0]
        $stack.RemoveAt(0)

        $matrix[$loc[0]][$loc[1]] ++
        if ($matrix[$loc[0]][$loc[1]] -ne 10) { continue }

            $flash ++

        if ($loc[0] -eq 0) {
            $stack.Add(@(($loc[0]+1),$loc[1]))
            if ($loc[1] -ne 0) {
                $stack.Add(@(($loc[0]+1),($loc[1]-1)))
                $stack.Add(@($loc[0],($loc[1]-1)))
            } 
            if ($loc[1] -ne $matrix[0].Count-1) {
                $stack.Add(@(($loc[0]+1),($loc[1]+1)))
                $stack.Add(@($loc[0],($loc[1]+1)))
            }
        } elseif ($loc[0] -eq $matrix.Count-1) {
            $stack.Add(@(($loc[0]-1),$loc[1]))
            if ($loc[1] -ne 0) {
                $stack.Add(@(($loc[0]-1),($loc[1]-1)))
                $stack.Add(@($loc[0],($loc[1]-1)))
            } 
            if ($loc[1] -ne $matrix[0].Count-1) {
                $stack.Add(@(($loc[0]-1),($loc[1]+1)))
                $stack.Add(@($loc[0],($loc[1]+1)))
            }
        } else {
            $stack.Add(@(($loc[0]+1),$loc[1]))
            $stack.Add(@(($loc[0]-1),$loc[1]))
            if ($loc[1] -ne 0) {
                $stack.Add(@(($loc[0]+1),($loc[1]-1)))
                $stack.Add(@($loc[0],($loc[1]-1)))
                $stack.Add(@(($loc[0]-1),($loc[1]-1)))
            } 
            if ($loc[1] -ne $matrix[0].Count-1) {
                $stack.Add(@(($loc[0]+1),($loc[1]+1)))
                $stack.Add(@($loc[0],($loc[1]+1)))
                $stack.Add(@(($loc[0]-1),($loc[1]+1)))
            }
        }
    }

    $notAllFlash = $false

    for ($row = 0; $row -lt $matrix.Count; $row++) {
        for ($col = 0; $col -lt $matrix[$row].Count; $col++) {
            if ($matrix[$row][$col] -ge 10) { $matrix[$row][$col] = 0 }
            else { $notAllFlash = $true }
        }
    }

    #part1
    if ($i -eq 100) {
        $flash
    }
}

#part 2
$i