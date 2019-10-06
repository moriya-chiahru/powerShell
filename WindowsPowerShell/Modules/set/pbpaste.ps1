#クリップボードの内容を保存、表示
function pbpaste( $path ){
    # アセンブリの読み込み
    Add-Type -Assembly System.Windows.Forms

    # クリップボードから取得
    $Get = [Windows.Forms.Clipboard]::GetText()
    if( $path.Length -eq 0 ) {
        echo $Get
    } else {
        Invoke-CustomEncodingBlock { $Get | Set-Content $path -Encoding utf8 } -UseBOMlessUTF8
    }
}