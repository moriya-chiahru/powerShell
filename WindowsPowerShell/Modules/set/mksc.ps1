#�N���b�v�{�[�h�̓��e��ۑ��A�\��
function mksc( $path , $name ){
    $thisDir = Convert-Path .
    #WshShell�I�u�W�F�N�g���쐬
    $shell = New-Object -ComObject WScript.Shell

    if( $name.Length -eq 0 ) {
        $pathArray = $path -split "\\"
        $name = $pathArray[$pathArray.Length-1]
    }

    #�V���[�g�J�b�g�ւ̃I�u�W�F�N�g���쐬
    $lnk = $shell.CreateShortcut($thisDir + "\" + $name +".lnk")

    #�����N��p�X�ݒ�
    $lnk.TargetPath = $path

    #�A�C�R���t�@�C���p�X�ݒ�
    $lnk.IconLocation = $path

    #�V���[�g�J�b�g��ۑ�
    $lnk.Save()

}