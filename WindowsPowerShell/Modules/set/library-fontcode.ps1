<#
.SYNOPSYS
    �t�@�C���o�͂Ɋւ��G���R�[�f�B���O�ݒ��ύX�����X�N���v�g�u���b�N�����s���܂��B
.DESCRIPTION
    �w�肵���X�N���v�g�u���b�N���ł̂݃t�@�C���o�͂�����R�}���h���b�g(Out-File�Ȃ�)�̃G���R�[�f�B���O�̋�����ύX���܂��B  
    ���ݕύX�\�ȓ_�͈ȉ��ɂȂ�܂��B
      1. �ʏ�BOM�t����UTF8��BOM������UTF8�ɕύX����
      2. DEFAULT�G���R�[�f�B���O���w�肵���R�[�h�y�[�W�̃G���R�[�f�B���O�ɕύX����
.PARAMETER UseBOMlessUTF8
    UTF8�p�����[�^�[�Ŏw�肳���G���R�[�f�B���O��BOM����UTF8�ɕύX���܂��B
.PARAMETER DefaultCodePage
    Default�p�����[�^�[�̃G���R�[�f�B���O���w�肵���R�[�h�y�[�W�̃G���R�[�f�B���O�ɕύX���܂��B
.EXAMPLE
    PS C:\> Invoke-CustomEncodingBlock { "BOM�Ȃ�UTF8" | Out-File .\BOMless.txt -Encoding utf8 } -UseBOMlessUTF8
    ���̗�ł�Out-File�R�}���h���b�g�̏o�͂�BOM����UTF8�ɂ��܂��B
.EXAMPLE
    PS C:\> Invoke-CustomEncodingBlock { "�f�t�H���gEUC(51932)" | Out-File .\Default51932.txt -Encoding default } -DefaultCodePage 51932
    ���̗�ł�Out-File�R�}���h���b�g�̏o�͂�EUC(�R�[�h�y�[�W51932)�ɂ��܂��B
#>
function Invoke-CustomEncodingBlock {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ScriptBlock]$Block,
        [Parameter(Mandatory = $false)]
        [Switch]$UseBOMlessUTF8 = $false,
        [Parameter(Mandatory = $false)]
        [int]$DefaultCodePage = [System.Text.Encoding]::Default.WindowsCodePage
    )
    # PowerShell 6.0�ł̓G���R�[�f�B���O�̎�舵�����ς�������߂��̊֐����g���K�v������
    if ($PSVersionTable.PSVersion.Major -ge 6) {
        Write-Error "PowrShell 6.0�ȍ~�ł��̊֐��͎g���܂���B"
        return 
    }
    # �ύX����
    $isChangeUTF8 = $UseBOMlessUTF8
    # * .NET Core���� $null -eq [System.Text.Encoding]::Default �Ȃ��� [int]�̒l�Ŕ�r����
    $isChangeDefault = $DefaultCodePage -ne [int]([System.Text.Encoding]::Default.WindowsCodePage)
    # �ύX�Ȃ��̏ꍇ�͒P���ɃX�N���v�g�u���b�N�����s���ďI��
    if (-not $isChangeUTF8 -and -not $isChangeDefault ) {
        $Block.Invoke()
        return
    }

    try {
        # ����̓����ύX
        $type = [System.Text.Encoding]
        if ($isChangeUTF8) {
            $UTF8wBOM = [System.Text.Encoding]::UTF8
            $UTF8woBOM = New-Object "System.Text.UTF8Encoding" -ArgumentList @($false)

            $mUTF8 = $type.GetMember("utf8Encoding", [System.Reflection.BindingFlags]::NonPublic -bor [System.Reflection.BindingFlags]::Static)
            if ($mUTF8.Length -eq 0) {
                throw ("Type member {0} not found." -f "utf8Encoding")
            }
            $mUTF8[0].SetValue($mUTF8[0], $UTF8woBOM)
        }
        if ($isChangeDefault) {
            $currentDefaultEncoding = [System.Text.Encoding]::Default
            $newDefaultEncoding = [Text.Encoding]::GetEncoding($DefaultCodePage)

            # PS 5.0�ȍ~�� System.Management.Automation.ClrFacade �N���X�ɃG���R�[�f�B���O�̃L���b�V��������̂ł�����ς���
            if ($PSVersionTable.PSVersion.Major -lt 5) {
                $mDefault = $type.GetMember("defaultEncoding", [System.Reflection.BindingFlags]::NonPublic -bor [System.Reflection.BindingFlags]::Static)
                if ($mDefault.Length -eq 0) {
                    throw ("Type member {0} not found." -f "defaultEncoding")
                }
                $mDefault[0].SetValue($mDefault[0], $newDefaultEncoding)
            } else {
                $asm = $MyInvocation.GetType().Assembly
                $typeFacade = $asm.GetType("System.Management.Automation.ClrFacade")
                # PS 5.0 - 5.1 �� _defaultEncoding
                # PS 6.0(.NET Core)���� s_defaultEncoding ���ۂ�...
                foreach ($name in @("_defaultEncoding", "s_defaultEncoding")) {
                    $mDefault = $typeFacade.GetMember($name, [System.Reflection.BindingFlags]::NonPublic -bor [System.Reflection.BindingFlags]::Static)
                    if ($mDefault.Length -ne 0) {
                        break
                    }
                }
                if ($mDefault.Length -eq 0) {
                    throw ("Type member {0} not found." -f "defaultEncoding")
                }
                $mDefault[0].SetValue($mDefault[0], $newDefaultEncoding)
            }
        }
        
        # Scriptblock���s
        $Block.Invoke()
    } finally {
        if ($isChangeUTF8) {
            if ($null -ne $mUTF8) {
                $mUTF8[0].SetValue($mUTF8[0], $UTF8wBOM)
            }
        }
        if ($isChangeDefault) {
            if ($null -ne $mDefault) {
                $mDefault[0].SetValue($mDefault[0], $currentDefaultEncoding)
            }
        }
    }
}
