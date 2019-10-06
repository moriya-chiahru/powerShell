function filediff(){
$localPaths = @("//10.1.3.195/2018rn", "//10.1.3.195/2018comrn", "//10.1.3.195/webcbroot/hidehome")
$firstDir = Convert-Path .\

# 自分のPCパス
$mydiscPath = Read-Host "比較元パス"

if($mydiscPath -match "C:"){
    # 絶対パス
    $thisDir = $mydiscPath
}else{
    # 相対パス
    cd $firstDir
    cd $mydiscPath
    $thisDir = Convert-Path .\
}

$thisDir = $thisDir.Replace("\", "/")
$lists = Get-ChildItem $thisDir -Recurse *

# ローカルパス選択
for ($i=0; $i -lt $localPaths.Count; $i++){
    echo "[$i]"$localPaths[$i]
}

$localPathSerect = Read-Host "比較ローカルパス"
$localPathSerect = $localPaths[$localPathSerect]

#比較
    foreach($list in $lists){
        # ファイルかフォルダか判定
        if ( !$list.PSIsContainer ){
            $mydiscPathFull = $list.FullName.Replace("\", "/");
            $mydiscPath = $mydiscPathFull.Replace($thisDir, "");
            $localPath = $localPathSerect + $mydiscPath;
            echo "************************"
            echo $mydiscPathFull
            if( Test-Path $localPath ) {
                echo $localPath
                diffc $mydiscPathFull $localPath
            } else {
                echo "比較先にファイルが存在しません"
            }

        }
    }

#始めのパスに戻る    
cd $firstDir
}