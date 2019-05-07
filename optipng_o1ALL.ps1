function DisplayInBytes($num) {
    $suffix = "B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"
    $index = 0
    while ($num -gt 1kb) {
        $num = $num / 1kb
        $index++
    }
    "{0:N2} {1}" -f $num, $suffix[$index]
}
$array = Get-ChildItem ".\" -Filter *.png
$cnt = $array.length
$tot_len = 0
$tot_len2 = 0
foreach ($item in $array) {
    $name = $item.Name
    $idx = $array.IndexOf($item)
    $len = $item.length
    $tot_len += $len
    Write-Output "Processing item $idx of $cnt : $name"
    optipng.exe -silent -o1 "$name"
    $item2 = Get-Item "$name"
    $len2 = $item2.length
    $tot_len2 += $len2
    $pct = ($len - $len2) * 100 / $len
    $os = "({0:N2}%) {1:N} -> {2:N}" -f $pct, $len, $len2
    Write-Output $os
}
$pct = ($tot_len - $tot_len2) * 100 / $tot_len
$tot_len_str = DisplayInBytes($tot_len)
$tot_len2_str = DisplayInBytes($tot_len2)
$os = "({0:N2}%) {1} -> {2}" -f $pct, $tot_len_str, $tot_len2_str
Write-Output "Processed $cnt items."
Write-Output $os