function imgv ($dir)
{
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

if(!$dir) {
    $dir = Convert-Path .
}

$files = Get-ChildItem $dir -Recurse *

#ウィンドウ
$form = New-Object System.Windows.Forms.Form 
$form.Text = "画像一覧"
$form.Size = New-Object System.Drawing.Size(1200,800)
$form.AutoScrollMinSize = New-Object System.Drawing.Size(1200,800)
$form.StartPosition = "CenterScreen"

$columnCount = 0
$rowCount = 0
for ($i=0; $i -lt $files.Count; $i++) {
    if ( ($files[$i].PSIsContainer) -Or ($files[$i].Extension -notmatch ".jpg|.jepg|.png|.gif|.bmp") ) {
        continue
    }


    #画像サイズ
    $picSize = 300
    #横配置
    $width = $columnCount * $picSize
    #縦配置 テキスト
    $height = $rowCount * ( $picSize + 100 )
    #縦配置画像
    $heightPic = $height+60
    #列計算
    if($columnCount -eq 3 ) {
        $columnCount = 0
        $rowCount++
    } else{
        $columnCount++
    }

    #ファイル名
    $label = New-Object System.Windows.Forms.Label
    $label.Text = $files[$i].Name
    $label.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
    $label.Location = New-Object System.Drawing.Point($width,$height)
    $label.Width = 200

    #ファイル名
    $textBox = New-Object System.Windows.Forms.TextBox 
    $textBox.Text = $files[$i].Name
    $textBox.Location = New-Object System.Drawing.Point($width,$height) 
    $textBox.Size = New-Object System.Drawing.Size($picSize,50) 

    #画像
    $pic = New-Object System.Windows.Forms.PictureBox
    $pic.Size = New-Object System.Drawing.Size($picSize, $picSize)
    $pic.Image = [System.Drawing.Image]::FromFile($files[$i].FullName)
    $pic.Location = New-Object System.Drawing.Point($width,$heightPic)
    $pic.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom

    $form.Controls.Add($pic)
    $form.Controls.Add($textBox)
}


#フォームを表示
$result = $form.ShowDialog()

#リソースを開放
$pic.Image.Dispose()
$pic.Image = $null
}