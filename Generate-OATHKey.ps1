function Convert-Base32ToHex($base32) {
    $base32chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567";
    $bits = "";
    $hex = "";

    for ($i = 0; $i -lt $base32.Length; $i++) {
        $val = $base32chars.IndexOf($base32.Chars($i));
        $binary = [Convert]::ToString($val, 2)
        $staticLen = 5
        $padder = '0'
        $bits += Add-LeftPad $binary.ToString()  $staticLen  $padder
    }

    for ($i = 0; $i+4 -le $bits.Length; $i+=4) {
        $chunk = $bits.Substring($i, 4)
        $intChunk = [Convert]::ToInt32($chunk, 2)
        $hexChunk = Convert-IntToHex($intChunk)
        $hex = $hex + $hexChunk
    }
    return $hex;
}
function Convert-IntToHex([int]$num) {
    return ('{0:x}' -f $num)
}

function Add-LeftPad($str, $len, $pad) {
    if(($len + 1) -ge $str.Length) {
        while (($len - 1) -ge $str.Length) {
            $str = ($pad + $str)
        }
    }
    return $str;
}

$Random = 1..32 | %{Get-Random -Minimum 0 -Maximum 32}
$Base32Chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"
$Base32Key = ""
$Random | %{$Base32Key += $Base32Chars[$_]}
Write-Host "Base32: " $Base32Key
Write-Host "Hex: " (Convert-Base32ToHex $Base32Key)
Remove-Variable Base32Key
Write-Host "Most authenticator apps want Base32. Duo bulk import needs hex"
Pause
