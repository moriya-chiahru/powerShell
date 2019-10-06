Write-Host ("Hello PS Profile from {0}" -f $PSCommandPath) -ForegroundColor Green

#【ライブラリ】文字コードをUTF8BOM無しで保存
#Invoke-CustomEncodingBlock
 . "C:\Users\NSW00_907185\Documents\WindowsPowerShell\Modules\set\library-fontcode.ps1"

#【ライブラリ】diffを見やすくする
#diffc
 . "C:\Users\NSW00_907185\Documents\WindowsPowerShell\Modules\set\library-diffc.ps1"

#サブフォルダ含むファイルのリストを表示
#filelist
 . "C:\Users\NSW00_907185\Documents\WindowsPowerShell\Modules\set\filelist.ps1"

#ローカルと自分の作業フォルダの差分をとる
 . "C:\Users\NSW00_907185\Documents\WindowsPowerShell\Modules\set\filediff.ps1"

#フォルダ内の画像を表示
#imgv
 . "C:\Users\NSW00_907185\Documents\WindowsPowerShell\Modules\set\imgview.ps1"
 
#フォルダ内の画像リストを取得
#imgsize
 . "C:\Users\NSW00_907185\Documents\WindowsPowerShell\Modules\set\imgsize.ps1"


#クリップボードの内容を保存、表示
#pbpaste 保存ファイル名（無ければ表示のみ）
 . "C:\Users\NSW00_907185\Documents\WindowsPowerShell\Modules\set\pbpaste.ps1"

#ショーっとカット作成
#mksc 作成するパス 作成するファイル名(ない場合はパスから名前取得"
 . "C:\Users\NSW00_907185\Documents\WindowsPowerShell\Modules\set\mksc.ps1"