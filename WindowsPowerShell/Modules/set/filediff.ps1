function filediff(){
$localPaths = @("//10.1.3.195/2018rn", "//10.1.3.195/2018comrn", "//10.1.3.195/webcbroot/hidehome")
$firstDir = Convert-Path .\

# ������PC�p�X
$mydiscPath = Read-Host "��r���p�X"

if($mydiscPath -match "C:"){
    # ��΃p�X
    $thisDir = $mydiscPath
}else{
    # ���΃p�X
    cd $firstDir
    cd $mydiscPath
    $thisDir = Convert-Path .\
}

$thisDir = $thisDir.Replace("\", "/")
$lists = Get-ChildItem $thisDir -Recurse *

# ���[�J���p�X�I��
for ($i=0; $i -lt $localPaths.Count; $i++){
    echo "[$i]"$localPaths[$i]
}

$localPathSerect = Read-Host "��r���[�J���p�X"
$localPathSerect = $localPaths[$localPathSerect]

#��r
    foreach($list in $lists){
        # �t�@�C�����t�H���_������
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
                echo "��r��Ƀt�@�C�������݂��܂���"
            }

        }
    }

#�n�߂̃p�X�ɖ߂�    
cd $firstDir
}