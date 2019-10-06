
function filelist(){
    $thisDir = Convert-Path .
    $lists = Get-ChildItem -Recurse *

    foreach($list in $lists){
        # ファイルかフォルダか判定
        if ( !$list.PSIsContainer ){
            echo $list.FullName.Replace($thisDir, "").Replace("\", "/")
        }
    }
}

#前のコード
#Get-ChildItem -Recurse * | ? { ! $_.PSIsContainer } | % { $_.FullName }
