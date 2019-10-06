<#
.SYNOPSIS
    2�̃t�@�C�����r

.DESCRIPTION
    �C���O�ƏC����̃t�@�C�����r���A�������R���\�[���ɕ\������B
    [+]���C����ɑ��݂���s(�ǉ�/�ύX)�A[-]���C����ɑ��݂��Ȃ��s(�폜/�ύX)�B

.PARAMETER FromFile
    �C���O�t�@�C��

.PARAMETER ToFile
    �C����t�@�C��

.PARAMETER Full
    �ύX�Ȃ��̍s���\������ꍇ�Ɏw��B
    �ύX�Ȃ��̍s��[=]�ŕ\���B

.NOTES
    �s�ԍ��͏o�܂���

.EXAMPLE
    diffc .\File_ver1.txt .\File_ver2.txt
    File_ver1.txt �� File_ver2.txt �̍�����\��

.EXAMPLE
    diffc C:\Work\before.csv D:\Tmp\after.csv -Full
    before.csv �� after.csv �̍�����ύX���Ȃ��s���܂߂ĕ\��
#>
function diffc([Parameter(Mandatory)][string]$FromFile, [Parameter(Mandatory)][string]$ToFile, [switch]$Full)
{
    Compare-Object (Get-Content $FromFile) (Get-Content $ToFile) -IncludeEqual:$Full | 
        ForEach-Object {
            [string]$line = ""
            [string]$foreColor = ""
            if ($_.SideIndicator -eq "=>")
            {
                # �C����ɑ��݂���s�i�ǉ��܂��͕ύX���ꂽ�s�j
                $line = "[+] " + $_.InputObject
                $foreColor = "Green"
            }
            elseif ($_.SideIndicator -eq "<=")
            {
                # �C����ɑ��݂��Ȃ��s�i�폜�܂��͕ύX���ꂽ�s�j
                $line = "[-] " + $_.InputObject
                $foreColor = "Magenta"
            }
            elseif ($Full)
            {
                # �ύX���Ȃ��s
                $line = "[=] " + $_.InputObject
                $foreColor = "Gray"
            }

            Write-Host $line -ForegroundColor $foreColor
        }
}