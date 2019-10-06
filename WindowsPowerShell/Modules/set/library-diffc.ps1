<#
.SYNOPSIS
    2つのファイルを比較

.DESCRIPTION
    修正前と修正後のファイルを比較し、差分をコンソールに表示する。
    [+]が修正後に存在する行(追加/変更)、[-]が修正後に存在しない行(削除/変更)。

.PARAMETER FromFile
    修正前ファイル

.PARAMETER ToFile
    修正後ファイル

.PARAMETER Full
    変更なしの行も表示する場合に指定。
    変更なしの行は[=]で表示。

.NOTES
    行番号は出ません

.EXAMPLE
    diffc .\File_ver1.txt .\File_ver2.txt
    File_ver1.txt と File_ver2.txt の差分を表示

.EXAMPLE
    diffc C:\Work\before.csv D:\Tmp\after.csv -Full
    before.csv と after.csv の差分を変更がない行も含めて表示
#>
function diffc([Parameter(Mandatory)][string]$FromFile, [Parameter(Mandatory)][string]$ToFile, [switch]$Full)
{
    Compare-Object (Get-Content $FromFile) (Get-Content $ToFile) -IncludeEqual:$Full | 
        ForEach-Object {
            [string]$line = ""
            [string]$foreColor = ""
            if ($_.SideIndicator -eq "=>")
            {
                # 修正後に存在する行（追加または変更された行）
                $line = "[+] " + $_.InputObject
                $foreColor = "Green"
            }
            elseif ($_.SideIndicator -eq "<=")
            {
                # 修正後に存在しない行（削除または変更された行）
                $line = "[-] " + $_.InputObject
                $foreColor = "Magenta"
            }
            elseif ($Full)
            {
                # 変更がない行
                $line = "[=] " + $_.InputObject
                $foreColor = "Gray"
            }

            Write-Host $line -ForegroundColor $foreColor
        }
}