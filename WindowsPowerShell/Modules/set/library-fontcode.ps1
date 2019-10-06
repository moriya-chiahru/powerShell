<#
.SYNOPSYS
    ファイル出力に関わるエンコーディング設定を変更したスクリプトブロックを実行します。
.DESCRIPTION
    指定したスクリプトブロック内でのみファイル出力をするコマンドレット(Out-Fileなど)のエンコーディングの挙動を変更します。  
    現在変更可能な点は以下になります。
      1. 通常BOM付きのUTF8をBOM無しのUTF8に変更する
      2. DEFAULTエンコーディングを指定したコードページのエンコーディングに変更する
.PARAMETER UseBOMlessUTF8
    UTF8パラメーターで指定されるエンコーディングをBOM無しUTF8に変更します。
.PARAMETER DefaultCodePage
    Defaultパラメーターのエンコーディングを指定したコードページのエンコーディングに変更します。
.EXAMPLE
    PS C:\> Invoke-CustomEncodingBlock { "BOMなしUTF8" | Out-File .\BOMless.txt -Encoding utf8 } -UseBOMlessUTF8
    この例ではOut-Fileコマンドレットの出力をBOM無しUTF8にします。
.EXAMPLE
    PS C:\> Invoke-CustomEncodingBlock { "デフォルトEUC(51932)" | Out-File .\Default51932.txt -Encoding default } -DefaultCodePage 51932
    この例ではOut-Fileコマンドレットの出力をEUC(コードページ51932)にします。
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
    # PowerShell 6.0ではエンコーディングの取り扱いが変わったためこの関数を使う必要が無い
    if ($PSVersionTable.PSVersion.Major -ge 6) {
        Write-Error "PowrShell 6.0以降でこの関数は使えません。"
        return 
    }
    # 変更判定
    $isChangeUTF8 = $UseBOMlessUTF8
    # * .NET Coreだと $null -eq [System.Text.Encoding]::Default なため [int]の値で比較する
    $isChangeDefault = $DefaultCodePage -ne [int]([System.Text.Encoding]::Default.WindowsCodePage)
    # 変更なしの場合は単純にスクリプトブロックを実行して終了
    if (-not $isChangeUTF8 -and -not $isChangeDefault ) {
        $Block.Invoke()
        return
    }

    try {
        # 既定の動作を変更
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

            # PS 5.0以降は System.Management.Automation.ClrFacade クラスにエンコーディングのキャッシュがあるのでここを変える
            if ($PSVersionTable.PSVersion.Major -lt 5) {
                $mDefault = $type.GetMember("defaultEncoding", [System.Reflection.BindingFlags]::NonPublic -bor [System.Reflection.BindingFlags]::Static)
                if ($mDefault.Length -eq 0) {
                    throw ("Type member {0} not found." -f "defaultEncoding")
                }
                $mDefault[0].SetValue($mDefault[0], $newDefaultEncoding)
            } else {
                $asm = $MyInvocation.GetType().Assembly
                $typeFacade = $asm.GetType("System.Management.Automation.ClrFacade")
                # PS 5.0 - 5.1 は _defaultEncoding
                # PS 6.0(.NET Core)だと s_defaultEncoding っぽい...
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
        
        # Scriptblock実行
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
