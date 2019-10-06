function imgv ($dir)
{
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

if(!$dir) {
    $dir = Convert-Path .
}

$files = Get-ChildItem $dir -Recurse *

#�E�B���h�E
$form = New-Object System.Windows.Forms.Form 
$form.Text = "�摜�ꗗ"
$form.Size = New-Object System.Drawing.Size(1200,800)
$form.AutoScrollMinSize = New-Object System.Drawing.Size(1200,800)
$form.StartPosition = "CenterScreen"

$columnCount = 0
$rowCount = 0
for ($i=0; $i -lt $files.Count; $i++) {
    if ( ($files[$i].PSIsContainer) -Or ($files[$i].Extension -notmatch ".jpg|.jepg|.png|.gif|.bmp") ) {
        continue
    }


    #�摜�T�C�Y
    $picSize = 300
    #���z�u
    $width = $columnCount * $picSize
    #�c�z�u �e�L�X�g
    $height = $rowCount * ( $picSize + 100 )
    #�c�z�u�摜
    $heightPic = $height+60
    #��v�Z
    if($columnCount -eq 3 ) {
        $columnCount = 0
        $rowCount++
    } else{
        $columnCount++
    }

    #�t�@�C����
    $label = New-Object System.Windows.Forms.Label
    $label.Text = $files[$i].Name
    $label.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
    $label.Location = New-Object System.Drawing.Point($width,$height)
    $label.Width = 200

    #�t�@�C����
    $textBox = New-Object System.Windows.Forms.TextBox 
    $textBox.Text = $files[$i].Name
    $textBox.Location = New-Object System.Drawing.Point($width,$height) 
    $textBox.Size = New-Object System.Drawing.Size($picSize,50) 

    #�摜
    $pic = New-Object System.Windows.Forms.PictureBox
    $pic.Size = New-Object System.Drawing.Size($picSize, $picSize)
    $pic.Image = [System.Drawing.Image]::FromFile($files[$i].FullName)
    $pic.Location = New-Object System.Drawing.Point($width,$heightPic)
    $pic.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom

    $form.Controls.Add($pic)
    $form.Controls.Add($textBox)
}


#�t�H�[����\��
$result = $form.ShowDialog()

#���\�[�X���J��
$pic.Image.Dispose()
$pic.Image = $null
}