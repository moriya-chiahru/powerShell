
function filelist(){
    $thisDir = Convert-Path .
    $lists = Get-ChildItem -Recurse *

    foreach($list in $lists){
        # �t�@�C�����t�H���_������
        if ( !$list.PSIsContainer ){
            echo $list.FullName.Replace($thisDir, "").Replace("\", "/")
        }
    }
}

#�O�̃R�[�h
#Get-ChildItem -Recurse * | ? { ! $_.PSIsContainer } | % { $_.FullName }
