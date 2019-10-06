
function imgsize() {
Add-Type -AssemblyName System.Drawing
$thisDir = Convert-Path .
$lists = Get-ChildItem -Recurse *

foreach($list in $lists){
    # ファイルかフォルダか判定
    if ( $list.Extension -match "jpg|png|gif" ){
    
        $src_image = [System.Drawing.Image]::FromFile($list)
        echo ""
        echo $list.Name
        echo "W" $src_image.Width
        echo "H" $src_image.height

        $src_image.Dispose()
    }
}
}