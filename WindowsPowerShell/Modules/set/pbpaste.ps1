#�N���b�v�{�[�h�̓��e��ۑ��A�\��
function pbpaste( $path ){
    # �A�Z���u���̓ǂݍ���
    Add-Type -Assembly System.Windows.Forms

    # �N���b�v�{�[�h����擾
    $Get = [Windows.Forms.Clipboard]::GetText()
    if( $path.Length -eq 0 ) {
        echo $Get
    } else {
        Invoke-CustomEncodingBlock { $Get | Set-Content $path -Encoding utf8 } -UseBOMlessUTF8
    }
}