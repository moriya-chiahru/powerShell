#クリップボードの内容を保存、表示
function mksc( $path , $name ){
    $thisDir = Convert-Path .
    #WshShellオブジェクトを作成
    $shell = New-Object -ComObject WScript.Shell

    if( $name.Length -eq 0 ) {
        $pathArray = $path -split "\\"
        $name = $pathArray[$pathArray.Length-1]
    }

    #ショートカットへのオブジェクトを作成
    $lnk = $shell.CreateShortcut($thisDir + "\" + $name +".lnk")

    #リンク先パス設定
    $lnk.TargetPath = $path

    #アイコンファイルパス設定
    $lnk.IconLocation = $path

    #ショートカットを保存
    $lnk.Save()

}