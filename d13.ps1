$session = New-Object Microsoft.Powershell.Commands.WebRequestSession
$cookie = New-Object System.Net.Cookie
$cookie.Name = "session"
$cookie.Value = Get-Content -Path ".\cookie.txt"
$cookie.Domain = ".adventofcode.com"
$session.Cookies.Add($cookie)

$response = Invoke-WebRequest -Uri "https://adventofcode.com/2021/day/13/input" -WebSession $session -UseBasicParsing
$content = [System.Collections.ArrayList]$response.Content.split()
$content.RemoveAt($content.Count-1)

#part selector
$p1 = $false

$matrix = [bool[][]]::new(1311)

for ($row = 0; $row -lt $matrix.Count; $row++) {
    $matrix[$row] = [bool[]]::new(895)
}

for ($cRow = 0; $cRow -lt $content.Count; $cRow++) {
    if ($content[$cRow] -match ",") {
        $loc = $content[$cRow].split(',')
        $matrix[$loc[0]][$loc[1]] = $true
    } elseif ($content[$cRow] -match "=") {
        $fold = $content[$cRow].split('=')
        $foldNb = [int]::Parse($fold[1])

        if ($fold[0] -like "x") {
            $newMatrix = $matrix[0..($foldNb-1)]
            for ($row = $foldNb + 1; $row -lt $matrix.Count; $row++) {
                for ($col = 0; $col -lt $matrix[$row].Count; $col++) {
                    if ($matrix[$row][$col]) { $newMatrix[(2*$foldNb-$row)][$col] = $true }
                }
            }
        } else {
            $newMatrix = [bool[][]]::new($matrix.Count)
            for ($i = 0; $i -lt $newMatrix.Count; $i++) {
                $newMatrix[$i] = [bool[]] $matrix[$i][0..($foldNb-1)]
            }
            for ($row = 0; $row -lt $matrix.Count; $row++) {
                for ($col = $foldNb + 1; $col -lt $matrix[$row].Count; $col++) {
                    if ($matrix[$row][$col]) { $newMatrix[$row][(2*$foldNb-$col)] = $true }
                }
            }
        }

        if ($p1) {
            $c = 0
            for ($row = 0; $row -lt $newMatrix.Count; $row++) {
                for ($col = 0; $col -lt $newMatrix[$row].Count; $col++) {
                    if ($newMatrix[$row][$col]) { $c++ }
                }
            }
            $c
            return
        }

        $matrix = $newMatrix
    }
}

for ($col = 0; $col -lt $Matrix[0].Count; $col++) {
    $str = ""
    for ($row = 0; $row -lt $Matrix.Count; $row++) {
        if ($matrix[$row][$col]) { $str += "#" }
        else { $str += "."}
    }
    $str
}