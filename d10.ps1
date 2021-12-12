$session = New-Object Microsoft.Powershell.Commands.WebRequestSession
$cookie = New-Object System.Net.Cookie
$cookie.Name = "session"
$cookie.Value = Get-Content -Path ".\cookie.txt"
$cookie.Domain = ".adventofcode.com"
$session.Cookies.Add($cookie)

$response = Invoke-WebRequest -Uri "https://adventofcode.com/2021/day/10/input" -WebSession $session -UseBasicParsing
$content = [System.Collections.ArrayList]$response.Content.split()
$content.RemoveAt($content.Count-1)

$toterr = 0
$comp = New-Object System.Collections.Generic.List[System.Object]

foreach ($line in $content) {

    $stack = New-Object System.Collections.Generic.List[System.Object]
    $err = 0

    switch ($line.ToCharArray()) {
        '(' { $stack.Add('(') }
        '[' { $stack.Add('[') }
        '{' { $stack.Add('{') }
        '<' { $stack.Add('<') }
        ')' { if ($stack[-1] -eq '(') { $stack.RemoveAt($stack.Count-1) } else { $err += 3; break }}
        ']' { if ($stack[-1] -eq '[') { $stack.RemoveAt($stack.Count-1) } else { $err += 57; break }}
        '}' { if ($stack[-1] -eq '{') { $stack.RemoveAt($stack.Count-1) } else { $err += 1197; break }}
        '>' { if ($stack[-1] -eq '<') { $stack.RemoveAt($stack.Count-1) } else { $err += 25137; break }}
    }
    $toterr += $err
    if ($err -ne 0) { continue }
    $stack.Reverse()
    $i = 0
    foreach ($char in $stack) {
        $i = $i * 5
        switch ($char) {
            '(' { $i += 1 }
            '[' { $i += 2 }
            '{' { $i += 3 }
            '<' { $i += 4 }
        }
    }

    $comp.Add($i)
}

#part 1
$toterr

#part 2
$comp = $comp | Sort-Object
$comp[($comp.Count-1)/2]